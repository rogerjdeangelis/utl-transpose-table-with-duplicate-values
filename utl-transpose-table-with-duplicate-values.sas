Transpose table with duplicate values                                                           
                                                                                                
   Two Solutions                                                                                
                                                                                                
       a. Single datastep  (prefered solution)                                                  
          Novinosrin profile                                                                    
          https://communities.sas.com/t5/user/viewprofilepage/user-id/138205                    
                                                                                                
       b. proc means with stackods to untranspose then merge                                    
                                                                                                
                                                                                                
github                                                                                          
https://tinyurl.com/y6mdgb2v                                                                    
https://github.com/rogerjdeangelis/utl-transpose-table-with-duplicate-values                    
                                                                                                
SAS Forum                                                                                       
https://tinyurl.com/y5vmwlz4                                                                    
https://communities.sas.com/t5/SAS-Procedures/Transpose-Question/m-p/583993                     
                                                                                                
*_                   _                                                                          
(_)_ __  _ __  _   _| |_                                                                        
| | '_ \| '_ \| | | | __|                                                                       
| | | | | |_) | |_| | |_                                                                        
|_|_| |_| .__/ \__,_|\__|                                                                       
        |_|                                                                                     
;                                                                                               
                                                                                                
data have;                                                                                      
   input ID Unit O1 O2 O3;                                                                      
cards4;                                                                                         
1 1 2 1 3                                                                                       
1 2 2 1 3                                                                                       
1 3 2 1 3                                                                                       
2 1 2 4 .                                                                                       
2 3 2 4 .                                                                                       
;;;;                                                                                            
run;quit;                                                                                       
                                                                                                
                                                                                                
WORK.HAVE total obs=5                                                                           
                                                                                                
Obs    ID    UNIT    O1    O2    O3                                                             
                                                                                                
 1      1      1      2     1     3  * transpose o1-o3 once                                     
 2      1      2      2     1     3                                                             
 3      1      3      2     1     3                                                             
                                                                                                
 4      2      1      2     4     .                                                             
 5      2      3      2     4     .                                                             
                                                                                                
*           _                                                                                   
 _ __ _   _| | ___  ___                                                                         
| '__| | | | |/ _ \/ __|                                                                        
| |  | |_| | |  __/\__ \                                                                        
|_|   \__,_|_|\___||___/                                                                        
                                                                                                
;                                                                                               
  1. proc means for o1, o2 and o3 with stackods                                                 
                                                                                                
    ID    VARIABLE    N    MEAN                                                                 
                                                                                                
     1       O1       1      2   ** same as transpose because of dups                           
     1       O2       1      1                                                                  
     1       O3       1      3                                                                  
     2       O1       1      2                                                                  
     2       O2       1      4                                                                  
     2       O3       0      .                                                                  
                                                                                                
  3. merge with have without by                                                                 
                                                                                                
      ID    UNIT    MEAN                                                                        
                                                                                                
       1      1       2                                                                         
       1      2       1                                                                         
       1      3       3                                                                         
       2      1       2                                                                         
       2      3       4                                                                         
                                                                                                
*                                                                                               
 _ __  _ __ ___   ___ ___  ___ ___                                                              
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                             
| |_) | | | (_) | (_|  __/\__ \__ \                                                             
| .__/|_|  \___/ \___\___||___/___/                                                             
|_|                                                                                             
;                                                                                               
                                                                                                
*              _       _            _                                                           
  __ _      __| | __ _| |_ __ _ ___| |_ ___ _ __                                                
 / _` |    / _` |/ _` | __/ _` / __| __/ _ \ '_ \                                               
| (_| |_  | (_| | (_| | || (_| \__ \ ||  __/ |_) |                                              
 \__,_(_)  \__,_|\__,_|\__\__,_|___/\__\___| .__/                                               
                                           |_|                                                  
;                                                                                               
                                                                                                
data have;                                                                                      
   input ID Unit O1 O2 O3;                                                                      
cards4;                                                                                         
1 1 2 1 3                                                                                       
1 2 2 1 3                                                                                       
1 3 2 1 3                                                                                       
2 1 2 4 .                                                                                       
2 3 2 4 .                                                                                       
;;;;                                                                                            
run;quit;                                                                                       
                                                                                                
data want;                                                                                      
 do _n_=1 by 1 until(last.id);                                                                  
   set have;                                                                                    
    by id;                                                                                      
    array t(*) O1 O2 O3;                                                                        
    OwnCar=t(_n_);                                                                              
    output;                                                                                     
 end;                                                                                           
 keep id unit owncar;                                                                           
run;                                                                                            
                                                                                                
*_                                                                                              
| |__     _ __ ___   ___  __ _ _ __  ___   _ __ ___   ___ _ __ __ _  ___                        
| '_ \   | '_ ` _ \ / _ \/ _` | '_ \/ __| | '_ ` _ \ / _ \ '__/ _` |/ _ \                       
| |_) |  | | | | | |  __/ (_| | | | \__ \ | | | | | |  __/ | | (_| |  __/                       
|_.__(_) |_| |_| |_|\___|\__,_|_| |_|___/ |_| |_| |_|\___|_|  \__, |\___|                       
                                                              |___/                             
;                                                                                               
                                                                                                
data have;                                                                                      
   input ID Unit O1 O2 O3;                                                                      
cards4;                                                                                         
1 1 2 1 3                                                                                       
1 2 2 1 3                                                                                       
1 3 2 1 3                                                                                       
2 1 2 4 .                                                                                       
2 3 2 4 .                                                                                       
;;;;                                                                                            
run;quit;                                                                                       
                                                                                                
ods output summary=havone;                                                                      
proc means data=have(where=(unit=1)) stackods;                                                  
  by id;                                                                                        
  var O:;                                                                                       
run;quit;                                                                                       
                                                                                                
data want;                                                                                      
  merge have(in=h) havone;                                                                      
  if h;                                                                                         
  keep id unit mean;                                                                            
run;quit;                                                                                       
                                                                                                
                                                                                                
