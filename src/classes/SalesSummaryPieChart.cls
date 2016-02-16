/* *************************************************************************************************************************************
      Developed by : Shashi Lad
                On : 1/20/2015
           Purpose : Provide the functionality of drill-down pie-chart using javaScript Remoting
     Related code  : Page: AccountPieChart / OrderPage
                     Objects : Order / OrderItem / Account
************************************************************************************************************************************* */

global class SalesSummaryPieChart {

    // members 
        public account acc ; 

    public Integer sYear {get;set;} 
    public Integer eYear {get;set;} 
    public Integer sMonth {get;set;} 
    public Integer eMonth {get;set;} 

    public string wedg {get;set;}
    public string mGrp {get;set;}
    public string mjrGrp {get;set;}
    public string mnrGrp {get;set;}
    public string pList {get;set;}
    public String sDate {get;set;}
    public String qtyAmt {get;set;}
    public List<string> accIds {get;set;}
    public string accId {get;set;}
        public String ary {get; set;}
        
        public Integer preserveStartYear {get;set;}
        public Integer preserveStartMonth {get;set;}
        public Integer preserveEndYear {get;set;}
        public Integer preserveEndMonth {get;set;}

    public boolean disButton {get;set;}
    public boolean showData {get;set;}
    public boolean showLineData {get;set;}

    public final list<String> monthList ;
    
    // Constructor
    public SalesSummaryPieChart(ApexPages.StandardController controller) {

        date endDt     = date.today();
        date startDt   = endDt.addMonths(-35);

        sYear  = startDt.Year();
        eYear  = endDt.Year();
        sMonth = startDt.Month();
        eMonth = endDt.Month();
        
            preserveStartYear = sYear;
            preserveStartMonth = sMonth;
            preserveEndYear = eYear;
            preserveEndMonth = eMonth;     
        
            monthList = new list<String>{'','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

                acc = [select id,name,IDN_Type__c from account 
                                        where id = :Apexpages.Currentpage().getParameters().get('Id')];
        
        accIds = new list<string>();
        
        if (acc.IDN_Type__c == 'Idn' || acc.IDN_Type__c =='Coalition'){
                for(account a : [select Id from Account where ParentId = :acc.Id and recordtype.name='Teradata Account' and name!=null ]){
                accIds.add(a.Id);
            }    
        }else{
                accIds.add(acc.Id);
        }
 
        ary = JSON.serialize(accIds);
        
                system.debug('-------------- accIds ---------------' + accIds);
                
    }
  

    public List<PieWedgeData> getPieData() {
        disButton=false;
        showData=false;
        showLineData= false;
        return SalesSummaryPieChart.generatePieData( this.wedg, this.mGrp,this.mjrGrp,this.mnrGrp,this.pList, 
                                                                 this.sYear,this.eYear, this.accIds, this.sMonth, this.eMonth);
    }


    public List<SelectOption> getSMonths() {
        List<SelectOption> optionList = new List<SelectOption>();
            for(integer m=1 ; m<=12 ; m++){
                optionList.add(new SelectOption(String.valueOf(m),monthList[m]));
                }   
        return optionList;
    }
    

    public List<SelectOption> getSYears() {
        List<SelectOption> optionList = new List<SelectOption>();
        for(integer i=eYear ; i>= sYear ; i--){
            optionList.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
                }   
        return optionList;
    }
    
    public List<SelectOption> getEMonths() {
        List<SelectOption> optionList = new List<SelectOption>();

            integer maxMonth = 12;
            integer minMonth = 1;
            
            if(preserveEndYear == eYear)
                        maxMonth = preserveEndMonth;

            for(integer m=minMonth ; m<=maxMonth ; m++){
                optionList.add(new SelectOption(String.valueOf(m),monthList[m]));
                }   

        return optionList;
    }
    

    public List<SelectOption> getEYears() {
        List<SelectOption> optionList = new List<SelectOption>();
        for(integer i=eYear ; i>= sYear ; i--){
            optionList.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
                }   
        return optionList;
    }
    

    // remote action for pie chart
    @RemoteAction
    global static List<PieWedgeData> getRemotePieData( string w, string mG, string mjrG, string mnrG, string pList, 
                                                                                                   Integer sYr,Integer eYr, list<string> aId, Integer sMn,Integer eMn) {
                                                                                                        
        return SalesSummaryPieChart.generatePieData(w,mG,mjrG,mnrG,pList,sYr,eYr,aId,sMn,eMn);
    }


    // remote action for line chart
    @RemoteAction
    global static List<PieWedgeData> getRemoteLineData( string w, string mG, string mjrG, string mnrG, string pList, 
                                                                                                        Integer sYr,Integer eYr, list<string> aId, Integer sMn,Integer eMn) {
                                                                                                                
        return SalesSummaryPieChart.generateLineData(w,mG,mjrG,mnrG,pList,sYr,eYr,aId,sMn,eMn);
    }


    // data generator for pie chart 
    public static List<PieWedgeData> generatePieData( string w,string mG, string mjrG, string mnrG, string pList, 
                                                                                                  Integer sYr,Integer eYr, list<string> aId, Integer sMn,Integer eMn) {
                                                                                                        
        List<PieWedgeData> data = new List<PieWedgeData>();
        List<aggregateResult> aggList = new List<aggregateResult>();  

        date startDate = date.newInstance(sYr, sMn, 1);
        date endDate = date.newInstance(eYr, eMn, 25);

        String qryString = 'SELECT fList, sum(Total_Price__c ) amt, sum(Quantity) qty FROM OrderItem o'  
                                                        + ' WHERE UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate  and o.Order.accountid in :aId GROUP BY ';
        String havFld      = '';
        String fldList     = '';
        String grpFldList  = '';
        String getValueFld = '';
        
        system.debug('----------------  mg ------------- '+ mG);
        
        if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG!=null || mnrG!='') 
                                        && (pList != null || pList != '')) {
                                                
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c,PROD_CD__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c,PROD_CD__c ';
            havFld      = ' HAVING MNR_GRP_NM__c= :mnrG '; 
            getValueFld =  'PROD_CD__c';
            
        }
        
        if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG!=null || mnrG!='')
                                        && (pList == null || pList == '')) {
                                                
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c ';
            havFld      = ' HAVING MNR_GRP_NM__c= :mnrG '; 
            getValueFld =  'MNR_GRP_NM__c';
            
        }
        
        if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG==null || mnrG=='')) {
                                        
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c ';
            havFld      = ' HAVING MJR_GRP_NM__c= :mjrG '; 
            getValueFld =  'MNR_GRP_NM__c';
            
        }
        
        if ((mG!=null ||  mG!='') 
                        && (mjrG==null || mjrG=='') 
                                && (mnrG==null || mnrG=='')) {
                                        
            fldList     =  'GRP_NM__C, MJR_GRP_NM__c';
            grpFldList  =  'GRP_NM__C, MJR_GRP_NM__c';
            havFld      = ' HAVING GRP_NM__C=:mG'; 
            getValueFld =  'MJR_GRP_NM__c';
            
        }
                
        if ((mG==null || mG=='') 
                        && (mjrG==null || mjrG=='') 
                                && (mnrG==null || mnrG=='')) {
                                        
            fldList     =  'GRP_NM__C';
            grpFldList  =  'GRP_NM__C';
            getValueFld =  'GRP_NM__C';
            havFld ='';
            
        }        

        qryString = qryString.replace('fList',fldList) + grpFldList + havFld ;
        
        system.debug('----------------Pie chart - query string -----------------' + qryString);
        
        aggList =  Database.Query(qryString);
        
        system.debug('--------------- Pie chart aggList ------------------------' + aggList.size());
        
        Integer perc     = 0;
        Integer percQty  = 0;
        
        Decimal totalAmt = 0;
        Decimal totalQty = 0;
        
        for(aggregateResult p: aggList){
            totalAmt += (decimal)p.get('amt') ;
            totalQty += (decimal)p.get('qty');
        }
            
        for(aggregateResult c: aggList){
        
             string sName = (string)c.get(getValueFld);
        
             Decimal sAmt = (decimal)c.get('amt');
             Decimal sQty = (decimal)c.get('qty');
        
             if (totalAmt != 0) {
                 perc = 0;
                 Decimal d = sAmt*100 / totalAmt;  
                 perc = (d.round(System.RoundingMode.CEILING)).intValue();
             }    
        
             if (totalQty != 0) {
                 percQty = 0;
                 Decimal d = sQty*100 / totalQty;  
                 percQty = (d.round(System.RoundingMode.CEILING)).intValue();
             }                 
        
             sName += '*' +String.valueOf(perc)+ '*' +String.valueOf(percQty);
        
             data.add(new PieWedgeData(sName,sAmt,sQty));
              
        }
        
        return data;
    }     // end of generatePieData
 
    // data generator for line chart
    public static List<PieWedgeData> generateLineData( string w,string mG, string mjrG, string mnrG, string pList, 
                                                                                                   Integer sYr,Integer eYr,list<string> aId, Integer sMn,Integer eMn) {
                                                                                                        
        List<PieWedgeData> data       = new List<PieWedgeData>();
        List<aggregateResult> aggList = new List<aggregateResult>();
          
        system.debug('--------------- Account id from line generate data --------------- ' + aId);
        
        date startDate = date.newInstance(sYr, sMn, 1);
        date endDate = date.newInstance(eYr, eMn, 25);

        String qryString = 'SELECT UNI_DT__c, sum(Total_Price__c ) amt, sum(Quantity) qty FROM OrderItem  '
                                                        + ' wFld GROUP BY UNI_DT__c order by UNI_DT__c DESC ';
        String whereFld = ' ' ;
        
         if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG!=null || mnrG!='') 
                                        && (pList != null || pList != '')) {
                                                
            whereFld = ' WHERE GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG AND MNR_GRP_NM__c= :mnrG '
                                        + '  AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate ' ;
             
        }
        
        if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG!=null || mnrG!='')
                                        && (pList == null || pList == '')) {
                                                
            whereFld  = ' WHERE  GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG AND MNR_GRP_NM__c= :mnrG ' 
                                        + ' AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate ';
                                         
        }
        
        if ((mG != null || mG!='') 
                        && (mjrG!=null || mjrG!='') 
                                && (mnrG==null || mnrG=='')) {
                                                
            whereFld  = ' WHERE GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG  ' 
                                        + ' AND UNI_DT__c>=:startDate  AND UNI_DT__c<=:endDate '; 
        }
        
        if ((mG!=null ||  mG!='') 
                        && (mjrG==null || mjrG=='') 
                                && (mnrG==null || mnrG=='')) {
                                        
            whereFld = ' WHERE  GRP_NM__C=:mG  AND UNI_DT__c>=:startDate  AND UNI_DT__c<=:endDate ';
             
        }        
        
        if ((mG==null || mG=='') 
                        && (mjrG==null || mjrG=='') 
                                && (mnrG==null || mnrG=='')) {
                                        
            whereFld ='  WHERE UNI_DT__c>=:startDate  AND UNI_DT__c<=:endDate ';
            
        }   
             
        qryString = qryString.replace('wFld',whereFld + ' AND OrderItem.Order.accountid in :aId ' )  ;
        
        system.debug('------------------ Line Chart - Query String  ------------------' + qryString);
        
        aggList =  Database.Query(qryString);
        
        system.debug('--------------- Line chart aggList ------------------------' + aggList.size());

        for(aggregateResult c: aggList){
             String sName = String.ValueOf(c.get('UNI_DT__c')).SubString(5,7) + '-'
                                                + String.ValueOf(c.get('UNI_DT__c')).SubString(0,4);
        
             Decimal sAmt = (decimal)c.get('amt');
             Decimal sQty = (decimal)c.get('qty');
        
             data.add(new PieWedgeData(sName,sAmt,sQty));
        }
        
        return data;     
    } // end of generateLineData
 
 
    // render amt/qty button for pie chart  - //TODO : Didn't like CSS while using as class so have to inline css
    public PageReference changeChartQty(){
        disButton = true;
        return null;
    }
 
 
    public PageReference changeChartAmt(){
        disButton= false;
        return null;
    }
    
 
    // render list/chart button for pie chart
    public PageReference ListData(){
        showData= true;
        return null;
    }
 
 
    public PageReference ChartData(){
        showData= false;
        return null;
    }
 
 
     // render list/chart button for Line chart
    public PageReference LineListData(){
        showLineData= true;
        return null;
    }
 
 
    public PageReference LineChartData(){
        showLineData= false;
        return null;
    }
     
 
    // Wrapper class
    global class PieWedgeData {
 
        public String name { get; set; }
 
        public decimal data { get; set; }
        public decimal qty {get; set;}
 
        public PieWedgeData(String name, decimal data, decimal qty) {
            this.name = name;
            this.data = data;
            this.qty = qty;
        }
 
    }
 
}