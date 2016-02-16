@isTest
private class ContactListsForSystem_ControllerTEST {

    static testMethod void TestController() {
        DataForTest dft = new DataForTest();

    	Account masterAcct = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('System Account'));
    	Account childAcct1 = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
    	Account childAcct2 = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
		
		
		childAcct1.parentId = masterAcct.Id;
		update childAcct1;
		childAcct2.parentId = masterAcct.Id;
		update childAcct2;
		list<Contact> masterContacts = dft.getContacts(2,masterAcct.id);
		list<Contact> child1Contacts = dft.getContacts(5,childAcct1.id);
		list<Contact> child2Contacts = dft.getContacts(5,childAcct2.id);
		
		User u = dft.getTestUser('ETH-Sales System Admin');
		
		System.RunAs(U){
			
			Test.startTest();

			ApexPages.currentPage().getParameters().put('Id',masterAcct.Id);
			ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(masterContacts);
			ContactListsForSystem_Controller qCls = new ContactListsForSystem_Controller(stdController);
			
			Test.stopTest();
			
			//verify result
			list<list<Contact>> totalContacts = new list<list<Contact>>();
			totalContacts = qCls.accConList.values();
			system.assert(totalContacts[0].size()==5);
						
		}		    	
        
    }
}