/* after delete, , after undelete, after update, before delete, before insert, before update */

trigger UserTrigger on User (after insert)
{
  UserTriggerHandler handler = new UserTriggerHandler(Trigger.isExecuting, Trigger.size);

  if(Trigger.isInsert && Trigger.isAfter)
  {
    handler.OnAfterInsert(Trigger.newMap.keySet());
    // UserTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
  }
  
/*  Rem out for code coverage 10/3/2014
//=======================================
  
  else if(Trigger.isInsert && Trigger.isBefore)
  {
    // handler.OnBeforeInsert(Trigger.new);
  }
  else if(Trigger.isUpdate && Trigger.isBefore)
  {
    // handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  }

  else if(Trigger.isUpdate && Trigger.isAfter)
  {
    // handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    // UserTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
  }
  else if(Trigger.isDelete && Trigger.isBefore)
  {
    // handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
  }

  else if(Trigger.isDelete && Trigger.isAfter)
  {
    // handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    // UserTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
  }
  else if(Trigger.isUnDelete)
  {
    // handler.OnUndelete(Trigger.new);
  }
*/
}