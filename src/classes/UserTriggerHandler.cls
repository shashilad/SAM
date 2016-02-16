public with sharing class UserTriggerHandler
{
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;

  // constructor
  public UserTriggerHandler(boolean isExecuting, integer size)
  {
    m_isExecuting = isExecuting;
    BatchSize = size;
    

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


  public void OnAfterInsert(set<Id> newUsers)
  {
    UserHelperClass.FollowEthiconGroup(newUsers, true);
  }

/* Rem out to get code coverage 10/3/2014
//========================================

  // trigger routing
  public void OnBeforeInsert(List<User> newUsers){}

  
  @future public static void OnAfterInsertAsync(Set<ID> newUserIDs){}


  public void OnBeforeUpdate(List<User> oldUsers, List<User> updatedUsers, Map<ID, User> UserMap){}

   

  public void OnAfterUpdate(List<User> oldUsers, List<User> updatedUsers, Map<ID, User> UserMap){}


  @future public static void OnAfterUpdateAsync(Set<ID> updatedUserIDs){}


  public void OnBeforeDelete(List<User> UsersToDelete, Map<ID, User> UserMap){}


  public void OnAfterDelete(List<User> deletedUsers, Map<ID, User> UserMap){}


  @future public static void OnAfterDeleteAsync(Set<ID> deletedUserIDs){}


  public void OnUndelete(List<User> restoredUsers){}
*/
}