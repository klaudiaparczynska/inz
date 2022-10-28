import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api, wire } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserInfoToReports from '@salesforce/apex/MenuTotals.getUserInfoToReports';

export default class TotalReports extends LightningElement {
  summary;  
  error;
  @api get totals(){
    return this.summary;
  }
  set totals(value) {
    this.summary = value;

  }
    infos;

    connectedCallback() {
        console.log(this.totals); //zeżarte
        this.summary = this.totals;
        getUserInfoToReports({})
        .then(result => {
          console.log("result: " + result)
            this.infos = result;
            this.error = undefined;

            let consumedKcal = JSON.parse(this.summary[0].calories);
            this.updateChart(consumedKcal, "Consumed", consumedKcal);
            this.updateChart((this.infos - consumedKcal).toFixed(2), "To consume", (this.infos - consumedKcal).toFixed(2));
            this.renderedCallback();
        })
        .catch(error => {
            this.error = error;
            this.infos = undefined;
        })
  

    }

    
  
    chart;
    chartjsInitialized = false;
    config={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(41, 52, 98)',
            'rgb(242, 76, 76)'
        ],
        label:'Calories'
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
    
    updateChart(count,label, value)
    {
      this.chart.data.labels.push(label);
      this.chart.data.datasets.forEach((dataset) => {
        dataset.data.push(count);
      });
      if(value > 0) {
        this.config.data.datasets[0].backgroundColor[1] = 'rgb(2, 214, 45)';
      } else {
        this.config.data.datasets[0].backgroundColor[1] = 'rgb(242, 76, 76)';
      }
      this.chart.update();
    }
    

}



