public class IssueHistoriesComponentController {
/* 
Notes:  Custom_Object__c's History is Custom_Object__History. Please remember the DOUBLE underscores.
        i.e. Issue__c's history is Issue__History.
*/
  public Id caseId  {get; set;}
  public Id IssueId {get; set;}
  public cHistories[] histories; 

  public Static final Map<String, Schema.SObjectField> IssueFieldmap = Schema.SObjectType.Issue__c.fields.getMap();
  public Static final List<Schema.PicklistEntry> fieldPicklistValues = Issue__History.Field.getDescribe().getPicklistValues();

  public List<cHistories> getHistories(){    
    list<cHistories> histories = new list<cHistories>();
  
    List<Issue__History> IssueHistories=
      [ SELECT CreatedDate, CreatedBy.Name, CreatedBy.Id, Field, NewValue, OldValue 
        FROM Issue__History 
        WHERE ParentId=:IssueId 
        ORDER BY CreatedDate DESC
        LIMIT 8];
    System.debug('IssueHistories: ' + IssueHistories);
    
    
    String prevDate = '';
    for(Issue__History iHistory : IssueHistories){    
      if((iHistory.newValue == null && iHistory.oldValue == null) 
      || (iHistory.newValue != null && !(string.valueOf(iHistory.newValue).startsWith('005') || string.valueOf(iHistory.newValue).startsWith('00G')))
      || (iHistory.oldValue != null && !(string.valueOf(iHistory.oldValue).startsWith('005') || string.valueOf(iHistory.oldValue).startsWith('00G'))))
      
      { cHistories tempHistory = new cHistories();
// Set the Date and who performed the action
        if(String.valueOf(iHistory.CreatedDate) != prevDate){
          //tempHistory.theDate = String.valueOf(iHistory.CreatedDate);
          //tempHistory.theDate = iHistory.CreatedDate;
          String  AM  =' AM';
          Integer Hour=iHistory.CreatedDate.Hour();
          if(Hour>12){
            Hour -=12;
            AM    =' PM';
          }
          tempHistory.theDate = String.valueOf(
              iHistory.CreatedDate.Month()  + '/' + 
              iHistory.CreatedDate.Day()    + '/' + 
              iHistory.CreatedDate.Year()   + ' ' + 
              Hour                          + ':' + 
              iHistory.CreatedDate.Minute() + AM );
          tempHistory.who = iHistory.CreatedBy.Name;
          tempHistory.userId = iHistory.CreatedBy.Id;
        }else{
          tempHistory.theDate = '';
          tempHistory.who = '';
          tempHistory.userId = iHistory.CreatedBy.Id;
        }
        
        prevDate = String.valueOf(iHistory.CreatedDate);

// Get the field label
        String fieldLabel = IssueHistoriesComponentController.returnFieldLabel(String.valueOf(iHistory.Field));

// Set the Action value
        if (String.valueOf(iHistory.Field) == 'created') { // on Creation
        tempHistory.action = 'Created.';
        }
        else if(iHistory.OldValue != null && iHistory.NewValue == null){ // when deleting a value from a field
        // Format the Date and if there's an error, catch it and re
          try {
            tempHistory.action = 'Deleted ' + Date.valueOf(iHistory.OldValue).format() + ' in <b>' + fieldLabel + '</b>.';
          } catch (Exception e){
          tempHistory.action = 'Deleted ' + String.valueOf(iHistory.OldValue) + ' in <b>' + fieldLabel + '</b>.';
          }
        }
        else{ // all other scenarios
          String fromText = '';
          if (iHistory.OldValue != null) {
            try {
              fromText = ' from ' + Date.valueOf(iHistory.OldValue).format();
            } catch (Exception e) {
              fromText = ' from ' + String.valueOf(iHistory.OldValue);
            }
          }

          String toText = '';
          if (iHistory.OldValue != null){
            try{
              toText = Date.valueOf(iHistory.NewValue).format();
            } catch (Exception e) {
              toText = String.valueOf(iHistory.NewValue);
            }
          }
          
          if(toText != '')
            tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
          else
            tempHistory.action = 'Changed <b>' + fieldLabel;
        }

        histories.add(tempHistory);  // Add to the list
      }
    }

    return histories;
  }

  
  // Function to return Field Label of a Issue field given a Field API name
  public Static String returnFieldLabel(String fieldName){
    if(IssueHistoriesComponentController.IssueFieldmap.containsKey(fieldName))
      return IssueHistoriesComponentController.IssueFieldmap.get(fieldName).getDescribe().getLabel();
    else{    
      for(Schema.PicklistEntry pickList : fieldPicklistValues){
        
        if(pickList.getValue() == fieldName){
          if(pickList.getLabel() != null)
            return pickList.getLabel();
          else
            return pickList.getValue();
        }
      }
    }
    return '';
  }


  // Inner Class to store the detail of the case histories  
  public class cHistories{
    public String theDate {get; set;}
    public String who     {get; set;}
    public Id userId      {get; set;} 
    public String action  {get; set;}
  }
  
}