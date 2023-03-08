* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Descriptive stats
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

log close _all
log using "./descriptive_stats/mother_child_ages.log", replace nomsg
tab age mother_5 if woman
tab age mother_10 if woman
tab age mother_15 if woman
log close