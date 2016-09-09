import { Component,AfterViewInit } from '@angular/core';
import {Observable} from 'rxjs/Rx'
@Component({
  selector: 'my-app',
  template: `
    <h1>My First Angular 2 App</h1>
    <input type="text" id="search" value="htc"/>    
  `
})
export class AppComponent implements AfterViewInit { 
    constructor(){
      
    }
    ngAfterViewInit(){
      
      Observable.fromEvent($("#search"),'keyup').map(data=>data['keyCode']).subscribe(data=>console.log(data));
    }
}
