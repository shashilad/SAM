public class LegalReportXLS_Controller{
	 public List<Opportunity> optyList {get;set;}
	 public List<contact> conList{get;set;}
	 public List<account> accList{get;set;}
	 public String searchStr{get;set;}
	 public list<Objective__c> objectiveList{get;set;}
	
	 public string[] s {get;set;}
	
	 public LegalReportXLS_Controller(){
	        searchStr = ApexPages.CurrentPage().getParameters().get('srcText');
			
		    optyList = New List<Opportunity>();
	   		conList = New List<contact>();
	   		accList = New List<account>();
			
	        soslDemo_method();
	   }
	  
	 public void soslDemo_method(){
	
		   if(searchStr.length() > 2){
			       String searchStr1 = '*'+searchStr+'*';
			       String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,description,createddate,lastmodifieddate,Next_Step__c,BillingStreet,Additional_Facility_Info__c), '
			                                                   + ' Contact(id,name,title,title__c,createddate,lastmodifieddate,Description,MobilePhone,GM_reference__c,mailingstreet,Department,NOTES_TXT__c), '
			                                                   + ' Opportunity(id,name,StageName,Description,NextStep,createddate, lastmodifieddate,Rep_Comments__c), '
			                                                   + ' Objective__c(id,Name, createddate, LastModifiedDate,MBO__c ) ';
			       list<List <sObject>> searchList = search.query(searchQuery);
			       accList = ((list<Account>)searchList[0]);
			       conList  = ((list<contact>)searchList[1]);
			       optyList = ((list<Opportunity>)searchList[2]);
			       objectiveList = ((list<Objective__c>)searchList[3]);
			       if(accList.size() == 0 && conList.size() == 0 && optyList.size() == 0 && objectiveList.size() == 0  ){
	           			apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results returned with matching string..'));
	           			return;
	       		   }
	   	 	   
	   		}else{
	      		 apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least three characters..'));
	       		 return;
	   		}
	 }
	  
 
}