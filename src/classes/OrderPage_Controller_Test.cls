@isTest
private class OrderPage_Controller_Test {

	private static testMethod void test1() {
 	    Account a = new Account(Name = 'Test Account for remoting', JJHCS_Number__c='11223344');
        ApexPages.StandardController controller = new ApexPages.StandardController (a);
        OrderPage_Controller p= new OrderPage_Controller(controller);
     
	}

}