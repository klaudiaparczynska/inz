global with sharing class getRanking {
    public class FlowInput{
        @InvocableVariable public List<Ranking_has_user__c> rankingHasUser;
    }
    public static List<Ranking> getRanking(Set<Id> ids){
        List<Ranking_has_user__c> rankings = [SELECT Position__c, Activity_points__c, User__r.Name FROM Ranking_has_user__c WHERE Id IN: ids ORDER BY Position__c ASC];
        List<Ranking> finalRanking = new List<Ranking>();
        for(Ranking_has_user__c rnk : rankings){
            Ranking rank = new Ranking(rnk.Id, rnk.Position__c, rnk.Activity_points__c, rnk.User__r.Name);
            finalRanking.add(rank);
        }
        return finalRanking;
    }
    @InvocableMethod(label='Get ranking')
    public static FlowOutput[] users(List<FlowInput> params){
        FlowOutput[] results = new List<FlowOutput>();
        Set<Id> rankingsId = new Set<Id>();
        for(FlowInput input : params){
            for(Ranking_has_user__c rank : input.rankingHasUser){
                rankingsId.add(rank.Id);
            }
        }
        List<Ranking> ranking = getRanking(rankingsId);
        results.add(new FlowOutput(ranking));
        return results;
    }
    public class FlowOutput{
        @InvocableVariable public List<Ranking> rankings;

        public FlowOutput(List<Ranking> rankings){
            this.rankings = rankings;
        }
    }
}
