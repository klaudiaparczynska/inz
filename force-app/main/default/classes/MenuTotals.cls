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
}
