* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* New stocks file - figure 1
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

**# Tables * * * * * * * * * 
* Table 1 for different age groups * * * * * * * * * * * * * * * * * * * *
capture log close
foreach ag of global age_group{
	
	* Counterfactuals
	log using "./descriptive_stats/stocks_not_mothers_`ag'.log", replace nomsg
	tab ciclo state if mother==0&wife==1&`ag'==1&sexo1==1
	log close

	log using "./descriptive_stats/stocks_not_fathers_`ag'.log", replace nomsg
	tab ciclo state if father==0&husband==1&`ag'==1&sexo1==0
	log close

	log using "./descriptive_stats/stocks_not_mothers_`ag'_w.log", replace nomsg
	tab ciclo state if mother==0&wife==1&`ag'==1&sexo1==1 [fweight=facexp]
	log close

	log using "./descriptive_stats/stocks_not_fathers_`ag'_w.log", replace nomsg
	tab ciclo state if father==0&husband==1&`ag'==1&sexo1==0 [fweight=facexp]
	log close
	
	* singles
	log using "./descriptive_stats/stocks_single_women_`ag'.log", replace nomsg
	tab ciclo state if mother==0&wife==0&`ag'==1&sexo1==1
	log close

	log using "./descriptive_stats/stocks_single_men_`ag'.log", replace nomsg
	tab ciclo state if father==0&husband==0&`ag'==1&sexo1==0
	log close

	log using "./descriptive_stats/stocks_single_women_`ag'_w.log", replace nomsg
	tab ciclo state if mother==0&wife==0&`ag'==1&sexo1==1 [fweight=facexp]
	log close

	log using "./descriptive_stats/stocks_single_men_`ag'_w.log", replace nomsg
	tab ciclo state if father==0&husband==0&`ag'==1&sexo1==0 [fweight=facexp]
	log close
	
	foreach par of global parent_string {
	
		log using "./descriptive_stats/stocks_mothers_`ag'_`par'.log", replace nomsg
		tab ciclo state if mother_`par'==1&`ag'==1&wife==1
		log close

		log using "./descriptive_stats/stocks_fathers_`ag'_`par'.log", replace nomsg
		tab ciclo state if father_`par'==1&`ag'==1&husband==1
		log close

		log using "./descriptive_stats/stocks_mothers_`ag'_`par'_w.log", replace nomsg
		tab ciclo state if mother_`par'==1&`ag'==1&wife==1 [fweight=facexp]
		log close

		log using "./descriptive_stats/stocks_fathers_`ag'_`par'_w.log", replace nomsg
		tab ciclo state if father_`par'==1&`ag'==1&husband==1 [fweight=facexp]
		log close
	
	
	}
}

* Descriptive stats by age groups

gen woman_status = "couple_0k" if mother==0&wife==1&sexo1==1
gen man_status = "couple_0k" if father==0&husband==1&sexo1==0

replace woman_status = "couple_k" if mother==1&wife==1&sexo1==1
replace man_status = "couple_k" if father==1&husband==1&sexo1==0

replace woman_status = "single" if mother==0&wife==0&sexo1==1
replace man_status = "single" if father==0&husband==0&sexo1==0

replace woman_status = "other" if woman_status==""&sexo1==1
replace man_status = "other" if man_status==""&sexo1==0

capture log close
* Time series
foreach ag of global age_group{
	log using "./descriptive_stats/women_status_ciclo_`ag'.log", replace nomsg
	tab ciclo woman_status if `ag'==1&sexo1==1
	log close
	
	log using "./descriptive_stats/men_status_ciclo_`ag'.log", replace nomsg
	tab ciclo man_status if `ag'==1&sexo1==0
	log close
	
	log using "./descriptive_stats/women_status_ciclo_`ag'_w.log", replace nomsg
	tab ciclo woman_status if `ag'==1&sexo1==1 [fweight=facexp]
	log close
	
	log using "./descriptive_stats/men_status_ciclo_`ag'_w.log", replace nomsg
	tab ciclo man_status if `ag'==1&sexo1==0 [fweight=facexp]
	log close
}
