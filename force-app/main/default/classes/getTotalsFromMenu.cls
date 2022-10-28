public with sharing class getTotalsFromMenu {
    public class FlowInput{
        @InvocableVariable public Decimal totalCalories;
        @InvocableVariable public Decimal totalProtein;
        @InvocableVariable public Decimal totalFat;
        @InvocableVariable public Decimal totalCarbohydrates;

    }
    @InvocableMethod(label='GetTotals')
    public static FlowOutput[] getTotals(List<FlowInput> input){
        FlowOutput[] results = new List<FlowOutput>();
        List<MenuTotals> menuTotals = new List<MenuTotals>();
        for(FlowInput i : input) {
            MenuTotals mt = new MenuTotals(i.totalCalories, i.totalProtein, i.totalFat, i.totalCarbohydrates);
            menuTotals.add(mt);
        }
        results.add(new FlowOutput(menuTotals));
        return results;
    }

    public class FlowOutput{
        @InvocableVariable public List<MenuTotals> totals;

        public FlowOutput(List<MenuTotals> t) {
            totals = t;
        }
    }
}
