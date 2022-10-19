global with sharing class showActivityLog {
    public class FlowInput{
        @InvocableVariable public Id activityLog;
    }

    public static List<Activity> getActivities(Id activityLogId)
    {
        List<Activity_log_has_activity__c> activityLogs = [SELECT Id, Activity__r.Name, Burned_calories__c, Time__c, Activity_points__c 
        FROM Activity_log_has_activity__c WHERE Activity_Log__c =: activityLogId];
        List<Activity> activities = new List<Activity>();
        for(Activity_log_has_activity__c act : activityLogs){
            Activity activity = new Activity(act.Id, act.Activity__r.Name, act.Burned_calories__C, act.Time__c, act.Activity_points__c);
            activities.add(activity);
        }
        return activities;
    }
    @InvocableMethod(label='Get Activities')
    public static FlowOutput[] activities(List<FlowInput> params){
        FlowOutput[] results = new List<FlowOutput>();
        Id actId = params[0].activityLog;
        List<Activity> acts = getActivities(actId);
        results.add(new FlowOutput(acts));
        return results;
    }
    public class FlowOutput{
        @InvocableVariable public List<Activity> activities;

        public FlowOutput(List<Activity> activities) {
            this.activities = activities;
        }
    }
}
