public class FeedItemHelper
{
  public static String EthiconGroup = '@Ethicon Broadcast';
  public static String HelpDeskGroup = '@Helpdesk';
  public static String EthiconUserGroup = 'EthiconChatterGroup';


  public static Id GetEthiconGroupId()
  {
    Id ethiconGroupId = 
        [
          SELECT Id 
          FROM   Group 
          WHERE  DeveloperName =:FeedItemHelper.EthiconUserGroup 
          LIMIT 1
        ].Id;

    return ethiconGroupId;
  }


  public static Id GetEthiconCollaborationGroupId()
  {
    List<CollaborationGroup> CG=
        [
          SELECT Id
          FROM   CollaborationGroup
          WHERE  Name = 'Ethicon Broadcast'
          LIMIT 1
        ];
    
    if(CG.isEmpty())
      return null;
    else
      return CG[0].Id;
  }


  public static Id GetHelpdeskCollaborationGroupId()
  {
    List<CollaborationGroup> CG =
        [
          SELECT Id
          FROM   CollaborationGroup
          WHERE  Name = 'Helpdesk'
          LIMIT 1
        ];
        
    if(CG.isEmpty())
      return null;
    else
      return CG[0].Id;
  }


  public static Set<Id> GetGroupUserIds(Id groupId)
  {
    Set<Id> memberIds = new Set<Id>();

    List<GroupMember> groupMembers = 
        [
          SELECT UserOrGroupId 
          FROM   GroupMember 
          WHERE  GroupId =:groupId
        ];

    for(GroupMember gm: groupMembers)
      memberIds.add(gm.UserOrGroupId);

    return memberIds;
  }


  public static Map<Id,FeedItem> GetUsersToFeedItemMap(
      List<FeedItem> newFeedItems)
  {
    Map<Id,FeedItem> usersToFeedItems = new Map<Id,FeedItem>();
     
    for(FeedItem fi: newFeedItems)
      usersToFeedItems.put(fi.CreatedById,fi);

    return usersToFeedItems;
  }


  public static List<User> GetAssociatedUsers(
      List<FeedItem> newFeedItems)
  {
    Set<Id> userIds = new Set<Id>();

    for(FeedItem fi: newFeedItems)
      userIds.add(fi.CreatedById);

    List<User> users =
        [
          SELECT Id, UserRoleId, ProfileId
          FROM   User 
          WHERE  Id IN: userIds
        ];

    return users;
  }


  public static void EthiconGroupRestrictions(
      List<User> users, 
      Map<Id,FeedItem> usersToFeedItems)
  {
    Id ethiconGroupId = FeedItemHelper.GetEthiconGroupId();
    Id ethiconColGroId = FeedItemHelper.GetEthiconCollaborationGroupId();
    Set<Id> ethiconMemberIds = FeedItemHelper.GetGroupUserIds(ethiconGroupId);

    String errMsg = 'Only authorized personnel are permitted to post to this group. Please try posting again from your own chatter page or in a different group.';
    
    for(User u: users)
    {
      FeedItem fi = usersToFeedItems.get(u.Id);

      if(fi != null)
      { 
        // posted directly to the Ethicon group
        if(fi.ParentId == ethiconColGroId)
        {
          if(!ethiconMemberIds.contains(u.Id))
          {
            fi.addError(errMsg);
          }
        }
        else
        { 
          // @Ethicon in the body
          if(fi.Body != null)
          {
            if(fi.Body.contains(FeedItemHelper.EthiconGroup))
            {
              if(!ethiconMemberIds.contains(u.Id))
              {
                fi.addError(errMsg);
              }
            }
          }
        }
      }
    }
  }


  public static void HelpDeskToIssue(List<FeedItem> newFeedItems)
  {
    Id helpDeskColGroId = FeedItemHelper.GetHelpdeskCollaborationGroupId();
    List<FeedItem> selectFeedItems = new List<FeedItem>();

    for(FeedItem fi: newFeedItems)
    {
      if(fi.ParentId == helpDeskColGroId)
      {
        selectFeedItems.add(fi);
      }
      else
      {
        if(fi.Body != null)
        {
          if(fi.Body.contains(FeedItemHelper.HelpDeskGroup))
          {
            selectFeedItems.add(fi);
          }
        }
      }
    }

    if(!selectFeedItems.isEmpty())
    {
      FeedItemHelper.CreateIssuesFromFeedItems(selectFeedItems);
    }
  }

  public static void CreateIssuesFromFeedItems(List<FeedItem> selectFeedItems)
  {
    List<Issue__c> newIssues = new List<Issue__c>();

    for(FeedItem fi: selectFeedItems)
    {
      String body = fi.Body;

      Issue__c i        = new Issue__c();
      i.OriginatedBy__c = fi.CreatedById;
      i.Priority__c     = 'Medium';
      i.Status__c       = 'new';
      i.IssueOrigin__c  = 'Chatter';
      i.Issue__c        = fi.Body;

      if(body.length() > 255)
        i.Subject__c = body.substring(0,255);
      else
        i.Subject__c = body;

      newIssues.add(i);
    }

    if(!newIssues.isEmpty())
    {
      insert newIssues;
    }
  }
  public static void FeedfromDeviceCategorize(List <FeedItem> selectFeedItems){
    
     List<Chatter_Report__c> recordsToInsert = new List<Chatter_Report__c>();
     String optWeb = System.label.Optimizerweb;
     String optIos = System.label.OptimizerIos;
     String sfdcOne = System.Label.SFDCOne;
     String chatterDesk = 'Chatter Desktop';
     String browser = 'Community';
     String comm = 'Community';
     String appEx = 'AppExchange';
     
     for(FeedItem fi: selectFeedItems){
        if (fi.Type == 'AdvancedTextPost' || fi.Type == 'CollaborationGroupCreated' || fi.Type == 'TextPost' || fi.Type == 'ContentPost' || fi.Type=='LinkPost' || fi.Type=='PollPost'){
            Chatter_Report__c c = new Chatter_Report__c();
            ConnectApi.Feeditem f = ConnectApi.ChatterFeeds.getFeeditem(null,fi.Id);
            if (String.valueof(f).contains(OptWeb)) {
                c.Name = 'Optimizer Web';
            } else if (String.valueof(f).contains(OptIos)) {
                c.Name = 'Optimizer iOS';
            } else if (String.valueof(f).contains(sfdcOne)) {
                c.Name = sfdcOne;
            } else if (String.valueof(f).contains(chatterDesk)) {
                c.Name = chatterDesk;
            }else{
               c.Name = 'Salesforce.com Web';
            }      
            c.FeedId__c = fi.Id; 
            c.PostDate__c = fi.CreatedDate;
            c.ownerId = System.Label.IdSubstitution;
            recordsToInsert.add(c);   
        }      
    }
    insert recordsToInsert;
  }    
}