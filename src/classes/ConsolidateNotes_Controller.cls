public with sharing class ConsolidateNotes_Controller{
    // members
    public Account acc {get;set;}
    public Map<string,list<sObject>> mp {get;set;}
    public Competitive_Account_Consolidation__c con {get;set;}
    public string profileType {get;set;}  
    public String consNotes {get;set;}
    public string aid {get;set;}
    public String strSearch {get;set;}
    public boolean isFound {get;set;}
    public boolean noQuestions {get;set;}
    public boolean isAttach {get;set;}
    public Attachment existAttach{get;set;}
     public ConsolidateNotes_Controller(ApexPages.StandardSetController controller) {
       existAttach = null;
       String pageId = ApexPages.currentPage().getParameters().get('Id');
       try{
        acc = [select id,name from account 
                            where id = :pageId limit 1];
        existAttach = [select id from Attachment where ParentId = :pageId and Name='ConsolidateNotes.pdf'limit 1];                     
       }catch(exception e){}
        aid=acc.id;
        isFound = true;
        isAttach = false;
        noQuestions = false;
        profileType='All';

        getData();

    }
  
    // get the data using selection 
    public pageReference getData(){
        noQuestions=false;
        getdoFindConNotes();
        string pType = '';
        mp= null;
        mp = new Map<string,list<sObject>>();
        getProfileData(profileType);
        if (mp.size()==0) noQuestions=true;
        return null;
    }                  

    // get the records from corresponding question object
    public void getProfileData(String proType){
        system.debug('--------------- Executing getProfileData ------------------');
        string andCond = (proType=='All' ? ' ' : 'AND RecordType.Name=:proType');
        string qry ='SELECT Name,recordtype.name,cDate__c,Contact_Name__r.name,(select Category__c, Name,Subject__c, Custom_Question__c,Comments__c from  accQiName__r order by category__c) '
                    + ' FROM AccountQI__c '
                    + ' WHERE Account_Name__c = :aid   andCondition order by recordtype.name';
                    
        qry = qry.replace('andCondition', andCond);
        list<sObject> lst = new list<sObject>();
       
        for(AccountQI__c r : database.Query(qry)){
            system.debug('############## r.accQiName__r.size() ##### '+r.accQiName__r.size());
            boolean needToShow = false;
            
            for(sObject li : r.getSobjects('accQiName__r')){
                if  (strSearch == null || strSearch == ''){
                    lst.add(li);  
                    needToShow = true;
                }else {
                    boolean needToAdd = false;
                    if (String.valueof(li.get('Custom_Question__c')) != null && needToAdd == false ){
                           if(String.valueof(li.get('Custom_Question__c')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){     
                                needToAdd = true;
                            }    
                     }
                     if (String.valueof(li.get('Subject__c')) != null && needToAdd == false){
                           if(String.valueof(li.get('Subject__c')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){     
                                needToAdd = true;
                            }    
                     }
                     if (String.valueof(li.get('Category__c')) != null && needToAdd == false){
                           if(String.valueof(li.get('Category__c')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){     
                                needToAdd = true;
                            }    
                     }
                     if (needToAdd == false){
                        try{
                            if(String.valueof(li.get('Comments__c')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){     
                                needToAdd = true;
                            }
                        }catch(exception e){}    
                    }
                    if(needToAdd){
                            lst.add(li); 
                            needToShow = true;
                    }        
                }   //end of if 
            } // end of innter for
            string pComb = (proType!='All' 
                            ? r.Name + (r.Contact_Name__r.name!=null 
                                        ?' - ' + r.Contact_Name__r.name 
                                        : '') 
                            : '( ' + r.RecordType.Name.trim() +' ) - '+ r.Name + (r.Contact_Name__r.name!=null
                                                                                   ?' - ' + r.Contact_Name__r.name 
                                                                                   : ''));
            if (needToShow){
                 mp.put(pComb,lst);
                 lst = new list<sObject>();
            }
        } //end of outer for
        system.debug('######### mp.size() ######## '+ mp);
    } //end of method
    
    // Check to see if consolidate note exists
    public void getDoFindConNotes(){
        con = null;
        isFound = true;
        consNotes ='';
        try{
            con = [select Consolidated_Notes__c from Competitive_Account_Consolidation__c where Name = :profileType  and Account__c= :aId limit 1];
        }catch (exception e){ 
            isFound = false;
            con = new Competitive_Account_Consolidation__c ();
        }    
    }     
    
    // Reset search 
    public pageReference doReset(){
        strSearch ='';
        profileType ='All';
        getData();
        return null;
    }
    // save method
    public pageReference doSave(){
        if (isFound) {
            update con;
        }else{
            con.Name = profileType;
            con.account__c = aId;
            insert con; 
        }
        return null;
    }
    
    // record type picklist
    // TODO : add the recordtype method to UtilClass
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        for (Recordtype r : [select Name from Recordtype where sObjectType='AccountQI__c' and isActive=true]){ 
            options.add(new SelectOption(r.Name,r.Name));
        }    
        return options;
    }
   public pagereference attach() {
        PageReference myPdf = new PageReference ('/apex/AccountCompReportPDF?id='+acc.Id);
        if (isAttach){
           if (existAttach == null){
                Attachment myAttach = new Attachment();
                myAttach.ParentId = acc.id;
                myAttach.name = 'ConsolidateNotes.pdf';
                myAttach.body = myPdf.getContentAsPdf();
                insert myAttach;
           }else{
               existAttach.body = myPdf.getContentAsPdf();
               update existAttach;
           }
        }
       // myPdf.setRedirect(true);
      // return myPdf;
        isAttach = false;
        return null;
    } 
}