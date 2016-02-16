public with sharing class CollaborationGroupMemberHelper
{
    public static void CheckCollaborationGroupId(List<CollaborationGroupMember> triggerNew)
    {
        String errorStr = 'Cannot unfollow Ethicon Broadcast group. This group is used for company-wide broadcasts.';
        Id ethiconColGroId = FeedItemHelper.GetEthiconCollaborationGroupId();
        for(CollaborationGroupMember cgm: triggerNew)
            if(cgm.CollaborationGroupId == ethiconColGroId)
                cgm.addError(errorStr);
    }
}