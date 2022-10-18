import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

const productDetails= [
    {
        label: 'Name', fieldName: 'LinkName', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        }
    },
    {label: 'Calories', fieldName: 'Calories'},
    {label: 'Protein', fieldName: 'Protein'},
    {label: 'Fat', fieldName: 'Fat'},
    {label: 'Carbohydrates', fieldName: 'Carbohydrates'},
];


export default class ListProducts extends NavigationMixin(LightningElement) {
    @api products;
    @api mealName;
    @track markers;
    columns=productDetails;
    helpProducts;

    connectedCallback(){
        this.showProducts();
    }

    showProducts(){
        if (this.products) {
            let helper = [];
            
            for(let i = 0; i < this.products.length; i++) {
                let x = this.products[i].mealTypes.filter(value =>{
                    return value.New_Product__c == this.products[i].id;
                }).map(v=>{
                    return v.Id;
                });

                helper.push({
                    Id: this.products[i].id,
                    Name: this.products[i].name,
                    Calories:  this.products[i].calories,
                    Protein: this.products[i].protein,
                    Fat: this.products[i].fat,
                    Carbohydrates: this.products[i].carbohydrates,
                    LinkName : '/' + x[0]
                })
            }
            this.helpProducts = helper;
            this.show=true;
        }
        }       
}