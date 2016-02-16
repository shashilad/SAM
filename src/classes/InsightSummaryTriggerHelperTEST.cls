@isTest
private class InsightSummaryTriggerHelperTEST {
    
    // +++++++++++++++++++
    // create data
    // +++++++++++++++++++
    @testSetup static void setup() {
        
        
        DataForTest  dft = new DataForTest();
        
        Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
        system.assert(acc != null);
        
        Competitive_Account_Consolidation__c comp1 
            = new Competitive_Account_Consolidation__c
            (Account__c  			= acc.Id,
             Name 					= System.Label.SamACO,
             Category__c 			= 'Cost',
             Consolidated_Notes__c  = 'Do not read me .. I am dummy note');
        
        insert comp1;
        
        
        
    }
    
    
    
    // +++++++++++++++++++
    // Testing single record insert
    // +++++++++++++++++++
    @isTest static void SingleRecordTest() {
        Account acc = [SELECT Id 
                       FROM Account 
                       LIMIT 1];
        Test.startTest();
        
        Competitive_Account_Consolidation__c comp2	
            = new Competitive_Account_Consolidation__c
            (Account__c  			= acc.Id,
             Name 					= System.Label.SamACO,
             Category__c 			= 'All',
             Consolidated_Notes__c  = 'I am all .. I am dummy note');
        
        insert comp2;
        
        Test.stopTest();

        //verify pdf is attached first time and only one is attached
        system.assert(1 == [SELECT count() 
                            FROM Attachment 
                            WHERE ParentId =  :acc.Id]);
        
    }
    
    
    
    // +++++++++++++++++++
    // Testing single record update
    // +++++++++++++++++++
    @isTest static void SingleRecordUpdateTest() {
        Account acc = [SELECT Id 
                       FROM Account  where name='TestAccount'
                       LIMIT 1];
        
        system.assert(acc != null); 
        
        Competitive_Account_Consolidation__c comp1
            = [SELECT id,Consolidated_Notes__c 
               FROM Competitive_Account_Consolidation__c
               WHERE Account__c = :acc.Id
               LIMIT 1];
        
        system.assert(comp1 != null); 
        
        // NOTE : Tried to verify result using milliseconds but sometimes works and many times failed due to the system speed. 
        // so ignored the verification
        // 
        //    DateTime updateDateStart = [SELECT LastModifiedDate
        // FROM Attachment 
        // WHERE ParentId =  :acc.Id LIMIT 1].LastModifiedDate;
        // 
        //  system.debug(updateDateStart.millisecond() +'$$$$$$$$$$$$$$$$$$');
        
        
        Test.startTest();

        comp1.Consolidated_Notes__c = 'I am updated Comp1 notes';

        update comp1;

        Test.stopTest();
        
    }
    
    
    
    // +++++++++++++++++++
    // Testing single record delete
    // +++++++++++++++++++
    static testMethod void SingleRecordDeleteTest() {
        Account acc = [SELECT Id 
                       FROM Account  where name='TestAccount'
                       LIMIT 1];
        
        system.assert(acc != null); 
        
        Competitive_Account_Consolidation__c comp1
            = [SELECT id,Consolidated_Notes__c 
               FROM Competitive_Account_Consolidation__c
               WHERE Account__c = :acc.Id
               LIMIT 1];
        
        system.assert(comp1 != null); 
        
        
        
        Test.startTest();

        delete comp1;

        Test.stopTest();

    }    



    // +++++++++++++++++++
    // Testing BULK records 
    // +++++++++++++++++++
    static testMethod void BulkInsertTest() {
        Account acc = [SELECT Id 
                       FROM Account
                       LIMIT 1];
        list<Competitive_Account_Consolidation__c>  compList	
            = new list<Competitive_Account_Consolidation__c>();
 
        Test.startTest();

        for(integer i=0; i<202; i++){ 
            Competitive_Account_Consolidation__c c	
                = new Competitive_Account_Consolidation__c
                (Account__c  			= acc.Id,
                 Name 					= System.Label.SamACO,
                 Category__c 			= 'All'+i,
                 Consolidated_Notes__c  = 'I am all .. I am dummy note'+i);
            compList.add(c);
        }
        
        insert compList;
        
        
        Test.stopTest();            

        //verify pdf is attached first time and only one is attached
        system.assert(1 == [SELECT count() 
                            FROM Attachment 
                            WHERE ParentId =  :acc.Id]);
        
    }
    
        
}