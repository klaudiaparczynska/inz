public with sharing class getMenusToFlow {
    public class FlowInput{
        @InvocableVariable public List<Meal_type__c> mealType;
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

        List<Meal_type_has_product__c> breakfasts = [SELECT Id, Name, Meal_Type__c, New_Product__c, Grammage__c FROM Meal_type_has_product__c WHERE Meal_Type__c IN: mealTypes AND Meal_Type__r.Descriptor__r.Name = 'Breakfast'];
        Map<Id, Decimal> breakfastProductsGrammage = new Map<Id, Decimal>();
        for(Meal_type_has_product__c breakfast : breakfasts){
            breakfastProductsGrammage.put(breakfast.New_Product__c, breakfast.Grammage__c);
        }
        Map<Id, New_Product__c> breakfastProducts = new Map<Id, New_Product__c>([SELECT Name, Calories__c, Carbohydrates__c, Fat__c, Protein__c FROM New_Product__c WHERE Id IN: breakfastProductsGrammage.keySet()]);
        Map<String, List<Decimal>> breakfastOutput = new Map<String, List<Decimal>>();
        List<Product> products = new List<Product>();
        for(Id id : breakfastProductsGrammage.keySet()){
            List<Decimal> macros = new List<Decimal>();
            New_Product__c prod = breakfastProducts.get(id);
            Decimal grammage = breakfastProductsGrammage.get(id)/100;
            macros.add(prod.Calories__c*grammage);
            macros.add(prod.Protein__c*grammage);
            macros.add(prod.Fat__c*grammage);
            macros.add(prod.Carbohydrates__c*grammage);
            breakfastOutput.put(prod.Name, macros);
            Product product = new Product(prod.Name, prod.Calories__c*grammage, prod.Protein__c*grammage,
            prod.Fat__c*grammage, prod.Carbohydrates__c*grammage);
            products.add(product);
        }
        system.debug(products);
        results.add(new FlowOutput(products));

        return results;
    }
    
    public class FlowOutput{
        @InvocableVariable public List<Product> mealTypeProductOutput;

        public FlowOutput(List<Product> mealProduct) {
            this.mealTypeProductOutput = mealProduct;
        }
    }
    public class Product{
        @InvocableVariable public String name;
        @InvocableVariable public Decimal calories;
        @InvocableVariable public Decimal protein;
        @InvocableVariable public Decimal fat;
        @InvocableVariable public Decimal carbohydrates;

        public Product(String name, Decimal cal, Decimal prot, Decimal fat, Decimal carbo){
            this.name = name;
            this.calories = cal;
            this.protein = prot;
            this.fat = fat;
            this.carbohydrates = carbo;
        }
    }
}