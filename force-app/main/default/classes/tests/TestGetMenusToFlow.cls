@isTest
public with sharing class TestGetMenusToFlow {
    @TestSetup
    static void makeData(){
        Ranking__c rank = new Ranking__c();
        rank.Start_date__c = Date.today();
        rank.End_date__c = Date.today().addDays(7);
        insert rank;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'fsd', Email='standard@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='xdd@xdd.com');
        insert u;
        List<Descriptor__c> descriptors = new List<Descriptor__c>();
        Descriptor__c breakfast = new Descriptor__c();
        breakfast.Name = 'Breakfast';
        descriptors.add(breakfast);
        Descriptor__c second = new Descriptor__c();
        second.Name = 'Second breakfast';
        descriptors.add(second);
        Descriptor__c dinner = new Descriptor__c();
        dinner.Name = 'Dinner';
        descriptors.add(dinner);
        Descriptor__c lunch = new Descriptor__c();
        lunch.Name = 'Lunch';
        descriptors.add(lunch);
        Descriptor__c snack = new Descriptor__c();
        snack.Name = 'Snack';
        descriptors.add(snack);
        insert descriptors;
        List<Meal_type__c> mlts = new List<Meal_type__c>();
        for(Descriptor__c dsc: descriptors){
            Meal_type__c mealType = new Meal_type__c();
            mealType.User__c = u.Id;
            mealType.Date__c = Date.today();
            mealType.Descriptor__c = dsc.Id;
            mlts.add(mealType);
        }
        insert mlts;
        New_product__c newProduct = new New_product__c();
        newProduct.Name = 'Big Mac';
        newProduct.Barcode__c = '1234567890123';
        newProduct.Calories__c = 230;
        newProduct.Carbohydrates__c = 50;
        newProduct.Fat__c = 20;
        newProduct.Protein__c = 30;
        insert newProduct;
        Dish__c dish = new Dish__c();
        dish.Name = 'McDonalds';
        insert dish;
        Dish_has_product__c productInDish = new Dish_has_product__c();
        productInDish.Dish__c = dish.Id;
        productInDish.New_Product__c = newProduct.Id;
        productInDish.Grammage__c = 50;
        insert productInDish;
        Meal_type_has_dish__c mealTypeDish = new Meal_type_has_dish__c();
        mealTypeDish.Dish__c = dish.Id;
        mealTypeDish.Grammage__c = 100;
        mealTypeDish.Meal_Type__c = mlts[0].Id;
        insert mealTypeDish;
        Meal_type_has_product__c product = new Meal_type_has_product__c();
        product.New_Product__c = newProduct.Id;
        product.Meal_Type__c = mlts[0].Id;
        product.Grammage__c = 120;
        insert product;
    }
    @isTest
    static void productsTest(){
        getMenusToFlow.FlowInput fi = new getMenusToFlow.FlowInput();
        List<Meal_type__c> mealTypes = [SELECT Id FROM Meal_type__c WHERE Date__c =: Date.today()];
        fi.mealType = mealTypes;
        Test.startTest();
        List<getMenusToFlow.FlowOutput> results = getMenusToFlow.products(new List<getMenusToFlow.FlowInput>{fi});
        List<ProductTest> products = new List<ProductTest>();
        List<Dish> dishes = new List<Dish>();
        for(getMenusToFlow.FlowOutput fo : results){
            for(ProductTest product : fo.breakfastProducts){
                products.add(product);
            }
            for(Dish dish : fo.breakfastDishes){
                dishes.add(dish);
            }
        }
        Test.stopTest();
        System.assertEquals(1, products.size(), 'Bad amount of products');
        System.assertEquals(1, dishes.size(), 'Bad amount of dishes');
    }
}
