import { LightningElement, api, track } from 'lwc';

export default class PrintMenus extends LightningElement {
    @api products;
    @api dishes;
}