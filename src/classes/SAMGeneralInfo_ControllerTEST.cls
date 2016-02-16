@isTest
private class SAMGeneralInfo_ControllerTEST {

    static testMethod void TestSAMGeneralInfoController() {
    	
      	// create data

  
  		String profName = System.Label.SamACO;

        Stk_ProfileMaster__c profMaster = new Stk_ProfileMaster__c(Name=profName,
                                                    ProfileText__c='ACO Leader profile' );
		insert profMaster;
    
        // create test user
       	DataForTest dft = new DataForTest();
        
        User u = dft.getTestUser('SAM Group');
   
    	System.RunAs(u){	
    		 Test.startTest();
    		
     		// testing redirect 
    		PageReference pageRef = Page.SAMGeneralInfo;
            
        	Test.setCurrentPage(pageRef);
      	
            SAMGeneralInfo_Controller qCls = new SAMGeneralInfo_Controller();
            
			qCls.profName=profMaster.Name;
            
            qCls.assignName();
			
            system.assert(qCls.pName!=null);	  
            
            Test.stopTest();
			    	
	    	
    	}	    
    }
    
 
}