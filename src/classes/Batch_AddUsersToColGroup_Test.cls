@isTest(seealldata=true)
public class Batch_AddUsersToColGroup_Test {
  
     static testMethod void testBatch() {
         test.startTest();
         ID batchprocessid = Database.executeBatch(new Batch_AddUsersToColGroup(), 200);
         test.stopTest();
     }
     static testMethod void testScheduler() {
         test.startTest();
         Batch_AddUsersToColGroup sch = new Batch_AddUsersToColGroup();
         sch.getUniqueJobName();
         sch.scheduleJob(null);
         sch.execute(null);    
         test.stopTest();
     }  
     
}