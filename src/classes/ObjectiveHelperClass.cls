public class ObjectiveHelperClass
{
  public static void DeleteRecords(
    Boolean deleteMBOs, 
    Boolean deleteObjectives, 
    Boolean deleteObjectiveQueues)
  {
    if(deleteMBOs)
    {
      List<Master_Objective__c> mbos = 
        [SELECT Id FROM Master_Objective__c];
      
      if(!mbos.isEmpty())
        delete mbos;
    }

    if(deleteObjectives)
    {
      List<Objective__c> objectives = 
        [SELECT Id FROM Objective__c];
      
      if(!objectives.isEmpty())
        delete objectives;
    }

    if(deleteObjectiveQueues)
    {
      List<Objective_Queue__c> objectiveQueue = 
        [SELECT Id FROM Objective_Queue__c];
      
      if(!objectiveQueue.isEmpty())
        delete objectiveQueue;
    }
  }

  public static void MakeMBOs()
  {
    List<Objective_Queue__c> objQueue = 
     [SELECT MBO_NAME__C, REGION__C FROM Objective_Queue__c];

    Set<String> newMBOSet   = new Set<String>();
    List<String> newMBOList = new List<String>();
    List<Master_Objective__c> newMBOs = new List<Master_Objective__c>();

    for(Objective_Queue__c oq: objQueue)
      newMBOSet.add(oq.MBO_NAME__c + '|;|' + oq.REGION__c);

    newMBOList.addAll(newMBOSet);

    for(String m: newMBOList)
    {
      List<String> temp = m.split('\\|\\;\\|');

      Master_Objective__c tempNewMBO = new Master_Objective__c(
        Name = temp[0], 
        Region__c = temp[1]
      );

      newMBOs.add(tempNewMBO);
    }

    if(newMBOs.size() > 0)
      insert newMBOs;
  }

  public static void MakeObjectives()
  {
    List<Master_Objective__c> allMBO = 
     [SELECT Id, Name, Region__c FROM Master_Objective__c];

    List<Objective_Queue__c> objQueue = 
     [SELECT MBO_NAME__C, REGION__C, ISR_TEMP__C, OBJECTIVE_TYPE__C, 
             JJHCS_TEMP__C, ACCOUNT_NAME__C, DIVISION__C, DISTRICT_MANAGER__C, 
             FIELD_REP__C
      FROM   Objective_Queue__c];

    List<Account> accList = 
     [SELECT Id, Name FROM Account WHERE Name =:'Unknown' LIMIT 1];

    Id accId = accList[0].Id;

    List<Objective__c> objInsert = new List<Objective__c>();

    Map<String, Id> allMBOMap = new Map<String, Id>();

    for(Master_Objective__c m: allMBO)
      allMBOMap.put(m.Name,m.Id);

    for(Objective_Queue__c oq: objQueue)
    {
      if(allMBOMap.get(oq.MBO_Name__C) != null)
      {
        Objective__c temp = new Objective__c(
          Name = oq.ACCOUNT_NAME__C,
          Account__c = accId,
          Account_Name__c = oq.ACCOUNT_NAME__C, 
          District_Manager__c = oq.DISTRICT_MANAGER__C,
          Division__c = oq.DIVISION__c,
          ISR_TEMP__c = oq.ISR_TEMP__c,
          JJHCS_TEMP__c = oq.JJHCS_TEMP__c,
          Master_Objective__c = allMBOMap.get(oq.MBO_NAME__C),
          Objective_Type__c = oq.OBJECTIVE_TYPE__C
        );

        objInsert.add(temp);
      }
    }
    
    if(!objInsert.isEmpty())
      insert objInsert;
  }


  public static void ConnectObjectivesToAccounts()
  {
    List<Account> relAcc = new List<Account>();
    Set<String> jjhcsNumbers = new Set<String>();

    List<Objective__c> allObj = 
     [SELECT Id, Name, Account_Name__c, Account__c, JJHCS_TEMP__c 
      FROM   Objective__c];

    if(!allObj.isEmpty())
    {
      for(Objective__c o: allObj)
        jjhcsNumbers.add(o.JJHCS_TEMP__c);

      relAcc = 
       [SELECT Id, Name, AccountNumber 
        FROM   Account 
        WHERE  AccountNumber in:jjhcsNumbers];
    }

    if(!relAcc.isEmpty())
    {
      Map<String,Id> accMap = new Map<String,Id>();

      for(Account a: relAcc)
        accMap.put(a.AccountNumber,a.Id);
      
      for(Objective__c o: allObj)
      {
        if(accMap.get(o.JJHCS_TEMP__c) != null)
          o.Account__c = accMap.get(o.JJHCS_TEMP__c);
        else
          System.debug('No JJHCS Match: ' + o.JJHCS_TEMP__c);
      }
      
      if(!allObj.isEmpty()) 
        update allObj;
    }
  }
}