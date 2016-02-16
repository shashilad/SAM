public with sharing class LegalReport_Controller {

   public String searchStr { get; set; }
   public String accReportId {get;set;}
   public String oppReportId {get;set;}
   public String conReportId {get;set;}
   public String leadReportId {get;set;}
   public LegalReport_Controller(){
	  try{
	  		accReportId = [select id from report where developerName = 'Account_Activities' limit 1 ].id;
	  }catch(exception e) {}		
	  try{
	      conReportId = [select id from report where developerName like 'Contact_Activities' limit 1 ].id;
	  }catch(exception e) {}		
	  try{
    	  oppReportId = [select id from report where developerName like 'Opportunity_Activities1' limit 1 ].id;
	  }catch(exception e) {}		
	  try{
   		  leadReportId = [select id from report where developerName like 'Lead_Activities' limit 1 ].id;
   	  }catch(exception e) {}		
   
   }
      
    public void refreshone(){
       
    }  
}