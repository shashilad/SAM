global class SetContactAccountId_Cron implements Schedulable{
/*
@author       George Huene 
@date         June 2nd, 2014 (SI-505)
  Schedule this SetContactAccountId_Cron thru Scheduler:
  Setup -> Develop -> Apex Classes -> Schedule Apex
  This Cron will in turn run a Batch Script SetContactAccountId_Batch 

Or, from Developer console, you can schedule this job to run every day from 9AM to 6PM:

String Note    ='      0 0        0-23   1-31          *      1-7 (SUN-SAT) 2014-2100      '+
                'Seconds Minutes  Hours  Day_of_month  Month  Day_of_week   Year(Optional) ';
String Schedule='      0 6        9-18   ?             *      MON-FRI                      '; 
                
SetContactAccountId_Cron ScheduledTask = new SetContactAccountId_Cron();
System.schedule('Scheduled  SetContactAccountId_Cron', Schedule, ScheduledTask);

// Note's for Illustration of how to set the schedule.
// Still have Question? http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm
*/

  global void execute(SchedulableContext SC) 
  { String myTime       = System.now().format('d-MM-yyyy h:mm a');
    Integer ROWS_LIMIT  = 50000;
    Integer NumberOfRows= ROWS_LIMIT;
/*
    AggregateResult Contacts =[SELECT COUNT(ID) FROM Contact 
                           WHERE Account.Name='Unknown' AND JJHCS__C!=null];
    NumberOfRows=(Integer)Contacts.get('expr0');
*/
    if(NumberOfRows<ROWS_LIMIT)
      ROWS_LIMIT=NumberOfRows;
        
    SetContactAccountId_Batch batchApex = new SetContactAccountId_Batch(ROWS_LIMIT);
    System.debug('batchApex=' + batchApex);
    ID batchprocessid = Database.executeBatch(batchApex); 
    System.debug('batchprocessid=' + batchprocessid);
  }
}