global with sharing class Dish {
    @AuraEnabled public Id dishId;
    @AuraEnabled public List<Meal_type_has_dish__c> mealTypes;
    @AuraEnabled public String name;
    @AuraEnabled public Decimal calories;
    @AuraEnabled public Decimal protein;
    @AuraEnabled public Decimal fat;
    @AuraEnabled public Decimal carbohydrates;

     public Dish(Id dishId, List<Meal_type_has_dish__c> mealTypes, String name, Decimal cal, Decimal prot, Decimal fat, Decimal carbo){
         this.dishId = dishId;
         this.mealTypes = mealTypes;
         this.name = name;
         this.calories = cal;
         this.protein = prot;
         this.fat = fat;
         this.carbohydrates = carbo;
     }
}