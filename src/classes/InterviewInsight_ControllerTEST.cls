@isTest
private class InterviewInsight_ControllerTEST {

    static testMethod void TestInterviewInsight() {
    	
      	// create data
    	list<Stakeholder_Interview__c> qiMain = new list<Stakeholder_Interview__c>();
       	DataForTest dft = new DataForTest();
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
  
  		String recId = System.Label.SamACO;
   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
    											     Account_Name__c = acc.id, cDate__c=system.Today(), 
    											 	 Profile_Type__c = recId);
	 	insert accQi;
  	
		Insight_Category__c iCat = new Insight_Category__c(Name='Other - Testing');
		insert iCat;

		// create test user
        User u = dft.getTestUser('SAM Group');
   
    	System.RunAs(u){	
    		Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.InterviewInsight;
        	Test.setCurrentPage(pageRef);
   
	        ApexPages.currentPage().getParameters().put('Id', accQi.Id);	

	    	ApexPages.StandardController stdController = new ApexPages.StandardController(accQi);
   			InterviewInsight_Controller qCls = new InterviewInsight_Controller(stdController);
            
            qCls.doSave();
  
  			
  			// assert that an attachment exists for the record
    		System.assertEquals(1,[select count() from attachment where parentId = :accQi.id]);
    		
			//testing adding categories
			qCls.addCategories();
			qCls.profileType=new List<String>{'test1','test2'};
			qCls.goOk();
			
			// confirm categories added
			id recordId = [select id from Interview_Insight__c where Name = 'test1'].id;
			system.assert(recordId != null);	
			
			// testing removing category
	        ApexPages.currentPage().getParameters().put('rId', recordId);	
			
			qCls.removeCategory();
			
			//confirm category removed			
			system.assertEquals(0, [select count() from Interview_Insight__c where Name = 'test1'] );

			//testing exception
	        ApexPages.currentPage().getParameters().put('rId', '');	
			qCls.removeCategory();
		
			//testing other methods
            
            qCls.searchCat = 'test';

            qCls.newCategory();
            
            system.assertEquals(1, [select count() from Insight_Category__c where name='Other - test']);

            qCls.searchCat = 'testing';

            qCls.getCategories();
            try{
            	qCls.newCategory();
            }catch(Exception e){
            	system.assert(e.getMessage().Contains('DUPLICATE'));
            }

            qCls.viewPdf();

            qCls.doCancel();

	    	Test.stopTest();
	    	 
	    	 
			    	
	    	
    	}
    }
}