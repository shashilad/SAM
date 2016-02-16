@isTest
private class InsightSummaryUpdate_ControllerTEST {
    
    static testMethod void TestController() {
        
        // +++++++++++++++++++
        // create data
        // +++++++++++++++++++

        list<Stakeholder_Interview__c> accQiList = new list<Stakeholder_Interview__c>();
        list<Interview_Insight__c>        iiList = new list<Interview_Insight__c>();
        DataForTest                          dft = new DataForTest();
        
        Account acc = dft.getAccount(UtilityCls.getRecordTypeNameToIdMapByObjectName('Account').get('Teradata Account'));
        system.assert(acc != null);
        
        String pName = System.Label.SamACO;
        
        Stakeholder_Interview__c accQi = new Stakeholder_Interview__c (Name = 'Test title',
                                                                       Account_Name__c = acc.id,cDate__c=system.today(), 
                                                                       Profile_Type__c = pName);    
        accQiList.add(accQi);
        insert accQiList;
        
        integer i = 0;
        for(Interview_Insight__c ii : [select Comments__c from Interview_Insight__c where Stakeholder_Interviews__c= :accQi.id]){
            ii.Comments__c = 'This is a sample comment. and number'+i;
            iiList.add(ii);
        }
        update iiList;
        
        system.assert(iiList != null);
        
        system.debug('---------------- iiList --------' + iilist);
        
        Competitive_Account_Consolidation__c c = new Competitive_Account_Consolidation__c
            (Account__c  = acc.Id,
             Name =pName,
             Category__c = 'Cost',
             Consolidated_Notes__c='Do not read me .. I am dummy note');
        
        insert c;
        
        // +++++++++++++++++++
        // create test user and execute as that user
        // +++++++++++++++++++

        User u =  dft.getTestUser('ETH-Sales System Admin');
        system.assert(u != null);
        
        System.RunAs(U){    
            Test.startTest();
            
            PageReference pageRef = Page.InsightSummaryUpdate;
            Test.setCurrentPage(pageRef);
       
            // +++++++++++++++++++
            // testing exception            
            // +++++++++++++++++++

            ApexPages.StandardSetController stdController  = new ApexPages.StandardSetController(accQiList);
            InsightSummaryUpdate_Controller qCls;
            try{
                qCls = new InsightSummaryUpdate_Controller(stdController);
            }catch (exception e){
                system.assert(e.getMessage().contains('Account not found'));
            }
       
       
            // +++++++++++++++++++
            // test positive case 
            // +++++++++++++++++++

            ApexPages.currentPage().getParameters().put('Id', acc.Id);  
            
            qCls            = new InsightSummaryUpdate_Controller(stdController);
            
            qCls.getItems();
            qCls.getCategories();           
            qCls.getRadioItems();
            qCls.getICategories();
            

            // +++++++++++++++++++
            //testing search
            // +++++++++++++++++++

            qCls.profileType = 'All';
            
            qCls.strSearch = 'test';
            qCls.getData();
            system.assert(qCls.interviewInsightList != null);
            
            qCls.strSearch = 'number';
            qCls.getData();
            system.assert(qCls.interviewInsightList != null);
            
            qCls.strSearch = 'Cost';
            qCls.getData();
            system.assert(qCls.interviewInsightList != null);
            


            // +++++++++++++++++++
            // testing edit
            // +++++++++++++++++++

            qCls.doEdit();
            qCls.notesList[0].Consolidated_Notes__c = 'this is sample notes for ALL';
            
            //verify edit is ON
            system.assertEquals(qCls.editOn, true);
            


            // +++++++++++++++++++
            // testing save
            // +++++++++++++++++++

            qCls.doSave();  
            
            system.assert([SELECT Consolidated_Notes__c 
                           FROM Competitive_Account_Consolidation__c 
                           WHERE category__c='All' 
                           AND Account__c  = :acc.Id 
                           AND  Name = 'All' limit 1].Consolidated_Notes__c.CONTAINS('this is sample notes'));
            
            
            // +++++++++++++++++++
            // testing cancel
            // +++++++++++++++++++

            qCls.doEdit();
            qCls.notesList[1].Consolidated_Notes__c = 'this is sample notes for Cost';
            qCls.doCancel();
            
            system.assert([SELECT count() 
                           FROM Competitive_Account_Consolidation__c 
                           WHERE category__c='All' 
                           AND Account__c  = :acc.Id 
                           AND  Name = 'Cost' limit 1] == 0);
            
            
            
            // +++++++++++++++++++
            // testing reset
            // +++++++++++++++++++

            qCls.strSearch = 'sample';
            qCls.doReset();
            system.assert(qCls.strSearch == '');
            
            
            
            // +++++++++++++++++++
            //testing adding categories to summary notes
            // +++++++++++++++++++

            qCls.getICategories();
            qCls.catType=new List<String>{'test1','test2'};
            qCls.goOk();
            
            id recordId = [SELECT Id 
                           FROM Competitive_Account_Consolidation__c 
                           WHERE category__c = 'test1'].id;
            
            system.assert(recordId != null);    
            

            // +++++++++++++++++++
            // testing removing category
            // +++++++++++++++++++

            ApexPages.currentPage().getParameters().put('rId', recordId);   
            qCls.removeCategory();
            system.assertEquals(0, [SELECT count() 
                                    FROM Interview_Insight__c 
                                    WHERE Name = 'test1'] );
            

            // +++++++++++++++++++
            // test adding new category in categorylist
            // +++++++++++++++++++

            qCls.searchCat = 'Training';
            qCls.newCategory();
            system.assert(null != [SELECT Id 
                                   FROM Competitive_Account_Consolidation__c 
                                   WHERE category__c = 'Other - Training']);
            

            // +++++++++++++++++++
            // testing new category duplicate exception
            // +++++++++++++++++++

            qCls.searchCat = 'Training';
            qCls.getICategories();
            try{
                qCls.newCategory();
            }catch (exception e){
                system.assert(e.getMessage().contains('DUPLICATE Insight Category'));
            }    
            
            
            // +++++++++++++++++++
            //testing exception
            // +++++++++++++++++++

            ApexPages.currentPage().getParameters().put('rId', ''); 
            
            try{
                qCls.removeCategory();
            }catch (exception e){
                system.assert(e.getMessage().contains('Error deleting record'));
            }    
            
            
            // +++++++++++++++++++
            // testing selections
            // +++++++++++++++++++

            qCls.selectAll();
            qCls.unSelectAll();
            qCls.setCategory(new String[]{'Cost'});
            String[] s = qCls.getCategory();
            qCls.getData();
            

            // +++++++++++++++++++
            //testing ACO type
            // +++++++++++++++++++

            qCls.profileType=pName;
            qCls.getData();
            
            
            Test.stopTest();
            
            
        }   
    }
}