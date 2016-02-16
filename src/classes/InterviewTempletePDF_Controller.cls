public class InterviewTempletePDF_Controller {
    
    public list<Custom_Questions__c> qItem {get;set;}
    public string spName {get;set;}
    public String isWordDoc {get;set;}
    
    public InterviewTempletePDF_Controller(ApexPages.StandardController controller) {
        
        spName		=	ApexPages.CurrentPage().getParameters().get('pname');
        isWordDoc 	= 	ApexPages.CurrentPage().getParameters().get('isWordDoc');
        
        if (spName == null || spName=='' ){
            qItem = [select  Custom_Question__c
                     from Custom_Questions__c 
                     where InterviewName__c = :ApexPages.CurrentPage().getParameters().get('Id')];
            
        }
        
        
    }
    
    
/*  
 * This can be set to view Word document as print preview 
 * --------------------------------------------------------
 * 
 *   public String getWordPrintViewXML() {
        return '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
    }
  */  
}