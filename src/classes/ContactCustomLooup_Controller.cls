public with sharing class ContactCustomLooup_Controller {
  public Contact contact {get;set;} // new account to create
  public List<Contact> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string aid{get;set;} // AccountId 
  public string aName {get;set;}
  public ContactCustomLooup_Controller() {
    contact = new Contact();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    aid = System.currentPageReference().getParameters().get('aid');
    contact.AccountId = aid;
    aName = [select name from Account where id=:aId limit 1].Name;
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<Contact> performSearch(string searchString) {

    String soql = 'select id, Name,Title__c,Reference__c,ROLE__c, Email,Phone from Contact where AccountId = :aid ';
    if(searchString != '' && searchString != null)
      soql = soql +  ' AND ( Name LIKE \'%' + searchString +'%\'' 
      			  + ' OR Email like \'%' + searchString + '%\'' 
      			  + ' OR Reference__c like \'%' + searchString + '%\'' 
      			  + ' OR Phone like \'%' + searchString + '%\'' 
      			  + ' OR Role__c like \'%' + searchString + '%\'' 
      			  + ' OR Title__c like \'%' + searchString + '%\' )' ;
   // soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }

  // save the new account record
  public PageReference saveContact() {
    string urlParam = System.currentPageReference().getUrl();
    insert contact;
    // reset the account
    
  	pageReference p = new pageReference(urlParam).setRedirect(true);
    contact = new Contact();
    return p;
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}