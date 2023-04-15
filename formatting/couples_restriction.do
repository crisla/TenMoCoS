* * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* To be used with EPA_stocks20_parents.dta
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Hetero restriction

sort ciclo nvivi relpp1

by ciclo nvivi: gen Lwife = (sexo1==1&((relpp1==1&relpp1[_n+1]==2&sexo1[_n+1]==1)|(relpp1==2&relpp1[_n-1]==1&sexo1[_n-1]==1)))
by ciclo nvivi: gen Ghusband = (sexo1==0&((relpp1==1&relpp1[_n+1]==2&sexo1[_n+1]==0)|(relpp1==2&relpp1[_n-1]==1&sexo1[_n-1]==0)))

* Age restriction
replace Lwife = 0 if wife==1&(edad5<20|edad5>50)
replace Ghusband = 0 if husband==1&(edad5<20|edad5>50)

gen gay_couple = (Lwife|Ghusband)
gen all_couples = (wife|husband)

* Uncomment for descriptive stats
// tab gay_couple all_couples, column

// log using "./descriptive_stats_Lcouples_w.log", replace nomsg
// tab ciclo Lwife if wife [fweight=facexp]
// log close
//
// log using "./descriptive_stats_Gcouples_w.log", replace nomsg
// tab ciclo Ghusband if husband [fweight=facexp]
// log close
//
// log using "./descriptive_stats_Lcouples.log", replace nomsg
// tab ciclo Lwife if wife
// log close
//
// log using "./descriptive_stats_Gcouples.log", replace nomsg
// tab ciclo Ghusband if husband
// log close

drop if gay_couple==1
drop gay_couple all_couples Lwife Ghusband

