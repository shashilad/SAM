/*
  Intends to provide coverage for:
    ObjectivesMBOController.cls
    ObjectiveHelperClass.cls
    OptimizerBootstrapController.cls
*/

@isTest(seeAllData=true)
private class ObjectivesTest
{

  public static testmethod void TestObjectivesMBOController()
  {  
    System.debug('TestObjectivesMBOController START');
    String uniqueName  = 'TestObjMboCont';
    Integer magicNum   = 5;
    String jjhcsPrefix = '1234';
    
    User u = CreateTestUser(uniqueName);

    List<Account> accs = CreateAccounts(uniqueName, magicNum, jjhcsPrefix);
    Id unknownAccId = accs.get(0).Id;

    List<String> mboNames = CreateMBONames(uniqueName, magicNum);
    
    List<String> objTypes = new List<String>{
      'Sales','Lead','Upgrade','Install','None'};
    List<Objective_Queue__c> objQueue = CreateObjectiveQueues(
      uniqueName, magicNum, jjhcsPrefix, mboNames, objTypes);

    System.debug('objTypes.size() = '+objTypes.size());
    System.debug('mboNames.size() = '+mboNames.size());

    System.RunAs(u)
    {
      System.Test.StartTest();
      
      /* ===== Start testing ObjectiveHelperClass ====== */
      ManageMBOObjConnections();
      /* =============================================== */


/* =================== ObjectivesMBOController Test START ==================== */
      List<Objective__c> allObjs = 
       [SELECT  Id, Jan__c,Feb__c,Mar__c,Q1_Target__c,Apr__c,May__c,Jun__c,
                Q2_Target__c,Jul__c,Aug__c,Sep__c,Q3_Target__c,Oct__c,
                Nov__c,Dec__c,Q4_Target__c,H1_Sales__c,H1_Target__c,
                H2_Sales__c,H2_Target__c
        FROM    Objective__c];

      if(!allObjs.isEmpty())
      {
        Integer objSize = allObjs.size()-10;

        Integer subtraction = -10;
        Integer num1Check = 1;
        Integer num2Check = 2;
        Integer num3Check = 3;
        Decimal oneNum = 10;
        Decimal twoNum = -1;
        Decimal threeNum = 0;
        Integer divisor = 4;
        Integer elseRecords = 0;
        Integer one = 0;
        Integer two = 0;
        Integer three = 0;
        String luiStr = 'Objective Met';

        System.debug('objSize = '+objSize);

        for(Integer i = 0; i < objSize; i++)
        {
          num1Check += 1;
          num2Check += 1;
          num3Check += 1;

          if(Math.mod(num1Check,divisor) == 0 && i != 115)
          {
            one += 1;
            allObjs[i].Jan__c       = oneNum;
            allObjs[i].Feb__c       = oneNum;
            allObjs[i].Mar__c       = oneNum;
            allObjs[i].Q1_Target__c = oneNum+500;
            allObjs[i].Apr__c       = oneNum;
            allObjs[i].May__c       = oneNum;
            allObjs[i].Jun__c       = oneNum;
            allObjs[i].Q2_Target__c = oneNum+500;
            allObjs[i].Jul__c       = oneNum;
            allObjs[i].Aug__c       = oneNum;
            allObjs[i].Sep__c       = oneNum;
            allObjs[i].Q3_Target__c = oneNum+500;
            allObjs[i].Oct__c       = oneNum;
            allObjs[i].Nov__c       = oneNum;
            allObjs[i].Dec__c       = oneNum;
            allObjs[i].Q4_Target__c = oneNum+500;

            allObjs[i].Jan_Status__c = luiStr;
            allObjs[i].Feb_Status__c = luiStr;
            allObjs[i].Mar_Status__c = luiStr;
            allObjs[i].Apr_Status__c = luiStr;
            allObjs[i].May_Status__c = luiStr;
            allObjs[i].Jun_Status__c = luiStr;
            allObjs[i].Jul_Status__c = luiStr;
            allObjs[i].Aug_Status__c = luiStr;
            allObjs[i].Sep_Status__c = luiStr;
            allObjs[i].Oct_Status__c = luiStr;
            allObjs[i].Nov_Status__c = luiStr;
            allObjs[i].Dec_Status__c = luiStr;
          }
          else if(Math.mod(num2Check,divisor) == 0 && i != 115)
          {
            two += 1;
            allObjs[i].Jan__c       = twoNum;
            allObjs[i].Feb__c       = twoNum;
            allObjs[i].Mar__c       = twoNum;
            allObjs[i].Q1_Target__c = twoNum;
            allObjs[i].Apr__c       = twoNum;
            allObjs[i].May__c       = twoNum;
            allObjs[i].Jun__c       = twoNum;
            allObjs[i].Q2_Target__c = twoNum;
            allObjs[i].Jul__c       = twoNum;
            allObjs[i].Aug__c       = twoNum;
            allObjs[i].Sep__c       = twoNum;
            allObjs[i].Q3_Target__c = twoNum;
            allObjs[i].Oct__c       = twoNum;
            allObjs[i].Nov__c       = twoNum;
            allObjs[i].Dec__c       = twoNum;
            allObjs[i].Q4_Target__c = twoNum;
          }
          else if(Math.mod(num3Check,divisor) == 0 && i != 115)
          {
            three += 1;
            allObjs[i].Jan__c       = threeNum;
            allObjs[i].Feb__c       = threeNum;
            allObjs[i].Mar__c       = threeNum;
            allObjs[i].Q1_Target__c = threeNum-500;
            allObjs[i].Apr__c       = threeNum;
            allObjs[i].May__c       = threeNum;
            allObjs[i].Jun__c       = threeNum;
            allObjs[i].Q2_Target__c = threeNum-500;
            allObjs[i].Jul__c       = threeNum;
            allObjs[i].Aug__c       = threeNum;
            allObjs[i].Sep__c       = threeNum;
            allObjs[i].Q3_Target__c = threeNum-500;
            allObjs[i].Oct__c       = threeNum;
            allObjs[i].Nov__c       = threeNum;
            allObjs[i].Dec__c       = threeNum;
            allObjs[i].Q4_Target__c = threeNum-500;
          }
          else
          {
            elseRecords += 1;
            allObjs[i].Jan__c       = 0;
            allObjs[i].Feb__c       = 0;
            allObjs[i].Mar__c       = 0;
            allObjs[i].Q1_Target__c = 0;
            allObjs[i].Apr__c       = 0;
            allObjs[i].May__c       = 0;
            allObjs[i].Jun__c       = 0;
            allObjs[i].Q2_Target__c = 0;
            allObjs[i].Jul__c       = 0;
            allObjs[i].Aug__c       = 0;
            allObjs[i].Sep__c       = 0;
            allObjs[i].Q3_Target__c = 0;
            allObjs[i].Oct__c       = 0;
            allObjs[i].Nov__c       = 0;
            allObjs[i].Dec__c       = 0;
            allObjs[i].Q4_Target__c = 0;
          }
        }
        update allObjs;

        System.debug('one = '+one);
        System.debug('two = '+two);
        System.debug('three = '+three);
        System.debug('elseRecords = '+elseRecords);
      }

      PageReference pageRef = Page.ObjectivesMBOPage;
      pageRef.getParameters().put('regions', 'Great Lakes');
      System.Test.setCurrentPage(pageRef);


      ObjectivesMBOController controller = new ObjectivesMBOController();

      controller.quarter = 'Q2';
      controller.hideQuarterDivs();
      controller.quarter = 'Q3';
      controller.hideQuarterDivs();
      controller.quarter = 'Q4';
      controller.hideQuarterDivs();
      controller.quarter = 'H1';
      controller.hideQuarterDivs();
      controller.quarter = 'H2';
      controller.hideQuarterDivs();

      controller.toggleSort();

      pageRef.getParameters().put('regions', 'Great Lakes');
      controller.regionQuery();
      controller.limitRegion = 'Great Lakes';
      controller.runQuery();
      controller.getMastObjPickListValues();

      pageRef.getParameters().clear();
      pageRef.getParameters().put('regions', 'All Regions');
      controller.regionQuery();

      controller.NoSalesMBO();
      controller.NoLuiMBO();

      controller.getQuarterPicklist();
      controller.getRegionPickListValues();
      controller.getMastObjPickListValues();
/* ==================== ObjectivesMBOController Test END ===================== */


      // Test OptimizerBooststrapController
      PageReference pageRef3 = Page.OptimizerBootstrapPage;
      System.Test.setCurrentPage(pageRef3);
      OptimizerBootstrapController controller2 = new OptimizerBootstrapController();

      /* ===== Finish testing ObjectiveHelperClass ===== */
      ObjectiveHelperClass.DeleteRecords(true, true, true);
      /* =============================================== */

      System.Test.StopTest();
    }
    System.debug('TestObjectivesMBOController END');
  }
  

