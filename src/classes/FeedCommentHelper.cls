// due to implementation limitations, this class has to run in system context
public class FeedCommentHelper{
    
  public static void CommentfromDeviceCategorize(List <FeedComment> selectFeedComments){
    
     List<Chatter_Report__c> recordsToInsert = new List<Chatter_Report__c>();
     set<Id> feedIds = new set<Id>();
     String optWeb = System.label.Optimizerweb;
     String optIos = System.label.OptimizerIos;
     String sfdcOne = System.Label.SFDCOne;
     String chatterDesk = 'Chatter Desktop';
     String browser = 'Community';
     String comm = 'Community';
     String appEx = 'AppExchange';
     
     for(FeedComment fc : selectFeedComments){
            Chatter_Report__c co = new Chatter_Report__c();
            ConnectApi.Comment f = ConnectApi.ChatterFeeds.getComment(null,fc.Id);
            if (String.valueof(f).contains(OptWeb)) {
                co.Name = 'Optimizer Web';
            } else if (String.valueof(f).contains(OptIos)) {
                co.Name = 'Optimizer iOS';
            } else if (String.valueof(f).contains(sfdcOne)) {
                co.Name = sfdcOne;
            } else if (String.valueof(f).contains(chatterDesk)) {
                co.Name = chatterDesk;
            }else{
               co.Name = 'Salesforce.com Web';
            }      
            co.CommentId__c = fc.Id; 
            co.PostDate__c = fc.CreatedDate;
            co.OwnerId = System.Label.IdSubstitution;
            recordsToInsert.add(co);   
            system.debug('--------- > Record to insert <--------------');
    }
    insert recordsToInsert;
  }
}