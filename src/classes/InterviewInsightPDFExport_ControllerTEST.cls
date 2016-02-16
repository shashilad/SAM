@isTest
private class InterviewInsightPDFExport_ControllerTEST
{

	static testMethod void testIIPdfExportController()
	{
	
     	// create data
     	DataForTest dft = new DataForTest();
     
     	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('System Account'));
  
  	
  		String recId = System.Label.SamACO;
   		list<Stakeholder_Interview__c> sList = new list<Stakeholder_Interview__c>();

   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
    											     Account_Name__c = acc.id, cDate__c=system.Today(),
    											 	 Profile_Type__c = recId);
  		sList.add(accQi);

	 	insert sList;
		// create test user
        User u = dft.getTestUser('ETH-Sales System Admin');
   
    	System.RunAs(u){	
    		
    		 Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.InterviewInsightPDFExport;
        	Test.setCurrentPage(pageRef);
   
	        ApexPages.currentPage().getParameters().put('Id', acc.Id);	

	    	ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(sList);
   			InterviewInsightPDFExport_Controller qCls = new InterviewInsightPDFExport_Controller(stdController);

            
         	Test.stopTest();
			    	
	    	
    	}	    


	}
}