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
        if (this.activites) {
            for(let i = 0; i < this.activites.length; i++) {

                helper.push({
                    Id: this.activites[i].id,
                    Name: this.activites[i].name,
                    Burned:  this.activites[i].burnedCalories,
                    Time: this.activites[i].activityTime,
                    Points: this.activites[i].activityPoints,
                    LinkName : '/' + this.activites[i].id
                })
            }
        }
        this.activity = helper;
    }
}