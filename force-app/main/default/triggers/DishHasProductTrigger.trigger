trigger DishHasProductTrigger on Dish_has_product__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.run(new DishHasProductTriggerHandler());
}