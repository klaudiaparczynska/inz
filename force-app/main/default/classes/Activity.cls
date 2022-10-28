global with sharing class Activity {
    @AuraEnabled public Id id;
    @AuraEnabled public String name;
    @AuraEnabled public Decimal burnedCalories;
    @AuraEnabled public Decimal activityTime;
    @AuraEnabled public Decimal activityPoints;
    public Activity(Id id, String name, Decimal burned, Decimal activityTime, Decimal activityPoints) {
        this.id = id;
        this.name = name;
        this.burnedCalories = burned;
        this.activityTime = activityTime;
        this.activityPoints = activityPoints;
    }
}
