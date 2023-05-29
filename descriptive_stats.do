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

**# Export tenure dataset to be formatted in python
export delimited sexo1 edad5 ciclo yd state act1 wife husband mother mother_5 mother_10  ///
mother_15 father father_5 father_10 father_15 father_state hub_state hub_ten_y ///
tenure ten_y wife_state wife_ten disc part_time facexp if employed==1&edad5>=20&edad5<60 ///
using "./descriptive_stats/tenure_dist.csv", replace

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

capture log close
log using "./descriptive_stats/tenure_3040_mothers_10.log", replace nomsg
tab ciclo if wife==1&mother_10==1&age3040==1 [fweight=facexp], sum(ten_y )
log close

log using "./descriptive_stats/tenure_3040_not_mothers.log", replace nomsg
tab ciclo if wife==1&mother_10==0&age3040==1 [fweight=facexp], sum(ten_y )
log close

log using "./descriptive_stats/tenure_3040_fathers_10.log", replace nomsg
tab ciclo if husband==1&father_10==1&age3040==1 [fweight=facexp], sum(ten_y )
log close

log using "./descriptive_stats/tenure_3040_not_fathers.log", replace nomsg
tab ciclo if husband==1&father_10==0&age3040==1 [fweight=facexp], sum(ten_y )
log close

**# Industry not missing

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

**# Reasons why not in work
log using "./descriptive_stats/reasons_women_1518.log", replace nomsg
tab rznotb inactive [fweight=facexp] if sexo1==1&yd>=2015&yd<=2018
log close

log using "./descriptive_stats/reasons_women_1922.log", replace nomsg
tab rznotb inactive [fweight=facexp] if sexo1==1&yd>=2019
log close

log using "./descriptive_stats/reasons_men_1518.log", replace nomsg
tab rznotb inactive [fweight=facexp] if sexo1==0&yd>=2015&yd<=2018
log close

log using "./descriptive_stats/reasons_men_1922.log", replace nomsg
tab rznotb inactive [fweight=facexp] if sexo1==0&yd>=2019
log close

// * Time series, inactive
log using "./descriptive_stats/rznotb_inac_w_age3040_w.log", replace nomsg
tab ciclo rznotb [fweight=facexp] if sexo1==1&inactive&age3040
log close

log using "./descriptive_stats/rznotb_inac_m_age3040_w.log", replace nomsg
tab ciclo rznotb [fweight=facexp] if sexo1==0&inactive&age3040
log close

log using "./descriptive_stats/rznotb_inac_husbands_age3040_w.log", replace nomsg
tab ciclo rznotb [fweight=facexp] if sexo1==0&inactive&age3040&husband==1
log close

log using "./descriptive_stats/rznotb_emp_husbands_age3040_w.log", replace nomsg
tab ciclo rznotb [fweight=facexp] if sexo1==0&employed&age3040&husband==1
log close

log using "./descriptive_stats/temp_ind_emp_husbands_age3040_w.log", replace nomsg
tab ciclo act1 [fweight=facexp] if sexo1==0&state=="T"&age3040&husband==1
log close

log using "./descriptive_stats/perm_ind_emp_husbands_age3040_w.log", replace nomsg
tab ciclo act1 [fweight=facexp] if sexo1==0&state=="P"&age3040&husband==1
log close
//
**# Same sex couples

sort ciclo nvivi relpp1

by ciclo nvivi: gen Lwife = (sexo1==1&((relpp1==1&relpp1[_n+1]==2&sexo1[_n+1]==1)|(relpp1==2&relpp1[_n-1]==1&sexo1[_n-1]==1)))
by ciclo nvivi: gen Ghusband = (sexo1==0&((relpp1==1&relpp1[_n+1]==2&sexo1[_n+1]==0)|(relpp1==2&relpp1[_n-1]==1&sexo1[_n-1]==0)))

* Age restriction
replace Lwife = 0 if wife==1&(edad5<20|edad5>50)
replace Ghusband = 0 if husband==1&(edad5<20|edad5>50)

gen gay_couple = (Lwife|Ghusband)
gen all_couples = (wife|husband)

tab gay_couple all_couples, column

log using "./descriptive_stats_Lcouples_w.log", replace nomsg
tab ciclo Lwife if wife [fweight=facexp]
log close

log using "./descriptive_stats_Gcouples_w.log", replace nomsg
tab ciclo Ghusband if husband [fweight=facexp]
log close

log using "./descriptive_stats_Lcouples.log", replace nomsg
tab ciclo Lwife if wife
log close

log using "./descriptive_stats_Gcouples.log", replace nomsg
tab ciclo Ghusband if husband
log close