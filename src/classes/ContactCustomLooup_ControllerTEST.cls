@isTest
private class ContactCustomLooup_ControllerTEST {

    static testMethod void TestController() {
		
      	// create data
       	DataForTest dft = new DataForTest();
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
    	
    	User u = dft.getTestUser('ETH-Sales System Admin');
 		
 		System.RunAs(u){	
    		Test.startTest();
			
			PageReference pageRef = Page.ContactCustomLookup;
        	Test.setCurrentPage(pageRef);
			
			ApexPages.currentPage().getParameters().put('lksrch', 'Test');
			ApexPages.currentPage().getParameters().put('aid', acc.Id);
			ApexPages.currentPage().getParameters().put('frm', 'frm');
			ApexPages.currentPage().getParameters().put('txt', 'txt');
				
			ContactCustomLooup_Controller acr = new ContactCustomLooup_Controller();
			
			system.assert(acr != null);
			
			acr.search();
			acr.getFormTag();
			acr.getTextBox();
			
			acr.Contact.lastName='Testcontact';
			acr.saveContact();
			
			acr.searchString = 'Testcontact';
			acr.search();
			
			system.assert(acr.results.size()==1);			
						
			Test.stopTest();
    	}
    }
}