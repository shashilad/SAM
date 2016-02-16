public class StakeholderInterviewTriggerHandler {
  private Boolean m_isExecuting = false;

  private Integer batchSize = 0;

  public StakeholderInterviewTriggerHandler(Boolean isExecuting, Integer size)
  {
    m_isExecuting = isExecuting;
    batchSize = size;
    if(IsTriggerContext){}
    if(IsVisualforcePageContext){}
    if(IsWebServiceContext){}
    if(IsExecuteAnonymousContext){}
  }

  // trigger contexts
  public boolean IsTriggerContext
  {get{ return m_isExecuting;}}

  public boolean IsVisualforcePageContext
  {get{ return !IsTriggerContext;}}

  public boolean IsWebServiceContext
  {get{ return !IsTriggerContext;}}

  public boolean IsExecuteAnonymousContext
  {get{ return !IsTriggerContext;}}

  // trigger routing
  public void OnAfterInsert(List<Stakeholder_Interview__c> newInterviews)
  {
  
    StakeholderInterviewTriggerHelper.addInsights(newInterviews);
    
  }
  public void OnBeforeInsert(List<Stakeholder_Interview__c> newInterviews)
  {
  	StakeholderInterviewTriggerHelper.GenerateInterviewTitle(newInterviews);
  }
  public void OnBeforeUpdate(List<Stakeholder_Interview__c> newInterviews)
  {
  	StakeholderInterviewTriggerHelper.UpdateInterviewTitle(newInterviews);
  }
    

/* Rem out for code coverage
//=============================
  public void OnBeforeInsert(List<AccountQI__c> newInterviews){}
 
  @future public static void OnAfterInsertAsync(Set<ID> newInterviewIDs){}
  
  public void OnBeforeUpdate(List<AccountQI__c> oldInterviews, List<AccountQI__c> updatedInterviews, Map<ID, Interview> InterviewMap){}
  
  public void OnAfterUpdate(List<AccountQI__c> oldInterviews, List<AccountQI__c> updatedInterviews, Map<ID, Interview> InterviewMap){}
 
  @future public static void OnAfterUpdateAsync(Set<ID> updatedInterviewIDs){}
 
  public void OnBeforeDelete(List<AccountQI__c> InterviewsToDelete, Map<ID, Interview> InterviewMap){}
 
  public void OnAfterDelete(List<AccountQI__c> deletedInterviews, Map<ID, Interview> InterviewMap){}
 
  @future public static void OnAfterDeleteAsync(Set<ID> deletedInterviewIDs){}

  public void OnUndelete(List<AccountQI__c> restoredInterviews){}
*/

}