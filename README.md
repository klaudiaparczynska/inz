# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

Steps necessary to perform to run the application correctly:
To be able to use the application in the Salesforce environment, you must follow the steps below
1. Sign up at https://developer.salesforce.com/signup.
2. Start Visual Studio Code which has the Salesforce Extension Pack plug-in.
3. Install Salesforce CLI on your computer.
4. Open the application project and in the Command Palette enter the Authorize an Org command.
5. Right click on the 'force-app' folder and select SFDX: Deploy source to org.
6. Open your environment and go to Setup.
7. In the permission sets settings, assign a permission set named Edit all/User permission to your user in the Manage Assignments tab.
8. In the Execute Anonymous Window, available in the developer console, execute the following script:

##Run Script

Ranking__c ranking = new Ranking__c();
ranking.Start_date__c = Date.today();
ranking.End_date__c = Date.today().addDays(7);
List<User> usersToRanking = [SELECT Id FROM User];
insert ranking;
List<Ranking_has_user__c> allRankingUsers = new List<Ranking_has_user__c>();
for(User user : usersToRanking){
    Ranking_has_user__c rankingUser = new Ranking_has_user__c();
    rankingUser.Ranking__c = ranking.Id;
    rankingUser.User__c = user.Id;
    allRankingUsers.add(rankingUser);
}
insert allRankingUsers;

9. Import data from .csv files via Salesforce Data Loader available at https://developer.salesforce.com/tools/data-loader.
10. To use the application together with other users, you can also use the link https://softserve36-dev-ed.my.site.com/behealthy/s/
