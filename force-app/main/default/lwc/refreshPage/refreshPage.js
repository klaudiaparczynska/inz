import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class RefreshPage extends NavigationMixin(LightningElement) {
    reloadPage() {
       window.location.reload();
    }
}