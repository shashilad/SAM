@IsTest
public class OrderTriggerTEST 
{   
  public static testMethod void Main(){
    try{ 
      
      // create data
      DataForTest dft = new DataForTest();
      ID recordTyp = UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'); 
      Account acc = dft.getAccount(recordTyp);
      Pricebook2 pb = dft.getStdPriceBook();
      User u = dft.getTestUser('ETH-Sales System Admin');
      System.debug('U: ' + U);
      System.debug('U.id: ' + U.id);

      System.RunAs(U){
	  
	      test.startTest();
	      
	      // single record test
          	Order ord = new Order(Accountid=acc.Id, EffectiveDate=Date.Today(), Status='Draft');
   			insert ord;
     	  // bulk test
   		  list <Order> orderList = dft.getOrders(201, acc.Id);
   		  
  		  test.stopTest();
  		  
  		  //verify result
		  for(Order o : [select Pricebook2Id from Order where AccountId = :acc.Id]){
		  		system.assert(o.Pricebook2Id != null );
		  }
		  
   	    }      
    }

    catch(DMLException DE){ 
      System.debug('OrderTriggerTEST DMLException Line Number: ' + DE.getLineNumber() + '\n' + DE + '\n');
      for (Integer i = 0; i < DE.getNumDml(); i++)         
        System.debug(DE.getDmlMessage(i)); 
    } catch(Exception E){
      System.debug('OrderTriggerTEST Exception Line Number: ' + E.getLineNumber() + '\n' + E + '\n');
    } 
  }
}