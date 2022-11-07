@isTest
public with sharing class TestGetRanking {
    @TestSetup
    static void makeData(){
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
        Ranking__c rank = new Ranking__c();
        rank.Name = 'Ranking #1';
        rank.Start_date__c = Date.today();
        rank.End_date__c = Date.today().addDays(7);
        insert rank;
        Ranking_has_user__c userInRank = new Ranking_has_user__c();
        userInRank.User__c = u.Id;
        userInRank.Ranking__c = rank.Id;
        insert userInRank;
    }
    @isTest
    static void getRankingTest(){
        
    }
}
