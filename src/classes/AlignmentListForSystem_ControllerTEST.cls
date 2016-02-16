@isTest
private class AlignmentListForSystem_ControllerTEST {

    static testMethod void TestController() {
        DataForTest dft = new DataForTest();

    	Account masterAcct = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('System Account'));
    	Account childAcct1 = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
    	Account childAcct2 = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
		
		
		childAcct1.parentId = masterAcct.Id;
		childAcct1.JJhcs_Number__c = '12300';
		update childAcct1;
		childAcct2.parentId = masterAcct.Id;
		childAcct2.JJhcs_Number__c = '12301';
		update childAcct2;
		list<AccountAlignment__c> child1Align = createAlign('12300');
		list<AccountAlignment__c> child2Align = createAlign('12301');
		
		User u = dft.getTestUser('ETH-Sales System Admin');
		
		System.RunAs(U){
			
			Test.startTest();

			ApexPages.currentPage().getParameters().put('Id',masterAcct.Id);
			
			ApexPages.StandardController stdController = new ApexPages.StandardController(masterAcct);
			
			AlignmentListForSystem_Controller qCls     = new AlignmentListForSystem_Controller(stdController);
			
			Test.stopTest();
			
			//verify result
			list<list<AccountAlignment__c>> totalRecords = new list<list<AccountAlignment__c>>();
	
			totalRecords = qCls.accAlgnList.values();

			system.assertEquals(totalRecords[0].size(),2);
						
		}		    	
        
    }
    static list<AccountAlignment__c> createAlign(string jjhcs){
       list<AccountAlignment__c> aaList = new list<AccountAlignment__c>();
       for(integer i=0; i<2; i++){
       	   aaList.add(new AccountAlignment__c(Name='Ethicon', JJhcs_number__c =jjhcs));
       }
       insert aaList;
       return aaList;
    }
}