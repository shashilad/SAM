@IsTest(SeeAllData=true)
public class UserTriggerTEST 
{   
  public static testMethod void Main() 
  { 
    try
    { 
      Integer Step=1;
      Account Acc1 = new Account(Name='Test_Account_1');
      INSERT Acc1;    
      
      Contact Cont1 = new Contact(FirstName='CFirst1', LastName='CLast1', Email='cfcl1@test.com', AccountId=Acc1.id);
      INSERT Cont1;
      
      ID Admin_Profile_Id=[SELECT ID FROM PROFILE WHERE NAME='System Administrator'].id;
      User U = new User( LASTNAME='Bonds', FIRSTNAME='Sonny', 
                         COMPANYNAME='MI:6', STATE='il', ALIAS='platform', 
                         POSTALCODE='60010', COUNTRY='US', EMAIL='sonnybond@crme.com',
                         USERNAME='sonnybond@crme.com', COMMUNITYNICKNAME='BondNumber1', 
                         TIMEZONESIDKEY='America/Chicago', LOCALESIDKEY='en_US', EMAILENCODINGKEY='ISO-8859-1', 
                         PROFILEID=Admin_Profile_Id, LANGUAGELOCALEKEY='en_US' );
      INSERT U;
      
      System.RunAs(U)
      {
        U.Email='test2@crme.com';
        
        UPDATE U;
        
        set<Id> Users = new set<Id>();
        
        Users.add(U.id);
        
        UserHelperClass.FollowEthiconGroup(Users, false);

        FeedItem feed = new FeedItem(
          ParentId = u.Id,
          Body = 'This is just a Plain Test'
        );
        insert feed;

        FeedComment comm = new FeedComment(
          FeedItemId = feed.Id,
          CommentBody = 'This is just a Plain Comment'
        );
        insert comm;

        feed = new FeedItem(
          ParentId = U.id,
          Body = FeedItemHelper.HelpDeskGroup+' test for inserting a new Issue @mention'
        );
        insert feed;
        
        feed = new FeedItem(
          ParentId = FeedItemHelper.GetHelpdeskCollaborationGroupId(),
          Body = FeedItemHelper.HelpDeskGroup+' test for inserting a new Issue to the group'
        );
        insert feed;
        
        feed = new FeedItem(
          ParentId = FeedItemHelper.GetEthiconCollaborationGroupId(),
          Body = 'testing posts to the group'
        );
        insert feed;

        feed = new FeedItem(
          ParentId = U.Id,
          Body = FeedItemHelper.EthiconGroup+' testing posts @mention'
        );
        insert feed;
        
      }
    }
    catch(DMLException DE)
    {
      System.debug('IssueTriggerTEST DMLException Line Number: ' + DE.getLineNumber() + '\n' + DE + '\n');
      for (Integer i = 0; i < DE.getNumDml(); i++)         
        System.debug(DE.getDmlMessage(i)); 
    } 
    catch(Exception E)
    {
      System.debug('IssueTriggerTEST Exception Line Number: ' + E.getLineNumber() + '\n' + E + '\n');
    }
  }
}