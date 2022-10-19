public with sharing class UserController {
    
    public static void getMacros() {
        Id currntUserId = UserInfo.getUserId();
        return [select Total_Calories__c from User where Id =: currntUserId];
    }
}
