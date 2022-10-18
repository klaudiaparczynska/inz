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
    @api dishes;
    @api mealName;
    @track markers;
    columns=productDetails;
    productsAndDishes;

    connectedCallback(){
        this.showProductsAndDishes();
    }

    showProductsAndDishes(){
        let helper = [];
        if (this.products) {
            for(let i = 0; i < this.products.length; i++) {
                let mealTypeHasProductId = this.products[i].mealTypes.filter(value =>{
                    return value.New_Product__c == this.products[i].id;
                }).map(v => {
                    return v.Id;
                });

                helper.push({
                    Id: this.products[i].id,
                    Name: this.products[i].name,
                    Calories:  this.products[i].calories,
                    Protein: this.products[i].protein,
                    Fat: this.products[i].fat,
                    Carbohydrates: this.products[i].carbohydrates,
                    LinkName : '/' + mealTypeHasProductId[0]
                })
            }
        }
        if (this.dishes) {
            for(let i = 0; i < this.dishes.length; i++) {
                console.log(JSON.stringify(this.dishes[i].mealTypes));
                let mealTypeHasDishId = this.dishes[i].mealTypes.filter(value =>{
                    return value.Dish__c == this.dishes[i].dishId;
                }).map(v=>{
                    return v.Id;
                });

                helper.push({
                    Id: this.dishes[i].dishId,
                    Name: this.dishes[i].name,
                    Calories:  this.dishes[i].calories,
                    Protein: this.dishes[i].protein,
                    Fat: this.dishes[i].fat,
                    Carbohydrates: this.dishes[i].carbohydrates,
                    LinkName : '/' + mealTypeHasDishId[0]
                })
            }  
        }
        this.productsAndDishes = helper;
    }   
}