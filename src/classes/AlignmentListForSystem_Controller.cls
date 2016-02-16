public with sharing class AlignmentListForSystem_Controller {
        // members
        public map<String,list<AccountAlignment__c>> accAlgnList  {get;set;} 
        public Id accId {get;set;}
       
        // constructor
        public AlignmentListForSystem_Controller (ApexPages.StandardController controller){
                accAlgnList = new map<String, list<AccountAlignment__c>>();
                accId = ApexPages.currentPage().getParameters().get('Id');
                for( account acc :  [select Name,JJHCS_Number__c,
                							(SELECT AccountId__c,ALGN_STRUC_ID__c,ALGN_STRUC_NM__c,
                									DIV_ID__c,DIV_MGR_NM__c,DIV_NM__c,JJHCS_Number__c,
                									Name,OwnerId,REG_ID__c,REG_MGR_NM__c,REG_NM__c,REP_NM__c,ROW_OBS_IND__c,TERR_NM__c 
                									FROM Account_Alignments__r where ROW_OBS_IND__c= false order by Name) 
                					 from Account where ParentId = :accId AND ParentId !=null
                                     order by JJHCS_Number__c]){
        
                        list<AccountAlignment__c> aaList = new list<AccountAlignment__c>();
                                        
                        for(sObject aa : acc.getSobjects('Account_Alignments__r')){
                                aaList.add((AccountAlignment__c)aa);
                        } //end of inner for-loop       
                        
                        if (aaList.size()>0 ) accAlgnList.put(acc.JJHCS_Number__c + ' - ' + acc.Name, aaList);
                        
                } // end of outer for-loop
        } 

}