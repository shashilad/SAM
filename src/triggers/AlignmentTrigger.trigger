trigger AlignmentTrigger on AccountAlignment__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) 
{
  AlignmentTriggerHandler handler = new AlignmentTriggerHandler(Trigger.isExecuting, Trigger.size);


  if(Trigger.isInsert && Trigger.isBefore)
  {
    handler.OnBeforeInsert(Trigger.new);
  }

  if(Trigger.isUpdate && Trigger.isBefore)
  {
    handler.OnBeforeUpdate(Trigger.new);
  }
}