function raiftalkCtrl($scope){
    var that=this;    
    $scope.config = {
        theme: "light-thick",
        scrollInertia: 500
    };
    this.benefits=[                 
       "Sample Point",
       "Sample Point",
       "Sample Point",
        "Sample Point",
       "Sample Point",
       "Sample Point",
        "Sample Point",
       "Sample Point",
       "Sample Point",
        "Sample Point",
        "Sample Point",
       "Sample Point",
       "Sample Point",
        "Sample Point",
       "Sample Point",
       "Sample Point",
        "Sample Point"      
    ];
    this.clicked=function(number){
        alert(number);
    };
    this.main_menu=["Learn","Teach","Partners","Help","About","Signin","Programs"];
    this.activeOptions=["Learn","Teach","Partners","Help","About","Signin","Programs"] ;   
    this.menu={
       "Learn": {
            "name":"Learn",
            "label":"Learn",
            "onClick":"activateSubMenu",
            "subOptions":["DIY"],
            "isActiveSubGroup":false
        },
       "Teach":{
            "name":"Teach",
            "label":"Teach",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
       "Partners":{
            "name":"Partners",
            "label":"Partners",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "Help":{
            "name":"Help",
            "label":"Help Us",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "About":{
            "name":"About",
            "label":"About",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "Signin":{
            "name":"Signin",
            "label":"Sign In",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },        
        "Programs":{
            "name":"Programs",
            "label":"Programs",
            "onClick":"dual",
            "subOptions":["RWB","RAIFLab","PrimeMovers","RAIFTalks","RAIFEduTours","RAIFExpo","RobotzIndia"],
            "isActiveSubGroup":false
        },
        "RWB":{
            "name":"RWB",
            "label":"RWB",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "RAIFLab":{
            "name":"RAIFLab",
            "label":"RAIF Lab",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "PrimeMovers":{
            "name":"PrimeMovers",
            "label":"Prime Movers",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "RAIFTalks":{
            "name":"RAIFTalks",
            "label":"RAIF Talks",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "RAIFEduTours":{
            "name":"RAIFEduTours",
            "label":"RAIF Educational Tours",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "RAIFExpo":{
            "name":"RAIFExpo",
            "label":"RAIF Expo",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "RobotzIndia":{
            "name":"RobotzIndia",
            "label":"RobotzIndia",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        },
        "DIY":{
            "name":"DIY",
            "label":"Do It Yourself",
            "onClick":"dual",
            "subOptions":[],
            "isActiveSubGroup":false
        }   
    };
    this.toggleSubMenu=function(option){            
        //If option is just selected
        console.log('option');
        if(that.main_menu.indexOf(option)>=0){
            if(!that.menu[option].isActiveSubGroup){            
                console.log('reached');
                console.log(that.activeOptions);
                that.activeOptions=[option];
                console.log(that.activeOptions);
                for(var i=0;i<that.menu[option].subOptions.length;i++){
                    //that.activeOptions.splice(that.activeOptions.indexOf(that.menu[option].subOptions[i]),1);
                    that.activeOptions.push(that.menu[option].subOptions[i]);
                }
                console.log(that.activeOptions);
                that.menu[option].isActiveSubGroup = true;                        
            }else{ //if the option is already activated  
                that.menu[option].isActiveSubGroup = false;                        
                /*for(var i=0;i<that.menu[option].subOptions.length;i++){
                    that.activeOptions.push();
                    that.activeOptions.splice((that.activeOptions.indexOf(option)+(i+1)),0,that.menu[option].subOptions[i])
                }*/
                that.activeOptions = that.main_menu;
            }
        }
    }
}
