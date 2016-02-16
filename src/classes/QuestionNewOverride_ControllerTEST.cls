@isTest
private class QuestionNewOverride_ControllerTEST {
	
    static testMethod void TestController() {

    	DataForTest dft = new DataForTest();

    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
   		AccountQI__c accQi = new AccountQI__c (Name = 'Test title',
    											 Account_Name__c = acc.id, 
    											 	RecordTypeId = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQI__c').get('Payer - ACO Profile'));
   		insert accQi;

    	User u = dft.getTestUser('ETH-Sales System Admin');
   
    	System.RunAs(U){	
    		Test.startTest();
    	
    		// testing redirect 
    		PageReference pageRef = Page.QuestionNewOverride;
        	Test.setCurrentPage(pageRef);
    
	        ApexPages.currentPage().getParameters().put('Id', accQi.Id);	
	    	ApexPages.currentPage().getParameters().put('retURL', '/'+accQi.Id);	
    	
	    	ApexPages.StandardController stdController = new ApexPages.StandardController(accQi);
	    	QuestionNewOverride_Controller qCls = new QuestionNewOverride_Controller(stdController);
	    	qCls.addRecType();
	        String pgUrl = ApexPages.currentPage().getUrl();
	        system.debug('-------- pgUrl ----------' + pgUrl);
	        system.assert(pgUrl.Contains('/apex/questionnewoverride'));
	
	    	// testing exception with Save&New   behavior 
	    	ApexPages.currentPage().getParameters().put('retURL', 'dummy');
	    	qCls = new QuestionNewOverride_Controller(stdController);
	    	qCls.mastId = accQi.Id;
	    	qCls.addRecType();
	     	system.assert(pgUrl.Contains('/apex/questionnewoverride'));
	    	
	    	Test.stopTest();
    	}	
	}
}