/* MODEL FOR SUBPROBLEM (RECOURSE)
Ethanol Transport Model Simple version
A bin packing problem with constraints. */

#function gsl_cdf_poisson_P;
set TRAINS;

param F_demand >= 0  integer; #Forecasted demand in carloads
param E_demand >= 0  integer; #Realized demand in carloads
param Mmax >=0 integer; #max length of a unit train
param Mmin >= 0 <=Mmax, integer; #min length of a unit train
param Nmax integer >=0 ; #max no of unit trains ;
param Nmin integer >=0 ; #minimum no of unit trains

#given number of cars
param L ;
param P ;
param S ; #starting no of L, P, S cars
#costs of car types
param CL >= 0 ;
param CP >=0 ;
param CO >= 0 ;
param CS >=0; #costs of car types
param CQ >=0; #costs of unused car
param CY {TRAINS} >=0; #ordering cost for trains

var XL {i in TRAINS} >=0 integer; #no of L cars in ith train
var XP {i in TRAINS} >=0 integer; #no of P cars in ith train
var O >= 0 integer ;
var Q >=0 integer; #no outsourced, no not used
var N >=0 integer; # number of trains actually used
var Y {i in TRAINS} >=0 <=1 binary; # binary, 1 if used and 0 if not

minimize RCost: CL*sum {i in TRAINS} XL[i] + CP*sum {i in TRAINS} XP[i] + CO*O + CQ*Q + sum {i in TRAINS} CY[i]*Y[i]
;
#costs to run L, P cars
#cost to outsource, idle
#fill order cost parameters

subject to notrains: N = sum {i in TRAINS} Y[i] ; #no of trains used
subject to mintrains: sum {i in TRAINS} Y[i] >= Nmin ; #at least Nmin trains
subject to maxtrains: sum {i in TRAINS} Y[i] <= Nmax ; #no more than Nmax trains

subject to trainmin {i in TRAINS}: (XL[i] + XP[i]) >= Mmin * Y[i] ; #must have Mmin in a train
subject to trainmax {i in TRAINS}: (XL[i] + XP[i]) <= Mmax * Y[i] ;  #no more than Mmax in train

subject to useallcars: sum{i in TRAINS} ( XL[i] + XP[i] ) + Q = L + P - S  ; #define Q the idle cars
subject to outsource: sum{i in TRAINS} ( XL[i] + XP[i] ) + O = E_demand ; #define O the outsourced cars

subject to Lcars: sum{i in TRAINS} XL[i] <= L ; #cant exceed the no of L cars available
subject to Pcars: sum{i in TRAINS} XP[i] <= P ; #cant exceed the no of P cars


