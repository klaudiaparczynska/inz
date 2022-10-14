public with sharing class DishHasProductTriggerHandler extends TriggerHandler  
{
    public DishHasProductTriggerHandler() 
    {
        super('Dish_has_product__c');
    }
    
    public override void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) 
    {
        DishHasProductHelper.createCalories(newRecords);

    }
    public override void afterUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {

    }
    public override void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {

    }

}
