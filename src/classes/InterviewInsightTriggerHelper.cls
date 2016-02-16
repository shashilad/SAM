public with sharing class InterviewInsightTriggerHelper {

    public static void updateTimestampOnInterview(List<Interview_Insight__c> insightRecords){
        set<Id> iIds = new set<id>();
        list<Stakeholder_Interview__c> iList = new list<Stakeholder_Interview__c>();
        for (Interview_Insight__c i : insightRecords){
            iIds.add(i.Stakeholder_Interviews__c);
        }
        for(Stakeholder_Interview__c s : [select Last_Updated__c from Stakeholder_Interview__c
                                                                where Id in :iIds]){
            s.Last_Updated__c = System.today();
            iList.add(s);
        }
        if (iList !=null   && iList.size()>0) update iList;



    }
/*
    public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</BODY></HTML>';
    @future
    public  static void addInterviewInsightPDF(list<Id> newInterviewInsights) {
         boolean isAttach=true;
         list<Attachment> existAttach = new list<Attachment>() ;
         list<Attachment> insertAttach = new list<Attachment>() ;
         set<Id> interviewId = new set<Id>();
         set<Id> updateAttachment = new set<Id>();
         PageReference myPdf;
        
         
         for(id i : newInterviewInsights){
            interviewId.add(i);
         }

                system.debug ('executing update attachment ----------------> 0');
 
         for(Attachment att : [select id,ParentId,body from Attachment where ParentId in :interviewId and Name='Insights.pdf']){
                myPdf = new PageReference ('/apex/InterviewInsightPDF?id='+ att.parentId);
                system.debug ('executing update attachment ----------------> 1'+mypdf);
            att.body = myPdf.getContentAsPdf();
            
                system.debug ('executing update attachment ----------------> 2'+att.body);
       //   string pdfcont = generatePDF(att.ParentId);
        //  att.body = Blob.toPDF(pdfCont);
         //                      att.contentType = 'pdf';
            existAttach.add(att);
                system.debug ('executing update attachment ----------------> 3');
            updateAttachment.add(att.ParentId);
                system.debug ('executing update attachment ----------------> 4');
         }
         
  
         for(Id iId : interviewId){
  
            if (!updateAttachment.contains(iId)){
  
                Attachment myAttach = new Attachment();
                myPdf = new PageReference ('/apex/InterviewInsightPDF?id='+ iId);
               // String pdfcon = generatePDF(iId);
                myAttach.ParentId = iId;
                myAttach.name = 'Insights.pdf';
                myAttach.body = myPdf.getContentAsPdf();
              //    myAttach.body = Blob.toPDF(pdfCon);
                insertAttach.add(myAttach);
                
            }
            
         }
            
         if (existAttach != null && existAttach.size()>0) update existAttach;
         if (insertAttach != null && insertAttach.size()>0) insert insertAttach;
            
    }
         
    public static string generatePDF(Id InterviewId){
        String pdfContent = '' + FORM_HTML_START;
        pdfContent = '' + FORM_HTML_START;
        
        List<Interview_Insight__c> iiList = [select Name,comments__c,Stakeholder_Interview__r.Name, Stakeholder_Interview__r.Account_Name__r.Name  from Interview_Insight__c 
                                                                where Stakeholder_Interview__c = :interviewId];
             
        pdfContent = pdfContent + '<H4>' + iiList[0].Stakeholder_Interview__r.Name +'</H4> <br/>';
        pdfContent = pdfContent + '<H5>' + 'Account : '+iiList[0].Stakeholder_Interview__r.Account_Name__r.Name+  '</H5><br/>';
         pdfContent = pdfContent + '<table width="100%">';
        String trCells = ' ';
        for (Interview_Insight__c ii : iiList){
                 trCells = trCells + '<tr width="100%" color="blue"><td width="10%">' + ii.Name + '</td>';
                 trCells = trCells + '<td width="90%">'+ii.Comments__c + '</td></tr>';
        }
        pdfContent = pdfContent + trCells + '</table>';
        pdfContent = pdfContent + FORM_HTML_END;
        System.debug ('---------------------------- pdfContent HTML format ------------- ' +pdfContent);
        return pdfContent;
    }
         
  
    
*/
}