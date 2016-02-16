/* *************************************************************************************************************************************
      Developed by : Shashi Lad
                On : 1/20/2015
           Purpose : Provide the functionality of drill-down pie-chart using javaScript Remoting
     Related code  : Page: AccountPieChart / OrderPage
                     Objects : Order / OrderItem / Account
************************************************************************************************************************************* */

global class PieChartRemoteController1 {

    // members 
    public Integer sYear {get;set;} 
    public Integer eYear {get;set;} 
    public string wedg {get;set;}
    public Integer sMonth {get;set;} 
    public Integer eMonth {get;set;} 
    public string mGrp {get;set;}
    public string mjrGrp {get;set;}
    public string mnrGrp {get;set;}
    public string pList {get;set;}
    public String sDate {get;set;}
    public String qtyAmt {get;set;}
    public boolean disButton {get;set;}
    public boolean showData {get;set;}
    public boolean showLineData {get;set;}
    public account acc ; 
    public string accId {get;set;}

    // Constructor
    public PieChartRemoteController1(ApexPages.StandardController controller) {
       acc = (Account) controller.getRecord();
       system.debug('@@@@@@@@@ acc controller @@@@@@@@' +acc);
       accId = acc.id;
       system.debug('@@@@@@@@@ accId @@@@@@@@' +acc.id);
    }
  
    public List<PieWedgeData> getPieData() {
        sYear= 2014;
        eYear = 2015;
        sMonth = 1;
        eMonth = 12;
        disButton=false;
        showData=false;
        showLineData= false;
       system.debug('@@@@@@@@@ accId @@@@@@@@ from getpiedata' +accId);
        return PieChartRemoteController1.generatePieData( this.wedg, this.mGrp,this.mjrGrp,this.mnrGrp,this.pList, this.sYear,this.eYear, this.accId, this.sMonth, this.eMonth);
    }
    /* public List<PieWedgeData> getLineData() {
         system.debug('@@@@@@@@@ accId @@@@@@@@ from getLinedata' +accId);
         return PieChartRemoteController1.generateLineData( this.wedg, this.mGrp,this.mjrGrp,this.mnrGrp,this.pList, this.sYear,this.eYear, this.accId);
    }*/

    public List<SelectOption> getSMonth() {
        List<SelectOption> optionList = new List<SelectOption>();
            optionList.add(new SelectOption('01','Jan'));
            optionList.add(new SelectOption('02','Feb'));
            optionList.add(new SelectOption('03','Mar'));
            optionList.add(new SelectOption('04','Apr'));
            optionList.add(new SelectOption('05','May'));
            optionList.add(new SelectOption('06','Jun'));
            optionList.add(new SelectOption('07','Jul'));
            optionList.add(new SelectOption('08','Aug'));
            optionList.add(new SelectOption('09','Sep'));
            optionList.add(new SelectOption('10','Oct'));
            optionList.add(new SelectOption('11','Nov'));
            optionList.add(new SelectOption('12','Dec'));
        return optionList;
    }
    public List<SelectOption> getSYears() {
        List<SelectOption> optionList = new List<SelectOption>();
            optionList.add(new SelectOption('2014','2014'));
            optionList.add(new SelectOption('2015','2015'));
            optionList.add(new SelectOption('2013','2013'));
            optionList.add(new SelectOption('2012','2012'));
            optionList.add(new SelectOption('2011','2011'));
        return optionList;
    }
    public List<SelectOption> getEMonth() {
        List<SelectOption> optionList = new List<SelectOption>();
            optionList.add(new SelectOption('01','Jan'));
            optionList.add(new SelectOption('02','Feb'));
            optionList.add(new SelectOption('03','Mar'));
            optionList.add(new SelectOption('04','Apr'));
            optionList.add(new SelectOption('05','May'));
            optionList.add(new SelectOption('06','Jun'));
            optionList.add(new SelectOption('07','Jul'));
            optionList.add(new SelectOption('08','Aug'));
            optionList.add(new SelectOption('09','Sep'));
            optionList.add(new SelectOption('10','Oct'));
            optionList.add(new SelectOption('11','Nov'));
            optionList.add(new SelectOption('12','Dec'));
        return optionList;
    }
    public List<SelectOption> getEYears() {
        List<SelectOption> optionList = new List<SelectOption>();
            optionList.add(new SelectOption('2015','2015'));
            optionList.add(new SelectOption('2014','2014'));
            optionList.add(new SelectOption('2013','2013'));
            optionList.add(new SelectOption('2012','2012'));
            optionList.add(new SelectOption('2011','2011'));
        return optionList;
    }


    // remote action for pie chart
    @RemoteAction
    global static List<PieWedgeData> getRemotePieData( string w, string mG, string mjrG, string mnrG, string pList, Integer sYr,Integer eYr, string aId, Integer sMn,Integer eMn) {
        return PieChartRemoteController1.generatePieData(w,mG,mjrG,mnrG,pList,sYr,eYr,aId,sMn,eMn);
    }

    // remote action for line chart
    @RemoteAction
    global static List<PieWedgeData> getRemoteLineData( string w, string mG, string mjrG, string mnrG, string pList, Integer sYr,Integer eYr, String aId, Integer sMn,Integer eMn) {
        return PieChartRemoteController1.generateLineData(w,mG,mjrG,mnrG,pList,sYr,eYr,aId,sMn,eMn);
    }

    // data generator for pie chart 
    public static List<PieWedgeData> generatePieData( string w,string mG, string mjrG, string mnrG, string pList, Integer sYr,Integer eYr, String aId, Integer sMn,Integer eMn) {
        List<PieWedgeData> data = new List<PieWedgeData>();
        List<aggregateResult> aggList = new List<aggregateResult>();  
        system.debug('@@@@@@@@@@@@@ account id from generate data@@@@@@@@@@@@ ' + aId);
        date startDate = date.newInstance(sYr, sMn, 1);
        date endDate = date.newInstance(eYr, eMn, 25);
        String qryString = 'SELECT fList, sum(Total_Price__c ) amt, sum(Quantity) qty FROM OrderItem o  where UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate  and o.Order.accountid=:aId GROUP BY ';
        // (UNI_YR__c>=:sYr and MonthNum__c>=:sMn) and (UNI_YR__c<=:eYr and MonthNum__c<=:eMn) and o.Order.accountid=:aId GROUP BY ';
        String havFld = '';
        String fldList ='';
        String grpFldList ='';
        String getValueFld ='';
        system.debug('######### mg '+ mG);
        if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG!=null || mnrG!='') && (pList != null || pList != '')) {
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c,PROD_CD__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c,PROD_CD__c ';
            havFld      = ' HAVING MNR_GRP_NM__c= :mnrG '; 
            getValueFld =  'PROD_CD__c';
        }
        if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG!=null || mnrG!='')&& (pList == null || pList == '')) {
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c ';
            havFld      = ' HAVING MNR_GRP_NM__c= :mnrG '; 
            getValueFld =  'MNR_GRP_NM__c';
        }
        if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG==null || mnrG=='')) {
            fldList     =  'GRP_NM__C,MJR_GRP_NM__c,MNR_GRP_NM__c ';
            grpFldList  =  'GRP_NM__C,mjr_GRP_NM__c,MNR_GRP_NM__c ';
            havFld      = ' HAVING MJR_GRP_NM__c= :mjrG '; 
            getValueFld =  'MNR_GRP_NM__c';
        }
        if ((mG!=null ||  mG!='') && (mjrG==null || mjrG=='') && (mnrG==null || mnrG=='')) {
            fldList     =  'GRP_NM__C, MJR_GRP_NM__c';
            grpFldList  =  'GRP_NM__C, MJR_GRP_NM__c';
            havFld      = ' HAVING GRP_NM__C=:mG'; 
            getValueFld =  'MJR_GRP_NM__c';
        }        
        if ((mG==null || mG=='') && (mjrG==null || mjrG=='') && (mnrG==null || mnrG=='')) {
            fldList     =  'GRP_NM__C';
            grpFldList  =  'GRP_NM__C';
            getValueFld =  'GRP_NM__C';
            havFld ='';
        }        

        qryString = qryString.replace('fList',fldList) + grpFldList + havFld;
        system.debug('@@@@@@@@@ query string @@@@@@@@@' + qryString);

        aggList =  Database.Query(qryString);
        Integer perc=0;
        Integer percQty = 0;
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
    }     
 
    // data generator for line chart
    public static List<PieWedgeData> generateLineData( string w,string mG, string mjrG, string mnrG, string pList, Integer sYr,Integer eYr,String aId, Integer sMn,Integer eMn) {
        List<PieWedgeData> data = new List<PieWedgeData>();
        List<aggregateResult> aggList = new List<aggregateResult>();  
        system.debug('@@@@@@@@@@@@@ account id from line generate data@@@@@@@@@@@@ ' + aId);
        date startDate = date.newInstance(sYr, sMn, 1);
        date endDate = date.newInstance(eYr, eMn, 25);

        String qryString = 'SELECT UNI_DT__c, sum(Total_Price__c ) amt, sum(Quantity) qty FROM OrderItem  wFld GROUP BY UNI_DT__c order by UNI_DT__c DESC ';
        String whereFld = ' ' ;
         if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG!=null || mnrG!='') && (pList != null || pList != '')) {
            whereFld = ' WHERE GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG AND MNR_GRP_NM__c= :mnrG   AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate ' ; 
        }
        if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG!=null || mnrG!='')&& (pList == null || pList == '')) {
            whereFld  = ' WHERE  GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG AND MNR_GRP_NM__c= :mnrG  AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate '; 
        }
        if ((mG != null || mG!='') && (mjrG!=null || mjrG!='') && (mnrG==null || mnrG=='')) {
            whereFld  = ' WHERE GRP_NM__C=:mG AND MJR_GRP_NM__c= :mjrG  AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate '; 
        }
        if ((mG!=null ||  mG!='') && (mjrG==null || mjrG=='') && (mnrG==null || mnrG=='')) {
            whereFld = ' WHERE  GRP_NM__C=:mG  AND UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate '; 
        }        
        if ((mG==null || mG=='') && (mjrG==null || mjrG=='') && (mnrG==null || mnrG=='')) {
            whereFld ='  WHERE UNI_DT__c>=:startDate  and UNI_DT__c<=:endDate ';
        }        
        qryString = qryString.replace('wFld',whereFld + ' and OrderItem.Order.accountid=:aId ' )  ;
        
        system.debug('@@@@@@@@@ query string line chart @@@@@@@@@' + qryString);
        aggList =  Database.Query(qryString);
        for(aggregateResult c: aggList){
        //     string sName = (string)c.get('UNI_YR__c') +'-'+ (String)c.get('UNI_MO_NM__c');
             String sName = String.ValueOf(c.get('UNI_DT__c')).SubString(5,7)+'-'+ String.ValueOf(c.get('UNI_DT__c')).SubString(0,4);
             Decimal sAmt = (decimal)c.get('amt');
             Decimal sQty = (decimal)c.get('qty');
             data.add(new PieWedgeData(sName,sAmt,sQty));
        }
        return data;     
    }     
 
    // render amt/qty button for pie chart  - //TODO : Didn't like CSS while using as class so have to inline css
    public PageReference changeChartQty(){
       // qtyAmt='true';
        disButton = true;
        return null;
    }
    public PageReference changeChartAmt(){
      //  qtyAmt='';
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