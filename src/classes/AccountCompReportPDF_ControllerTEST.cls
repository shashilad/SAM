@isTest
private class AccountCompReportPDF_ControllerTEST {

    static testMethod void TestController() {

      	// create data
       	DataForTest dft = new DataForTest();
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
	   	Account accNegative = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));

   		Competitive_Account_Consolidation__c c = new Competitive_Account_Consolidation__c
	    													(Account__c  = acc.Id,
	    															Category__c = 'All',
																			Consolidated_Notes__c='Do not read me .. I am a dummy note');
																			
	   	insert c;
	   	
	   	User u = dft.getTestUser('ETH-Sales System Admin');
   
    	System.RunAs(u){	
    		Test.startTest();
			
			PageReference pageRef = Page.AccountCompReportPDF;
        	Test.setCurrentPage(pageRef);
			
			// negative scenerio - no records - exception handled 
			ApexPages.StandardController controller = new ApexPages.StandardController(accNegative);
			AccountCompReportPDF_Controller acr = new AccountCompReportPDF_Controller(controller);

			// positive scenerio
			ApexPages.currentPage().getParameters().put('Id', acc.Id);	
			controller = new ApexPages.StandardController(acc);
			acr = new AccountCompReportPDF_Controller(controller);

			system.assert(acr != null); 
			
			Test.stopTest();
    	}
    }
}