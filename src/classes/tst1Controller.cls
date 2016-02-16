public with sharing class tst1Controller {
    public list<ContentDistribution> cd {get;set;}
    public tst1Controller(ApexPages.StandardController controller) {
              id relId = ApexPages.CurrentPage().getParameters().get('Id');
              if (relId != null ){
                  cd = [select  Name,DistributionPublicUrl from ContentDistribution 
                           where RelatedRecordId = :relId
                           and isDeleted=false];
              }     
                
    }

}