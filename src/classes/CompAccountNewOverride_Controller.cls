public with sharing  class CompAccountNewOverride_Controller {

    public Stakeholder_Interview__c accQi {get;set;}
    public String rTypeName {get;set;}
    public CompAccountNewOverride_Controller(ApexPages.StandardController controller) {
        accQi = (Stakeholder_Interview__c) controller.getRecord();
        rTypeName = System.Label.SamACO;
    }
    public void selectProfile(){
   
        rTypeName = accQi.Profile_type__c;
   
    }
 
}