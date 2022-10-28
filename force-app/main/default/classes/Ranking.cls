public with sharing class Ranking {
    @AuraEnabled public Id id;
    @AuraEnabled public Decimal position;
    @AuraEnabled public Decimal points;
    @AuraEnabled public String name;
    public Ranking(Id id, Decimal pos, Decimal points, String name) {
        this.id = id;
        this.position = pos;
        this.points = points;
        this.name = name;
        
    }
}
