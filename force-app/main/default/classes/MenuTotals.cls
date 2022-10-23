public with sharing class MenuTotals {
    @AuraEnabled public Decimal calories;
    @AuraEnabled public Decimal protein;
    @AuraEnabled public Decimal fat;
    @AuraEnabled public Decimal carbohydrates;

     public MenuTotals(Decimal cal, Decimal prot, Decimal fat, Decimal carbo){
         this.calories = cal;
         this.protein = prot;
         this.fat = fat;
         this.carbohydrates = carbo;
     }

     @AuraEnabled(cacheable=true)
     public static Double getUserInfoToReports(){
        List<User> user =  [SELECT Total_Calories__c from User where ID =: UserInfo.getUserId()];
        return user[0].Total_Calories__c;
     }
}
