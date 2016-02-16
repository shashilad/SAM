public with sharing class UserHelperClass
{
  @future
  public static void FollowEthiconGroup(set<Id> users, Boolean fromInsertTrigger)
  {
    Id ethiconColGroId = FeedItemHelper.GetEthiconCollaborationGroupId();
    
    if(ethiconColGroId == null)
      return;
      
    List<CollaborationGroupMember> gmToAdd = new List<CollaborationGroupMember>();

    if(fromInsertTrigger)
    {
      for(id u: users)
      {
        gmToAdd.add(new CollaborationGroupMember(
          CollaborationRole = 'Standard',
          CollaborationGroupId = ethiconColGroId,
          MemberId = u
        ));
      }
    }
    else
    {
      Set<Id> userIds = new Set<Id>();
      Set<Id> usersAlreadyMembers = new Set<Id>();
      
      for(Id u: users)
        userIds.add(u);

      List<CollaborationGroupMember> alreadyMembers = 
          [
            SELECT MemberId, CollaborationGroupId
            FROM   CollaborationGroupMember
            WHERE  MemberId IN: userIds
            AND    CollaborationGroupId =:ethiconColGroId
          ];

      if(!alreadyMembers.isEmpty())
        for(CollaborationGroupMember gm: alreadyMembers)
          usersAlreadyMembers.add(gm.MemberId);

      for(ID u: users)
      {
        Boolean userNeedsToBeAdded = true;

        if(!usersAlreadyMembers.isEmpty())
          if(usersAlreadyMembers.contains(u))
            userNeedsToBeAdded = false;

        if(userNeedsToBeAdded)
        {
          gmToAdd.add(new CollaborationGroupMember(
            CollaborationRole = 'Standard',
            CollaborationGroupId = ethiconColGroId,
            MemberId = u
          ));
        }
      }
    }

    if(!gmToAdd.isEmpty())
      insert gmToAdd;

    System.debug('Added '+gmToAdd.size()+' users to Ethicon Chatter Group');
  }
}