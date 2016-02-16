public with sharing class InterviewInsightPDFExport_Controller {
    
    // ++++++++++++++++++++++++++++++++++
    //  members 
    // ++++++++++++++++++++++++++++++++++

    public Account acc 		{get;set;}
    
    public String accId 	{get;set;}
    public String jjhcs 	{get;set;}
    public String sysType 	{get;set;}

	public list<Interview_Insight__c> iiList {get;set;}
	public list<Interview_Insight__c> iList  {get;set;}

    public set<String> catSet {get;set;}

	public map<String,list<Interview_Insight__c>> iiMap {get;set;}


    // ++++++++++++++++++++++++++++++++++
    //  constructor 
    // ++++++++++++++++++++++++++++++++++

	public InterviewInsightPDFExport_Controller(ApexPages.StandardSetController controller) {
		
		accid = ApexPages.currentPage().getParameters().get('Id');

        acc     = [SELECT Name,JJHCS_number__c,IDN_CD__c,RecordType.Name  
                   FROM Account 
                   WHERE id = :accId];
            
  		jjhcs   = (acc.JJHCS_number__c != null
                   ? acc.JJHCS_number__c 
                   : acc.IDN_CD__c);
        
        sysType = (acc.RecordType.Name == 'System Account' 
                   ? 'System' 
                   : 'Customer Account'); 

        
        iiList = [SELECT Name,Comments__c,Stakeholder_Interviews__r.Name,
                  		 Stakeholder_Interviews__r.Profile_Type__c,
                 		 Stakeholder_Interviews__r.cDate__c,
                	 	 Stakeholder_Interviews__r.Contact_Name__r.Name
                  FROM Interview_Insight__c 
                  WHERE Stakeholder_Interviews__r.Account_Name__r.Id = :accId 
                  ORDER BY Name,Stakeholder_Interviews__r.Profile_Type__c ];	


		system.debug('iiList size ----------------> ' + iiList);
        
		catSet 	= new set<String>();
		iiMap   = new map<String,list<Interview_Insight__c>>();

		for(Interview_Insight__c c : iiList){
            
			catSet.add(
                (c.Name.Contains('Other -')  ?  '1'  :  '0')
                + c.Name);
            
		}
         
        transient list<String> catList = new list<String>();
        
        catList.addAll(catSet);
        
        catList.sort();
        
		for (String s : catList){

			iList = new list<Interview_Insight__c>();
			
			for(Interview_Insight__c i : iiList){
                
				if (i.Name.trim() == s.trim().subString(1))
                    
					if (i.Comments__c != null ) ilist.add(i);
                
			}
			
			if (iList.size()>0) iiMap.put(s,iList);	

		}	

	}
}