/*

  Contexts not being used
 , after insert, after undelete, after update, before delete, before insert, before update

*/
trigger CollaborationGroupMemberTrigger on CollaborationGroupMember (after delete)
{
  CollaborationGroupMemberTriggerHandler handler = new CollaborationGroupMemberTriggerHandler(Trigger.isExecuting, Trigger.size);

  // if(Trigger.isInsert && Trigger.isBefore)
  // {
  //   handler.OnBeforeInsert(Trigger.new);
  // }
  // else if(Trigger.isInsert && Trigger.isAfter)
  // {
  //   handler.OnAfterInsert(Trigger.new);
  //   CollaborationGroupMemberTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
  // }
  // else if(Trigger.isUpdate && Trigger.isBefore)
  // {
  //   handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  // }

  // else if(Trigger.isUpdate && Trigger.isAfter)
  // {
  //   handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  //   CollaborationGroupMemberTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
  // } 

  // else if(Trigger.isDelete && Trigger.isBefore)
  // {
  //   handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
  // }else 

  if(Trigger.isDelete && Trigger.isAfter)
  {
    handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    // CollaborationGroupMemberTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
  }

  // else if(Trigger.isUnDelete)
  // {
  //   handler.OnUndelete(Trigger.new);
  // }
}