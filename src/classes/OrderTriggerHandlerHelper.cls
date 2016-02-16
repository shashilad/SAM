/**
  * @author       Shashi Lad 
  * @date         Apr 7th 2015
  */
public  class OrderTriggerHandlerHelper {

	//members

    
	// Methods 
  	public static void AssignDefualtPriceBookToOrder(list<Order> newOrders){
  		Id pbId = [select Id from Pricebook2 
  						where Name = 'Standard Price Book' limit 1].Id; 
  		for (Order o : newOrders){
  			o.PriceBook2Id  = pbId;
  		} 
  	}
}