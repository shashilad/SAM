public with sharing class ConsolidateNotes1All_Controller{
    
    // members
    
    public Account acc {get;set;}
    public string profileType {get;set;}  
    public String consNotes {get;set;}
    public string aid {get;set;}
    public String strSearch {get;set;}
    public list<string> profTypes {get;set;}
    public boolean isFound {get;set;}
    public boolean noQuestions {get;set;}
    public String[] category = new String[]{};
    public list<Interview_Insight__c> mp {get;set;}
    public list<Competitive_Account_Consolidation__c> notesList {get;set;}
    public string recId {get;set;}
    public list<string> catType {get;set;}  
    public boolean showCategories {get;set;}
    public String searchCat {get;set;}
    public boolean editOn {get;set;}
    public String viewByColumn {get;set;}
    public set<String> categoryHold {get;set;}  

    
    // constructor
    public ConsolidateNotes1All_Controller(ApexPages.StandardSetController controller) {

        editOn=false;
        viewByColumn = 'Name';
        isFound = true;
        noQuestions = false; 
        profileType='All';

        profTypes = new list<String>();
        categoryHold = new set<String>();
       
        String pageId = ApexPages.currentPage().getParameters().get('Id');
        
        try{
            acc = [select id,name,JJHCS_Sys_Number__c from account 
                   where id = :pageId limit 1];
        }catch(exception e){}
        
        aid=acc.id;
   
        getCategories();
        category.addAll(categoryHold);
        getData();

    }

    public String[] getCategory() {
        return category;
    }
    
    public void setCategory(String[] category) {
        this.category = category;
    }
    
    
    // get the data using selection 
    public pageReference getData(){
        system.debug ('----------------------  Executing getData() -------------------');
     
        mp= null;
        noQuestions=true;

        mp = new List<Interview_Insight__c>();
        system.debug(' getData() --  profileType --->' + profileType);
        
        getdoFindConNotes();
        
        categoryHold  = new set<String>();
     
        getProfileData(profileType);
        
        system.debug('getData() -- mp.size() ---------->' + mp.size());
        //  if (mp == null) noQuestions=true;
        return null;
    }                  
    
    // get the records from corresponding question object
    public void getProfileData(String proType){
        system.debug('--------------- Executing getProfileData ------------------');
     
        Set<String> categorySet = new Set<String>();
        categorySet.addAll(category);
        
        System.debug('getProfileData() --  Category ---> ' + category);
        
        string andCond = (proType=='All' 
                          ? ' ' 
                          : 'AND Stakeholder_Interviews__r.Profile_Type__c=:proType');
        
        string qry ='SELECT Name,Comments__c,Stakeholder_Interviews__r.Name,Stakeholder_Interviews__r.Profile_Type__c, ' 
            + ' Stakeholder_Interviews__r.Contact_Name__r.name,Stakeholder_Interviews__r.cDate__c from  Interview_Insight__c  '
            + ' WHERE Stakeholder_Interviews__r.Account_Name__c = :aid   andCondition order by ' 
            + viewByColumn ;
        
        qry = qry.replace('andCondition', andCond);
        
        for(Interview_Insight__c li : database.Query(qry)){
            boolean needToShow = false;
            if(categorySet.contains(li.Name.trim())){ 
                //   ||categorySet.contains('All')){
                if  (strSearch == null || strSearch == ''){
                    mp.add(li);  
                    if (li.Comments__c != null)  noQuestions = false;
                    needToShow = true;
                }else {
                    boolean needToAdd = false;
                    if (li.Name != null && needToAdd == false ){
                        if(li.Name.trim().toLowerCase().contains(strSearch.trim().toLowerCase())){   
                            needToAdd = true;
                        }    
                    }
                    if (needToAdd == false){
                        try{
                            if(li.Comments__c.trim().toLowerCase().contains(strSearch.trim().toLowerCase())){ 
                                
                                li.put('Comments__c',
                                       li.Comments__c.toLowerCase().replace(strSearch.trim().toLowerCase(),
                                                                            '<b style="background:yellow;">'+strSearch+'</b>'));    
                                
                                needToAdd = true;
                            }
                        }catch(exception e){}    
                    }
                    if(needToAdd){
                        mp.add(li); 
                        if (li.Comments__c != null)  noQuestions = false;
                        needToShow = true;
                    }        
                }   //end of if 
            }
        } // end of inner for
    } //end of method
    
    
    
    // get existing consolidate notes or dynamically create new ones
    public void getDoFindConNotes(){
        notesList = new list<Competitive_Account_Consolidation__c>();
        
        transient map<String, Competitive_Account_Consolidation__c> nMap = new map<String, Competitive_Account_Consolidation__c>();
        transient list<String> insightCat = new list<string>();
        transient set<string> catListSet = new set<String>();
        insightCat = System.Label.InsightCategories.split(',');
        insightCat.add('All');
        
        for (Competitive_Account_Consolidation__c c : [SELECT Category__c,Consolidated_Notes__c,Name, Account__c 
                                                       FROM Competitive_Account_Consolidation__c 
                                                       WHERE Name = :profileType 
                                                       AND Account__c= :aId]){
                                                           nMap.put(c.Category__c, c);      
                                                           insightCat.add(c.Category__c);
                                                       }
        insightCat.sort();
        catListSet.addAll(insightCat);
        for(String s : catListSet ){
            if (nMap.get(s) != null){
                system.debug ('category loop -->' + s);
                notesList.add(
                    nMap.get(s)
                );
            }else{
                system.debug('category not present --- >' + s);
                notesList.add(
                    new Competitive_Account_Consolidation__c (Category__c = s, 
                                                              Name = profileType, 
                                                              Account__c = aId)
                );
            }
        } 
    }     
    
    // Reset search 
    public pageReference doReset(){
        strSearch ='';
        //  profileType ='All';
        getData();
        return null;
    }
    
    
    public List<SelectOption> getItems() {
        transient List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        for (AggregateResult r : [select Profile_Type__c from Stakeholder_interview__c 
                                  where account_name__c = :aid 
                                  group by Profile_Type__c
                                  order by Profile_Type__c]){ 
                                      options.add(new SelectOption(String.valueOf(r.get('Profile_Type__c')),String.valueOf(r.get('Profile_Type__c'))));
                                  }    
        return options;
    }
    public List<SelectOption> getRadioItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Name','Category'));
        options.add(new SelectOption('Stakeholder_Interviews__r.Name','Stakeholder Type'));
        
        return options;
    }
    
    public List<SelectOption> getCategories() {
        List<SelectOption> options = new List<SelectOption>();
        
        //    options.add(new SelectOption('All','All'));
        for (AggregateResult r : [select Name from Interview_Insight__c 
                                  where Stakeholder_Interviews__r.Account_name__c = :aid 
                                  group by Name 
                                  order by Name]){ 
                                      options.add(new SelectOption(String.valueOf(r.get('Name')),String.valueOf(r.get('Name'))));
                                      categoryHold.add(String.valueOf(r.get('Name')));
                                  }    
        return options;
    }
    
    public pageReference selectAll(){
        category.addAll(categoryHold);
        getdata();
        return null;
    }
    
    public pageReference unSelectAll(){
        category=new list<String>();
        getdata();
        return null;
    }
  
   @future 
   public static void  attachPdf(string aId) {
        system.debug('Executing future attach -->');
        attachment existAttach = null;
        try{
            existAttach = [select id from Attachment where ParentId = :aId and Name='InsightSummary.pdf' limit 1];                     
        }catch(exception e){
            system.debug('Summary attached first time ------------------------>' + e);
        }
        PageReference myPdf = new PageReference ('/apex/AccountCompReportPDF?id='+aId);
        if (existAttach == null){
            Attachment myAttach = new Attachment();
            myAttach.ParentId = aId;
            myAttach.name = 'InsightSummary.pdf';
            if (Test.isRunningTest()){
                myAttach.body = blob.valueOf('Test');
            }else{
                myAttach.body = myPdf.getContentAsPdf();
            }
            insert myAttach;
        }else{
            if (Test.isRunningTest()){
                existAttach.body =blob.valueOf('Test');
            }else{
                existAttach.body = myPdf.getContentAsPdf();
            }
            update existAttach;
        }
        //        return null;
    }  
 
    public pageReference doEdit(){
        editOn = true;
        return null;
    }   
    
    public pageReference goOk(){
        
        list<Competitive_Account_Consolidation__c> insertList = new List<Competitive_Account_Consolidation__c>();
        
        for(String pt : catType){
            Competitive_Account_Consolidation__c insertCat = new Competitive_Account_Consolidation__c();
            insertCat.Category__c = pt; 
            insertCat.Name = profileType; 
            insertCat.Account__c = aId;
            
            insertList.add(insertCat);
        }
        
        if (insertList!=null && insertList.size()>0) 
            insert insertList;
        
        getDoFindConNotes();
        searchCat = ''; 
        return null;
    }
    
    public pageReference doCancel(){  
        getData();
        editOn=false;
        return null; 
    }
    public pageReference doSave(){ 
        upsert noteslist;
        editOn = false;
   //     getData();
  //      attach();
        return null; 
    }
 /*   public pageReference viewPdf(){ 
        return null; 
    }
    */
    public pageReference newCategory(){ 
        if(searchCat != '' && searchCat !=null){
            Insight_category__c iCat = new Insight_Category__c();
            iCat.Name = 'Other - ' + searchCat;
            try{
                insert iCat;
            }catch (exception e){ 
                ApexPages.addMessage (
                    new ApexPages.message (
                        ApexPages.Severity.ERROR,'DUPLICATE Insight Category. Please select from the list below or already selected !'
                    )
                );
            }
        }
    
        return null;
    }
    public pageReference removeCategory(){ 
 //       try{
            recId = ApexPages.CurrentPage().getParameters().get('rId');
            Competitive_Account_Consolidation__c deleteRec = [select Id 
                                                              from Competitive_Account_Consolidation__c 
                                                              where id=:recId];
            delete deleteRec;
   //     }catch(exception e){
            System.debug('Error deleting record -----------' + recId);
     //   }             
   
        getDoFindConNotes();
        searchCat = '';
        return null;
    }
    public list<SelectOption> getICategories(){   
        showCategories = false; 
        List<SelectOption> options = new List<SelectOption>();       
        list<String> insightCat = new list<String>();
        set<String> recCat = new set<String>();
        String andCond = '';
        
        for(Competitive_Account_Consolidation__c i : notesList){ 
            if (i!= null) recCat.add(i.Category__c);                     
        }
        
        if (searchCat !=null && searchCat != '') {
            andCond = ' Name like \'%' + searchCat +'%\' AND ';
            showCategories =  true;
        }        
        String Qry = 'select Name from Insight_Category__c  where ' + andCond+'   (Not Name in :recCat)';
        
        system.debug('Query ----------------------->'+qry);
        
        for(Insight_Category__c ic : database.Query(Qry)){
            options.add(new SelectOption(ic.Name,ic.Name));
        }
        return options;
    }             
}