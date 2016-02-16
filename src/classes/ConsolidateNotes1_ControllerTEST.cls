@isTest
private class ConsolidateNotes1_ControllerTEST {

    static testMethod void TestController() {
    	
    	// create data
       	list<Stakeholder_Interview__c> accQiList = new list<Stakeholder_Interview__c>();
       	list<Interview_Insight__c> iiList = new list<Interview_Insight__c>();
       	DataForTest dft = new DataForTest();
    	
    	Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
   	
   		String recId = System.Label.SamACO;
   		Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
    											     Account_Name__c = acc.id,cDate__c=system.today(), 
    											 	 Profile_Type__c = recId);	
    	accQiList.add(accQi);
   		insert accQiList;
		integer i = 0;
        for(Interview_Insight__c ii : [select Comments__c from Interview_Insight__c where Stakeholder_Interviews__c= :accQi.id]){
        	ii.Comments__c = 'This is a sample comment. and number'+i;
			iiList.add(ii);
        }
		update iiList;
		system.debug('###############' + iilist);
		
	   	Competitive_Account_Consolidation__c c = new Competitive_Account_Consolidation__c
	    													(Account__c  = acc.Id,
	    													        Name ='ACO',
	    															Category__c = 'Cost',
																			Consolidated_Notes__c='Do not read me .. I am dummy note');
																			
	   	insert c;

    	User u =  dft.getTestUser('ETH-Sales System Admin');
   
    	System.RunAs(U){	
    		Test.startTest();
    	
    		// testing redirect 
    		PageReference pageRef = Page.ConsolidateNotes1;
        	Test.setCurrentPage(pageRef);

	        ApexPages.currentPage().getParameters().put('Id', acc.Id);	
	  
	    	ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accQiList);
	    	ConsolidateNotes1_Controller qCls = new ConsolidateNotes1_Controller(stdController);
	    	
	    	qCls.getItems();
			qCls.getCategories();	    	
			
	    	//testing search
	    	qCls.profileType = 'All';
	    	qCls.strSearch = 'test';
	    	qCls.getProfileData(qCls.profileType);
	    	qCls.strSearch = 'number';
	    	qCls.getProfileData(qCls.profileType);


	    	//testing save

	    	qCls.doSave();	

	    	qCls.attach();
	    	
	    	//testing reset
	    	qCls.doReset();
	    	
	    	
	    	
	    	Test.stopTest();
			    	
	    	
    	}	
    }
}