global with sharing class getMenusToFlow {
    public class FlowInput{
        @InvocableVariable public List<Meal_type__c> mealType;
    }
    public static List<ProductTest> getProducts(Set<Id> mealTypesIds, String meal){
        List<Meal_type_has_product__c> mealTypeHasProducts = [SELECT Id, Name, Meal_Type__c, New_Product__c, Grammage__c FROM Meal_type_has_product__c WHERE Meal_Type__c IN: mealTypesIds AND Meal_Type__r.Descriptor__r.Name =: meal];
        Map<Id, Decimal> productsAndGrammage = new Map<Id, Decimal>();
        for(Meal_type_has_product__c mlTp : mealTypeHasProducts){
            if(productsAndGrammage.containsKey(mlTp.New_Product__c)){
                Decimal gramm = productsAndGrammage.get(mlTp.New_Product__c);
                Decimal finalGrammage = gramm + mlTp.Grammage__c;
                productsAndGrammage.put(mlTp.New_Product__c, finalGrammage);
            }
            else{
                productsAndGrammage.put(mlTp.New_Product__c, mlTp.Grammage__c);
            }
        }
        Map<Id, New_Product__c> newProducts = new Map<Id, New_Product__c>([SELECT Name, Calories__c, Carbohydrates__c, Fat__c, Protein__c FROM New_Product__c WHERE Id IN: productsAndGrammage.keySet()]);
        Map<String, List<Decimal>> productsOutput = new Map<String, List<Decimal>>();
        List<ProductTest> products = new List<ProductTest>();
        for(Id id : productsAndGrammage.keySet()){
            List<Decimal> macros = new List<Decimal>();
            New_Product__c prod = newProducts.get(id);
            Decimal grammage = productsAndGrammage.get(id)/100;
            macros.add(prod.Calories__c*grammage);
            macros.add(prod.Protein__c*grammage);
            macros.add(prod.Fat__c*grammage);
            macros.add(prod.Carbohydrates__c*grammage);
            productsOutput.put(prod.Name, macros);
            ProductTest product = new ProductTest(prod.Name, prod.Calories__c*grammage, prod.Protein__c*grammage,
            prod.Fat__c*grammage, prod.Carbohydrates__c*grammage);
            products.add(product);
        }
        return products;
    }
    public static List<Dish> getDishes(Set<Id> mealTypesIds, String meal){
        List<Meal_type_has_dish__c> mealTypeHasDishes = [SELECT Id, Name, Meal_Type__c, Dish__c, Grammage__c FROM Meal_type_has_dish__c WHERE Meal_Type__c IN: mealTypesIds AND Meal_Type__r.Descriptor__r.Name =: meal];
        Map<Id, Decimal> dishesAndGrammage = new Map<Id, Decimal>();
        for(Meal_type_has_dish__c mlTp : mealTypeHasDishes){
            if(dishesAndGrammage.containsKey(mlTp.Dish__c)){
                Decimal gramm = dishesAndGrammage.get(mlTp.Dish__c);
                Decimal finalGrammage = gramm + mlTp.Grammage__c;
                dishesAndGrammage.put(mlTp.Dish__c, finalGrammage);
            }
            else{
                dishesAndGrammage.put(mlTp.Dish__c, mlTp.Grammage__c);
            }
        }
        Map<Id, Dish__c> newDishes = new Map<Id, Dish__c>([SELECT Name, Total_calories__c, Total_carbohydrates__c, Total_fats__c, Total_proteins__c FROM Dish__c WHERE Id IN: dishesAndGrammage.keySet()]);
        List<Dish> dishes = new List<Dish>();
        for(Id id : dishesAndGrammage.keySet()){
            List<Decimal> macros = new List<Decimal>();
            Dish__c dsh = newDishes.get(id);
            Decimal grammage = dishesAndGrammage.get(id)/100;
            Dish dish = new Dish(dsh.Name, dsh.Total_calories__c*grammage, dsh.Total_proteins__c*grammage,
            dsh.Total_fats__c*grammage, dsh.Total_carbohydrates__c*grammage);
            dishes.add(dish);
        }
        return dishes;
    }
    @InvocableMethod(label='Get Menu By Flow Variables')
    public static FlowOutput[] products(List<FlowInput> params){
        FlowOutput[] results = new List<FlowOutput>();
        Set<Id> mealTypes = new Set<Id>();
        for(FlowInput input : params){
            for(Meal_type__c meal : input.mealType){
                mealTypes.add(meal.Id);
            }
        }
        List<ProductTest> breakfastProducts = getProducts(mealTypes, 'Breakfast');
        List<ProductTest> secondBreakfastProducts = getProducts(mealTypes, 'Second breakfast');
        List<ProductTest> lunchProducts = getProducts(mealTypes, 'Lunch');
        List<ProductTest> snackProducts = getProducts(mealTypes, 'Snack');
        List<ProductTest> dinnerProducts = getProducts(mealTypes, 'Dinner');
        List<Dish> breakfastDishes = getDishes(mealTypes, 'Breakfast');
        List<Dish> secondBreakfastDishes = getDishes(mealTypes, 'Second breakfast');
        List<Dish> lunchDishes = getDishes(mealTypes, 'Lunch');
        List<Dish> snackDishes = getDishes(mealTypes, 'Snack');
        List<Dish> dinnerDishes = getDishes(mealTypes, 'Dinner');
        results.add(new FlowOutput(breakfastProducts, secondBreakfastProducts, lunchProducts, snackProducts, dinnerProducts, breakfastDishes,
        secondBreakfastDishes, lunchDishes, snackDishes, dinnerDishes));

        return results;
    }
    
    public class FlowOutput{
        @InvocableVariable public List<ProductTest> breakfastProducts;
        @InvocableVariable public List<ProductTest> secondBreakfastProducts;
        @InvocableVariable public List<ProductTest> lunchProducts;
        @InvocableVariable public List<ProductTest> snackProducts;
        @InvocableVariable public List<ProductTest> dinnerProducts;
        @InvocableVariable public List<Dish> breakfastDishes;
        @InvocableVariable public List<Dish> secondBreakfastDishes;
        @InvocableVariable public List<Dish> lunchDishes;
        @InvocableVariable public List<Dish> snackDishes;
        @InvocableVariable public List<Dish> dinnerDishes;

        public FlowOutput(List<ProductTest> breakfast, List<ProductTest> secondBreakfast, List<ProductTest> lunch, List<ProductTest> snack, List<ProductTest> dinner,
        List<Dish> breakfastD, List<Dish> secondBreakfastD, List<Dish> lunchD, List<Dish> snackD, List<Dish> dinnerD) {
            this.breakfastProducts = breakfast;
            this.secondBreakfastProducts = secondBreakfast;
            this.lunchProducts = lunch;
            this.snackProducts = snack;
            this.dinnerProducts = dinner;
            this.breakfastDishes = breakfastD;
            this.secondBreakfastDishes = secondBreakfastD;
            this.lunchDishes = lunchD;
            this.snackDishes = snackD;
            this.dinnerDishes = dinnerD;
        }
    }
}