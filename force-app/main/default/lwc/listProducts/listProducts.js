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
                    Id: mealTypeHasProductId[0],
                    Name: this.products[i].name,
                    Calories:  Number(this.products[i].calories).toFixed(2),
                    Protein: Number(this.products[i].protein).toFixed(2),
                    Fat: Number(this.products[i].fat).toFixed(2),
                    Carbohydrates: Number(this.products[i].carbohydrates).toFixed(2),
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
                    Id: mealTypeHasDishId[0],
                    Name: this.dishes[i].name,
                    Calories:  Number(this.dishes[i].calories).toFixed(2),
                    Protein: Number(this.dishes[i].protein).toFixed(2),
                    Fat: Number(this.dishes[i].fat).toFixed(2),
                    Carbohydrates: Number(this.dishes[i].carbohydrates).toFixed(2),
                    LinkName : '/' + mealTypeHasDishId[0]
                })
            }  
        }
        this.productsAndDishes = helper;
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