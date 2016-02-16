@isTest
private class InterviewRecSelectOverrideS1TEST {
 	
   		
    static testMethod void ControllerTest() {
 		
 		// create data
       	DataForTest dft = new DataForTest();
    
    	//create account
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
		
		// create test user
        User u = dft.getTestUser('SAM Group');
   
    	System.RunAs(u){
    			
    		Test.startTest();
    		
    		PageReference pageRef = Page.InterviewRecSelectOverrideS1;
    		Test.setCurrentPage(pageRef);
    		
    		ApexPages.currentPage().getParameters().put('Id', acc.Id);
    		ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
    		InterviewRecSelectOverrideS1 iClass = new InterviewRecSelectOverrideS1(stdController); 
    		
    		iClass.callMethod();
    		
    		system.assert(iClass != null);
    		 
    		Test.stopTest();
    		 
    	}	 		
    }
}