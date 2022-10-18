import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLinkName from '@salesforce/apex/LinkNameHelper.getMealId';

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
    @track markers;
    columns=productDetails;
    helpProducts;
    listOfProducts;
    show=false;

    showProducts(){
        this.show=true;
        let linkname = [];
        console.log("--------------");
        console.log(this.products);
        console.log(this.products.length);
        if (this.products) {
            console.log('tu');
            let helper = [];
            for(let i = 0; i < this.products.length; i++) {
                console.log(this.products[i].id);
                console.log(this.products[i].name);
                console.log(this.products[i].calories);
                console.log(this.products[i].protein);
                console.log(this.products[i].fat);
                getLinkName({meals: this.products[i].mealTypes, productId: this.products[i].id})
                .then(result =>{
                    linkname=result;
                    console.log('lenght'+linkname.length);
                    console.log('xd'+linkname)
                }).catch(error => {
                    this.error = error;
                });

                helper.push({
                    Id: this.products[i].id,
                    Name: this.products[i].name,
                    Calories:  this.products[i].calories,
                    Protein: this.products[i].protein,
                    Fat: this.products[i].fat,
                    Carbohydrates: this.products[i].carbohydrates,
                    LinkName: '/' + linkname
                })
                console.log(helper);
                
            }
            this.listOfProducts = helper;
            this.helpProducts = helper;
            console.log('------------'+this.listOfProducts);
        }
        }
     
    handleSearchChange( event ) {
        this.searchString = event.detail.value;
    }

    handleSearch( event ) {
        const searchKey = event.target.value.toLowerCase();
        if ( searchKey ) {
            this.listOfProducts = this.helpProducts;   
            if ( this.listOfProducts ) {
                let recs = [];
                for ( let rec of this.listOfProducts ) {
                    let valuesArray = Object.values( rec );
                    for ( let val of valuesArray ) {
                        let strVal = String( val );
                        if ( strVal ) {
                            if ( strVal.toLowerCase().includes( searchKey ) ) {
                                recs.push( rec );
                                break;
                            }
                        }
                    }
                }
                this.listOfProducts = recs;
             }
        }  else {
            this.listOfProducts = this.helpProducts;
        }        
    }
}

