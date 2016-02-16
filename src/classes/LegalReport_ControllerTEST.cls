@isTest(seeAllData=true)
private class LegalReport_ControllerTEST {

    static testMethod void TestController() {
		LegalReport_Controller lc = new LegalReport_Controller();
		lc.searchStr = 'abc';
		lc.refreshOne();
    }
}