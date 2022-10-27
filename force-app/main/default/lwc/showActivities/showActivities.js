import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

const activityDetails= [
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    },
    {label: 'Burned calories', fieldName: 'Burned'},
    {label: 'Time', fieldName: 'Time'},
    {label: 'Activity points', fieldName: 'Points'}
];

export default class ShowActivities extends NavigationMixin(LightningElement) {
    @api activites;
    @track markers;
    columns=activityDetails;
    activity;

    connectedCallback(){
        this.showActivity();
    }

    showActivity(){
        let helper = [];
        let totalCalories = 0;
        let totalTime = 0;
        let totalPoints = 0;
        if (this.activites) {
            for(let i = 0; i < this.activites.length; i++) {
                totalCalories += this.activites[i].burnedCalories;
                totalTime += this.activites[i].activityTime;
                totalPoints += this.activites[i].activityPoints;
                helper.push({
                    Id: this.activites[i].id,
                    Name: this.activites[i].name,
                    Burned:  this.activites[i].burnedCalories,
                    Time: this.activites[i].activityTime,
                    Points: this.activites[i].activityPoints,
                    LinkName : '/' + this.activites[i].id
                })
            }
            helper.push({
                Id: '',
                Name: 'Total',
                Burned:  totalCalories,
                Time: totalTime,
                Points: totalPoints,
                LinkName : '/'
            })
        }
        console.log(helper);
        this.activity = helper;
    }
}