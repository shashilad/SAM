/*
 * Author/Date: Shashi Lad 4-7-2015
 * Purpose    : Utility class to create test data
 * 
*/
@isTest
public with sharing class DataForTest {
    
    // members 

 
    // get user profile
    public Profile getTestUserProfile( String profileName){
		Profile prof;
     	try {          
          		prof = [select id, name from profile where name=:profileName limit 1]; 
     	}catch (Exception e){
     			System.debug('********* can not find profile ******' + e);	
        }
        return prof;
    }
    
    // get user role
    public UserRole getTestUserRole( String roleName){
		UserRole role;
     	try {          
          		role = [select id from UserRole where Name=:roleName limit 1]; 
     	}catch (Exception e){
     			System.debug('********* can not find role ******' + e);	
        }
        return role;
    }
   
    // get bulk Accounts
    public List<Account> getAccounts (Integer numOfAcct, String recTypeId) {
	    list<Account> accs = new list<Account>();
		for (Integer i=0 ; i < numOfAcct ; i++){
			Account a = new Account();
			a.Name = 'TestAccount' + i;
			a.RecordTypeId =  recTypeId;
			accs.add(a);
		}
		insert accs;	
        return accs;
    }
    
    // get single Account 
    public Account getAccount (String recTypeId) {
    	Account acc = new Account ( Name = 'TestAccount', 
                                    RecordTypeId = recTypeId,
				                	JJHCS_number__c = '00001234',
               						IDN_CD__c = '123');
		insert acc;		  
		return acc;
    }
	
    // get bulk Contacts
    public List<Contact> getContacts (Integer numOfCon, String accId) {
	    list<Contact> cons = new list<Contact>();
		for (Integer i=0 ; i < numOfCon ; i++){
			Contact a = new Contact();
			a.LastName = 'TestContact' + i;
			a.AccountId =  accId;
			cons.add(a);
		}
		insert cons;	
        return cons;
    }
    
	// get standard pricebook
	public Pricebook2 getStdPriceBook(){
		Pricebook2 pb = new Pricebook2 (Name ='Standard Price Book', isActive=true );
		insert pb;
		return pb;
	}

	// Single order WITHOUT pricebook	
    public Order getOrder(String accId){
    	Order ord = new Order(Accountid=accId, EffectiveDate=Date.Today(), Status='Draft');
    	insert ord;
    	return ord;
    }
    
	// bulk order WITHOUT pricebook	
    public list<Order> getOrders(Integer numOfOrders, String accId){
    	list<Order> orderList = new list<Order>();
    	for(integer i=0 ; i < numOfOrders ; i++){
    		Order ord = new Order(Accountid=accId, EffectiveDate=Date.Today(), Status='Draft');
    		orderList.add(ord);
    	}	
    	if (orderList != null) insert orderList;
    	return orderList;
    }
    
    // get SAM user
    public User getTestUser(String profileName){
        
        Profile pro = getTestUserProfile(profileName); 
      //  UserRole role = getTestUserRole('Top Level');
        Long randomNumber = Math.mod (Math.mod (System.currentTimeMillis(), 1000000) , 989898989);
        User myUser = new User(alias = 'SamTest', email='SAMTestUser@salesforce.com', 
            emailencodingkey='UTF-8', firstname='SAMStdUser', lastname='Admin', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = pro.Id,  timezonesidkey='America/Los_Angeles', username='unittestuser'+randomNumber+'@testorg.com' );
        insert   myUser; 
        return myUser;
    }

    
}