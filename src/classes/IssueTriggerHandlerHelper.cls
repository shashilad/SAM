public  class IssueTriggerHandlerHelper {

  //------- Constants ----------------------------------------------------------

  
  //------- Methods ------------------------------------------------------------

  /**
  * @author       George Huene 
  * @date         Sept 12 2014
  * @description  
  * 
  */
  public static void AssignOwnerToSFDCsupportTeam(List<Issue__c> newIssues){
    ID GroupId = [ SELECT Id, Name
                   FROM Group
                   WHERE Type='Queue' AND Name LIKE 'Pending Assignment%' LIMIT 1].Id;
    
    List<GroupMember> GMs = [ SELECT Id, UserOrGroupId 
                       FROM GroupMember 
                       WHERE GroupId=:GroupId];
    System.debug('GMs: ' + GMs);
/*
    User User = [ SELECT ID, Name
                  FROM User
                  WHERE Id=:GMs[0].UserOrGroupId];
    System.debug('User: ' + User);
*/  
    for(Issue__c I : newIssues){
      I.OwnerId = GroupId;
    }
  }
  
  
  public static void IssueClosedToFollowStatus(List<Issue__c> newIssues, Map<Id, Issue__c> oldMap){
    for(Issue__c I : newIssues){
      Issue__c oldIssue;
      if(oldMap<>null)
        oldIssue = oldMap.get(I.Id);
        
      if(I.Status__c == 'Closed' && I.Resolution__c <> null){
        if(oldMap == null || (oldIssue <> null && oldIssue.Status__c <> 'Closed') ){
          I.IssueClosed__c    = true;
          I.DateTimeClosed__c = datetime.now();
        }
      }else if(I.Status__c == 'Reopened'){ // Look for Issue ReOpen Status
        if(oldMap <> null && oldIssue.Status__c == 'Closed'){
          I.IssueClosed__c    = false;
          I.DateTimeClosed__c = null;
        }
      }
    }
  }
  
  // Modified by Shashi lad : To provide access to to user for attachments
  public static void ProvideAccessToOriginator(List<Issue__c> newIssues){
    List<Issue__Share> issueShares = new List<Issue__Share>();
    for(Issue__c i : newIssues){
      Issue__Share issueShare = new Issue__Share();
      issueShare.ParentId = i.Id;
      issueShare.AccessLevel = 'Edit';
      issueShare.RowCause = Schema.Issue__Share.rowCause.Originator__c;
      issueShare.UserOrGroupId =  i.CreatedById;
      issueShares.add(issueShare);
    }
    if(issueShares != null && issueShares.size()>0) insert issueShares;
  }
  
}