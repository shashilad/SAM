/* ****************************************************************************************************************************************
** Developed by : Shashi Lad  3-20-2015
**      purpose : Reparenting Accounts to corresponding Systems. Also if IDN_Row_Obs_ind__c is 'Y'or 
				  if IDN__c name gets emplty on individual accounts than remove the parenting 
** **************************************************************************************************************************************** */

global class Batch_AccountsParentingToSystems implements Database.Batchable<SObject>,  Schedulable {
    
   /* *********************   Batchable methods below ********************* */
    // Batch start with getting records
    
    global Database.QueryLocator start(Database.BatchableContext bc){
    //    list<id> ids = ContactDeDuplication.getContactRecords(); 
        String soql = getQuery();
    	return Database.getQueryLocator(soql);
    }
    
    // Batch Execute 
    global void execute(Database.BatchableContext bc, list<Account> accountRecords) {
    	map<String, Account> sysMap = new map<String,Account>();
    	for (Account s: [SELECT id,Name,IDN_ROW_OBS_IND__c from Account WHERE RecordType.Name='System Account']){
    		sysMap.put(s.Name,s);
    	}	
     	list<Account> recordsToUpdate = new list<Account>();
  	 	for (Account a : accountRecords){
  	 		boolean checkObs = false;
  	 		try{
  	 			checkObs = sysMap.get(a.IDN__c).IDN_ROW_OBS_IND__c;
  	 		}catch(exception e){
  	 			system.debug('------------- Could not find the system for IDN --------------'+ a.IDN__c );
  	 			checkObs = true;
  	 		}	
          	if (!checkObs){
              	a.ParentId = sysMap.get(a.IDN__c).Id;
          	}else{
              	if (a.ParentId !=null) a.ParentId = null ;
          	}	
          	recordsToUpdate.add(a);
          										
        }
           	if (recordsToUpdate != null) update recordsToUpdate;								
       
          
          
          
      
    } // end of batch - execute
 
     // Batch finish 
    global void finish(Database.BatchableContext bc) {
        if (bc != null) {
            System.debug('finish,job id --> ' + bc.getJobId());
        }
    }

     // query
    private static String getQuery() {
      	string query = 'SELECT Id,Name,ParentId,IDN__c '
                     + 'FROM Account WHERE Recordtype.Name =\'Teradata Account\'  ORDER BY Name'; 
        if(Test.isRunningTest())  
        	query += ' LIMIT 200 ' ;   
        System.debug('------> soql: ' + query);
        return query;
    }
    
    
    /* *********************   Batchable methods below ********************* */
    global void execute(SchedulableContext sc) {
        integer batchSize = 200;  
        Database.executeBatch(new Batch_AccountsParentingToSystems(), batchSize);
    }
    global  void scheduleJob(String scheduleString) {
        If (scheduleString == null) {
            scheduleString = '0 0 22 ? * FRI';
        }
        
        System.schedule(getUniqueJobName(), scheduleString, new Batch_AccountsParentingToSystems());
    }
      
    public String getUniqueJobName() {
        //construct unique job name by appending timestamp
        String uniqueJobName = 'Batch_AccountsParentingToSystems-' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug('job name : ' + uniqueJobName);
        return uniqueJobName;
    }
}