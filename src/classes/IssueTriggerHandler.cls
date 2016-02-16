public class IssueTriggerHandler {

    /**
    *   @author         George Huene
    *   @date           May 29th 2014
    *   @description    IssueTriggerHandler
    */
//-------------- Insert Section -----------------------------------------------
  public static void OnBeforeInsert(Issue__c[] newIssues){
    IssueTriggerHandlerHelper.AssignOwnerToSFDCsupportTeam(newIssues);
    IssueTriggerHandlerHelper.IssueClosedToFollowStatus(newIssues, null);
  }

  public static void OnAfterInsert(Issue__c[] newIssues){
    IssueTriggerHandlerHelper.ProvideAccessToOriginator(newIssues);
  }
  //-------------- Update Section -----------------------------------------------

    public static void OnBeforeUpdate(Issue__c[] newIssues, Map<Id, Issue__c> newMap, Map<Id, Issue__c> oldMap) {
      IssueTriggerHandlerHelper.IssueClosedToFollowStatus(newIssues, oldMap);
    }

/*
    public static void OnAfterInsert(Issue__c[] newIssues, Map<Id, Issue__c> newMap) {
      // Nothing to do yet.
    }
    
    public static void OnAfterUpdate(Issue__c[] oldIssues,Issue__c[] newIssues,Map<Id, Issue__c> newMap){
      // Nothing to do yet.
    }   

//-------------- Delete Section -----------------------------------------------


    public static void OnBeforeDelete(Issue__c[] oldIssues, Map<Id, Issue__c> oldMap) {
    }

    public static void OnAfterDelete(Issue__c[] oldIssues, Map<Id, Issue__c> oldMap) {
    }

    public static void OnUndelete(Issue__c[] restoredIssues) {
    }
*/

}