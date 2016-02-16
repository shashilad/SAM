public class OptimizerBootstrapController{

    public Boolean showJJHCS       {get; set;}
    public Boolean showActivity    {get; set;}
    public Boolean showName        {get; set;}
    public Boolean showMBO         {get; set;}
    public Boolean showMaintenance {get; set;}
    public Boolean showHouse       {get; set;}
    public Boolean showISR         {get; set;}
    public Boolean showNumber      {get; set;}

    public List<Account> accounts  {get; set;}
    public List<Account> account0  {get; set;}
    public List<Account> accounts2 {get; set;}
    public List<Task>    task      {get; set;}
    
    public integer AccountSize  {get; set;}
    public integer Account2Size {get; set;}
    public integer TaskSize     {get; set;}

    public OptimizerBootstrapController(){
        showJJHCS = true; 
        showActivity = true; 
        showName = true; 
        showMBO = true; 
        showMaintenance = true;
        showHouse = true;
        showISR = true;
        showNumber = true;
        
        accounts = [SELECT Name, Type, JJHCS__c, AccountNumber, Activity_Monitor__c, MBO__c,
                    Maintenance__c, House__c, ISR__c FROM Account LIMIT 10]; 
        AccountSize=accounts.size();

        accounts2 = [SELECT Name, Type, JJHCS__c, AccountNumber, Activity_Monitor__c, MBO__c,
                    Maintenance__c, House__c, ISR__c FROM Account LIMIT 6]; 
        Account2Size=accounts2.size();

        account0 = [SELECT Name, Type, JJHCS__c, AccountNumber, Activity_Monitor__c, MBO__c,
                    Maintenance__c, House__c, ISR__c FROM Account WHERE Name='Test Account']; 
                    
        task = [SELECT Id, WhatId, What.Name, WhoId, Who.Name, ActivityDate, Subject FROM Task
                WHERE OwnerId =: userinfo.getUserId() LIMIT 10];
        TaskSize=task.Size();
        
    }

}