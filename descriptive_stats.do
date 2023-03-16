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


export delimited sexo1 edad5 yd state wife husband mother mother_5 mother_10  ///
mother_15 father father_5 father_10 father_15 father_state hub_state hub_ten_y ///
tenure ten_y wife_state wife_ten disc part_time facexp if employed==1&edad5>=20&edad5<60 ///
using "./descriptive_stats/tenure_dist.csv", replace
