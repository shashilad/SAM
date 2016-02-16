public  class InsightSummaryUpdate_Controller{
    
    // members
    
    
    public String aId 			{get;set;} 		// account Id
    public String profileType 	{get;set;} 		// Profile type selection value  
    public String strSearch 	{get;set;} 		// search string for insight descriptions
    public String recId 		{get;set;} 		// record id of Competitive_Account_Consolidation__c to be removed
    public String searchCat 	{get;set;} 		// category search string in add cateogory modal
    public String viewByColumn 	{get;set;} 		// hold column name to short the list by
    
    public Boolean editOn 		{get;set;} 		// is Edit button pressed?
    public Boolean noQuestions 	{get;set;} 		// insight description exists
    
    public set<String> categoryHold {get;set;}  // list of categories in set
    public list<String> catType 	{get;set;}  	// category selection value in the modal
    public String[] category = new String[]{}; 	// insight category checkbox selection value 
        
        public Account acc 											{get;set;}  // account record
    public list<Interview_Insight__c> interviewInsightList 		{get;set;} 	// Interview insight list
    public list<Competitive_Account_Consolidation__c> notesList {get;set;} 	// Summary insight list 
    
    
    // constructor
    public InsightSummaryUpdate_Controller(ApexPages.StandardSetController controller) {
        
        editOn		  = false;
        viewByColumn  = 'Name';
        noQuestions   = false; 
        profileType   = 'All';
        categoryHold  = new set<String>();
        String pageId = ApexPages.currentPage().getParameters().get('Id');
        
        try{
            acc = [SELECT Id,Name,JJHCS_Sys_Number__c 
                   FROM Account 
                   WHERE Id = :pageId 
                   LIMIT 1];
        aId = acc.Id;
        
        getCategories();
        category.addAll(categoryHold);
        getData();
        
        }catch(exception e){
            system.debug ('Account not found' + e);
        }
        
  
        
    }
    
    
    
    
    // get the data using selection 
    public pageReference getData(){
        system.debug ('----------------------  Executing getData() -------------------');
        
        interviewInsightList = null;
        noQuestions=true;
        
        interviewInsightList = new List<Interview_Insight__c>();
        system.debug(' getData() --  profileType --->' + profileType);
        
        getdoFindConNotes();
        
        categoryHold  = new set<String>();
        
        getProfileData(profileType);
        
        system.debug('getData() -- interviewInsightList.size() ---------->' + interviewInsightList.size());
        return null;
    }                  
    
    
    
    
    
    // get the records from corresponding question object
    public void getProfileData(String proType){
        system.debug('--------------- Executing getProfileData ------------------');
        
        transient Set<String> categorySet = new Set<String>();
        categorySet.addAll(category);
        
        System.debug('getProfileData() --  Category ---> ' + category);
        
        string andCond 	= 	(proType == 'All' 
                             ? ' ' 
                             : 'AND Stakeholder_Interviews__r.Profile_Type__c=:proType');
        
        string qry 		=	'SELECT Name,Comments__c,Stakeholder_Interviews__r.Name,Stakeholder_Interviews__r.Profile_Type__c, ' 
            + ' Stakeholder_Interviews__r.Contact_Name__r.name,Stakeholder_Interviews__r.cDate__c from  Interview_Insight__c  '
            + ' WHERE Stakeholder_Interviews__r.Account_Name__c = :aid   andCondition order by ' 
            + viewByColumn ;
        
        qry = qry.replace('andCondition', andCond);
        
        for(Interview_Insight__c li : database.Query(qry)){
            
            boolean needToShow = false;
            
            if(categorySet.contains(li.Name.trim())){ 
                
                if  (strSearch == null || strSearch == ''){
                    interviewInsightList.add(li);  
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
                        interviewInsightList.add(li); 
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
        transient set<string> catListSet  = new set<String>();
        
        insightCat = System.Label.InsightCategories.split(',');
        insightCat.add('All');
        
        insightCat.sort();
        
        for (Competitive_Account_Consolidation__c c : [SELECT Category__c,Consolidated_Notes__c,Name, Account__c 
                                                       FROM Competitive_Account_Consolidation__c 
                                                       WHERE Name = :profileType 
                                                       AND Account__c= :aId
                                                       Order by CategoryOrder__c,Category__c ]){
                                                           nMap.put(c.Category__c, c);      
                                                           insightCat.add(c.Category__c);
                                                       }
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
            } // end if
        } // end for
        
    }     
    
    
    
    // Reset search 
    public pageReference doReset(){
        strSearch ='';
        getData();
        return null;
    }
    
    
    
    public pageReference doEdit(){
        editOn = true;
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
        return null; 
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
    
    
    
    
    public pageReference goOk(){
        
        transient list<Competitive_Account_Consolidation__c> insertList = new List<Competitive_Account_Consolidation__c>();
        
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
    
    
    
    public pageReference newCategory(){ 
    
        if(searchCat != '' && searchCat !=null){
      
            Insight_category__c iCat = new Insight_Category__c();
            
            iCat.Name = 'Other - ' + searchCat.capitalize();
            
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

        try{
            recId = ApexPages.CurrentPage().getParameters().get('rId');
            Competitive_Account_Consolidation__c deleteRec = [select Id 
                                                              from Competitive_Account_Consolidation__c 
                                                              where id=:recId];
            delete deleteRec;
        }catch(exception e){
            System.debug('Error deleting record -----------' + recId);
        }             
        
        getDoFindConNotes();

        searchCat = '';

        return null;
    }
    
    
    
    
    
 /*   @future 
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
    
    */
    
    
    public list<SelectOption> getICategories(){   

        List<SelectOption> options 	= new List<SelectOption>();       
        list<String> insightCat		= new list<String>();
        set<String> recCat 			= new set<String>();
        String andCond 				= '';
        
        for(Competitive_Account_Consolidation__c i : notesList){ 
            if (i!= null) recCat.add(i.Category__c);                     
        }
        
        if (searchCat !=null && searchCat != '') {
            andCond = ' Name like \'%' + searchCat +'%\' AND ';
        }        

        String Qry = 'select Name from Insight_Category__c  where ' 
            		  + andCond
            		  +'   (Not Name in :recCat)';
        

        system.debug('Query ----------------------->'+qry);
        
        for(Insight_Category__c ic : database.Query(Qry)){
            options.add(new SelectOption(ic.Name,ic.Name));
        }
        
        return options;
    }             
    
     
    
    public String[] getCategory() {
        return category;
    }
    
 
    
    public void setCategory(String[] category) {
        this.category = category;
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
        transient list<String> catSorting = new list<String>();
        for (AggregateResult r : [select Name from Interview_Insight__c 
                                  where Stakeholder_Interviews__r.Account_name__c = :aid 
                                  group by Name 
                                  order by Name
                                 ]){ 
                                     String preFix = (String.valueOf(r.get('Name')).Contains('Other -')  ?  '1'  :  '0');
                                     catSorting.add(preFix + String.valueOf(r.get('Name')));
                                     
                                     // options.add(new SelectOption(String.valueOf(r.get('Name')),String.valueOf(r.get('Name'))));
                                     categoryHold.add(String.valueOf(r.get('Name')));
                                 }    
        catSorting.sort();
        
        for (String s : catSorting){
            options.add(new SelectOption(s.subString(1),s.subString(1)));
        }
        
        return options;
    }
    
    
    
}