import { LightningElement, api } from 'lwc';
const rankingDetails= [
    {
        label: 'Position', fieldName: 'Position', cellAttributes:{
            class:{fieldName:'amountColor'}
        }
    },
    {label: 'Name', fieldName: 'Name' , cellAttributes:{
        class:{fieldName:'amountColor'}
    }},
    {label: 'Activity points', fieldName: 'Points', cellAttributes:{
        class:{fieldName:'amountColor'}
    }}
];
export default class ShowRanking extends LightningElement {
    @api rankings;
    columns = rankingDetails; 
    ranking; 
    pageSizeOptions = [5, 10, 25, 50, 75, 100]; 
    totalRecords = 0; 
    pageSize; 
    totalPages; 
    pageNumber = 1;    
    recordsToDisplay = [];
    
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    
    connectedCallback(){
        this.showRanking();
    }

    showRanking(){
        let helper = [];
        if(this.rankings){
            for(let i = 0; i < this.rankings.length; i++){
                helper.push({
                    Id: this.rankings[i].id,
                    Name: this.rankings[i].name,
                    Position:  this.rankings[i].position,
                    Points: this.rankings[i].points
                })
            }
        }
        helper.forEach(currentItem => {
            currentItem.amountColor = currentItem.Position <= 3 ? "slds-text-color_success" : "";
        });
        this.ranking = helper;
        this.totalRecords = this.ranking.length;                 
        this.pageSize = this.pageSizeOptions[0];
        this.paginationHelper();
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }

    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.ranking[i]);
        }
    }
}