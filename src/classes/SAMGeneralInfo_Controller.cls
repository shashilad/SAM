public with sharing class SAMGeneralInfo_Controller {
    
    public Stk_ProfileMaster__c[] StkMaster {get;set;}
    public string profName {get;set;}
    public string pName {get;set;}
    
    public SAMGeneralInfo_Controller(){
      	StkMaster = [select Name, ProfileText__c from Stk_ProfileMaster__c 
                     		where isProfile__c = true  Order by Name ];
    }
    
    public void assignName (){
        system.debug('profName ------------->' +ApexPages.currentPage().getParameters().get('profName'));
        system.debug('pname---------> '+ profName);
        pName=profName;
    }
}