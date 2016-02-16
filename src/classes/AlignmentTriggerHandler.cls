public with sharing class AlignmentTriggerHandler {
	private Boolean m_isExecuting = false;

	private Integer batchSize = 0;
	
	public AlignmentTriggerHandler(Boolean isExecuting, Integer size) {
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
  	public void OnBeforeInsert(List<AccountAlignment__c> newAlignments){
  		AlignmentHelper.RelateAlignmentToAccounts(newAlignments);
  	}
  	
  	public void OnBeforeUpdate(List<AccountAlignment__c> updatedAlignments){
  		AlignmentHelper.RelateAlignmentToAccounts(updatedAlignments);
  	}
	
	
	/* Rem out for code coverage
	//=============================
	  public void OnAfterInsert(List<AccountAlignment__c> newAlignments) {}
	 
	 
	  @future public static void OnAfterInsertAsync(Set<ID> newAlignmentIDs){}
	  
	  public void OnBeforeUpdate(List<AccountAlignment__c> oldAlignments, List<AccountAlignment__c> updatedAlignments, Map<ID, Alignment> AlignmentMap){}
	  
	  public void OnAfterUpdate(List<AccountAlignment__c> oldAlignments, List<AccountAlignment__c> updatedAlignments, Map<ID, AccountAlignment__c> AlignmentMap){}
	 
	  @future public static void OnAfterUpdateAsync(Set<ID> updatedAlignmentIDs){}
	 
	  public void OnBeforeDelete(List<AccountAlignment__c> AlignmentsToDelete, Map<ID, AccountAlignment__c> AlignmentMap){}
	 
	  public void OnAfterDelete(List<AccountAlignment__c> deletedAlignments, Map<ID, AccountAlignment__c> AlignmentMap){}
	 
	  @future public static void OnAfterDeleteAsync(Set<ID> deletedAlignmentIDs){}
	
	  public void OnUndelete(List<AccountAlignment__c> restoredAlignments){}
	*/
}