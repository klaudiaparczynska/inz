@isTest
public with sharing class TestShowActivityLog {
    @TestSetup
    static void makeData(){
        Activity__c activity = new Activity__c();
        activity.Name = 'Football';
        activity.Burned_calories__c = 500;
        insert activity;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'fsd', Email='standard@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='xdd@xdd.com');
        u.Gender__c = 'Male';
        u.Weight__c = 86.5;
        u.Height__c = 181;
        u.PAL__c = 'Moderate physical activity';
        u.Goal__c = 'Keeping weight';
        insert u;
        Activity_log__c act = new Activity_log__c();
        act.Date__c = Date.today();
        act.User__c = u.Id;
        insert act;
        Activity_log_has_activity__c actAct = new Activity_log_has_activity__c();
        actAct.Activity_Log__c = act.Id;
        actAct.Activity__c = activity.Id;
        actAct.Time__c = 30;
        insert actAct;
    }
    @isTest
    static void showActivityTest(){
        showActivityLog.FlowInput aL = new showActivityLog.FlowInput();
        Id actId = [SELECT Id FROM Activity_log__c LIMIT 1].Id;
        aL.activityLog = actId;
        
        
        Test.startTest();
            List<showActivityLog.FlowOutput> results = showActivityLog.activities(new List<showActivityLog.FlowInput>{aL});
            List<Activity> acts = new List<Activity>();
            for(showActivityLog.FlowOutput fo : results){
                for(Activity activ : fo.activities){
                    acts.add(activ);
                }
            }    
        Test.stopTest();
        System.assertEquals(1, acts.size(), 'Bad size');
        System.assertEquals(6, acts[0].activityPoints);
    }
}
