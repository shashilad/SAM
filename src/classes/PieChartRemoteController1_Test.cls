@isTest
private class PieChartRemoteController1_Test {
    
	private static testMethod void testRemoting() {
	    Account a = new Account(Name = 'Test Account for remoting', JJHCS_Number__c='11223344');
        ApexPages.StandardController controller = new ApexPages.StandardController (a);
        String wedg ;
        String mGrp ;
        String mjrGrp;
        String mnrGrp;
        String pList;
        Integer sYear=2014;
        Integer eYear=2014;
        String aId;
        Integer sMonth = 1;
        Integer eMonth = 12;
        
        PieChartRemoteController1 p= new PieChartRemoteController1(controller);
        p.getPieData();
        p.changeChartQty();
        p.changeChartAmt();
        p.ListData();
        p.ChartData();
        p.LineListData();
        p.LineChartData();
        p.getSYears();
        p.getEYears();
        p.getSMonth();
        p.getEMonth();
        List<PieChartRemoteController1.PieWedgeData> pData = PieChartRemoteController1.getRemotePieData(wedg,mGrp,mjrGrp,mnrGrp,pList,sYear,eYear,aId,sMonth, eMonth);
        List<PieChartRemoteController1.PieWedgeData> lData = PieChartRemoteController1.generateLineData(wedg,mGrp,mjrGrp,mnrGrp,pList,sYear,eYear,aId,sMonth, eMonth);

	}
	
	// TODO  : create order/orderitem test data


}