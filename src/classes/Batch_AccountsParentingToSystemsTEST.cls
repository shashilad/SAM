/* ****************************************************************************************************************************************
** Developed by : Shashi Lad 4/27/2015
**      purpose : Test class for Batch_AccountsParentingToSystems
** **************************************************************************************************************************************** */
@isTest
public with sharing class Batch_AccountsParentingToSystemsTEST {
	
 
     static testMethod void testParenting() {
     	
    	Account parAccount = getAccount('System Account');
  		Account childAccount1 = getAccount('Teradata Account');
  		Account childAccount2 = getAccount('Teradata Account');
        
        parAccount.IDN_ROW_OBS_IND__c = false;
        update parAccount;
        
        childAccount1.IDN__c = parAccount.Name;
        update childAccount1;
    
        childAccount2.IDN__c = parAccount.Name;
        update childAccount2;
   		
   		DataForTest dft = new DataForTest();
 		User u = dft.getTestUser('ETH-Sales System Admin');
    
    	System.RunAs(u){	    

	        test.startTest();
	
	        ID batchprocessid = Database.executeBatch(new Batch_AccountsParentingToSystems(), 200);
	
	        test.stopTest();
	        
	        Account a1 = [select ParentId from Account where id = :childAccount1.Id limit 1];
			system.assert(a1.ParentId == parAccount.Id);

	        Account a2 = [select ParentId from Account where id = :childAccount1.Id limit 1];
			system.assert(a2.ParentId == parAccount.Id);
			
    	}
     }

     static testMethod void testUnParenting() {

 		Account parAccount = getAccount('System Account');
  		Account childAccount1 = getAccount('Teradata Account');
  		Account childAccount2 = getAccount('Teradata Account');
           
        parAccount.IDN_ROW_OBS_IND__c = true;
        update parAccount;
   
        childAccount1.ParentId = parAccount.Id;
        update childAccount1;
        
        childAccount2.ParentId = parAccount.Id;
        update childAccount2;
   		
		DataForTest dft = new DataForTest();
    	User u = dft.getTestUser('ETH-Sales System Admin');
    
    	System.RunAs(u){	    
	        test.startTest();
	        ID batchprocessid = Database.executeBatch(new Batch_AccountsParentingToSystems(), 200);
	        test.stopTest();
	        
	        Account a1 = [select ParentId from Account where id = :childAccount1.Id limit 1];
			system.assert(a1.ParentId == null);

	        Account a2 = [select ParentId from Account where id = :childAccount1.Id limit 1];
			system.assert(a2.ParentId == null);
			
    	}
     }


     static testMethod void testScheduler() {
         test.startTest();
         Batch_AccountsParentingToSystems sch = new Batch_AccountsParentingToSystems();
         sch.getUniqueJobName();
         sch.scheduleJob(null);
         sch.execute(null);    
         test.stopTest();
     }  

 	 static Account getAccount(String recType){
 	
 		DataForTest dft = new DataForTest();
 
 	 	return dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get(recType));
 	    
 	 }    
 	 
 
}