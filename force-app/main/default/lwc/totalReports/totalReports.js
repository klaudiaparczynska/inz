import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api } from 'lwc';

export default class TotalReports extends LightningElement {
    @api totals;

    connectedCallback() {
        console.log(this.totals);

    }
}