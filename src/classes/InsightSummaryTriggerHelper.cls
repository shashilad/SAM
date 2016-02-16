public class InsightSummaryTriggerHelper {
    
    
    @future 
    public static void  attachPdf(String aId) {
        
        system.debug('Executing future InsightSummaryTriggerHelper.attachPdf() -->');
        
        Attachment 		existAttach = null;
        PageReference 	myPdf 		= new PageReference ('/apex/AccountCompReportPDF?id='+aId);
        
        
        try{
            existAttach = [SELECT Id 
                           FROM Attachment 
                           WHERE ParentId = :aId 
                           AND Name='InsightSummary.pdf' 
                           LIMIT 1];       
            if (Test.isRunningTest()){
                
                existAttach.body =blob.valueOf('Test');
            }else{
                existAttach.body = myPdf.getContentAsPdf();
            }
            
            update existAttach;
            
            
        }catch(exception e){
            
            system.debug('Summary attached first time for ---' + aId + '---> ' + e);
            
            Attachment myAttach = new Attachment();
            myAttach.ParentId 	= aId;
            myAttach.name 		= 'InsightSummary.pdf';
            
            if (Test.isRunningTest()){
                myAttach.body = blob.valueOf('Test');
            }else{
                myAttach.body = myPdf.getContentAsPdf();
            }
            
            insert myAttach;
        }
        
    }  
}