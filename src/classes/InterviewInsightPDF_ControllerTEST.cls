@isTest
private class InterviewInsightPDF_ControllerTEST {

    static testMethod void TestInterviewInsightPDFController() {
    	
      	// create data
    
       	DataForTest dft = new DataForTest();
    
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
  
  	
  		String recId = System.Label.SamACO;
   	
   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
    											     Account_Name__c = acc.id, cDate__c=system.Today(),
    											 	 Profile_Type__c = recId);
	 	insert accQi;
  	
		// create test user
        User u = dft.getTestUser('SAM Group');
   
    	System.RunAs(u){	
    		 Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.InterviewInsightPDF;
        	Test.setCurrentPage(pageRef);
   
	        ApexPages.currentPage().getParameters().put('Id', accQi.Id);	

	    	ApexPages.StandardController stdController = new ApexPages.StandardController(accQi);
   			InterviewInsightPDF_Controller qCls = new InterviewInsightPDF_Controller(stdController);

	    	 Test.stopTest();
			    	
	    	
    	}	    
    }
    
 
}