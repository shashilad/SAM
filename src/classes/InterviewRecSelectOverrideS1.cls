public class InterviewRecSelectOverrideS1 {
 
    public string profileName {get;set;}
    public list<selectOption> sOptions {get;set;}
    public Account account {get;set;}
  
    public InterviewRecSelectOverrideS1( ApexPages.StandardController controller) {
    	account = (Account) controller.getRecord();
        sOptions = getRecordTypeList();
        system.debug('Constructor ------------------------.'+ profileName );
    }
  
 
    
    public List<SelectOption> getRecordTypeList() {
        List<SelectOption> options = new List<SelectOption>();
        for (Recordtype s : [select id,Name,Description from Recordtype where sObjectType='AccountQI__c' and isActive=true]){
            options.add(new selectOption(s.Id,s.name));
        }    
        system.debug('--------- options -------' + options);
        system.debug('getReordlist ------------------------.'+ profileName );
        return options;
    }

    public void callMethod() {
        system.debug('CallMethod------------------------.'+ profileName );
   //     acc=profileName;
    }

   
}