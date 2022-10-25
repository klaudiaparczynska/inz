public with sharing class listProductController {
    @AuraEnabled
    public static void deleteSelectedMealType(Id recordIdToDelete) {
        List<Meal_type_has_product__c> productToDelete = [SELECT Id from Meal_type_has_product__c WHERE Id =: recordIdToDelete];
        if(!productToDelete.isEmpty()) {
            delete productToDelete;
        } else {
            List<Meal_type_has_dish__c> dishToDelete = [SELECT Id from Meal_type_has_dish__c WHERE Id =: recordIdToDelete];
            delete dishToDelete;
        }

    }
}
