public class OrderTriggerHandler {

// -------------- Insert Section -----------------------------------------------
  
  public static void OnBeforeInsert(Order[] newOrders){
		OrderTriggerHandlerHelper.AssignDefualtPriceBookToOrder(newOrders);
  }





/*  public static void OnAfterInsert(Order[] newOrders){
  }
  // -------------- Update Section -----------------------------------------------

    public static void OnBeforeUpdate(Order[] newOrders, Map<Id, Order> newMap, Map<Id, Order> oldMap) {
    }
    public static void OnAfterInsert(Order[] newOrders, Map<Id, Order> newMap) {
      // Nothing to do yet.
    }
    
    public static void OnAfterUpdate(Order[] oldOrders,Order[] newOrders,Map<Id, Order> newMap){
      // Nothing to do yet.
    }   

// -------------- Delete Section -----------------------------------------------


    public static void OnBeforeDelete(Order[] oldOrders, Map<Id, Order> oldMap) {
    }

    public static void OnAfterDelete(Order[] oldOrders, Map<Id, Order> oldMap) {
    }

    public static void OnUndelete(Order[] restoredOrders) {
    }
*/

}