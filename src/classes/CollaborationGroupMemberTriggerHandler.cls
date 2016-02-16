public with sharing class CollaborationGroupMemberTriggerHandler
{
  private boolean m_isExecuting = false;

  private integer BatchSize = 0;

  public CollaborationGroupMemberTriggerHandler(boolean isExecuting, integer size)
  {
    m_isExecuting = isExecuting;
    BatchSize = size;
    
    Boolean a1 = IsTriggerContext;
    Boolean a2 = IsVisualforcePageContext;
    Boolean a3 = IsWebServiceContext;
    Boolean a4 = IsExecuteAnonymousContext;
  }

  // public void OnBeforeInsert(List<CollaborationGroupMember> newCollaborationGroupMembers)
  // {
  // }
   
  // public void OnAfterInsert(List<CollaborationGroupMember> newCollaborationGroupMembers)
  // {
  // }
   
  // @future public static void OnAfterInsertAsync(Set<ID> newCollaborationGroupMemberIDs)
  // { 
  // }

  // public void OnBeforeUpdate(List<CollaborationGroupMember> oldCollaborationGroupMembers, List<CollaborationGroupMember> updatedCollaborationGroupMembers, Map<ID, CollaborationGroupMember> CollaborationGroupMemberMap)
  // {
  // }

  // public void OnAfterUpdate(List<CollaborationGroupMember> oldCollaborationGroupMembers, List<CollaborationGroupMember> updatedCollaborationGroupMembers, Map<ID, CollaborationGroupMember> CollaborationGroupMemberMap)
  // {
  // }

  // @future public static void OnAfterUpdateAsync(Set<ID> updatedCollaborationGroupMemberIDs)
  // {
  // }

  // public void OnBeforeDelete(List<CollaborationGroupMember> CollaborationGroupMembersToDelete, Map<ID, CollaborationGroupMember> CollaborationGroupMemberMap)
  // {
  // }

  public void OnAfterDelete(List<CollaborationGroupMember> deletedCollaborationGroupMembers, Map<ID, CollaborationGroupMember> CollaborationGroupMemberMap)
  {
    CollaborationGroupMemberHelper.CheckCollaborationGroupId(deletedCollaborationGroupMembers);
  }

  // @future public static void OnAfterDeleteAsync(Set<ID> deletedCollaborationGroupMemberIDs)
  // {
  // }

  // public void OnUndelete(List<CollaborationGroupMember> restoredCollaborationGroupMembers)
  // {
  // }


  // trigger contexts
  public boolean IsTriggerContext
  {get{ return m_isExecuting;}}

  public boolean IsVisualforcePageContext
  {get{ return !IsTriggerContext;}}

  public boolean IsWebServiceContext
  {get{ return !IsTriggerContext;}}

  public boolean IsExecuteAnonymousContext
  {get{ return !IsTriggerContext;}}
}