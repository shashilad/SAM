public class AlignmentHelper {

	public static void RelateAlignmentToAccounts(List<AccountAlignment__c> newAlignments){
	  	
  		set<string> jj = new set<string>();
  		
		
		for(AccountAlignment__c a : newAlignments)
		{
		 	jj.add(a.JJHCS_Number__c);  
		}

		
		map<string, id> acc = new map<string, id>();
		
		for (account ac : [select Id, JJHCS_Number__c from account 
								where RecordType.Name='Teradata Account' 
								and jjhcs_number__c in :jj])
		{
		 	
		 	acc.put(ac.JJHCS_Number__c.trim(), ac.Id);
		    system.debug('###### acc #####'+acc);
		}
		
		for (AccountAlignment__c acl : newAlignments )
		{
			try{
			   acl.AccountId__c = acc.get(acl.JJHCS_Number__c.trim());
			}catch (exception e){
				system.debug ('Could not find the Account for this alignment '+ acl ); 
				acl.AccountId__c    = null;
			}   	
		}	
		
  	}
}