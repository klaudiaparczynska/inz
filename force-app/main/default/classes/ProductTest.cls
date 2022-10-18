global with sharing class ProductTest{
    @AuraEnabled public Id id;
    @AuraEnabled public List<Meal_type_has_product__c> mealTypes;
    @AuraEnabled public String name;
    @AuraEnabled public Decimal calories;
    @AuraEnabled public Decimal protein;
    @AuraEnabled public Decimal fat;
    @AuraEnabled public Decimal carbohydrates;

     public ProductTest(Id id, List<Meal_type_has_product__c> mealTypes, String name, Decimal cal, Decimal prot, Decimal fat, Decimal carbo){
         this.id = id;
         this.mealTypes = mealTypes;
         this.name = name;
         this.calories = cal;
         this.protein = prot;
         this.fat = fat;
         this.carbohydrates = carbo;
     }
 }