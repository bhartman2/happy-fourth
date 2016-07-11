/* MASTER MODEL FOR QUARTER
Ethanol Transport Period Model (Quarters) */

param NLpool >= 0 integer default 3; #size of price pools
param NPpool >= 0 integer default 3;
param NSpool >= 0 integer default 3;  

set LPOOL ;
set PPOOL ;
set SPOOL ;
set PDS ;

param F ; # this is the forecasted demand for the 3 month period. 
param Fc default 400 ; #to be passed in

param NQ ; #number of stages in each period (6 semimonths in a quarter)
#param seas {PDS} >=0 <=1; #seasonal factors to spread F over the stages (months) in the period (qtr)

param EDQ {PDS} ;

param KL {LPOOL} >= 0 integer; #monthly ownership costs of each pool
param KP {PPOOL} >= 0 integer;
param RS {SPOOL} >= 0 integer; #this one will be a revenue from sublease
param LPB ; #no of cars used
param SB ; #no of cars to lease


#param Mmax >=0 integer default 50; #max length of a unit train
#param Mmin >= 0 <=Mmax integer default 20; #min length of a unit train
#param Nmax integer >=0 default 5; #max no of unit trains ;
#param Nmin integer >=0 default 2; #minimum no of unit trains


var La {LPOOL} >=0 integer;
var Pa {PPOOL} >=0 integer;
var Sa {SPOOL} >=0 integer;
var Lop ;
var Pop ;
var Sop ;

param ERecourseCost ; # recourse costs from stages (months)

minimize Qcost: sum {i in LPOOL} KL[i]*La[i] + sum {i in PPOOL} KP[i]*Pa[i] - sum {i in SPOOL} RS[i]*Sa[i] 
	+ ERecourseCost ;

subject to lcars: sum{i in LPOOL} La[i] = Lop ;
# the pools add up to LL, PP, SS
subject to pcars: sum {i in PPOOL} Pa[i] = Pop ;
subject to scars: sum {i in SPOOL} Sa[i] = Sop ;

subject to slim {i in LPOOL}: Sa[i] <= La[i] + Pa[i];
                                                          
subject to cars: 
 sum {i in LPOOL} La[i] + sum {i in PPOOL} Pa[i]  
 = LPB;
subject to totcars: 
 sum {i in SPOOL} Sa[i] 
 = SB;