  public static void ManageMBOObjConnections()
  {
    ObjectiveHelperClass.MakeMBOs();
    ObjectiveHelperClass.MakeObjectives();
    ObjectiveHelperClass.ConnectObjectivesToAccounts();
  }

  public static User CreateTestUser(String uniqueName) 
  { 
    Profile p = [Select Id, Name from Profile where Name = 'System Administrator']; 
    return CreateTestUser(p,uniqueName);
  }

  public static User CreateTestUser(Profile p, String uniqueName)
  {
    User testUser = new User(
      LastName          = 'Bond', 
      FirstName         = 'James', 
      CompanyName       = 'Ethicon', 
      State             = 'IL', 
      Alias             = 'jbond', 
      PostalCode        = '60010', 
      Country           = 'US', 
      Email             = 'bondjames@crme.com',
      Username          = 'bondjames@crme.com', 
      CommunityNickname = 'BondjamesbonD', 
      TimeZoneSidKey    = 'America/Chicago', 
      LocaleSidKey      = 'en_US', 
      EmailEncodingKey  = 'UTF-8', 
      ProfileId         = p.Id, 
      LanguageLocaleKey = 'en_US'
    );
   
    insert testUser;
    return testUser;
  }

  public static List<Account> CreateAccounts(
    String uniqueName, 
    Integer numAccs, 
    String jjhcsPrefix)
  {
    
    List<RecordType> recordType = 
      [SELECT Id FROM RecordType WHERE DeveloperName = 'Teradata_Account'];

    Id accRecordTypeId = recordType.get(0).Id;

    List<Account> accs = new List<Account>();

    // the Objectives will be initially linked to an account named 'Unknown'
    Account tempAcc = new Account(
      Name = 'Unknown',
      RecordTypeId = accRecordTypeId
    );

    accs.add(tempAcc);

    for(Integer i = 0; i < numAccs; i++)
    {
      String tempI = String.valueOf(i);
      tempAcc = new Account(
        Name          = uniqueName + 'Account' + tempI,
        RecordTypeId  = accRecordTypeId,
        AccountNumber = jjhcsPrefix+tempI
      );
      
      accs.add(tempAcc);
    }

    if(!accs.isEmpty())
    {
      insert accs;
    }

    return accs;
  }

