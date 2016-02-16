trigger OrderTrigger on Order (after delete, after insert, after undelete,after update, before delete, before insert, before update) {

  if(Trigger.isBefore && Trigger.isInsert){
	OrderTriggerHandler.OnBeforeInsert(Trigger.New);
  }
/* No need for now:
  else if (Trigger.isInsert && Trigger.isAfter){
      OrderTriggerHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
  }else if (Trigger.isUpdate && Trigger.isAfter){
      OrderTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  }else if (Trigger.isDelete && Trigger.isBefore){
      OrderTriggerHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
  }else if (Trigger.isDelete && Trigger.isAfter){
      OrderTriggerHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
  }else if (Trigger.isUnDelete){
      OrderTriggerHandler.OnUndelete(Trigger.new);
  }
*/
}