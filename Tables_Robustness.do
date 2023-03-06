* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all 
// cd "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross"
use "./formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Part 1: Generate key indicator variables * * * * * * * * * 

* Add unemployment data
merge m:1 ciclo using "./other_data/urate_spain.dta"
drop if _merge==2
drop _merge

**# Part 2: regressions * * * * * * * * 

gen age2550 = 0
replace age2550 = 1 if age>=25&age<=50

gen age3045 = 0
replace age3045 = 1 if age>=30&age<=45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<=35

global age_group "age2550 age3045 age3035"

global parent_string "10 15 18"

**# Regressions * * * * * * * * * 
* Table 2 & 4 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group{
foreach par of global parent_string {
log using "./results/sqtreg_table_simple_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.covid##i.sexo1 ///
                if ((mother_`par'==1&wife==1)|(father_`par'==1&husband==1))&employed&`ag'==1, ///
                q(.25 .5 .75)
log close

log using "./results/sqtreg_table_advanced_simple_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother_`par'==1&wife==1)|(father_`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close	
}
}
				
				
				
				
				
				
				
				
				