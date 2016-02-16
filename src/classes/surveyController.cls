public class surveyController {
    public ApexPages.StandardController ctrl;
    public surveyController(ApexPages.StandardController controller) {
        ctrl = controller;
    }
public PageReference doSave(){

  ctrl.save();
  PageReference p = Page.thankyou;
  return p;
}  
}