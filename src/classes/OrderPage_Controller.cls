public class OrderPage_Controller {
    Account acc;
    public list<Order> ord {get;set;}
    public OrderPage_Controller(ApexPages.StandardController controller) {
        acc =(Account) controller.getRecord(); 
        ord = [select Year_inText__c from Order where AccountId = :acc.id];
    }
}