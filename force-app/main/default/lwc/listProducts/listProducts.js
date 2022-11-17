import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {refreshApex} from '@salesforce/apex';
import deleteSelectedMealType from '@salesforce/apex/listProductController.deleteSelectedMealType';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


const actions = [
    { label: 'Delete', name: 'delete' },
];

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
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];


export default class ListProducts extends NavigationMixin(LightningElement) {
    @api products;
    @api dishes;
    @api mealName;
    @track markers;
    @track error;
    columns=productDetails;
    @track productsAndDishes;
    @track finalPD;
    urls = [];


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
                    Id: mealTypeHasProductId[0],
                    Name: this.products[i].name,
                    Calories:  (this.products[i].calories).toFixed(0),
                    Protein: (this.products[i].protein).toFixed(2),
                    Fat: (this.products[i].fat).toFixed(2),
                    Carbohydrates: (this.products[i].carbohydrates).toFixed(2),
                    LinkName : ''
                })
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: mealTypeHasProductId[0],
                        actionName: 'view',
                    },
                }).then((url) => {
                    this.urls.push({
                        Id: mealTypeHasProductId[0],
                        Url: url
                    })
                    if(this.urls.length == this.productsAndDishes.length){
                        console.log(this.urls.length);
                        console.log(this.productsAndDishes.length);
                        this.showLinks();
                    }
                });
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
                    Id: mealTypeHasDishId[0],
                    Name: this.dishes[i].name,
                    Calories:  (this.dishes[i].calories).toFixed(0),
                    Protein: (this.dishes[i].protein).toFixed(2),
                    Fat: (this.dishes[i].fat).toFixed(2),
                    Carbohydrates: (this.dishes[i].carbohydrates).toFixed(2),
                    LinkName : ''
                })
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: mealTypeHasDishId[0],
                        actionName: 'view',
                    },
                }).then((url) => {
                    this.urls.push({
                        Id: mealTypeHasDishId[0],
                        Url: url
                    })
                    if(this.urls.length == this.productsAndDishes.length){
                        console.log(this.urls.length);
                        console.log(this.productsAndDishes.length);
                        this.showLinks();
                    }
                });
            }  
        }
        this.productsAndDishes = helper;
    } 
    showLinks(){
        for(let i = 0; i < this.productsAndDishes.length; i++){
            let u = this.urls.filter(u => u.Id == this.productsAndDishes[i].Id);
            console.log(u);
            if(u){
                this.productsAndDishes[i].LinkName = u[0].Url;
            }
        }
        this.finalPD = this.productsAndDishes;
    }
    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                console.log('ID:' + row.Id);
                this.handleDeleteRow(row.Id);
                break;
            default:
        }
    }

    handleDeleteRow(recordIdToDelete) {
        this.showLoadingSpinner = true;
        deleteSelectedMealType({recordIdToDelete:recordIdToDelete})
        .then(result =>{
            this.showLoadingSpinner = false;
            const evt = new ShowToastEvent({
                title: 'Success Message',
                message: 'Record deleted successfully ',
                variant: 'success',
                mode:'dismissible'
            });
            this.dispatchEvent(evt);
            location.reload();
            return false;
        } )
        .catch(error => {
            this.error = error;
        });

    }
}