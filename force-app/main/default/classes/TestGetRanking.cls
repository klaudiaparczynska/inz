@isTest
public with sharing class TestGetRanking {
    @TestSetup
    static void makeData(){
        Ranking__c rank = new Ranking__c();
        rank.Start_date__c = Date.today();
        rank.End_date__c = Date.today().addDays(7);
        insert rank;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'fsd', Email='standard@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='xdd@xdd.com');
        insert u;
    }
    @isTest
    static void getRankingTest(){
        getRanking.FlowInput rankingInput = new getRanking.FlowInput();
        Ranking__c ranking = [SELECT Id FROM Ranking__c WHERE Start_date__c =: Date.today() LIMIT 1];
        List<Ranking_has_user__c> rankingHasUser = [SELECT Id FROM Ranking_has_user__c WHERE Ranking__c =: ranking.Id];
        rankingInput.rankingHasUser = rankingHasUser;
        Test.startTest();
        List<getRanking.FlowOutput> results = getRanking.users(new List<getRanking.FlowInput>{rankingInput});
        List<Ranking> users = new List<Ranking>();
        for(getRanking.FlowOutput fo : results){
            for(Ranking rnk : fo.rankings){
                users.add(rnk);
            }
        }
        Test.stopTest();
        System.assertEquals(1, results.size(), 'Bad amount of ranking');
    }
}
