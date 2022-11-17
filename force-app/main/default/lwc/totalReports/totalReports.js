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
    infos = [];
  
    chart;
    chartFat;
    chartProtein;
    chartCarbs;
    chartjsInitialized = false;
    config={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(217, 217, 217)',
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
    configFat={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(217, 217, 217)',
            'rgb(242, 76, 76)'
        ],
        label:'Fats'
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
    configProtein={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(217, 217, 217)',
            'rgb(242, 76, 76)'
        ],
        label:'Proteins'
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
    configCarbs={
      type : 'doughnut',
      data :{
      datasets :[{
        data: [],
        backgroundColor :[
            'rgb(217, 217, 217)',
            'rgb(242, 76, 76)'
        ],
        label:'Carbohydrates'
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
    loadPromises(){
      Promise.all([
        loadScript(this,chartjs)
      ]).then(() => {
        const ctx = this.template.querySelector('canvas.donut')
        .getContext('2d');
        const ctxFat = this.template.querySelector('canvas.donut2')
        .getContext('2d');
        const ctxProt = this.template.querySelector('canvas.donut3')
        .getContext('2d');
        const ctxCarbs = this.template.querySelector('canvas.donut4')
        .getContext('2d');
        this.chart = new window.Chart(ctx, this.config);
        this.chartFat = new window.Chart(ctxFat, this.configFat);
        this.chartProtein = new window.Chart(ctxProt, this.configProtein);
        this.chartCarbs = new window.Chart(ctxCarbs, this.configCarbs);
      }).then(() => {
        getUserInfoToReports({})
        .then(result => {
          console.log("result: " + result);
            this.infos = result;
            console.log('cos');
            console.log(this.infos);
            this.error = undefined;

            let consumedKcal = JSON.parse(this.summary[0].calories);
            let consumedFat = JSON.parse(this.summary[0].fat);
            let consumedProtein = JSON.parse(this.summary[0].protein);
            let consumedCarbs = JSON.parse(this.summary[0].carbohydrates);
            this.updateChart(consumedKcal, "Consumed", consumedKcal, this.chart);
            this.updateChart((this.infos[0] - consumedKcal).toFixed(0), "To consume", (this.infos[0] - consumedKcal).toFixed(0), this.chart);
            this.updateChart(consumedFat, "Consumed", consumedFat, this.chartFat);
            this.updateChart((this.infos[1] - consumedFat).toFixed(2), "To consume", (this.infos[1] - consumedFat).toFixed(2), this.chartFat);
            this.updateChart(consumedProtein, "Consumed", consumedProtein, this.chartProtein);
            this.updateChart((this.infos[2] - consumedProtein).toFixed(2), "To consume", (this.infos[2] - consumedProtein).toFixed(2), this.chartProtein);
            this.updateChart(consumedCarbs, "Consumed", consumedCarbs, this.chartCarbs);
            this.updateChart((this.infos[3] - consumedCarbs).toFixed(2), "To consume", (this.infos[3] - consumedCarbs).toFixed(2), this.chartCarbs);
          })
        .catch(error => {
            this.error = error;
            this.infos = undefined;
        })
      })
    }
    renderedCallback()
    {
      if(this.chartjsInitialized)
      {
        return;
      }
      this.chartjsInitialized = true;
      this.loadPromises();
    }
    
    updateChart(count,label, value, name)
    {
      name.data.labels.push(label);
      name.data.datasets.forEach((dataset) => {
        dataset.data.push(count);
      });
      console.log(name.data);
      if(value > 0) {
        this.config.data.datasets[0].backgroundColor[1] = 'rgb(2, 214, 45)';
        this.configFat.data.datasets[0].backgroundColor[1] = 'rgb(2, 214, 45)';
        this.configProtein.data.datasets[0].backgroundColor[1] = 'rgb(2, 214, 45)';
        this.configCarbs.data.datasets[0].backgroundColor[1] = 'rgb(2, 214, 45)';
      } else {
        this.config.data.datasets[0].backgroundColor[1] = 'rgb(242, 76, 76)';
        this.configFat.data.datasets[0].backgroundColor[1] = 'rgb(242, 76, 76)';
        this.configProtein.data.datasets[0].backgroundColor[1] = 'rgb(242, 76, 76)';
        this.configCarbs.data.datasets[0].backgroundColor[1] = 'rgb(242, 76, 76)';
      }
      name.update();
    }
    

}



