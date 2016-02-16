public class ObjectivesMBOController{  // Renamed from ObjectivesCV_Controller_v11

  public Objective__c firstObjective        {get; set;}

  // main query results
  public List<Objective__c> salesObjectives {get; set;}
  public List<Objective__c> luiObjectives   {get; set;}

  // passed variables
  public String limitRegion     {get; set;}
  public String limitMBO        {get; set;}

  public String salesDiv        {get; set;}
  public String luiDiv          {get; set;}
  
  // hiding divs
  public String q1SalesVarStyle {get; set;}
  public String q2SalesVarStyle {get; set;}
  public String h1SalesVarStyle {get; set;}
  public String q3SalesVarStyle {get; set;}
  public String q4SalesVarStyle {get; set;}
  public String h2SalesVarStyle {get; set;}

  public String q1LuiVarStyle   {get; set;}
  public String q2LuiVarStyle   {get; set;}
  public String h1LuiVarStyle   {get; set;}
  public String q3LuiVarStyle   {get; set;}
  public String q4LuiVarStyle   {get; set;}
  public String h2LuiVarStyle   {get; set;}

  public String quarter         {get; set;}
  public String q1Div           {get; set;}
  public String q2Div           {get; set;}
  public String h1Div           {get; set;}
  public String q3Div           {get; set;}
  public String q4Div           {get; set;}
  public String h2Div           {get; set;}

  // styled footers
  public String q1Sales         {get; set;}
  public String q1SalesTar      {get; set;}
  public String q1SalesVar      {get; set;}

  public String q2Sales         {get; set;}
  public String q2SalesTar      {get; set;}
  public String q2SalesVar      {get; set;}
  
  public String h1Sales         {get; set;}
  public String h1SalesTar      {get; set;}
  public String h1SalesVar      {get; set;}

  public String q3Sales         {get; set;}
  public String q3SalesTar      {get; set;}
  public String q3SalesVar      {get; set;}

  public String q4Sales         {get; set;}
  public String q4SalesTar      {get; set;}
  public String q4SalesVar      {get; set;}

  public String h2Sales         {get; set;}
  public String h2SalesTar      {get; set;}
  public String h2SalesVar      {get; set;}

  public String q1LuiAct        {get; set;}
  public String q1LuiTar        {get; set;}
  public String q1LuiVar        {get; set;}

  public String q2LuiAct        {get; set;}
  public String q2LuiTar        {get; set;}
  public String q2LuiVar        {get; set;}

  public String h1LuiAct        {get; set;}
  public String h1LuiTar        {get; set;}
  public String h1LuiVar        {get; set;}

  public String q3LuiAct        {get; set;}
  public String q3LuiTar        {get; set;}
  public String q3LuiVar        {get; set;}

  public String q4LuiAct        {get; set;}
  public String q4LuiTar        {get; set;}
  public String q4LuiVar        {get; set;}

  public String h2LuiAct        {get; set;}
  public String h2LuiTar        {get; set;}
  public String h2LuiVar        {get; set;}

  // used for quarters
  public String blankThing      {get; set;}

  // query fields
  private String baseLimit  = ' LIMIT 500';
  
  private String mainFields = 'SELECT Id, Name, MBO__c, Region__c, JJHCS__c, JJHCS_TEMP__c, AccountName__c, Account_Name__c, '+
                              'District_Manager__c, ISR__c, Field_Rep__c, Division__c, Status__c, '+
                              'Master_Objective__c, Objective_Type__c, ';

  private String salesFields= 'Jan__c, Feb__c, Mar__c, fQ1_Sales__c, Q1_Target__c, Q1_Var__c, ' +
                              'Apr__c, May__c, Jun__c, fQ2_Sales__c, Q2_Target__c, Q2_Var__c, ' +
                              'Jul__c, Aug__c, Sep__c, fQ3_Sales__c, Q3_Target__c, Q3_Var__c, ' +
                              'Oct__c, Nov__c, Dec__c, fQ4_Sales__c, Q4_Target__c, Q4_Var__c, ' +
                              'H1_Sales__c, H1_Target__c, H1_Var__c, ' +
                              'H2_Sales__c, H2_Target__c, H2_Var__c ' +
                              'FROM Objective__c WHERE Objective_Type__c = \'Sales\' ';
  
  private String luiFields  = 'fJan_Status__c, fFeb_Status__c, fMar_Status__c, fQ1_Status__c,' +
                              'fApr_Status__c, fMay_Status__c, fJun_Status__c, fQ2_Status__c, Q2_Target__c, Q2_Var__c, ' +
                              'fJul_Status__c, fAug_Status__c, fSep_Status__c, fQ3_Status__c, Q3_Target__c, Q3_Var__c, ' +
                              'fOct_Status__c, fNov_Status__c, fDec_Status__c, fQ4_Status__c, Q4_Target__c, Q4_Var__c ' +
                              'FROM Objective__c WHERE Objective_Type__c IN (\'Lead\',\'Upgrade\',\'Install\') ';

  // Constructor
  public ObjectivesMBOController(){

    System.debug('ObjectivesCV_Controller_v09 Start');

    List<Objective__c> firstObjective = [SELECT Id, Master_Objective__c 
                                         FROM Objective__c 
                                         WHERE Region__c =:'Great Lakes'];
    
    limitMBO = String.valueOf(firstObjective[0].Master_Objective__c);
    quarter  = 'Q1';

    runQuery();
    hideQuarterDivs();

    System.debug('ObjectivesCV_Controller_v09 End');

  }
  
  // Used to hide divs from the controller
  public void hideQuarterDivs(){

    System.debug('hideQuarterDivs Start');
    
    if(quarter == 'Q1'){

      q1Div = 'display:block';
      q2Div = 'display:none';
      q3Div = 'display:none';
      q4Div = 'display:none';
      h1Div = 'display:none';
      h2Div = 'display:none';

    }else if(quarter == 'Q2'){

      q1Div = 'display:none';
      q2Div = 'display:block';
      q3Div = 'display:none';
      q4Div = 'display:none';
      h1Div = 'display:none';
      h2Div = 'display:none';

    }else if(quarter == 'Q3'){

      q1Div = 'display:none';
      q2Div = 'display:none';
      q3Div = 'display:block';
      q4Div = 'display:none';
      h1Div = 'display:none';
      h2Div = 'display:none';

    }else if(quarter == 'Q4'){

      q1Div = 'display:none';
      q2Div = 'display:none';
      q3Div = 'display:none';
      q4Div = 'display:block';
      h1Div = 'display:none';
      h2Div = 'display:none';

    }else if(quarter == 'H1'){

      q1Div = 'display:none';
      q2Div = 'display:none';
      q3Div = 'display:none';
      q4Div = 'display:none';
      h1Div = 'display:block';
      h2Div = 'display:none';
    
    }else if(quarter == 'H2'){

      q1Div = 'display:none';
      q2Div = 'display:none';
      q3Div = 'display:none';
      q4Div = 'display:none';
      h1Div = 'display:none';
      h2Div = 'display:block';  

    }

    System.debug('hideQuarterDivs End');
  }

  // Sort direction defaults to asc
  public String sortDir{get{if(sortDir == null){sortDir = 'asc';} return sortDir;}set;}
    
  // Field to sort by
  public String sortField{get{if(sortField == null){sortField = 'Account_Name__c';} return sortField;}set;}

  // toggle the sort direction
  public void toggleSort(){
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    runQuery();
  }

  // was created to make sure the region variable gets passed on time
  public PageReference regionQuery(){

    System.debug('regionQuery START');

    // grab region value from the page
    String region = Apexpages.currentPage().getParameters().get('regions');
    
    System.debug('region: ' + region);

    // dynamically assign region value to limitRegion
    if(region == 'All Regions'){
      limitRegion = '';
    }else{
      limitRegion = region;
    }

    // build query
    String mboTempQuery = 'SELECT Id, Name FROM Master_Objective__c ';
    String limit1       = ' LIMIT 1';

    // dynamically add region limit
    if(limitRegion != null && limitRegion != ''){

      mboTempQuery += 'WHERE Region__c = \'' + limitRegion + '\' ';
    }

    // adding a limit makes the query faster
    mboTempQuery += limit1;

    System.debug('mboTempQuery: ' + mboTempQuery);

    // send the query
    List<Master_Objective__c> master = Database.query(mboTempQuery);

    // assign limitMBO
    if(!master.isEmpty()){
      limitMBO = String.valueOf(master[0].Id);
    }

    // run the main query
    runQuery();
    
    System.debug('regionQuery END');

    return null;
  }

  // RUNS MAIN QUERIES
  public void runQuery(){

    System.debug('runQuery Start');

    // declarations
    String salesQuery;
    String luiQuery;
    String mboID;

    /* SALES QUERY */
    salesQuery = mainFields + salesFields;

    // conditionally add region limit
    if(limitRegion != null && limitRegion != ''){
    
      salesQuery += ' AND Region__c = \'' + limitRegion + '\' ';
    }

    // mbo limit is always added
    salesQuery += ' AND Master_Objective__c = \'' + limitMBO + '\' ';

    // final query with all added parts
    salesQuery += ' ORDER BY ' + sortField + ' ' + sortDir + baseLimit;

    System.debug('salesQuery: ' + salesQuery);

    // SEND OBJECTIVE QUERY ! ! !
    salesObjectives = Database.query(salesQuery);

    // run MBO query if there are SALES records
    if(!salesObjectives.isEmpty()){

      mboID = salesObjectives[0].Master_Objective__c;
      
      // show the div
      salesDiv = 'display:block';

      // build MBO query
      String mboSalesQuery = 'SELECT ';
      mboSalesQuery += 'Name, Id, ' + 
                       'Q1_Sales__c, Q1_Sales_Target__c, Q1_Sales_Variance__c, ' +
                       'Q2_Sales__c, Q2_Sales_Target__c, Q2_Sales_Variance__c, ' +
                       'Q3_Sales__c, Q3_Sales_Target__c, Q3_Sales_Variance__c, ' +
                       'Q4_Sales__c, Q4_Sales_Target__c, Q4_Sales_Variance__c, ' +
                       'H1_Sales__c, H1_Sales_Target__c, H1_Sales_Variance__c, ' +
                       'H2_Sales__c, H2_Sales_Target__c, H2_Sales_Variance__c ' +
                       'FROM Master_Objective__c WHERE Id =\'' + mboID + '\'';

      System.debug('mboSalesQuery: ' + mboSalesQuery);

      // send the query
      Master_Objective__c tempSales = Database.query(mboSalesQuery);
      
      // send result out for formatting
      SalesMBOFooterFormatStyle(tempSales);

    }else{

      // otherwise, hide this div
      salesDiv = 'display:none';

      // clear strings and formatting
      NoSalesMBO();
    }

    /* LUI QUERY */
    luiQuery  = mainFields + luiFields;

    // conditionally add region limit
    if(limitRegion != null && limitRegion != ''){
      luiQuery += ' AND Region__c = \'' + limitRegion + '\' ';
    }

    // mbo limit is always added
    luiQuery   += ' AND Master_Objective__c = \'' + limitMBO + '\' ';

    // final query with all added parts
    luiQuery   += ' ORDER BY ' + sortField + ' ' + sortDir + baseLimit;

    System.debug('luiQuery: ' + luiQuery);

    // SEND OBJECTIVE QUERY ! ! !
    luiObjectives = Database.query(luiQuery);

    // run MBO query if there are LUI records
    if(!luiObjectives.isEmpty()){

      mboID = luiObjectives[0].Master_Objective__c;

      // show the div
      luiDiv = 'display:block';

      // build MBO query
      String mboLUIQuery = 'SELECT ';
      mboLUIQuery += 'Q1_Status__c, Q1_Target__c, Q1_LUI_Variance__c, ' +
                     'Q2_Status__c, Q2_Target__c, Q2_LUI_Variance__c, ' +
                     'Q3_Status__c, Q3_Target__c, Q3_LUI_Variance__c, ' +
                     'Q4_Status__c, Q4_Target__c, Q4_LUI_Variance__c, ' +
                     'H1_Status__c, H1_Target__c, H1_LUI_Variance__c, ' +
                     'H2_Status__c, H2_Target__c, H2_LUI_Variance__c ' +
                     'FROM Master_Objective__c WHERE Id =\'' + mboID + '\'';

      // send the query
      Master_Objective__c tempLUI = Database.query(mboLUIQuery);

      // send out for formatting
      LUIMBOFooterFormatStyle(tempLUI);

    }else{
      
      // otherwise, hide this div
      luiDiv = 'display:none';

      // clear strings and formatting
      NoLuiMBO();
    }

    System.debug('runQuery End');
  } 

  // SALES Footer string creation and conditional styling
  public void SalesMBOFooterFormatStyle(Master_Objective__c tempSales){

    System.debug('SalesMBOFooterFormatStyle Start');

    // Q1
    Double q1SalesActNum = tempSales.Q1_Sales__c;
    Double q1SalesTarNum = tempSales.Q1_Sales_Target__c;
    Double q1SalesVarNum = tempSales.Q1_Sales_Variance__c;
    // Q2
    Double q2SalesActNum = tempSales.Q2_Sales__c;
    Double q2SalesTarNum = tempSales.Q2_Sales_Target__c;
    Double q2SalesVarNum = tempSales.Q2_Sales_Variance__c;
    // H1
    Double h1SalesActNum = tempSales.H1_Sales__c;
    Double h1SalesTarNum = tempSales.H1_Sales_Target__c;
    Double h1SalesVarNum = tempSales.H1_Sales_Variance__c;
    // Q3
    Double q3SalesActNum = tempSales.Q3_Sales__c;
    Double q3SalesTarNum = tempSales.Q3_Sales_Target__c;
    Double q3SalesVarNum = tempSales.Q3_Sales_Variance__c;
    // Q4
    Double q4SalesActNum = tempSales.Q4_Sales__c;
    Double q4SalesTarNum = tempSales.Q4_Sales_Target__c;
    Double q4SalesVarNum = tempSales.Q4_Sales_Variance__c;
    // H2
    Double h2SalesActNum = tempSales.H2_Sales__c;
    Double h2SalesTarNum = tempSales.H2_Sales_Target__c;
    Double h2SalesVarNum = tempSales.H2_Sales_Variance__c;

    /* ACTUAL */
    // Q1 Actual
    if(q1SalesActNum >= 0){
      q1Sales = '$' + q1SalesActNum.intValue().format();
    }else{
      q1Sales = null;
    }
    // Q2 Actual
    if(q2SalesActNum >= 0){
      q2Sales = '$' + q2SalesActNum.intValue().format();
    }else{
      q2Sales = null;
    }
    // H1 Actual
    if(h1SalesActNum >= 0){
      h1Sales = '$' + h1SalesActNum.intValue().format();
    }else{
      h1Sales = null;
    }
    // Q3 Actual
    if(q3SalesActNum >= 0){
      q3Sales = '$' + q3SalesActNum.intValue().format();
    }else{
      q3Sales = null;
    }
    // Q4 Actual
    if(q4SalesActNum >= 0){
      q4Sales = '$' + q4SalesActNum.intValue().format();
    }else{
      q4Sales = null;
    }
    // H2 Actual
    if(h2SalesActNum >= 0){
      h2Sales = '$' + h2SalesActNum.intValue().format();
    }else{
      h2Sales = null;
    }

    /* TARGET */
    // Q1 Target
    if(q1SalesTarNum >= 0){
      q1SalesTar = '$' + q1SalesTarNum.intValue().format();
    }else{
      q1SalesTar = 'n/a';
    }
    // Q2 Target
    if(q2SalesTarNum >= 0){
      q2SalesTar = '$' + q2SalesTarNum.intValue().format();
    }else{
      q2SalesTar = 'n/a';
    }
    // H1 Target
    if(h1SalesTarNum >= 0){
      h1SalesTar = '$' + h1SalesTarNum.intValue().format();
    }else{
      h1SalesTar = 'n/a';
    }
    // Q3 Target
    if(q3SalesTarNum >= 0){
      q3SalesTar = '$' + q3SalesTarNum.intValue().format();
    }else{
      q3SalesTar = 'n/a';
    }
    // Q4 Target
    if(q4SalesTarNum >= 0){
      q4SalesTar = '$' + q4SalesTarNum.intValue().format();
    }else{
      q4SalesTar = 'n/a';
    }
    // H2 Target
    if(h2SalesTarNum >= 0){
      h2SalesTar = '$' + h2SalesTarNum.intValue().format();
    }else{
      h2SalesTar = 'n/a';
    }

    /* VARIANCE */
    // Q1 Variance
    if(q1SalesVarNum < 0){
      q1SalesVarStyle = 'color:#ef3333';
      q1SalesVar = '($' + q1SalesVarNum.intValue().format() + ')';
      q1SalesVar = q1SalesVar.replace('-', '');
    }else if(q1SalesVarNum > 0){
      q1SalesVarStyle = 'color:#008000';
      q1SalesVar = '$' + q1SalesVarNum.intValue().format();
    }else{
      q1SalesVarStyle = '';
      q1SalesVar = '$0';
    }
    // Q2 Variance
    if(q2SalesVarNum < 0){
      q2SalesVarStyle = 'color:#ef3333';
      q2SalesVar = '($' + q2SalesVarNum.intValue().format() + ')';
      q2SalesVar = q2SalesVar.replace('-', '');
    }else if(q2SalesVarNum > 0){
      q2SalesVarStyle = 'color:#008000';
      q2SalesVar = '$' + q2SalesVarNum.intValue().format();
    }else{
      q2SalesVarStyle = '';
      q2SalesVar = '$0';
    }
    // H1 Variance
    if(h1SalesVarNum < 0){
      h1SalesVarStyle = 'color:#ef3333';
      h1SalesVar = '($' + h1SalesVarNum.intValue().format() + ')';
      h1SalesVar = h1SalesVar.replace('-', '');
    }else if(h1SalesVarNum > 0){
      h1SalesVarStyle = 'color:#008000';
      h1SalesVar = '$' + h1SalesVarNum.intValue().format();
    }else{
      h1SalesVarStyle = '';
      h1SalesVar = '$0';
    }
    // Q3 Variance
    if(q3SalesVarNum < 0){
      q3SalesVarStyle = 'color:#ef3333';
      q3SalesVar = '($' + q3SalesVarNum.intValue().format() + ')';
      q3SalesVar = q3SalesVar.replace('-', '');
    }else if(q3SalesVarNum > 0){
      q3SalesVarStyle = 'color:#008000';
      q3SalesVar = '$' + q3SalesVarNum.intValue().format();
    }else{
      q3SalesVarStyle = '';
      q3SalesVar = '$0';
    }
    // Q4 Variance
    if(q4SalesVarNum < 0){
      q4SalesVarStyle = 'color:#ef3333';
      q4SalesVar = '($' + q4SalesVarNum.intValue().format() + ')';
      q4SalesVar = q4SalesVar.replace('-', '');
    }else if(q4SalesVarNum > 0){
      q4SalesVarStyle = 'color:#008000';
      q4SalesVar = '$' + q4SalesVarNum.intValue().format();
    }else{
      q4SalesVarStyle = '';
      q4SalesVar = '$0';
    }
    // H2 Variance
    if(h2SalesVarNum < 0){
      h2SalesVarStyle = 'color:#ef3333';
      h2SalesVar = '($' + h2SalesVarNum.intValue().format() + ')';
      h2SalesVar = h2SalesVar.replace('-', '');
    }else if(h2SalesVarNum > 0){
      h2SalesVarStyle = 'color:#008000';
      h2SalesVar = '$' + h2SalesVarNum.intValue().format();
    }else{
      h2SalesVarStyle = '';
      h2SalesVar = '$0';
    }

    System.debug('SalesMBOFooterFormatStyle End');
  }

  // Clearing SALES footer strings and conditional styling
  public void NoSalesMBO(){

    System.debug('NoSalesMBO Start');
    
    // SALES ACTUAL
    q1Sales = null;
    q2Sales = null;
    h1Sales = null;
    q3Sales = null;
    q4Sales = null;
    h2Sales = null;
    
    // SALES TARGET
    q1SalesTar = null;
    q2SalesTar = null;
    h1SalesTar = null;
    q3SalesTar = null;
    q4SalesTar = null;
    h2SalesTar = null;

    // SALES VARIANCE
    q1SalesVarStyle = '';
    q1SalesVar      = 'n/a';

    q2SalesVarStyle = '';
    q2SalesVar      = 'n/a';

    h1SalesVarStyle = '';
    h1SalesVar      = 'n/a';
  
    q3SalesVarStyle = '';
    q3SalesVar      = 'n/a';
  
    q4SalesVarStyle = '';
    q4SalesVar      = 'n/a';

    h2SalesVarStyle = '';
    h2SalesVar      = 'n/a';

    System.debug('NoSalesMBO End');
  }

  // LUI Footer string creation and conditional styling
  public void LUIMBOFooterFormatStyle(Master_Objective__c tempLUI){

    System.debug('LUIMBOFooterFormatStyle Start');

    Double q1LuiActNum = tempLUI.Q1_Status__c;
    Double q1LuiTarNum = tempLUI.Q1_Target__c;
    Double q1LuiVarNum = tempLUI.Q1_LUI_Variance__c;

    Double q2LuiActNum = tempLUI.Q2_Status__c;
    Double q2LuiTarNum = tempLUI.Q2_Target__c;    
    Double q2LuiVarNum = tempLUI.Q2_LUI_Variance__c;

    Double h1LuiActNum = tempLUI.H1_Status__c;
    Double h1LuiTarNum = tempLUI.H1_Target__c;
    Double h1LuiVarNum = tempLUI.H1_LUI_Variance__c;

    Double q3LuiActNum = tempLUI.Q3_Status__c;
    Double q3LuiTarNum = tempLUI.Q3_Target__c;
    Double q3LuiVarNum = tempLUI.Q3_LUI_Variance__c;

    Double q4LuiActNum = tempLUI.Q4_Status__c;
    Double q4LuiTarNum = tempLUI.Q4_Target__c;
    Double q4LuiVarNum = tempLUI.Q4_LUI_Variance__c;

    Double h2LuiActNum = tempLUI.H2_Status__c;
    Double h2LuiTarNum = tempLUI.H2_Target__c;
    Double h2LuiVarNum = tempLUI.H2_LUI_Variance__c;

    /* ACTUAL */
    // Q1
    if(q1LuiActNum > 0){
      q1LuiAct = q1LuiActNum.intValue().format();
    }else{
      q1LuiAct = null;
    }
    // Q2
    if(q2LuiActNum > 0){
      q2LuiAct = q2LuiActNum.intValue().format();
    }else{
      q2LuiAct = null;
    }
    // H1
    if(h1LuiActNum > 0){
      h1LuiAct = h1LuiActNum.intValue().format();
    }else{
      h1LuiAct = null;
    }
    // Q3
    if(q3LuiActNum > 0){
      q3LuiAct = q3LuiActNum.intValue().format();
    }else{
      q3LuiAct = null;
    }
    // Q4
    if(q4LuiActNum > 0){
      q4LuiAct = q4LuiActNum.intValue().format();
    }else{
      q4LuiAct = null;
    }
    // H2
    if(h2LuiActNum > 0){
      h2LuiAct = h2LuiActNum.intValue().format();
    }else{
      h2LuiAct = null;
    }

    /* TARGET */
    // Q1
    if(q1LuiTarNum > 0){
      q1LuiTar = q1LuiTarNum.intValue().format();
    }else{
      q1LuiTar = 'n/a';
    }
    // Q2
    if(q2LuiTarNum > 0){
      q2LuiTar = q2LuiTarNum.intValue().format();
    }else{
      q2LuiTar = 'n/a';
    }
    // H2
    if(h1LuiTarNum > 0){
      h1LuiTar = h1LuiTarNum.intValue().format();
    }else{
      h1LuiTar = 'n/a';
    }
    // Q3
    if(q3LuiTarNum > 0){
      q3LuiTar = q3LuiTarNum.intValue().format();
    }else{
      q3LuiTar = 'n/a';
    }
    // Q4
    if(q4LuiTarNum > 0){
      q4LuiTar = q4LuiTarNum.intValue().format();
    }else{
      q4LuiTar = 'n/a';
    }
    // H2
    if(h2LuiTarNum > 0){
      h2LuiTar = h2LuiTarNum.intValue().format();
    }else{
      h2LuiTar = 'n/a';
    }

    /* VARIANCE */
    // Q1
    if(q1LuiVarNum < 0){
      q1LuiVarStyle = 'color:#ef3333';
      q1LuiVar = q1LuiVarNum.intValue().format();
    }else if(q1LuiVarNum > 0){
      q1LuiVarStyle = 'color:#008000';
      q1LuiVar = q1LuiVarNum.intValue().format();
    }else{
      q1LuiVarStyle = '';
      q1LuiVar = 'n/a';
    }
    // Q2
    if(q2LuiVarNum < 0){
      q2LuiVarStyle = 'color:#ef3333';
      q2LuiVar = q2LuiVarNum.intValue().format();
    }else if(q2LuiVarNum > 0){
      q2LuiVarStyle = 'color:#008000';
      q2LuiVar = q2LuiVarNum.intValue().format();
    }else{
      q2LuiVarStyle = '';
      q2LuiVar = 'n/a';
    }
    // H1
    if(h1LuiVarNum < 0){
      h1LuiVarStyle = 'color:#ef3333';
      h1LuiVar = h1LuiVarNum.intValue().format();
    }else if(h1LuiVarNum > 0){
      h1LuiVarStyle = 'color:#008000';
      h1LuiVar = h1LuiVarNum.intValue().format();
    }else{
      h1LuiVarStyle = '';
      h1LuiVar = 'n/a';
    }
    // Q3
    if(q3LuiVarNum < 0){
      q3LuiVarStyle = 'color:#ef3333';
      q3LuiVar = q3LuiVarNum.intValue().format();
      q3LuiVar = q3LuiVar.replace('-', '');
    }else if(q3LuiVarNum > 0){
      q3LuiVarStyle = 'color:#008000';
      q3LuiVar = q3LuiVarNum.intValue().format();
    }else{
      q3LuiVarStyle = '';
      q3LuiVar = 'n/a';
    }
    // Q4
    if(q4LuiVarNum < 0){
      q4LuiVarStyle = 'color:#ef3333';
      q4LuiVar = q4LuiVarNum.intValue().format();
    }else if(q4LuiVarNum > 0){
      q4LuiVarStyle = 'color:#008000';
      q4LuiVar = q4LuiVarNum.intValue().format();
    }else{
      q4LuiVarStyle = '';
      q4LuiVar = 'n/a';
    }
    // H2
    if(h2LuiVarNum < 0){
      h2LuiVarStyle = 'color:#ef3333';
      h2LuiVar = h2LuiVarNum.intValue().format();
    }else if(h2LuiVarNum > 0){
      h2LuiVarStyle = 'color:#008000';
      h2LuiVar = h2LuiVarNum.intValue().format();
    }else{
      h2LuiVarStyle = '';
      h2LuiVar = 'n/a';
    }

    System.debug('LUIMBOFooterFormatStyle End');
  }

  // Clearing LUI footer strings and conditional styling
  public void NoLuiMBO(){

    System.debug('NoLuiMBO Start');
    
    // LUI ACTUAL 
    q1LuiAct = null;
    q2LuiAct = null;
    h1LuiAct = null;
    q3LuiAct = null;
    q4LuiAct = null;
    h2LuiAct = null;

    // LUI TARGET
    q1LuiTar = null;
    q2LuiTar = null;
    h1LuiTar = null;
    q3LuiTar = null;
    q4LuiTar = null;
    h2LuiTar = null;

    // LUI VARIANCE
    q1LuiVarStyle = '';
    q1LuiVar = 'n/a';

    q2LuiVarStyle = '';
    q2LuiVar = 'n/a';

    h1LuiVarStyle = '';
    h1LuiVar = 'n/a';
  
    q3LuiVarStyle = '';
    q3LuiVar = 'n/a';
  
    q4LuiVarStyle = '';
    q4LuiVar = 'n/a';

    h2LuiVarStyle = '';
    h2LuiVar = 'n/a';

    System.debug('NoLuiMBO End');
  }

  // populates period picklist
  public List<SelectOption> getQuarterPicklist(){
    
    List<SelectOption> options = new List<SelectOption>();

    options.add(new SelectOption('Q1', 'Q1'));
    options.add(new SelectOption('Q2', 'Q2'));
    options.add(new SelectOption('Q3', 'Q3'));
    options.add(new SelectOption('Q4', 'Q4'));
    options.add(new SelectOption('H1', 'H1'));
    options.add(new SelectOption('H2', 'H2'));

    return options;
  }

  // populates region picklist from Server
  public List<String> getRegionPickListValues(){
    
    List<String> options = new List<String>();
    
    // pulled through schema to avoid SF Query limits
    Schema.DescribeFieldResult descFieldResult = Master_Objective__c.Region__c.getDescribe();
    List<Schema.PicklistEntry> picklistEntries = descFieldResult.getPicklistValues();

    for(Schema.PicklistEntry f :picklistEntries){
      options.add(f.getLabel());
    }

    return options;
  }

  // Dynamically populates MBO picklist from server
  public List<SelectOption> getMastObjPickListValues(){

    System.debug('getMastObjPickListValues Start');

    // build query
    String mboTempQuery = ' SELECT Name, Id FROM Master_Objective__c ';

    // dynamically limit by region
    if(limitRegion != null && limitRegion != ''){
      mboTempQuery += ' WHERE Region__c = \'' + limitRegion + '\' ';
    }

    System.debug('mboTempQuery: ' + mboTempQuery);
    
    List<SelectOption> options = new List<SelectOption>();

    // send query
    List<Master_Objective__c> temp = Database.query(mboTempQuery);

    System.debug('Picklist Pop limitMBO: ' + limitMBO);

    // loop through results and build select options
    if(!temp.isEmpty()){
      
      limitMBO = String.valueOf(temp[0].Id);
      
      for(Master_Objective__c t: temp){
        options.add(new SelectOption(String.valueOf(t.Id), t.Name));
      }
    }

    System.debug('getMastObjPickListValues End');

    // return the list
    return options;
  }
}