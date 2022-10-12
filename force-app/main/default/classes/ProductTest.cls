global with sharing class ProductTest{
    @AuraEnabled public String name;
    @AuraEnabled public Decimal calories;
    @AuraEnabled public Decimal protein;
    @AuraEnabled public Decimal fat;
    @AuraEnabled public Decimal carbohydrates;

     public ProductTest(String name, Decimal cal, Decimal prot, Decimal fat, Decimal carbo){
         this.name = name;
         this.calories = cal;
         this.protein = prot;
         this.fat = fat;
         this.carbohydrates = carbo;
     }
 }