@isTest
public with sharing class ListProductControllerTest {
    @TestSetup
    static void makeData(){
        Meal_type_has_product__c mealWithProduct = new Meal_type_has_product__c();
        insert mealWithProduct;
        Meal_type_has_dish__c mealWithDish = new Meal_type_has_dish__c();
        insert mealWithDish;
        Dish__c dish = new Dish__c();
        insert dish;
    }

    @isTest
    public static void deleteSelectedMealTypeProductTest() {
        Meal_type_has_product__c meal = [SELECT Id FROM Meal_type_has_product__c LIMIT 1];
        Test.startTest();
        listProductController.deleteSelectedMealType(meal.Id);
        Test.stopTest();
        
        List<Meal_type_has_product__c> resultMeals = [SELECT Id FROM Meal_type_has_product__c];
        List<Meal_type_has_dish__c> mealWithDish = [SELECT Id FROM Meal_type_has_dish__c];
        System.assert(resultMeals.size() != 1, 'Meal should be deleted');
        System.assertEquals(3, Limits.getDmlStatements(), 'Two DMLs should be done - SELECT and DELETE');
        System.assertEquals(0, resultMeals.size(), 'No records should be found');
        System.assertEquals(1, mealWithDish.size(), 'Meal types with dishes shouldnt be deleted');
    }
    @isTest
    public static void deleteSelectedMealTypeDishTest() {
        Meal_type_has_dish__c meal = [SELECT Id FROM Meal_type_has_dish__c LIMIT 1];
        Test.startTest();
        listProductController.deleteSelectedMealType(meal.Id);
        Test.stopTest();
        
        List<Meal_type_has_dish__c> resultMeals = [SELECT Id FROM Meal_type_has_dish__c];
        List<Meal_type_has_product__c> mealWithProduct = [SELECT Id FROM Meal_type_has_product__c];
        System.assertEquals(3, Limits.getDmlStatements(), '3 DMLs should be done - 2x SELECT and DELETE');
        System.assert(resultMeals.size() != 1, 'Meal should be deleted');
        System.assertEquals(0, resultMeals.size(), 'No records should be found');
        System.assertEquals(1, mealWithProduct.size(), 'Meal types with products shouldnt be deleted');
    }
    @isTest
    public static void deleteSelectedMealTypeNegativeTest() {
        Dish__c dish = [SELECT Id FROM Dish__c LIMIT 1];
        Test.startTest();
        listProductController.deleteSelectedMealType(dish.Id);
        Test.stopTest();
        
        List<Meal_type_has_dish__c> resultMeals = [SELECT Id FROM Meal_type_has_dish__c];
        List<Meal_type_has_product__c> mealWithProduct = [SELECT Id FROM Meal_type_has_product__c];
        System.assert(resultMeals.size() > 0, 'Meal should not be deleted');
        System.assertEquals(3, Limits.getDmlStatements(), '3 DMLs should be done');
        System.assertEquals(1, resultMeals.size(), 'No records should be deleted');
        System.assertEquals(1, mealWithProduct.size(), 'Meal types with products shouldnt be deleted');
    }

}
