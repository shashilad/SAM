public with sharing class InterviewInsight_Controller {

    public string recId {get;set;}
    public string accQiId {get;set;}
    public list<Interview_Insight__c> iiList {get;set;}
    public boolean showCategories {get;set;}
    public list<string> profileType {get;set;}
    public List<SelectOption> cats {get;set;}
    public String searchCat {get;set;}
  

    public InterviewInsight_Controller(ApexPages.StandardController controller){
        showCategories = false;
      
        accQiId = ApexPages.CurrentPage().getParameters().get('Id');
        iiList = [select Name,Comments__c from Interview_Insight__c where Stakeholder_Interviews__c = :accQiId];
  
        cats  = getCategories();
    }
    
    
    public PageReference doSave(){
        update iiList;
        attach(accQiId);
        return null;
    }
 
 
    public PageReference doCancel(){
        attach(accQiId);
        return new PageReference('/'+accQiId).setRedirect(true);
    }
 
 
    public  static void attach(string qId) {
        boolean isAttach=true;
        Attachment existAttach ;
     
        PageReference myPdf = new PageReference ('/apex/InterviewInsightPDF?id='+qId);
     
        try{
            existAttach = [select id from Attachment where ParentId = :qId and Name='Insights.pdf' limit 1]; 
        }catch (exception e) {
            isAttach = false;
        }
             
        blob body;
      
        if (!isAttach){
            Attachment myAttach = new Attachment();
            myAttach.ParentId = qId;
            myAttach.Name = 'Insights.pdf';
                
            try{
                myAttach.body = myPdf.getContentAsPdf();
            } catch (VisualforceException e) {
                myAttach.body = Blob.valueOf('Error');
            }
            insert myAttach;
        }else{
            try{
                existAttach.body = myPdf.getContentAsPdf();
            } catch (VisualforceException e) {
                existAttach.body = Blob.valueOf('Error');
            }
            update existAttach;
        }
    } 


    public pageReference addCategories(){
        cats  = getCategories();
        return null;     
    }


    public list<SelectOption> getCategories(){   
        showCategories = false; 
        List<SelectOption> options = new List<SelectOption>();       
        list<String> insightCat = new list<String>();
        set<String> recCat = new set<String>();
        ProfileType=null;
        String andCond = '';
        
        for(Interview_Insight__c i : iiList){ 
            recCat.add(i.Name);                     
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
    

    public pageReference goOk(){
        doSave();
        Interview_Insight__c insertCat;
        list<Interview_insight__c> insertList = new List<Interview_Insight__c>();
    
        for(String pt : profileType){
            insertCat = new Interview_Insight__c();
            insertCat.Name = pt;
            insertCat.Stakeholder_Interviews__c = accQiId;
            insertList.add(insertCat);
         }

         if (insertList!=null && insertList.size()>0) 
              insert insertList;

          iiList = [select Name,Comments__c from Interview_Insight__c 
                                            where Stakeholder_Interviews__c = :accQiId];
          searchCat = '';
          return null;
    }
  

    public pageReference removeCategory(){
        try{
            recId = ApexPages.CurrentPage().getParameters().get('rId');
            Interview_Insight__c deleteRec = [select Id from Interview_Insight__c 
                                                         where id=:recId];
             delete deleteRec;
        }catch(exception e){
            System.debug('Error deleting record -----------' + recId);
        }             
     
        iiList = [select Name,Comments__c from Interview_Insight__c 
                                            where Stakeholder_Interviews__c = :accQiId];
        searchCat = '';
        return null;
    }


    public PageReference viewPdf(){
        attach(accQiId);
        return null;
    }


    public pageReference newCategory(){
        if(searchCat != '' && searchCat !=null){
            Insight_category__c iCat = new Insight_Category__c();
            iCat.Name = 'Other - ' + searchCat;
            try{
                insert iCat;
            }catch (exception e){ 
                ApexPages.addMessage (new ApexPages.message (ApexPages.Severity.ERROR,'DUPLICATE Insight Category. Please select from the list below or already selected !'));
            }
        }
        return null;
    }
}