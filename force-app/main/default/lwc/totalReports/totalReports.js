import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api, wire } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserInfoToReports from '@salesforce/apex/MenuTotals.getUserInfoToReports';

export default class TotalReports extends LightningElement {
    summary;
    infos;

    connectedCallback() {
        console.log(this.totals); //zeżarte

    }
    @wire(getUserInfoToReports, {}) 
    getDatas({error, data}){
        if(error) {

        }else {
            this.infos = data; //dostępne dla użytkownika na podstawie masy etc
            console.log('---------');
            console.log(this.infos);
            console.log(this.totals);
            this.totals.forEach(element => console.log(element));
            this.totals.forEach(element => console.log(element.calories));
           //this.updateChart(this.totals[0].calories, "Consumed");
           // this.updateChart(this.infos - this.totals[0].calories, "To consume"); 
        }

    }
    @api
    get totals(){
      return this.summary;
    } 
    set totals(value){
      this.summary = value;
      //tu chart
    }
/*
    chart;
    chartjsInitialized = false;
    config={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(41, 52, 98)',
            'rgb(242, 76, 76)',
            'rgb(236, 155, 59)',
            'rgb(247, 215, 22)',
        ],
        label:'Votes'
      }],
      labels:[]
      },
      options: {
          responsive : true,
        legend : {
            position :'right'
        },
        animation:{
          animateScale: true,
          animateRotate : true
        },
      }
    };
  
    renderedCallback()
    {
      if(this.chartjsInitialized)
      {
        return;
      }
      this.chartjsInitialized = true;
      Promise.all([
        loadScript(this,chartjs)
      ]).then(() =>{
        const ctx = this.template.querySelector('canvas.donut')
        .getContext('2d');
        this.chart = new window.Chart(ctx, this.config);
      })
      .catch(error =>{
        this.dispatchEvent(
          new ShowToastEvent({
            title : 'Error loading ChartJS',
            message : error.message,
            variant : 'error',
          }),
        );
      });
    }
    updateChart(count,label)
    {
      this.chart.data.labels.push(label);
      this.chart.data.datasets.forEach((dataset) => {
        dataset.data.push(count);
      });
      this.chart.update();
    }
    */

}



