public with sharing class showProductsInDish {
    @AuraEnabled(cacheable = true)
    public static List<New_product__c> showProducts(Id recordId){
        Id dish = [SELECT Dish__r.Id FROM Meal_type_has_dish__c WHERE Id =: recordId LIMIT 1].Dish__c;
        List<Dish_has_product__c> productsInDish = [SELECT Id, New_Product__c, Grammage__c FROM Dish_has_product__c WHERE Dish__c =: dish];
        List<New_product__c> products = new List<New_Product__c>();
        Set<Id> productsId = new Set<Id>();
        for(Dish_has_product__c dishProduct : productsInDish){
            productsId.add(dishProduct.New_Product__c);
        }
        products = [SELECT Name FROM New_Product__c WHERE Id IN: productsId];
        return products;
    }
}
