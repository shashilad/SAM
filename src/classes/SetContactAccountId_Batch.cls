global class SetContactAccountId_Batch implements Database.Batchable<SObject>, Database.Stateful{

/**
@author       George Huene 
@date         June 2nd 2014 (SI-505)
@description  Please create a cron job that runs periodically 
               to update contact records in POC so that the Contact.AccountId gets updated 
               based on matching Contact.CUST_ACCT_NO__c TO Account.ACCOUNTNUMBER.

How to Test (From Developer Console, Execute)
try
{ Integer ROWS_LIMIT=321;
  SetContactAccountId_Batch batchApex = new SetContactAccountId_Batch(ROWS_LIMIT);
  System.debug('batchApex=' + batchApex);
  ID batchprocessid = Database.executeBatch(batchApex); 
  System.debug('batchprocessid=' + batchprocessid);
}
catch(Exception e)
{ System.debug(e);
}

*/
  
  Static Final Boolean DO_UPDATE  = true;  // Switches so that you can turn On and Off
  Static Final Boolean SHOW_DEBUG = true;
  Static Final Integer Batch_MAX_SIZE = 50000; // 50K is a Batch MAXIMUM Rows Allowed
  
  Integer failedUpdates        =0;
  Integer Rows_ToBe_Processed  =0;
  Integer Rows_Processed       =0;
  Integer RowsToBeUpdated      =0;
  Integer Accounts_NOT_Found   =0;
  Integer ROWS_LIMIT           =0;
  Integer Already_Got_AccountId=0;
  Integer Account_Total_Rows   =0;
  Integer Contact_Total_Rows   =0;
  
  global SetContactAccountId_Batch(Integer ROWS_LIMIT){
    this.ROWS_LIMIT=Batch_MAX_SIZE;
    if(ROWS_LIMIT<Batch_MAX_SIZE)
      this.ROWS_LIMIT =ROWS_LIMIT;
  }

  global Database.queryLocator start(Database.BatchableContext ctx){
    System.debug('ROWS_LIMIT=' + ROWS_LIMIT);
/*
    if(1==2){ // include these Queries will exceed 50K LIMIT. So disabled for now
      aggregateResult Acc_Count=[ SELECT COUNT(ID) Counter FROM Account  ];
      //Account_Total_Rows=(Integer)Acc_Count.get('Counter');
      System.debug('Account_Total_Rows='+Account_Total_Rows);

      aggregateResult Cont_Count=[ SELECT COUNT(ID) Counter FROM Contact ];
      //Contact_Total_Rows=(Integer)Cont_Count.get('Counter');
      System.debug('Contact_Total_Rows='+Contact_Total_Rows);
    }
*/
    return Database.getQueryLocator(
      [ SELECT ID, JJHCS__C, AccountId FROM Contact 
        WHERE RecordType.Name='Optimizer Contact' AND Account.Name='Unknown' AND JJHCS__C!=null 
        LIMIT :ROWS_LIMIT 
      ]);
  }

  global void execute(Database.BatchableContext ctx, List<Sobject> scope){
    List<Contact> Contacts = (List<Contact>)scope;
    Integer ContactSize  =Contacts.Size();
    Rows_ToBe_Processed +=Contacts.Size();
    
    List<String> JJCHS_Numbers = new List<String>();
    for(Contact C : Contacts){
      JJCHS_Numbers.add(C.JJHCS__C);
    }
    
    Map<String, ID> CustAccNo_Account_Map = new Map<String, ID>();
    List<Account> Accounts =
      [ SELECT ID, AccountNumber FROM Account 
        WHERE RecordType.Name='Teradata Account' AND AccountNumber IN :JJCHS_Numbers ];
      
    if(Accounts.Size()==0){
      Accounts_NOT_Found += ContactSize;
    }else{ //if(Accounts!=null && Accounts.Size()>0){
      for(Account Acc : Accounts){
        CustAccNo_Account_Map.put(Acc.AccountNumber, Acc.ID);
      }
      
      for(Contact C : Contacts){
        if(CustAccNo_Account_Map.get(C.JJHCS__C)==null){ // NOT Found
          Accounts_NOT_Found++;
        }else{
          if(C.AccountId != CustAccNo_Account_Map.get(C.JJHCS__C)){ // They're DIFFERENT
            C.AccountId = CustAccNo_Account_Map.get(C.JJHCS__C);
            RowsToBeUpdated++;
          }
          else{
            Already_Got_AccountId++;
          }
        }
      }
      if(DO_UPDATE){
        List<Database.SaveResult> dsrs = Database.update(Contacts, false);
        for(Database.SaveResult dsr : dsrs){
          if(!dsr.isSuccess() || ROWS_LIMIT==1){
            failedUpdates++;
          }
          else{
            Rows_Processed++;
            if(SHOW_DEBUG)
              System.debug('update row #' + Rows_Processed);
          }
        }
      }
    }
  }

  
  global void finish(Database.BatchableContext ctx){
    if(SHOW_DEBUG)
      System.debug('DONE! ' + Rows_Processed + ' Rows Processed.  failedUpdates=' + failedUpdates);
    List<String> args = new String[]{'0','number','<span>#,###.0</span>'};

    AsyncApexJob a = [ SELECT id, ApexClassId, 
                       JobItemsProcessed, TotalJobItems, 
                       NumberOfErrors, CreatedBy.Email 
                       FROM AsyncApexJob 
                       WHERE id = :ctx.getJobId()];
      
    String emailMessage = 'Your batch job SetContactAccountId has finished.<br/>'
           + 'It executed ' + a.totalJobItems + ' batches.<br/>'
           + 'Of which, ' + a.jobitemsprocessed + ' processed without any exceptions thrown<br/>'
           + 'and ' + a.numberOfErrors + ' batches threw unhandled exceptions.<br/><br/>'
           + 'Of the batches that executed without error:<br/>' 
           + String.format(ROWS_LIMIT.format(), args) + ' =Query LIMIT<br/>'
           + String.format(Rows_ToBe_Processed.format(), args) + ' row(s) to be processed<br/><br/>'
           + String.format(Accounts_NOT_Found.format(), args) + ' row(s) of Account NOT FOUND.<br/>'
           + String.format(Already_Got_AccountId.format(), args) + ' row(s) already got AccountId.<br/>'
           + String.format(RowsToBeUpdated.format(), args) + ' row(s) UPDATED.<br/>'
           + String.format(failedUpdates.format(), args) + ' row(s) were not updated successfully.<br/><br/>'
           ;
/*
      if(1==2){
        emailMessage +=
             String.format(Account_Total_Rows.format(), args) + ' total Account total rows.<br/>'
           + String.format(Contact_Total_Rows.format(), args) + ' total Contact total rows.<br/><br/>'
          ;
      }
*/ 
    if(SHOW_DEBUG)
      System.debug(emailMessage);

    Messaging.SingleEmailMessage mail = 
          new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'test@crme.com'}; //{a.createdBy.email};
    mail.setToAddresses(toAddresses);
    mail.setReplyTo('noreply@salesforce.com');
    mail.setSenderDisplayName('Batch Job Summary');
    mail.setSubject('Batch job completed');
    mail.setPlainTextBody(emailMessage);
    mail.setHtmlBody(emailMessage);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] 
                       { mail });
  } 
 
}