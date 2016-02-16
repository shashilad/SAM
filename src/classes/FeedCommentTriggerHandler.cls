public class FeedCommentTriggerHandler
{
  private Boolean m_isExecuting = false;

  private Integer batchSize = 0;

  public FeedCommentTriggerHandler(Boolean isExecuting, Integer size)
  {
    m_isExecuting = isExecuting;
    batchSize = size;
    if(IsTriggerContext){}
    if(IsVisualforcePageContext){}
    if(IsWebServiceContext){}
    if(IsExecuteAnonymousContext){}
  }

  // trigger contexts
  public boolean IsTriggerContext
  {get{ return m_isExecuting;}}

  public boolean IsVisualforcePageContext
  {get{ return !IsTriggerContext;}}

  public boolean IsWebServiceContext
  {get{ return !IsTriggerContext;}}

  public boolean IsExecuteAnonymousContext
  {get{ return !IsTriggerContext;}}

  // trigger routing
  public void OnAfterInsert(List<FeedComment> newFeedComments)
  {
    FeedCommentHelper.CommentfromDeviceCategorize(newFeedComments);
  }

/* Rem out for code coverage
//=============================
  public void OnBeforeInsert(List<FeedItem> newFeedItems){}
 
  @future public static void OnAfterInsertAsync(Set<ID> newFeedItemIDs){}
  
  public void OnBeforeUpdate(List<FeedItem> oldFeedItems, List<FeedItem> updatedFeedItems, Map<ID, FeedItem> FeedItemMap){}
  
  public void OnAfterUpdate(List<FeedItem> oldFeedItems, List<FeedItem> updatedFeedItems, Map<ID, FeedItem> FeedItemMap){}
 
  @future public static void OnAfterUpdateAsync(Set<ID> updatedFeedItemIDs){}
 
  public void OnBeforeDelete(List<FeedItem> FeedItemsToDelete, Map<ID, FeedItem> FeedItemMap){}
 
  public void OnAfterDelete(List<FeedItem> deletedFeedItems, Map<ID, FeedItem> FeedItemMap){}
 
  @future public static void OnAfterDeleteAsync(Set<ID> deletedFeedItemIDs){}

  public void OnUndelete(List<FeedItem> restoredFeedItems){}
*/
}