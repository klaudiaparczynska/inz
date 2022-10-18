public with sharing class LinkNameHelper {
    @AuraEnabled(cacheable=true)
    public static Id getMealId(List<Meal_type_has_product__c> meals, Id productId){
        for(Meal_type_has_product__c meal : meals) {
            if(meal.New_Product__c == productId) {
                return meal.Id;
            }
        }
        return null;

    }
        
}
