* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* New stocks file - figure 1
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear


gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen age3045 = 0
replace age3045 = 1 if age>=30&age<45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<35

gen age3050 = 0
replace age3050 = 1 if age>=30&age<=45

global age_group "age3040 age3045 age3035 age3050"

global parent_string "10 15"

**# Tables * * * * * * * * * 
* Table 1 for different age groups * * * * * * * * * * * * * * * * * * * *
capture log close _all
foreach ag of global age_group{
	foreach par of global parent_string {
	
	* Counterfactuals
	log using "./descriptive_stats/stocks_not_mothers_`ag'_`par'.log", replace nomsg
	tab ciclo state if mother_`par'==0&wife==1&`ag'==1&sexo1==1
	log close

	log using "./descriptive_stats/stocks_not_fathers_`ag'_`par'.log", replace nomsg
	tab ciclo state if father_`par'==0&husband==1&`ag'==1&sexo1==0
	log close

	log using "./descriptive_stats/stocks_not_mothers_`ag'_`par'_w.log", replace nomsg
	tab ciclo state if mother_`par'==0&wife==1&`ag'==1&sexo1==1 [fweight=facexp]
	log close

	log using "./descriptive_stats/stocks_not_fathers_`ag'_`par'_w.log", replace nomsg
	tab ciclo state if father_`par'==0&husband==1&`ag'==1&sexo1==0 [fweight=facexp]
	log close
	
	log using "./descriptive_stats/stocks_mothers_`ag'_`par'.log", replace nomsg
	tab ciclo state if mother_`par'==1&`ag'==1
	log close

	log using "./descriptive_stats/stocks_fathers_`ag'_`par'.log", replace nomsg
	tab ciclo state if father_`par'==1&`ag'==1
	log close

	log using "./descriptive_stats/stocks_mothers_`ag'_`par'_w.log", replace nomsg
	tab ciclo state if mother_`par'==1&`ag'==1 [fweight=facexp]
	log close

	log using "./descriptive_stats/stocks_fathers_`ag'_`par'_w.log", replace nomsg
	tab ciclo state if father_`par'==1&`ag'==1 [fweight=facexp]
	log close
	
	
	}
}
