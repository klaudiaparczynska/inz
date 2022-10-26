import { LightningElement, api } from 'lwc';
import showProducts from '@salesforce/apex/showProductsInDish.showProducts';

const dishDetails= [
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    }
];
export default class ShowProductsInDish extends LightningElement {
    @api recordId;
    columns = dishDetails;
    prodDish;
    connectedCallback(){
        this.showProducts()
    }
    showProducts(){
        let helper = [];
        showProducts({recordId:this.recordId})
        .then(result => {
            console.log(result);
            for(let i = 0; i < result.length; i++){
                helper.push({
                    Id: result[i].Id,
                    Name: result[i].Name,
                    LinkName : '/' + result[i].Id
                })
            }
            this.prodDish = helper;
        })
        .catch(error => {
            this.error = error;
        })
    }
}