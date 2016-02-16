public class SamProfileInfoRes_Controller {
    

    public Stk_ProfileMaster__c pMaster{get;set;}
    public string titleA{get;set;}
    public string titleB{get;set;}
    public string titleC{get;set;}
    public string linkName {get;set;}
    public string pType {get;set;}
    public map<string,list<Stk_InfoLinks__c>> listAll {get;set;}
    public SamProfileInfoRes_Controller(){
        
        pType = '';
        pType = ApexPages.currentPage().getParameters().get('profileName');
        if (pType!='') listAll = doListAll();
    }
    
    public map<string,list<Stk_InfoLinks__c>> doListAll(){
        
        map<string,list<Stk_InfoLinks__c>> mapList = new map<string,list<Stk_InfoLinks__c>>();
        list<String> sec = new list<String> {'A','B','C'};
            
            try{    
            pMaster = [SELECT Id,Name,Title_A__c,Title_B__c,Title_C__c  
                       FROM Stk_ProfileMaster__c
                       WHERE Name = :pType.trim() 
                       LIMIT 1];
            }catch(exception e){
                system.debug('No data found --->' +e);
            }    
        UtilityCls.DebugMessage('pMaster value',pMaster);
        if(pMaster != null){
            titleA = pMaster.Title_A__c;
            titleB = pMaster.Title_B__c;
            titleC = pMaster.Title_C__c;
            
        for(string s: sec){
            list<Stk_InfoLinks__c> stkList = new list<Stk_InfoLinks__c>();
            for(Stk_InfoLinks__c stk : [SELECT Name,Title__c,subTitle__c,Link__c 
                                        FROM Stk_InfoLinks__c 
                                        WHERE Stakeholder_Profile_Master__c= :pMaster.id 
                                        ORDER BY Name,Title__c]){
                                            if (stk.Name.trim() == s.trim())
                                                stkList.add(stk);
                                            
                                        }
            mapList.put(s,stkList);
        }
        }    
        return mapList;
    }
    
    public list<ContentVersion> getDocIds(){
        list<ContentVersion> Ids = new list<ContentVersion>();
        ID workspaceId = [SELECT Id 
                          FROM ContentWorkspace 
                          WHERE Name = :System.Label.SamLibrary limit 1].Id;
        
        UtilityCls.DebugMessage('Library Id ' , workspaceId);
        
        List <ContentVersion> allDocuments = [SELECT id,tagCsv,Title 
                                              FROM ContentVersion 
                                              WHERE ContentDocument.ParentId = :workspaceId 
                                              AND isLatest = true ];
        
        for(ContentVersion cv : allDocuments){
            if (cv.tagCsv != null && cv.tagCsv !=''){
                if (cv.tagCsv.ToLowerCase().contains(pType.ToLowerCase())){
                    UtilityCls.DebugMessage('Tag Name ', cv.tagCsv);
                    UtilityCls.DebugMessage('Title Name ' , cv.Title);
                    ids.add(cv);
                }
            }  
        }
        return ids;
    }
    
    public pageReference CountLinkClicks(){
        UtilityCls.DebugMessage('Link Name ',linkName);
        try{
            Stk_InfoLinks__c iLink = [SELECT id
                                      FROM Stk_InfoLinks__c
                                      WHERE Stakeholder_Profile_Master__c= :pMaster.id
                                      AND Link__c = :linkName];
      SamLinkCountHistory__c countHist = new SamLinkCountHistory__c();
            countHist.Stakeholder_Information_Link__c = iLink.Id;
            insert countHist;
    }catch (exception e){
            UtilityCls.DebugMessage('Exception from CountLInkClicks', e) ;
        }                                 
        
        return null;
    }
    
    public pageReference CountDocClicks(){
        UtilityCls.DebugMessage('Link Name', linkName);
        
        Id pId = [SELECT Id FROM Stk_ProfileMaster__c 
                  WHERE Name='Contents' 
                  LIMIT 1].Id;
        Stk_InfoLinks__c iLink ;
        try{
            iLink = [SELECT id
                     FROM Stk_InfoLinks__c
                     WHERE Stakeholder_Profile_Master__c= :pId
                     AND Title__c = :linkName.trim()];       
            
        }catch (exception e){
            UtilityCls.DebugMessage('Document clicked first time and added to Stk_InfoLinks__c', e) ;
            iLink = new  Stk_InfoLinks__c ();
            iLink.Title__c = linkName;
            iLink.Name = 'C';
            iLink.Stakeholder_Profile_Master__c = pId;
            insert iLink;
        }finally{
       SamLinkCountHistory__c countHist = new SamLinkCountHistory__c();
            countHist.Stakeholder_Information_Link__c = iLink.Id;
            insert countHist;           
        }    
        return null;
    }
}