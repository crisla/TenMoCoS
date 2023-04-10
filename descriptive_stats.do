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


export delimited sexo1 edad5 ciclo yd state wife husband mother mother_5 mother_10  ///
mother_15 father father_5 father_10 father_15 father_state hub_state hub_ten_y ///
tenure ten_y wife_state wife_ten disc part_time facexp if employed==1&edad5>=20&edad5<60 ///
using "./descriptive_stats/tenure_dist.csv", replace

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen non_missing_ind = (acta!=.|act1!=.)

capture log close
log using "./descriptive_stats/non_missing_ind_3040_mothers_ne.log", replace nomsg
tab ciclo non_missing_ind if age3040&mother_15&wife==1&state=="I" [fw=facexp]
log close

log using "./descriptive_stats/non_missing_ind_3040_not_mothers_ne.log", replace nomsg
tab ciclo non_missing_ind if age3040&mother_15==0&wife==1&state=="I" [fw=facexp]
log close

log using "./descriptive_stats/non_missing_ind_3040_mothers.log", replace nomsg
tab ciclo non_missing_ind if age3040&mother_15&wife==1 [fw=facexp]
log close

log using "./descriptive_stats/non_missing_ind_3040_not_mothers.log", replace nomsg
tab ciclo non_missing_ind if age3040&mother_15==0&wife==1 [fw=facexp]
log close
