public class AccountCompReportPDF_Controller {
    
    public list<Competitive_Account_Consolidation__c> compRecords {get;set;}
    public map<String,List<Competitive_Account_Consolidation__c>> compMap {get;set;}
    public set<String> profType {get;set;}  
    public Account acc {get;set;}
    public String accId {get;set;}
    public String jjhcs {get;set;}
    public String sysType {get;set;}
    
    public list<Competitive_Account_Consolidation__c> compList {get;set;}
    
    public AccountCompReportPDF_Controller(ApexPages.StandardController controller) {
        
        profType = new set<String>();
        compMap    = new Map<String,List<Competitive_Account_Consolidation__c>>(); 
        accId = ApexPages.currentPage().getParameters().get('Id');
        
        try{
            
            acc     = [select Name,JJHCS_number__c,IDN_CD__c,RecordType.Name  from Account where id = :accId];
            
            jjhcs   = (acc.JJHCS_number__c != null ? acc.JJHCS_number__c : acc.IDN_CD__c);
            sysType = (acc.RecordType.Name == 'System Account' ? 'System' : 'Customer Account'); 
            
            for (Competitive_Account_Consolidation__c cat : [select Name from Competitive_Account_Consolidation__c
                                                             where Account__c = :accId]	){
                                                                 
                                                                 profType.add(cat.Name);
                                                             }    
            
            compRecords = [select Name,Account__c,category__c,Consolidated_Notes__c  from   Competitive_Account_Consolidation__c 
                           where account__c = :accId 
                           order by Name,categoryOrder__c,category__c ];
            
            for (String c : profType){
                compList = new List<Competitive_Account_Consolidation__c>();
                for(Competitive_Account_Consolidation__c rec : compRecords){
                    
                    if (c.trim() == rec.Name.trim() && rec.Consolidated_Notes__c !=null)
                        compList.add(rec);
                    
                }
                
                if (compList.size()>0) {
                    String catName = (c.trim()=='All' ? '.Common' : c);
                    compMap.put(catName,compList);
                }
                
            }
            
            System.debug('CompMap records ------->' + compMap);
            
            
            
        }catch(Exception e ){
            
            system.debug('Error in constructor ------->' + e);
        }                                    
        
    }
    
}