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
     public static List<Double> getUserInfoToReports(){
        List<User> user =  [SELECT Total_Calories__c, Total_fat__c, Total_proteins__c, Total_carbohydrates__c from User where ID =: UserInfo.getUserId()];
        List<Double> listMacros = new List<Double>{user[0].Total_Calories__c, user[0].Total_fat__c, user[0].Total_proteins__c, user[0].Total_carbohydrates__c};
        return listMacros;
     }
}
