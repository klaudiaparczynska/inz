public class scheduleActivityLog implements Schedulable{
    public static void execute(SchedulableContext sc){
        List<User> users = [SELECT Id, Name FROM User];
        List<Activity_Log__c> activityLogs = new List<Activity_Log__c>();
        for(User usr : users){
            Activity_Log__c alog = new Activity_Log__c();
            alog.User__c = usr.Id;
            alog.Date__c = Date.today().addDays(1);
            activityLogs.add(alog);
        }
        insert activityLogs;
    }
}
/*
scheduleActivityLog alog = new scheduleActivityLog();
String sch = '0 0 0 1/1 * ? *';
System.schedule('Create activity logs', sch, alog);
*/