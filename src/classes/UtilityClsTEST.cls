/**
 * Developed by : Shashi Lad 4/7/2015
 */
@isTest
private class UtilityClsTEST {

    static testMethod void myUnitTest() {
        UtilityCls util = new UtilityCls();
        
        Map<String,String> objRTMap1 = UtilityCls.getRecordTypeNameToIdMapByObjectName('Account');
        system.assert(objRTMap1 != null);
        
        Map<String,String> objRTMap2 = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQI__c');
        system.assert(objRTMap2 != null);
         
        Map<String,String> objRTMap3 = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQItem__c');
        system.assert(objRTMap3 != null);

        Map<String,String> objRTMap4 = UtilityCls.getRecordTypeNameToIdMapByObjectName('Contact');
        system.assert(objRTMap4 != null);
  
        Map<string, id> acc = util.getAccountRecordTypeIdMap() ;
        system.assert(acc != null);

        Map<string, id> accQi = util.getAccQiRecordTypeIdMap() ;
        system.assert(accQi != null); 

        Map<string, id> accQitem = util.getAccQitemRecordTypeIdMap() ;
        system.assert(accQitem != null); 
        
       
    }
}