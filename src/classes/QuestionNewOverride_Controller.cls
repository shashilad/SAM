public class QuestionNewOverride_Controller {
    
    // members
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String rType {get; set;}
    public String cancelURL {get; set;}
    public String ent {get; set;}
    public String mastId {get;set;}
    public String confirmationToken {get; set;}
    public AccountQI__c  profType{get;set;}
    public Id recTypeForQItem {get;set;}
    public String fldName {get;set;}
    
    // constructor
    public QuestionNewOverride_Controller (ApexPages.StandardController controller) {
        fldName = system.label.AccountQIURLfield;
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        saveNewURL =  ApexPages.currentPage().getParameters().get('save_new_url');
        mastId = ApexPages.CurrentPage().getParameters().get(fldName+'_lkid');
        
        if (retUrl!=null) retURL = retURL.subString(1);
        
        system.debug('----- retUrl ----'+ retUrl);
        system.debug('----- rType ----'+ rType);
        system.debug('----- cancelURL ----'+ cancelURL);
        system.debug('----- ent ----'+ ent);
        system.debug('------- mastId -----' + mastId);
    }

    // page action 
    public pageReference addRectype(){
        try{
        profType = [select id,name,Recordtype.Name from AccountQI__c where id = :retURL limit 1];
        }catch(exception e){
             retURL = mastId;
             profType = [select id,name,Recordtype.Name from AccountQI__c where id = :retURL limit 1];
        }
        system.debug('#### profType Name ######' + profType.Recordtype.name);
        if (profType!=null) {
            try{
                recTypeForQItem = [Select id from Recordtype where Name = :profType.Recordtype.Name  and sObjectType='AccountQItem__c' limit 1].Id ;
                pagereference returnURL = new pagereference(system.label.QuestionUrl);
                returnURL.getParameters().put(fldName, profType.Name);
                returnURL.getParameters().put(fldName+'_lkid', profType.Id);
                returnURL.getParameters().put('retURL', '/'+retURL);
                returnURL.getParameters().put('RecordType', recTypeForQItem);
                returnURL.getParameters().put('cancelURL', cancelURL);
                returnURL.getParameters().put('ent', ent);
                returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
                returnURL.getParameters().put('save_new_url', saveNewURL);
                returnURL.getParameters().put('saveURL', '/' +retURL);
                returnURL.getParameters().put('nooverride', '1');
                returnURL.setRedirect(true);
                return returnURL;
            }catch(Exception e){
                return null;
            }
        }else{
            return null;
        }
    }

}