* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Descriptive stats - stocks
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

log close _all
log using "./descriptive_stats/stocks_E_industry.log", replace nomsg
tab ciclo act1 if state=="P"|state=="T"
log close

log using "./descriptive_stats/stocks_E_industry_w.log", replace nomsg
tab ciclo act1 if state=="P"|state=="T" [fweight=facexp]
log close


log close _all
log using "./descriptive_stats/stocks_E_occ.log", replace nomsg
tab ciclo ocup1 if state=="P"|state=="T"
log close

log using "./descriptive_stats/stocks_E_occ_w.log", replace nomsg
tab ciclo ocup1 if state=="P"|state=="T" [fweight=facexp]
log close

log close _all
log using "./descriptive_stats/stocks_erte_occ.log", replace nomsg
tab ciclo act1 if (state=="P"|state=="T")&erte
log close

log using "./descriptive_stats/stocks_erte_w.log", replace nomsg
tab ciclo act1 if (state=="P"|state=="T")&erte [fweight=facexp]
log close


export delimited sexo1 edad5 yd state wife husband mother mother_5 mother_10  ///
mother_15 father father_5 father_10 father_15 father_state hub_state hub_ten_y ///
tenure ten_y wife_state wife_ten disc part_time facexp if employed==1&edad5>=20&edad5<60 ///
using "./descriptive_stats/tenure_dist.csv", replace

