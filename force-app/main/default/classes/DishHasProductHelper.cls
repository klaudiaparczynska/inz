public with sharing class DishHasProductHelper {
    
    public static void createCalories(List<Dish_has_product__c> newRecords) {
        Map<Id, Decimal> productsDetails = new Map<Id, Decimal>();
        for(Dish_has_product__c dishHasProduct : newRecords) {
            if(productsDetails.containsKey(dishHasProduct.New_Product__c)) {
                Decimal grammageIncrement = productsDetails.get(dishHasProduct.New_Product__c);
                grammageIncrement += dishHasProduct.Grammage__c;
                productsDetails.put(dishHasProduct.New_Product__c, grammageIncrement);
            } else {
                productsDetails.put(dishHasProduct.New_Product__c, dishHasProduct.Grammage__c);
            }
        }
        System.debug(productsDetails);
        List<New_Product__c> productsToCountCalories = [SELECT Id, Calories__c, Carbohydrates__c, Fat__c, Protein__c FROM New_Product__c WHERE Id IN :productsDetails.keySet()];
        Decimal productCalories = 0;
        Decimal productCarbohydrates = 0;
        Decimal productFat = 0;
        Decimal productProtein = 0;
        for(New_Product__c product : productsToCountCalories) {
            Decimal productGrammage = productsDetails.get(product.Id)/100;
            productCalories += product.Calories__c * productGrammage;
            productCarbohydrates += product.Carbohydrates__c * productGrammage;
            productFat += product.Fat__c * productGrammage;
            productProtein += product.Protein__c * productGrammage;
        }
        Dish__c dish = [SELECT Id, Total_calories__c, Total_carbohydrates__c, Total_fats__c, Total_proteins__c FROM Dish__c WHERE Id =: newRecords[0].Dish__c];
        dish.Total_calories__c = productCalories;
        dish.Total_carbohydrates__c = productCarbohydrates;
        dish.Total_fats__c = productFat;
        dish.Total_proteins__c = productProtein;
        update dish;
    }
}
