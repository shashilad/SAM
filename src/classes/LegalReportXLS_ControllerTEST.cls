@isTest
private class LegalReportXLS_ControllerTEST {

    static testMethod void TestController() {
        ApexPages.currentPage().getParameters().put('srcText','abc');
        LegalReportXLS_Controller lrx = new LegalReportXLS_Controller();
    }
}