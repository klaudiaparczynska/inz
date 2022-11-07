@isTest
public with sharing class testGetTotalsFromMenu {
    @TestSetup
    static void makeData(){
        Meal_type__c mlt = new Meal_type__c();
        mlt.Total_calories__c = 1500;
        mlt.Total_carbohydrates__c = 200;
        mlt.Total_fats__c = 20;
        mlt.Total_proteins__c = 30;
        insert mlt;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'fsd', Email='standard@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='xdd@xdd.com');
        u.Gender__c = 'Male';
        u.Weight__c = 86.5;
        u.Height__c = 191;
        u.Age__c = 22;
        u.PAL__c = 'Moderate physical activity';
        u.Goal__c = 'Keeping weight';
        insert u;
    }
    @isTest
    static void testData(){
        getTotalsFromMenu.FlowInput fi = new getTotalsFromMenu.FlowInput();
        Meal_type__c mlt = [SELECT Total_calories__c, Total_carbohydrates__c,
        Total_fats__c, Total_proteins__c FROM Meal_type__c LIMIT 1];
        fi.totalCalories = mlt.Total_calories__c;
        fi.totalCarbohydrates = mlt.Total_carbohydrates__c;
        fi.totalFat = mlt.Total_fats__c;
        fi.totalProtein = mlt.Total_proteins__c;
        
        
        Test.startTest();
            Decimal cal = 0;
            List<getTotalsFromMenu.FlowOutput> results = getTotalsFromMenu.getTotals(new List<getTotalsFromMenu.FlowInput>{fi});
            for(getTotalsFromMenu.FlowOutput fo : results){
                for(MenuTotals menu : fo.totals){
                    cal = menu.calories;
                }
            }    
        Test.stopTest();
        
        System.assertEquals(1500, cal, 'Bad calories');
        System.assertEquals(1, results.size(), 'Bad results'); 
    }
    @isTest
    public static void testGetUserInfoToReports(){
        User u = [SELECT Id, Gender__c, Weight__c, Height__c, PAL__c, Goal__c, Total_Calories__c FROM User WHERE UserName = 'xdd@xdd.com'];
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = '0PS7Q000007KgZ8WAK', AssigneeId = u.Id);
        insert psa;
        Double calories = 0;
        Test.startTest();
        System.runAs(u){
                List<Double> macros = MenuTotals.getUserInfoToReports();
                system.debug(macros);
                calories = macros[0];
        }
        Test.stopTest();
        u = [SELECT Id, Gender__c, Weight__c, Height__c, PAL__c, Goal__c, Total_Calories__c FROM User WHERE UserName = 'xdd@xdd.com'];
        system.debug(u);
        System.assertEquals(3297, calories, 'Bad user calories');
    }
}
