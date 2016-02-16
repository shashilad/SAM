@IsTest
public class IssueTriggerTEST 
{   
  public static testMethod void Main() 
  { try
    { 
      Integer Step=1;
      Account Acc1 = new Account(Name='Test_Account_1');
      INSERT Acc1;    
      Account Acc2 = new Account(Name='Test_Account_2');
      INSERT Acc2;
      
      Contact Cont1 = new Contact(FirstName='CFirst1', LastName='CLast1', Email='cfcl1@test.com', AccountId=Acc1.id);
      INSERT Cont1;
      Contact Cont2 = new Contact(FirstName='CFirst2', LastName='CLast2', Email='cfcl2@test.com', AccountId=Acc2.id);
      INSERT Cont2;
      
      ID Admin_Profile_Id=[SELECT ID FROM PROFILE WHERE NAME='System Administrator'].id;
      User U = new User( LASTNAME='Bonds', FIRSTNAME='Sonny', 
                         COMPANYNAME='Barrington Broncos Wrestling Club', STATE='il', ALIAS='platform', 
                         POSTALCODE='60010', COUNTRY='US', EMAIL='sonnybond@crme.com',
                         USERNAME='sonnybond@crme.com', COMMUNITYNICKNAME='BondNumber1', 
                         TIMEZONESIDKEY='America/Chicago', LOCALESIDKEY='en_US', EMAILENCODINGKEY='ISO-8859-1', 
                         PROFILEID=Admin_Profile_Id, LANGUAGELOCALEKEY='en_US' );
      INSERT U;
      System.debug('U: ' + U);
      System.debug('U.id: ' + U.id);

      
      System.RunAs(U){
        if(1==1)
        { Issue__c Issue = new Issue__c(IssueOrigin__c='Email', Resolution__c='Done');
          insert Issue;
          
          Issue.Status__c='Closed';
          update Issue;

          Issue.Status__c='Reopened';
          update Issue;
          
          Issue__c Issue2 = new Issue__c(IssueOrigin__c='Email', Resolution__c='Done');
          insert Issue2;

          PageReference pageRef = Page.IssueVpage2;
          Test.setCurrentPage(pageRef);

          ApexPages.StandardController Standard_Controller = new ApexPages.StandardController(Issue2);
          IssueController myPageCon = new IssueController(Standard_Controller);

          pageRef.getParameters().put('IssueOrigin__c', 'Phone');
          myPageCon.Save();
          
          PageReference pageRef2 = Page.IssueVpage2;
          pageRef2.getParameters().put('id', Issue2.id);
          Test.setCurrentPage(pageRef2);
          
          ApexPages.StandardController Standard_Controller2 = new ApexPages.StandardController(Issue2);
          IssueController myPageCon2 = new IssueController(Standard_Controller2);

          pageRef.getParameters().put('Status__c', 'Closed');
          myPageCon.apexSetOwnerId();
          myPageCon.apexCloseIssue();

          myPageCon.apexReopenIssue();
          myPageCon.apexEscalateIssue();
          myPageCon.apexOnholdIssue();
          
          myPageCon.Email_System_Debug('Test');
          myPageCon.Save();
        }

      }      
    }

    catch(DMLException DE){
      System.debug('IssueTriggerTEST DMLException Line Number: ' + DE.getLineNumber() + '\n' + DE + '\n');
      for (Integer i = 0; i < DE.getNumDml(); i++)         
        System.debug(DE.getDmlMessage(i)); 
    } catch(Exception E){
      System.debug('IssueTriggerTEST Exception Line Number: ' + E.getLineNumber() + '\n' + E + '\n');
    }
  }
  
    
}