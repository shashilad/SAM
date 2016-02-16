public with sharing class SAMDisplayKeyQuestions_Controller {
    
    
    public Stakeholder_Interview__c qRecord {get;set;}
    public list<KeyQuestion__c> kqList {get;set;} 
    public map<string,list<KeyQuestion__c>> questionList {get;set;}
    public map<string,list<KeyQuestion__c>> keyList {get;set;}
    public set<String> catList {get;set;}
    public string pName {get;set;}
    public SAMDisplayKeyQuestions_Controller(ApexPages.StandardController controller){
        pName=ApexPages.CurrentPage().getParameters().get('pname');
        catList = new set<String>();
        questionList = new map<string,list<KeyQuestion__c>>();
        keyList = new map<string,list<KeyQuestion__c>>();
        list<KeyQuestion__c> qList = new list<KeyQuestion__c>();
        list<KeyQuestion__c> kList = new list<KeyQuestion__c>();
        try{
            qRecord = [select profile_type__c from Stakeholder_Interview__c 
                       where id= :ApexPages.CurrentPage().getParameters().get('Id') limit 1];
        }catch(exception e){
            system.debug('No record found --->'+e);
            qRecord = new Stakeholder_Interview__c();
            qRecord.Profile_Type__c = pName ;
        }
        
        kqList = [select Question__c,Stakeholder_Profile_Master__r.Name,CategoryOrder__c,Category__c from KeyQuestion__c 
                  where (Stakeholder_Profile_Master__r.Name = :qRecord.profile_type__c.trim() OR Stakeholder_Profile_Master__r.Name='General') order by CategoryOrder__c];
        
        
        for(KeyQuestion__c c : kqList){
            catList.add(String.valueOf(c.CategoryOrder__c)+c.Category__c);
            system.debug('Category -------> '+ c.Category__c);
        }        
        
        for(string s : catList){
            
            system.debug('Category *******> '+ s);
            
            for(KeyQuestion__c k : kqlist){
                if (k.Category__c.trim().toLowerCase() == s.substring(1,s.length()).trim().toLowerCase()){
                    if(k.Stakeholder_Profile_Master__r.Name.trim().toLowerCase() == 'general'){
                        qList.add(k);
                    }else{
                        kList.add(k);
                        
                    }    
                }   
            }
            system.debug('Questions  -------> '+ qList);
            if (qList.size() > 0 ) questionList.put(s.trim(),qList);
            if (kList.size() > 0 ) keyList.put(s.trim(),kList);
            
            qList = new list<KeyQuestion__c>();
            kList = new list<KeyQuestion__c>();
            
        }
        
    }
    
}