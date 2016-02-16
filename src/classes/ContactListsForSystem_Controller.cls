public with sharing class ContactListsForSystem_Controller {
        // members
        public map<String,list<Contact>> accConList  {get;set;} 
        public Id accId {get;set;}
        // constructor
        public ContactListsForSystem_Controller (ApexPages.StandardSetController controller){
                accConList = new map<String, list<Contact>>();
                accId = ApexPages.currentPage().getParameters().get('Id');
                for( account acc :  [select Name,JJHCS_Number__c,(Select Name, Title,Reference__c,VAC_MEMB_IND__c,Key_Decision_Maker__c,LICENSE_NUM__c,EVNT_FACULTY_IND__c from Contacts) 
                                                                                from Account where ParentId = :accId AND ParentId !=null
                                                                                order by JJHCS_Number__c]){
        
                        list<Contact> conList = new list<Contact>();                
                        for(sObject con : acc.getSobjects('Contacts')){
                                conList.add((Contact)con);
                        } //end of inner for-loop       
                        if (conList.size()>0) accConList.put(acc.JJHCS_Number__c + ' - ' + acc.Name, conList);
                } // end of outer for-loop
        } 


        // methods
        

}