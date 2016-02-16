/* ****************************************************************************************************************************************
** Developed by : Shashi Lad
**      purpose : Test class for Batch_ContactDeDup
** **************************************************************************************************************************************** */
@isTest
public class Batch_ContactDeDup_Test {
  
     static testMethod void testBatch() {
         List<Contact> cRecords = createData();
         system.assertEquals(true,cRecords.size()==2);
         test.startTest();
         ID batchprocessid = Database.executeBatch(new Batch_ContactDeDup(), 200);
         test.stopTest();
     }
     static testMethod void testScheduler() {
         test.startTest();
         Batch_ContactDeDup sch = new Batch_ContactDeDup();
         sch.getUniqueJobName();
         sch.scheduleJob(null);
         sch.execute(null);    
         test.stopTest();
     }  
     static list<contact> createData(){
        id aRecId = [select id from recordType where sObjecttype='Account' and  name like 'Teradata%' limit 1].id;
        id cRecId = [select id from recordType where sObjecttype='Contact' and name like 'ISR%' limit 1].id;
        Account acc = new Account(name='Test Account', jjhcs_number__c ='111111', recordTypeId=aRecId);
        insert acc;
        list<Contact> conRec = new list<Contact>();
        for (integer i=0;i<2;i++ ){
             Contact con = new Contact(LastName = 'LadTest',
                                       recordtypeId = cRecId,
                                       AccountId = acc.Id );
              conRec.add(con);
       }
       insert conRec;
       return conRec;
    }    
   
 
}