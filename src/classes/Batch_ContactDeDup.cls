/* ****************************************************************************************************************************************
** Developed by : Shashi Lad
**      purpose : In effort to de-dup the contacts, this batch process will check duplicate name in same account and check for any activities 
                  for those contacts. It makes the contact primary with activities on it and all other dup records will send to related
                  child object. It also copies the data from source and keep the record with the flag so that we can hide them using 
                  sharing rules.
** **************************************************************************************************************************************** */

global class Batch_ContactDeDup implements Database.Batchable<SObject>,  Schedulable {
    
   /* *********************   Batchable methods below ********************* */
    // Batch start with getting records
    
    global Database.QueryLocator start(Database.BatchableContext bc){
    //    list<id> ids = ContactDeDuplication.getContactRecords(); 
        String soql = getQuery();
        return Database.getQueryLocator(soql);
    }
    
    // Batch Execute 
     global void execute(Database.BatchableContext bc, list<Contact> conRecords) {
          
        List<Contact> conList = null;
        Map<Id, Id> priCont = new map<Id, Id>();
        Set<id> taskList = new Set<id>();
        Set<id> eventList = new Set<id>();
        List<contact> contIds = new List<contact>();
        List<Duplicate_Contacts__c> dc = new list<Duplicate_Contacts__c>();
        List<contact> cont = new list<contact>();
        list<id> cId = new list<id>();
        Map<String, String> dupCon = new map<String,String>();
        id prevCon = null;
        String prevName = null;

        // get the activity details
        for (contact ct : conRecords){
           cId.add(ct.Id);
        }
        for(sObject s1 : [select id,(select id,whoId from activityHistories),(select id,whoId from OpenActivities) from contact where id in :cId ]){
            if (s1.getsObjects('ActivityHistories') != null || s1.getsObjects('OpenActivities') != null) { 
               taskList.add(s1.id);   
               system.debug('@@@@@@@@@@@@ '+  s1.id);
            }    
        }
        
        // Iterator 
        for(contact con : conRecords){
            Id primaryCont = null ;
            conList = new List<Contact>();

            if(prevName != con.Name){
                    
                    // set the primary contact 
                    for (contact c1 : conRecords) {
                       if (c1.accountId == con.AccountId && c1.Name == con.Name) {
                             if(c1.dup_primary__c == true){
                                 primaryCont = c1.Id;
                                 system.debug('****** Primary contact already assigned..........'+ primaryCont);  
                             }else{
                                if ( (taskList.contains(c1.Id) || eventList.contains(c1.Id)) && primaryCont==null ){
                                   primaryCont = c1.Id;
                                   system.debug('****** Primary contact with activities ..........'+ primaryCont);      
                                }
                             }
                             conList.add(c1);
                        }
                     }
                    system.debug('Contact list ---------->' + conList);
                     
                     // set the flags and copy the dups to custom objects
                    for (contact c : conList) {
                             if (primaryCont == null ){
                                 primaryCont = c.id;
                                 c.dup_merged__c = false;
                                 c.Dup_Primary__c = true;
                                 cont.add(c);
                                 system.debug(' PRIMARY Contact ..........'+ primaryCont);  
                             }else{ 
                                 if (c.id == primaryCont){
                                         c.Dup_Primary__c = true;
                                         c.dup_merged__c = false;
                                         cont.add(c);
                                 }else{    
                                     if (c.id != primaryCont ){
                                             Duplicate_Contacts__c d = new Duplicate_Contacts__c();
                                             d.name = c.name;
                                             d.phone__c = c.phone;
                                             d.email__c = c.email;
                                             d.JJhcs_Number__c = c.Account_JJHCS__c;
                                             d.Account_Name__c = c.Account_Name__c;
                                             d.City__c = c.MailingCity;
                                             d.fax__c = c.Fax;
                                             d.Mobile__c = c.MobilePhone;
                                             d.Salutation__c = c.Salutation;
                                             d.State__c = c.MailingState;
                                             d.Street__c = c.MailingStreet;
                                             d.Zip__c = c.MailingPostalCode;
                                             d.Title1__c = c.Title;
                                             d.Title2__c = c.Title__c;
                                             d.Extension__c = c.Extension__c;
                                             d.Primary_Contact__c = primaryCont ;
                                             d.DupContact_Id__c = c.id;
                                             dc.add(d);
                                             system.debug(' DUPLICATE Contact..........'+d);  
                                             // to mark the processed records to hide from users later
                                             c.Dup_Primary__c = false;
                                             c.dup_merged__c = true;
                                             cont.add(c); 
                                     }
                                 }                                     
                             }     
                    } //for close       
                    prevCon  = con.AccountId;
                    prevName = con.Name;
            } // if close
        } //for close 
        system.debug('##### Contacts size to update flags ######### '+ cont.size());
        system.debug('##### Contacts to mark as duplicate and clone to custom object ########'+ dc.size());
        if (dc != null)  upsert dc DupContact_Id__c;
        if (cont != null)  update  cont;
     } // end of batch - execute
 
     // Batch finish 
     global void finish(Database.BatchableContext bc) {
        if (bc != null) {
            System.debug('finish,job id --> ' + bc.getJobId());
        }
     }

     // query
     private static String getQuery() {
        
   //     String query = ' select accountid,id,name,phone,dup_primary__c from contact where id in :ids  order by accountid,name' ;
                             //  ' order by accountid, count(id)';
        string query = 'select Id,name,accountid,phone,dup_merged__c,dup_Primary__c,email,'
                     + 'Account_JJHCS__c,Account_Name__c,MailingCity,Fax,MobilePhone,Salutation,MailingState,MailingStreet,'
                     + 'MailingPostalCode,Title,Title__c,Extension__c '
                     + 'from contact   order by accountid,name'; 
        System.debug('------> soql: ' + query);
        return query;
     }
    
    
   /* *********************   Batchable methods below ********************* */
     global void execute(SchedulableContext sc) {
        integer batchSize = 200;  
        Database.executeBatch(new Batch_ContactDeDup(), batchSize);
     }
     global  void scheduleJob(String scheduleString) {
        If (scheduleString == null) {
            scheduleString = '0 0 22 ? * FRI';
        }
        
        System.schedule(getUniqueJobName(), scheduleString, new Batch_ContactDeDup());
     }
      
     public String getUniqueJobName() {
        //construct unique job name by appending timestamp
        String uniqueJobName = 'Batch_ContactDeDup-' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug('job name : ' + uniqueJobName);
        return uniqueJobName;
     }
}