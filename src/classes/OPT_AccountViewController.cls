public with sharing class OPT_AccountViewController {

    public boolean showAccountHome {get;set;}
    public boolean showStakeholderProfiles {get;set;}
    public boolean showInsightSummary {get;set;}
    public String accountId {get;set;}
    public Stakeholder_Interview__c[] interviewList;
    public OPT_AccountViewController(ApexPages.StandardController controller){
        showAccountHome = true;
        showStakeholderProfiles = false;
         showInsightSummary = false;
        accountId = ApexPages.currentPage().getParameters().get('Id');
        
    }
	
    public Stakeholder_Interview__c[] getInterviewList(){
        return [select Name,cDate__c, Last_Updated__c, Profile_Type__c from Stakeholder_Interview__c 
             	where Account_Name__c = :accountId
                order by Profile_Type__c] ;
        
    }
    public pageReference goAccountHome(){
         showAccountHome = true;
         showStakeholderProfiles = false;
         showInsightSummary = false;
         return null;
    }
    public pageReference goStakeholderProfiles(){
         showAccountHome = false;
         showStakeholderProfiles = true;
         showInsightSummary = false;
         return null;
    }
    
    public pageReference goInsightSummary(){
         showAccountHome = false;
         showStakeholderProfiles = false;
         showInsightSummary = true;
         return null;
    }
    
    
}