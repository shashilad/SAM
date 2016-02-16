/* ****************************************************************************************************************************************
//Developed by Shashi Lad : 2/27/2015
//"Static variables can only be accessed from within the execution context in which they are created and are deleted when the 
//execution context completes"  
//With that said, if you need to persist a value when making multiple passes on a trigger, this is a good place to do it 
**************************************************************************************************************************************** */
public class UtilityCls {
  
  private static Map<String,String> accQiRecordTypeIdMap = null;
  private static Map<String,String> accRecordTypeIdMap = null;
  
  // get AccountQI__c recordtypes
  public Map<string, id> getAccQiRecordTypeIdMap(){
             accQiRecordTypeIdMap =  new map<string,id>();
             Map<String, String> recTypNameToIdMap = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQI__C');
            return recTypNameToIdMap;
  }    
  // get AccountQItem__c recordtypes
  public Map<string, id> getAccQitemRecordTypeIdMap(){
             accQiRecordTypeIdMap =  new map<string,id>();
             Map<String, String> recTypNameToIdMap = UtilityCls.getRecordTypeNameToIdMapByObjectName('AccountQItem__c');
            return recTypNameToIdMap;
  }    
  
  // get Account recordtypes
  public Map<string, id> getAccountRecordTypeIdMap(){
             accRecordTypeIdMap =  new map<string,id>();
             Map<String, String> recTypNameToIdMap = UtilityCls.getRecordTypeNameToIdMapByObjectName('Account');
            return recTypNameToIdMap;
  }         



  //Util Method to get RecortypeName to Id Map for a give Object Name
  public static Map<String,String> getRecordTypeNameToIdMapByObjectName(String ObjName){
        Map<ID, Schema.RecordTypeInfo> rectypMap = null;
        if(objName != null){
            if('Account'.equalsIgnoreCase(objName.trim())){
                rectypMap = Schema.SObjectType.Account.getRecordTypeInfosById();
            }else if('AccountQI__c'.equalsIgnoreCase(objName.trim())){
                rectypMap = Schema.SObjectType.AccountQI__c.getRecordTypeInfosById(); 
            }else if('AccountQItem__c'.equalsIgnoreCase(objName.trim())){
                rectypMap = Schema.SObjectType.AccountQItem__c.getRecordTypeInfosById(); 
            }else if('Contact'.equalsIgnoreCase(objName.trim())){
                rectypMap = Schema.SObjectType.Contact.getRecordTypeInfosById(); 
            }
        }

        Map<String,String> recTypNameToIdMap = new Map<String,string>(); 

        if(rectypMap != null){  
            for(string str: rectypMap.keySet()){
                system.debug('########## map value = '+str);
                System.debug('########## record type name ='+ rectypMap.get(str).getName());
                recTypNameToIdMap.put( rectypMap.get(str).getName(),str);
            }
        }
        return recTypNameToIdMap;

  }
   
    public static void DebugMessage(string message, string val){
        system.debug('+---------------------------------------------------------------------------------+');
        system.debug('++++   '+ message + '++++ ' + val );
        system.debug('+---------------------------------------------------------------------------------+');
        
    }  
    public static void DebugMessage(string message, exception val){
        system.debug('+---------------------------------------------------------------------------------+');
        system.debug('++++   '+ message + '++++ ' + val );
        system.debug('+---------------------------------------------------------------------------------+');
        
    }  
    public static void DebugMessage(string message, sObject val){
        system.debug('+---------------------------------------------------------------------------------+');
        system.debug('++++   '+ message + '++++ ' + val );
        system.debug('+---------------------------------------------------------------------------------+');
        
    } 
    public static void DebugMessage(string message, list<sObject> val){
        system.debug('+---------------------------------------------------------------------------------+');
        system.debug('++++   '+ message + '++++ ' + val );
        system.debug('+---------------------------------------------------------------------------------+');
        
    }     
    public static void DebugMessage(string message, list<String> val){
        system.debug('+---------------------------------------------------------------------------------+');
        system.debug('++++   '+ message + '++++ ' + val );
        system.debug('+---------------------------------------------------------------------------------+');
        
    }  
}