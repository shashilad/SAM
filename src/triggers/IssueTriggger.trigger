trigger IssueTriggger on Issue__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

  if(Trigger.isBefore){
    if(Trigger.isInsert){
      IssueTriggerHandler.OnBeforeInsert(Trigger.new);
    }else if (Trigger.isUpdate){
      IssueTriggerHandler.OnBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
  }
  if(Trigger.isAfter){
    if(Trigger.isInsert){
       IssueTriggerHandler.OnAfterInsert(Trigger.new);
    }
  }    
/* No need for now:
  else if (Trigger.isInsert && Trigger.isAfter){
      IssueTriggerHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
  }else if (Trigger.isUpdate && Trigger.isAfter){
      IssueTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  }else if (Trigger.isDelete && Trigger.isBefore){
      IssueTriggerHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
  }else if (Trigger.isDelete && Trigger.isAfter){
      IssueTriggerHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
  }else if (Trigger.isUnDelete){
      IssueTriggerHandler.OnUndelete(Trigger.new);
  }
*/
}