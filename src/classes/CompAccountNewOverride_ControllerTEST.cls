@isTest
private class CompAccountNewOverride_ControllerTEST {

    static testMethod void ControllerTest() {
        // create data
    	list<Stakeholder_Interview__c> qiMain = new list<Stakeholder_Interview__c>();
       	DataForTest dft = new DataForTest();
       	
       	// insert account  
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
   		
 		String recId = 'ACO';
   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
    											     Account_Name__c = acc.id, cDate__c=system.today(),
    											 	 Profile_Type__c = recId);
			insert accQi;												
   	
		// create test user
        User u = dft.getTestUser('ETH-Sales System Admin');
    
    	System.RunAs(u){	
    
    		Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.CompAccountNewOverride;
  
        	Test.setCurrentPage(pageRef);
  
  		        ApexPages.currentPage().getParameters().put('Id', accQi.Id);	
 	
 		    	ApexPages.StandardController stdController = new ApexPages.StandardController(accQi);
    			CompAccountNewOverride_Controller qCls = new CompAccountNewOverride_Controller(stdController);
				
				qCls.selectProfile();
				
    
	    	Test.stopTest();
    	}	    
    }
 
}