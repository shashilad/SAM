public with sharing class IssueController
{ public Issue__c Issue              {get; set;}
  public User     User               {get; set;}
  public Id       UserId             {get; set;}
  public String   Helpdesk_User      {get; set;}
  public String   Helpdesk_UserTable {get; set;}
  public Id       Issue_OwnerId      {get; set;}
  public String   IssueObjectPrefix  {get; set;}

  public IssueController(ApexPages.StandardController controller) {
    ID IssueId = apexpages.currentpage().getparameters().get('id');
    
    Schema.DescribeSObjectResult dsr = Issue__c.sObjectType.getDescribe();
    IssueObjectPrefix                = dsr.getKeyPrefix();

    UserId=Userinfo.getUserId();
    User User = [ SELECT Id, HelpdeskUser__c
                  FROM User
                  WHERE Id=:UserId ];
    Helpdesk_User = User.HelpdeskUser__c;
    
    List<User> Users = [ SELECT id, Name, Profile.Name, HelpdeskUser__c FROM User 
                         WHERE  HelpdeskUser__c='Yes' 
                         ORDER BY Name];
    String HelpdeskUser_Table='';
    for(User U: Users){
      HelpdeskUser_Table += U.Id + '#' + U.Name + '#' + U.Profile.Name + '#' + U.HelpdeskUser__c + '##';
    }
    Helpdesk_UserTable=HelpdeskUser_Table;

    if(IssueId==null){
      Issue = new Issue__c();
    }
    else{
      Issue = [ SELECT Id, CreatedById, Name, LastModifiedById, OwnerId, Owner.Name,
                BusinessHours__c, ClosedBy__c, DateTimeClosed__c, DateTimeOpened__c,
                Device__c, IsEscalated__c, Issue__c, IssueAgeDays__c, IssueOrigin__c, 
                IssueClosed__c, IssueDays__c, Owner__c, Reason__c, OriginatedBy__c,
                Parent__c, Priority__c, Resolution__c, Status__c, Subject__c, Type__c,
                SuppliedCompany__c, SuppliedEmail__c, SuppliedName__c,SuppliedPhone__c,
                IssueCategory__c
                FROM Issue__c WHERE Id=:IssueId];
    }
  }
 
 
  public PageReference Save() {
    String DebugString='';
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');

    if(IssueId==null){
      if(Issue.OriginatedBy__c==null)
        Issue.OriginatedBy__c=UserInfo.getUserId();
      insert Issue;
      IssueId=Issue.Id;
      DebugString += 'if(IssueId==null){\n';

    }
    else{
      update Issue;
      IssueId=Issue.Id;
      DebugString += 'else{\n';
    }
    
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }
    
    
  public PageReference apexEscalateIssue(){
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    String DebugString    ='';

    System.debug('apexCloseIssue Entrance. Issue.Status__c:' + Issue.Status__c);
    Issue.Status__c   = 'Escalated';
    update Issue;
    
    System.debug(DebugString);
    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }

  
  public PageReference apexOnholdIssue(){
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    String DebugString    ='';
    
    Issue.Status__c   = 'On Hold';
    update Issue;
    
    System.debug(DebugString);
    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }

    
  public PageReference apexReopenIssue(){
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    String DebugString    ='';

    Issue.Status__c   = 'Reopened';
    Issue.ClosedBy__c = null;
    update Issue;

    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }

    
  public PageReference apexCloseIssue(){
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    String DebugString    ='';

    Issue.Status__c   = 'Closed';
    Issue.ClosedBy__c = UserId;
    update Issue;

    System.debug(DebugString);
    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }
  
  
  public PageReference apexSetOwnerId(){
    ID IssueId            = apexpages.currentpage().getparameters().get('id');
    String retURL         = apexpages.currentpage().getparameters().get('retURL');
    String scontrolCaching= apexpages.currentpage().getparameters().get('scontrolCaching');
    String sfdc_override  = apexpages.currentpage().getparameters().get('sfdc.override');
    String Parameters     = '?id=' + IssueId + 
                            '&scontrolCaching=' + scontrolCaching +
                            '&sfdc.override=' + sfdc_override + 
                            '&retURL=' + retURL; 
    String UrlString      ='/apex/IssueVpage2' + Parameters;
    String DebugString    ='';

    update Issue;
    
    PageReference pageRef= new PageReference(UrlString);
    pageRef.setRedirect(true);
    return pageRef;
  }

    
  public String Email_System_Debug(String eBody) {
  //======================================================================================================
    String From_Email  = 'test@crme.com'; 
    String From_Name   = 'Test Dev';
    String To_Email    = 'test@crme.com';
    String Peter_Email = 'poconnell@crme.com';

    String eSubject    ='System.Debug(ContactSendEmailController().ERROR)';

    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String[] toAddresses = new String[] {To_Email}; 
    
    if(From_Name!=null && From_Name!='')
      mail.setSenderDisplayName(From_Name);
      
    mail.setToAddresses(toAddresses);
    mail.setReplyTo(From_Email);
    mail.setSubject(eSubject);
    mail.setBccSender(false);

    mail.setUseSignature(false);

    mail.setPlainTextBody(eBody);
    mail.setHtmlBody(eBody.replace('\n', '<br/>\n'));

    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    return null;
  }

}