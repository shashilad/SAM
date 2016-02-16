@isTest
private class SalesSummaryPieChartTEST {
    
	private static testMethod void testRemoting() {
	    Account a = new Account(Name = 'Test Account for remoting', JJHCS_Number__c='11223344');
	    insert a;
        list <String> aList = new list<String>();
        aList.add(a.id);
        ApexPages.CurrentPage().getParameters().put('Id',a.Id);
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
        
        SalesSummaryPieChart p= new SalesSummaryPieChart(controller);
        p.getPieData();
        p.changeChartQty();
        p.changeChartAmt();
        p.ListData();
        p.ChartData();
        p.LineListData();
        p.LineChartData();
        p.getSYears();
        p.getEYears();
        p.getSMonths();
        p.getEMonths();
        List<SalesSummaryPieChart.PieWedgeData> pData = SalesSummaryPieChart.getRemotePieData(wedg,mGrp,mjrGrp,mnrGrp,pList,sYear,eYear,aList,sMonth, eMonth);
        List<SalesSummaryPieChart.PieWedgeData> lData = SalesSummaryPieChart.generateLineData(wedg,mGrp,mjrGrp,mnrGrp,pList,sYear,eYear,aList,sMonth, eMonth);

	}
	
	// TODO  : create order/orderitem test data


}