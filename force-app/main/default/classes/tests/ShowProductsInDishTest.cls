@isTest
public with sharing class ShowProductsInDishTest {
    @TestSetup
    static void makeData(){
        Dish__c dish = new Dish__c();
        Dish__c dishWithoutProd = new Dish__c(Name='No Products');
        insert new List<Dish__c>{dish, dishWithoutProd};
        Meal_type_has_dish__c mealType = new Meal_type_has_dish__c(Dish__c=dish.Id, Grammage__c=10);
        Meal_type_has_dish__c mealTypeWithoutDish = new Meal_type_has_dish__c(Grammage__c=0);
        insert new List<Meal_type_has_dish__c>{mealType, mealTypeWithoutDish};
        New_Product__c product = new New_Product__c(Barcode__c='1234567890123', Calories__c=50, Carbohydrates__c=5, Fat__c=1, Protein__c=2);
        insert product;
        Dish_has_product__c dish_product = new Dish_has_product__c(New_Product__c=product.Id, Grammage__c=100, Dish__c=dish.Id);
        insert dish_product;
    }
    @isTest
    public static void showProductsTestPositive(){
        Meal_type_has_dish__c mealType = [SELECT Id FROM Meal_type_has_dish__c WHERE Grammage__c=10 LIMIT 1];
        Test.startTest();
        List<New_product__c> result = showProductsInDish.showProducts(mealType.Id);
        Test.stopTest();
        System.assert(result.size() > 0, 'Result list size should be > 0');
        System.assertEquals(1, result.size(), 'Result list size should be exactly 1');
    }
    @isTest
    public static void showProductsTestNegative(){

        Meal_type_has_dish__c mealType = [SELECT Id FROM Meal_type_has_dish__c WHERE Grammage__c=0 LIMIT 1];
        Test.startTest();
        List<New_product__c> result = showProductsInDish.showProducts(mealType.Id);
        Test.stopTest();
        System.assert(result.size() < 1, 'Result list size should be less than 1');
        System.assertEquals(0, result.size(), 'Result list size should be exactly 0');
    }
}
