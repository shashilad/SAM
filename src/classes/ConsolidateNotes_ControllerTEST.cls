@isTest
private class ConsolidateNotes_ControllerTEST {

    static testMethod void TestController() {
    	
    	// create data
    	list<AccountQItem__c> qiItem = new list<AccountQItem__c>();
       	list<AccountQI__c> qi = new list<AccountQI__c>();
       	DataForTest dft = new DataForTest();
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
   		AccountQI__c accQi = new AccountQI__c (Name = 'Test title',
    											 Account_Name__c = acc.id, 
    											 	RecordTypeId = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQI__c').get('Payer - ACO Profile'));
   		qi.add(accQi);
   		insert qi;
				
		for(integer i=0; i<2 ; i++){
			AccountQItem__c accQitem = new AccountQItem__c (Custom_Question__c ='Question '+i,
																Category__c = 'Key Questions',
																QiName__c = accQi.Id,
																	RecordTypeid = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQItem__c').get('Payer - ACO Profile'));
			qiItem.add(accQitem);
		}
		insert qiItem;
	   	Competitive_Account_Consolidation__c c = new Competitive_Account_Consolidation__c
	    													(Account__c  = acc.Id,
	    															Category__c = 'All',
																			Consolidated_Notes__c='Do not read me .. I am dummy note');
																			
	   	insert c;

    	User u = dft.getTestUser('ETH-Sales System Admin');
   
    	System.RunAs(U){	
    		Test.startTest();
    	
    		// testing redirect 
    		PageReference pageRef = Page.ConsolidateNotes;
        	Test.setCurrentPage(pageRef);
    
	        ApexPages.currentPage().getParameters().put('Id', acc.Id);	
	  
	    	ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(qi);
	    	ConsolidateNotes_Controller qCls = new ConsolidateNotes_Controller(stdController);
	    	qCls.getItems();
	    	
	    	//testing search
	    	qCls.strSearch = 'Question';
	    	qCls.getData();
	    	qCls.strSearch = 'Ky';
	    	qCls.getData();
	    	
	    	//testing reset
	    	qCls.doReset();
	    	
	    	//testing save
	    	qCls.doSave();	
	    	
	    	//testing if note preset
	    	Test.stopTest();
			    	
	    	
    	}	
    }
}