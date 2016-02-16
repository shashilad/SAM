public class StakeholderInterviewTriggerHelper {

    public static void UpdateInterviewTitle(list<Stakeholder_Interview__c> newInterviews){
        for (Stakeholder_Interview__c si : newInterviews){
			if (si.Contact_Name__c != null) 
                si.Name = si.AccountName__c + ' - ' + si.Profile_Type__c.LEFT(20) +' - ' + si.ContactName__c.LEFT(19);
        }
    }
    public static void GenerateInterviewTitle(list<Stakeholder_Interview__c> newInterviews){
		set<String> accs = new set<String>();

        for (Stakeholder_Interview__c si : newInterviews){
            accs.add(si.Account_Name__c);
        }

        system.debug ('###### Accs ####### ' + accs);
        map <String,Integer> countMap = new map<String,Integer>();
        
        for (AggregateResult ar : [SELECT Account_Name__c,Profile_Type__c,count(id) cnt from Stakeholder_Interview__c 
                                   WHERE EmptyContact__c = true AND Account_Name__c in :accs 
                                   GROUP BY Account_Name__c, Profile_Type__c ]){
           	countMap.put(String.valueOf(ar.get('Account_Name__c'))
                         	+String.valueOf(ar.get('Profile_Type__c')), 
                         Integer.valueOf(ar.get('cnt')) );
                                       
        }
		system.debug('########### countMap #######' + countMap);
        for (Stakeholder_Interview__c i : newInterviews){
            if ( i.Contact_Name__c == null) i.EmptyContact__c = true;
            integer counter = 0;
            try {
			    counter= countMap.get(i.Account_Name__c + i.Profile_Type__c) + 1 ;
            }catch(Exception e){
                counter = 1;
                system.debug(' counter 1 --->' + e);
            }
            i.Name = i.AccountName__c + ' - ' 
                    		+ i.Profile_Type__c.LEFT(20) +' - '
                    			+ (i.Contact_Name__c == null 
	    	                      	?	String.valueOf(counter)
    	    	                  	:	i.ContactName__c.LEFT(19)); 
	        
	        UtilityCls.DebugMessage('Interview Title', i.Name);
        }
    }
	public static void AddInsights(list <Stakeholder_Interview__c> newInterviews){
	
	   list<String> insightCat = new list<string>();
	   list<Interview_Insight__c> iiList = new list<Interview_Insight__c>();
    
       insightCat = System.Label.InsightCategories.split(',');
    
       for(Stakeholder_Interview__c ac : newInterviews){
          
          for(string  s : insightCat){
    
              Interview_Insight__c ii = new Interview_Insight__c();
    
              ii.Name = s;
    
              ii.Stakeholder_Interviews__c = ac.Id;
    
              iiList.add(ii);
          }
    
       }
    
       if (iiList.size()>0) insert iiList;
       
	}
	

}