  public static List<String> CreateMBONames(
    String uniqueName, 
    Integer numMBONames)
  {
    List<String> tempMBONames = new List<String>();

    for(Integer i = 0; i < numMBONames; i++)
    {
      tempMBONames.add(uniqueName+'MBO'+String.valueOf(i));
    }

    return tempMBONames;
  }


  public static List<Objective_Queue__c> CreateObjectiveQueues(
    String uniqueName, 
    Integer numObjsPerMbo,
    String jjhcsPrefix,
    List<String> mboNames,
    List<String> objTypes)
  {
    
    List<Objective_Queue__c> objQs = new List<Objective_Queue__c>();
    
    for(String m: mboNames)
    {
      for(String ot: objTypes)
      {
        for(Integer i = 0; i < numObjsPerMbo; i++)
        {
          String tempI = String.valueOf(i);
          
          if(i==0)
          {
            objQs.add(new Objective_Queue__c(
              Account_Name__c   = uniqueName + 'Account' + tempI,
              Objective_Type__c = ot,
              Region__c         = 'Great Lakes',
              Mbo_Name__c       = m,
              JJHCS_TEMP__c     = jjhcsPrefix + tempI
            ));
          }
          else
          {
            objQs.add(new Objective_Queue__c(
                Account_Name__c   = uniqueName + 'Account' + tempI,
                Objective_Type__c = ot,
                Region__c         = m+jjhcsPrefix,
                Mbo_Name__c       = m,
                JJHCS_TEMP__c     = jjhcsPrefix+tempI
            ));  
          }
    } } }

    objQs.add(new Objective_Queue__c(
      Account_Name__c   = 'does not belong',
      Objective_Type__c = 'Sales',
      Region__c         = 'none',
      Mbo_Name__c       = 'does not belong',
      JJHCS_TEMP__c     = '123456'
    ));

    insert objQs;
    return objQs;
  }
}