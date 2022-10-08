public class scheduleMealType implements Schedulable{
    public static void execute(SchedulableContext sc){
        List<User> users = [SELECT Id, Name FROM User];
        List<Descriptor__c> dsc = [SELECT Name FROM Descriptor__c];
        List<Meal_Type__c> mlt = new List<Meal_Type__c>();
        for(User usr : users){
            for(Descriptor__c d : dsc){
                Meal_Type__c mealType = new Meal_Type__c();
                mealType.User__c = usr.Id;
                mealType.Descriptor__c = d.Id;
                mealType.Date__c = Date.today().addDays(1);
                mealType.Name = String.valueOf(usr.Name) + String.valueOf(Date.today().addDays(1)) + String.valueOf(d.Name);
                mlt.add(mealType);
            }
        }
        insert mlt;
    }
}