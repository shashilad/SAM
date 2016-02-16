trigger InterviewinsightTrigger on Interview_Insight__c (after update,after insert) {
   InterviewInsightTriggerHelper.updateTimestampOnInterview(Trigger.New);
}