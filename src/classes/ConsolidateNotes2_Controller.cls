public with sharing class ConsolidateNotes2_Controller{
    
    // members
    
    public Account acc {get;set;}
    public Map<string,list<sObject>> mp {get;set;}
    public Competitive_Account_Consolidation__c con {get;set;}
    public Map<String,Competitive_Account_Consolidation__c> summaryMap {get;set;}
    public string profileType {get;set;}  
    public string category {get;set;}  
    public String consNotes {get;set;}
    public string aid {get;set;}
    public String strSearch {get;set;}
    public list<string> profTypes {get;set;}
    public boolean isFound {get;set;}
    public boolean noQuestions {get;set;}
    public Attachment existAttach{get;set;}
    public Map<string,list<Interview_Insight__c>> insightMap {get;set;}
    public list<String> categoryList {get;set;}
    public long comments {get;set;}
    public ConsolidateNotes2_Controller(ApexPages.StandardSetController controller) {
        profTypes = new list<String>();
        
        category='Cost';
        existAttach = null;
        isFound = true;
        noQuestions = false;
        profileType='All';
        String pageId = ApexPages.currentPage().getParameters().get('Id');
        
        try{
            acc = [select id,name,JJHCS_Sys_Number__c from account 
                   where id = :pageId limit 1];
        }catch(exception e){
            
            system.debug ('exception occured');
        }
       
        aid=acc.id;
        getData();
    }
    
    // get the data using selection 
    public pageReference getData(){
        noQuestions=true;
  //      getdoFindConNotes();
        string pType = '';
   //     mp= null;
     //   mp = new Map<string,list<sObject>>();
        //   getProfileData(profileType);
       
        getInsights(profileType); 
      getSummaryListRecords();
        //   system.debug('mp size ---------->' + mp.size());
        //  if (mp == null) noQuestions=true;
        return null;
    }                  
    
    
    public void getInsights(String proType){
        system.debug('--------------- Executing getInsights ------------------');
        string andCond = (proType=='All' 
                          ? ' ' 
                          : 'AND Stakeholder_Interviews__r.Profile_Type__c=:proType');
        
        set<String> uniqueCategories = new set<string>();
        for(Interview_Insight__c s : [Select Name from Interview_Insight__c 
                                      WHERE Stakeholder_Interviews__r.Account_Name__c = :aid 
                                      Order by Name]){
                                          uniqueCategories.add(s.Name);
                                      }
        
        
        
        string qry = 'SELECT  Name,Comments__c,Stakeholder_Interviews__r.Name,Stakeholder_Interviews__r.Profile_Type__c,' 
            + ' Stakeholder_Interviews__r.Contact_Name__r.name from  Interview_Insight__c  '
            + ' WHERE Stakeholder_Interviews__r.Account_Name__c = :aid   andCondition order by Name';
        
        system.debug('query ----> ' + qry);
        
        
        qry = qry.replace('andCondition', andCond);
        
        list<Interview_Insight__c> queryRecords = database.Query(qry);
        categoryList = new list<string>();
        insightMap = new Map<string,list<Interview_Insight__c>> ();
        for (String cat  : uniqueCategories){
            list<Interview_Insight__c> insightList = new list<Interview_Insight__c>(); 
            for(Interview_Insight__c insight : queryRecords){
                if (cat.trim().toLowerCase() == insight.Name.trim().toLowerCase()) 
                    insightList.add(insight);    
            }
            insightMap.put(cat,insightList);
            categoryList.add(cat);
        }
        
     
    }
    
    
    
    
    public void getSummaryListRecords(){
        system.debug('executing summarylistrecords  ###############'+ profiletype +' ---  ' + aid);
      	summaryMap = new  Map<String,Competitive_Account_Consolidation__c>();
        for(Competitive_Account_Consolidation__c comp :  [select id,Category__c,Consolidated_Notes__c, Name,Account__c 
                                                          from Competitive_Account_Consolidation__c 
                                                          where Name = :profileType                   
		                                                  and Account__c= :aId]){
            system.debug('Existing notes -----> ' + comp);   
           summaryMap.put(comp.Category__c, comp);                                                 
			                                                           
        }
        
        for(String c : categoryList){
  			system.debug('category -----> ' + c);                                                              

       if (! summaryMap.containsKey(c)){

                
                Competitive_Account_Consolidation__c compTemp = new Competitive_Account_Consolidation__c();
                
                compTemp.Category__c = c;
                compTemp.Account__c = aId;
                compTemp.Name = profileType;
				system.debug('Adding category-----> ' + compTemp);                                                              

                
                summaryMap.put(c,compTemp);
       }           
        }

    }     

    
    
    
    // get the records from corresponding question object
    public void getProfileData(String proType){
        system.debug('--------------- Executing getProfileData ------------------');
        string andCond = (proType=='All' ? ' ' : 'AND Profile_Type__c=:proType');
        string qry ='SELECT Name,Profile_Type__c,cDate__c,Contact_Name__r.name,'
            + '(select  Name,Comments__c,Stakeholder_Interviews__r.Name,Stakeholder_Interviews__r.Profile_Type__c,' 
            + 'Stakeholder_Interviews__r.Contact_Name__r.name from  Interview_Insights__r order by Name) '
            + ' FROM Stakeholder_interview__c'
            + ' WHERE Account_Name__c = :aid   andCondition order by Profile_Type__c';
        
        qry = qry.replace('andCondition', andCond);
        list<sObject> lst = new list<sObject>();
        
        for(Stakeholder_interview__c r : database.Query(qry)){
            
            boolean needToShow = false;
            
            for(sObject li : r.getSobjects('Interview_Insights__r')){
                if(category.trim().toLowerCase().contains(String.valueof(li.get('Name')).trim().toLowerCase())){
                    if  (strSearch == null || strSearch == ''){
                        lst.add(li);  
                        if (li.get('Comments__c') != null)  noQuestions = false;
                        needToShow = true;
                    }else {
                        boolean needToAdd = false;
                        if (String.valueof(li.get('Name')) != null && needToAdd == false ){
                            if(String.valueof(li.get('Name')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){   
                                
                                
                                needToAdd = true;
                            }    
                        }
                        if (needToAdd == false){
                            try{
                                if(String.valueof(li.get('Comments__c')).trim().toLowerCase().contains(strSearch.trim().toLowerCase())){ 
                                    
                                    li.put('Comments__c',
                                           String.valueof(li.get('Comments__c')).toLowerCase().replace(strSearch.trim().toLowerCase(),
                                                                                                       '<b style="background:yellow;">'+strSearch+'</b>'));    
                                    
                                    needToAdd = true;
                                }
                            }catch(exception e){}    
                        }
                        if(needToAdd){
                            lst.add(li); 
                            if (li.get('Comments__c') != null)  noQuestions = false;
                            needToShow = true;
                        }        
                    }   //end of if 
                }
            } // end of innter for
            
            if (needToShow){
                mp.put(r.Name,lst);
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
            con = [select Consolidated_Notes__c from Competitive_Account_Consolidation__c 
                   where Name = :profileType 
                   and Category__c=:category  
                   and Account__c= :aId limit 1];
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
     /*   if (isFound) {
            update con;
        }else{
            con.Name = profileType;
            con.Category__c = category;
            con.account__c = aId;
            insert con; 
        }*/
        System.debug('save ----> ');
        list<Competitive_Account_Consolidation__c> saveSummaryList = new list<Competitive_Account_Consolidation__c>();
        for (string s : summaryMap.keySet()){ 
             
             saveSummaryList.add( summaryMap.get(s));
            System.debug('save ----> ' + saveSummaryList);
        }
        upsert saveSummaryList;
        return null;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        for (AggregateResult r : [select Profile_Type__c from Stakeholder_interview__c 
                                  where account_name__c = :aid 
                                  group by Profile_Type__c
                                  order by Profile_Type__c]){ 
                                      options.add(new SelectOption(String.valueOf(r.get('Profile_Type__c')),String.valueOf(r.get('Profile_Type__c'))));
                                  }    
        return options;
    }
    
    public List<SelectOption> getCategories() {
        List<SelectOption> options = new List<SelectOption>();
        for (AggregateResult r : [select Name from Interview_Insight__c 
                                  where Stakeholder_Interviews__r.Account_name__c = :aid 
                                  group by Name 
                                  order by Name]){ 
                                      options.add(new SelectOption(String.valueOf(r.get('Name')),String.valueOf(r.get('Name'))));
                                  }    
        return options;
    }
    
    
    
    public void attach() {
        existAttach = null;
        try{
            existAttach = [select id from Attachment where ParentId = :ApexPages.currentPage().getParameters().get('Id') and Name='InsightSummary.pdf' limit 1];                     
        }catch(exception e){
            system.debug('Summary attached first time ------------------------>' + e);
        }
        PageReference myPdf = new PageReference ('/apex/AccountCompReportPDF?id='+acc.Id);
        if (existAttach == null){
            Attachment myAttach = new Attachment();
            myAttach.ParentId = acc.id;
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
    } 
}