@isTest 
private class SetContactAccountId_TEST{
/*
@author       George Huene 
@date         May 30 2014 (SI-505)
@Description  To test 2 classes:
                1. SetContactAccountId_Cron 
                2. SetContactAccountId_Batch 
*/

  static testMethod void RunTest(){
    ID TeraAccountId=[SELECT ID FROM RecordType WHERE Name='Teradata Account' LIMIT 1].Id;
    ID OptimizerContactId=[SELECT ID FROM RecordType WHERE Name='Optimizer Contact' LIMIT 1].Id;
    
    Account Acc0 = new Account ( name='Test Account', AccountNumber='00001234', RecordTypeId=TeraAccountId);
    INSERT  Acc0;
    ID AccId=Acc0.Id;
    
    Account Acc1 = new Account ( name='Unknown', AccountNumber='00000001', RecordTypeId=TeraAccountId);
    INSERT  Acc1;

    Contact Cont0 = new Contact 
      ( FirstName='Test', LastName='Contact', AccountId=Acc1.Id, JJHCS__c='00001234'
        , RecordTypeId=OptimizerContactId);
    INSERT  Cont0;
    ID ContId=Cont0.id;

    Contact Cont1 = new Contact 
      ( FirstName='Test2', LastName='Contact2', AccountId=Acc1.Id, JJHCS__c='00001235'
        , RecordTypeId=OptimizerContactId);
    INSERT  Cont1;
    
    System.debug(' **** BEFORE BATCH JOB *****');
    Test.startTest();    
    Integer ROWS_LIMIT=3;
    SetContactAccountId_Batch batchApex = new SetContactAccountId_Batch(ROWS_LIMIT);
    System.debug('batchApex=' + batchApex);
    ID batchprocessid = Database.executeBatch(batchApex); 
    

    SetContactAccountId_Batch batchApex2 = new SetContactAccountId_Batch(ROWS_LIMIT);
    ID batchprocessid2 = Database.executeBatch(batchApex2); 
    Test.stopTest();      
    
    SetContactAccountId_Cron task = new SetContactAccountId_Cron();
    SchedulableContext SC = null;
    task.execute(SC);
    System.debug(' **** AFTER BATCH JOB *****');
/*
    System.debug(' **** BEFORE BATCH JOB #2*****');
    Test.startTest();    
    ROWS_LIMIT=1;
    SetContactAccountId_Batch batchApex3 = new SetContactAccountId_Batch(ROWS_LIMIT);
    System.debug('batchApex3=' + batchApex3);
    batchprocessid = Database.executeBatch(batchApex3);
    
    SetContactAccountId_Batch batchApex4 = new SetContactAccountId_Batch(ROWS_LIMIT);
    batchprocessid2 = Database.executeBatch(batchApex4); 
    Test.stopTest();      
    
    SetContactAccountId_Cron task2 = new SetContactAccountId_Cron();
    SchedulableContext SC2 = null;
    task2.execute(SC2);
    System.debug(' **** AFTER BATCH JOB #2 *****');
*/
// Check if the scripts/classes work
    Contact Contact = [SELECT ID, AccountId FROM Contact WHERE Id=:ContId];

    System.assertEquals(Contact.AccountId, AccId,
        Contact.AccountId +' <> '+AccId+' Contact.AccountId is NOT set thru JJHCS');
  }
}