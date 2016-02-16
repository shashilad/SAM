/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Developed by : Shashi Lad
                on : 1/19/2015
           purpose : Add new chatter users to 'Ethicon Broadcast' group automatically. This is a temp work around for the trigger which is behaving wierd. It adds
                     some users but not all.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

global class Batch_AddUsersToColGroup implements Database.Batchable<SObject>,  Schedulable {
    
   /* *********************   Batchable methods below ********************* */
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String soql = getQuery();
        return Database.getQueryLocator(soql);
    }
    
     global void execute(Database.BatchableContext bc, list<User> usrRecords) {
        id ethiconColGroId =  FeedItemHelper.GetEthiconCollaborationGroupId();
        system.debug('Ethicon group id --------> ' + ethiconColGroId );
            
        set<id> userIds = new set<id>();
        for (user u : usrRecords ){
            userIds.add(u.id);
        }
        system.debug('total users size ------> ' + userIds.size());   
 
        set<id> usersAlreadyMembers = new set<id>();
        for (CollaborationGroupMember c :[select memberid from CollaborationGroupMember where  collaborationgroupid=:ethiconColGroId and member.profile.name like '%chatter%']){
            usersAlreadyMembers.add(c.memberid);
        }
    
        system.debug('already member size -----> ' + usersAlreadyMembers.size());
            
        set<id> needToAdd = new set<id>();
            
        for (id us : userids){
            if(!usersAlreadyMembers.contains(us)){
                system.debug ('need to add --------> ' + us);
                needToAdd.add(us);           
            }else{
                  system.debug ('Do not add --------> ' + us);
            }
             
        }
            
        system.debug('Need to add size ---------> ' + needToAdd.size());

        List<CollaborationGroupMember> ad = new List<CollaborationGroupMember>();
            
        for(id i : needToAdd){
            ad.add(new CollaborationGroupMember(CollaborationRole = 'Standard',
                                                CollaborationGroupId = ethiconColGroId,
                                                MemberId = i));
        }
                 
        system.debug('################ Adding '  + ad.size() + 'new users to collaborationgroup ########## ');
        if (ad != null && ad.size()>0) insert ad;
                
                    
    
    
    
           
     } // end of batch - execute
 
     // Batch finish 
     global void finish(Database.BatchableContext bc) {
        if (bc != null) {
            System.debug('finish,job id --> ' + bc.getJobId());
        }
     }

     // existing User records with chatter profiles
     private static String getQuery() {
        String query = 'SELECT id from User where profile.name like \'%chatter%\' and isActive=True';
        if (Test.isRunningTest()) query += '  limit 10';
        System.debug('------> soql: ' + query);
        return query;
     }
    
    
   /* *********************   Batchable methods below ********************* */
    global void execute(SchedulableContext sc) {
        integer batchSize = 200;  
        Database.executeBatch(new Batch_AddUsersToColGroup(), batchSize);
     }
     global  void scheduleJob(String scheduleString) {
        If (scheduleString == null) {
            scheduleString = '0 0 17 * * ?';
        }
        
        System.schedule(getUniqueJobName(), scheduleString, new Batch_AddUsersToColGroup());
     }
      
     public String getUniqueJobName() {
        //construct unique job name by appending timestamp
        String uniqueJobName = 'Batch_AddUsersToColGroup-' + System.now().format('yyyy-MM-dd_k:m:s');
        System.debug('job name : ' + uniqueJobName);
        return uniqueJobName;
     } 
}