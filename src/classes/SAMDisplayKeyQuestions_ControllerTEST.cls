@isTest
private class SAMDisplayKeyQuestions_ControllerTEST {

   static testMethod void TestSAMDisplayKeyQuestionsController() {
    	
      	// create data
    
       	DataForTest dft = new DataForTest();
    
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
  
  	
  		String recId = System.Label.SamACO;
        
       Stk_ProfileMaster__c  profMast = new Stk_ProfileMaster__c (Name = recId );
       insert profMast;
       
   	   Stk_ProfileMaster__c  profGen = new Stk_ProfileMaster__c (Name = 'General' );
       insert profGen;
       
   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test Title',
    											     Account_Name__c = acc.id, cDate__c=system.Today(),
    											 	 Profile_Type__c = recId);
	 	insert accQi;
       
        KeyQuestion__c questions = new KeyQuestion__c (Stakeholder_Profile_Master__c = profMast.id, 
                                                       Category__c = 'WHAT',
                                                       Question__c ='This is WHAT question');
        insert questions;
       
       questions = new KeyQuestion__c (Stakeholder_Profile_Master__c = profGen.id, 
                                        Category__c = 'WHO',
                                        Question__c ='This is WHO question');
  	
		insert questions;
       
        // create test user
        User u = dft.getTestUser('SAM Group');
   
    	System.RunAs(u){	
    		
    		Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.SAMDisplayKeyQuestions;
        	Test.setCurrentPage(pageRef);
   
	        ApexPages.currentPage().getParameters().put('Id', accQi.Id);	

	    	ApexPages.StandardController stdController = new ApexPages.StandardController(accQi);
   			SAMDisplayKeyQuestions_Controller qCls = new SAMDisplayKeyQuestions_Controller(stdController);

			system.assert(qCls.kqList != null);
            
            //testing exception
            pageRef = Page.SAMDisplayKeyQuestions;
        	Test.setCurrentPage(pageRef);
   
	        ApexPages.currentPage().getParameters().put('pname', recId);	
            try{
            	qCls = new SAMDisplayKeyQuestions_Controller(null);
            }catch(exception e){
                System.assert(e.getMessage().contains('No record found'));
            }    
                         
           
	    	Test.stopTest();
			    	
	    	
    	}	    
    }
    


}