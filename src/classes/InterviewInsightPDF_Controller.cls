public with sharing class InterviewInsightPDF_Controller {
    
    public String intId {get;set;}
    public list<Interview_Insight__c> iiList {get;set;} 
    public Stakeholder_Interview__c accQi {get;set;}
    
    public InterviewInsightPDF_Controller(ApexPages.StandardController controller){
    
        intId = ApexPages.CurrentPage().getParameters().get('Id');
    
        accQi = [select Name,Account_Name__r.Name,Contact_Name__r.Name from Stakeholder_Interview__c where id=:intId];
    
        iiList = [select Name,Comments__c from Interview_Insight__c where Stakeholder_Interviews__c = :intId];
    
        system.debug ('interview insight pdf ---> ' + iiList);
    
    }
    
}