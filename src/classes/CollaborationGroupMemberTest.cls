@IsTest(SeeAllData=true)
private class CollaborationGroupMemberTest
{
  public static testmethod void NormalTest()
  {
    User u = [SELECT Id FROM User  where isActive=true AND Profile.Name ='SAM Group'  LIMIT 1];
    
    UtilityCls.DebugMessage('User', u);
      
    Id ethiconGroupId = FeedItemHelper.GetEthiconCollaborationGroupId();

    UtilityCls.DebugMessage('Groupid', ethiconGroupId);

    CollaborationGroupMember[] cgm = 
        [
          SELECT MemberId, CollaborationGroupId 
          FROM   CollaborationGroupMember 
          WHERE  MemberId =:u.Id 
          AND    CollaborationGroupId =:ethiconGroupId
          LIMIT  1
        ];

    System.RunAs(u)
    {
      Test.StartTest();
      try{delete cgm;}catch(Exception e){/* should throw an exception */}
      Test.StopTest();
    }
  }
}