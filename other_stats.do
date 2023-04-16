* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Other data
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear


gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen age3540 = 0
replace age3540 = 1 if age>=35&age<40

gen age3035 = 0
replace age3035 = 1 if age>=30&age<35

gen age3045 = 0
replace age3045 = 1 if age>=30&age<45

gen age3050 = 0
replace age3050 = 1 if age>=30&age<=45

gen age2065 = 0
replace age2065 = 1 if age>=20&age<=60

global age_group "age3040 age3045 age3035 age3050 age2065"
// global age_group "age3540"

global parent_string "10 15"


**# Part-time

log using "./descriptive_stats/stocks_parttime_mothers_3040_10_w.log", replace nomsg
tab ciclo state_pt if mother_10==1&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_parttime_fathers_3040_10_w.log", replace nomsg
tab ciclo state_pt if father_10==1&age3040==1&husband==1 [fweight=facexp]
log close


log using "./descriptive_stats/stocks_parttime_not_mothers_3040_10_w.log", replace nomsg
tab ciclo state_pt if mother_15==0&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_parttime_not_fathers_3040_10_w.log", replace nomsg
tab ciclo state_pt if father_15==0&age3040==1&husband==1 [fweight=facexp]
log close


**# ERTEs

log using "./descriptive_stats/stocks_erte_mothers_3040_10_w.log", replace nomsg
tab ciclo erte if mother_10==1&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_erte_fathers_3040_10_w.log", replace nomsg
tab ciclo erte if father_10==1&age3040==1&husband==1 [fweight=facexp]
log close


log using "./descriptive_stats/stocks_erte_not_mothers_3040_10_w.log", replace nomsg
tab ciclo erte if mother_15==0&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_erte_not_fathers_3040_10_w.log", replace nomsg
tab ciclo erte if father_15==0&age3040==1&husband==1 [fweight=facexp]
log close

* Hours reduction ERTE

log using "./descriptive_stats/stocks_erteh_mothers_3040_10_w.log", replace nomsg
tab ciclo erteh if mother_10==1&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_erteh_fathers_3040_10_w.log", replace nomsg
tab ciclo erteh if father_10==1&age3040==1&husband==1 [fweight=facexp]
log close


log using "./descriptive_stats/stocks_erteh_not_mothers_3040_10_w.log", replace nomsg
tab ciclo erteh if mother_15==0&age3040==1&wife==1 [fweight=facexp]
log close

log using "./descriptive_stats/stocks_erteh_not_fathers_3040_10_w.log", replace nomsg
tab ciclo erteh if father_15==0&age3040==1&husband==1 [fweight=facexp]
log close














		