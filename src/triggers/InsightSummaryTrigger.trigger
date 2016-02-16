trigger InsightSummaryTrigger on Competitive_Account_Consolidation__c (after insert,after update, after delete) {
    
    set<Id> accountIds = new set<Id>();
    if((Trigger.isInsert  || Trigger.isUpdate) 
       && (Trigger.isAfter)) {   
         for (Competitive_Account_Consolidation__c c : trigger.New){
           accountIds.add(c.Account__c);    
        }
        for(Id accountId : accountIds){
            InsightSummaryTriggerHelper.attachPdf(accountId);
        }
    }

    if(Trigger.isDelete && Trigger.isAfter){

       for (Competitive_Account_Consolidation__c c : trigger.Old){
           accountIds.add(c.Account__c);    
        }
        for(Id accountId : accountIds){
            InsightSummaryTriggerHelper.attachPdf(accountId);
        }
    }

    
}