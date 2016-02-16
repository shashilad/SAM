@isTest(seeAllData=true)
private class SamProfileInfoRes_ControllerTEST {
	
	static testMethod void TestSamProfileInfoController() {
        DataForTest dft = new DataForTest();
		Stk_ProfileMaster__c pMast = new Stk_ProfileMaster__c(Name =System.Label.SamACO,
                                                              Title_A__c = 'title1',
                                                              Title_B__c = 'title2',
                                                              Title_C__c = 'title3');
        insert pMast;
		pMast = new Stk_ProfileMaster__c(Name ='Contents',
                                         Title_A__c = 'title1',
                                         Title_B__c = 'title2',
                                         Title_C__c = 'title3');
        insert pMast;
        
       	Stk_InfoLinks__c lnk = new Stk_InfoLinks__c(Name='C',
                                                    Title__c='link title',
                                                    Link__c='http://www.salesforce.com',
                                                    Stakeholder_Profile_Master__c= pMast.Id);
        
        insert lnk;
        
        User u = [select id from user 
                  	where profileid in (select id from profile where name='SAM Group') 
                  		and isActive=true
                  			limit 1];
 		
    	System.RunAs(U){	
    		Test.startTest();	
            
            PageReference pageRef = Page.SamProfileInfoRes;
            
        	Test.setCurrentPage(pageRef);
            
			ApexPages.currentPage().getParameters().put('profileName',System.Label.SamACO);
            
    		SamProfileInfoRes_Controller ctrl = new SamProfileInfoRes_Controller();
			
			system.assertEquals(ctrl.pType, System.Label.SamACO);
            system.assert(ctrl.listAll != null);
    
			ctrl.getDocIds();

		//	ctrl.getListAll();
        
        	ctrl.CountDocClicks();
            
            ctrl.CountLinkClicks();
            
            //testing negative 
            ctrl.pType=null;
            try{
           	 ctrl.doListAll();
            }catch (exception e){
            	system.assert(e.getMessage().contains('No data found'));
                    
            }
            
			Test.stopTest();
        }

	}

}