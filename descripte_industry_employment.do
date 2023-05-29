* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Descriptive stats - stocks
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Tabulates stocks per quarter
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

