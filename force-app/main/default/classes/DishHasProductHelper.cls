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
        Map<String, Decimal> macros = new Map<String, Decimal>{'kcal' => 0, 'carbo' => 0, 'fat' => 0, 'protein' => 0, 'gram' => 0};
        for(New_Product__c product : productsToCountCalories) {
            Decimal productGrammage = productsDetails.get(product.Id)/100;
            macros.put('kcal', ( macros.get('kcal') + product.Calories__c * productGrammage));
            macros.put('carbo', ( macros.get('carbo') + product.Carbohydrates__c * productGrammage));
            macros.put('fat', ( macros.get('fat') + product.Fat__c * productGrammage));
            macros.put('protein', ( macros.get('protein') + product.Protein__c * productGrammage));
            macros.put('gram', ( macros.get('gram') + productGrammage));
            
        }
        Dish__c dish = [SELECT Id, Total_calories__c, Total_carbohydrates__c, Total_fats__c, Total_proteins__c FROM Dish__c WHERE Id =: newRecords[0].Dish__c];
        dish.Total_calories__c = macros.get('kcal')/macros.get('gram');
        dish.Total_carbohydrates__c = macros.get('carbo')/macros.get('gram');
        dish.Total_fats__c = macros.get('fat')/macros.get('gram');
        dish.Total_proteins__c = macros.get('protein')/macros.get('gram');
        update dish;
    }
}
