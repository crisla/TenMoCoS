* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all 
cd "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross"
use "./rawfiles/EPA_stocks20_parents.dta", clear

drop if age<20
drop if age>50

keep permanent age act occ public_servant married parent parent_* divorced widowed part_time erte age college tenure ciclo mili woman factorel inactive wife_ten_y hub_ten_y wife_ten_y2 hub_ten_y2 less_hs hub_age wife_age hub_se wife_se hub_college wife_college hub_less_hs wife_less_hs period_y mother mother_* employed father father_* wife husband sexo1 ten_y other_ten_y ttrend ttrend2 covid other_se other_college other_less_hs yd occgroup

* Add unemployment data
merge m:1 ciclo using "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross/urate_spain.dta"
drop _merge

**# Part 2: regressions * * * * * * * * 

gen age2550 = 0
replace age2550 = 1 if age>=25&age<50

gen age3045 = 0
replace age3045 = 1 if age>=30&age<45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<35

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen age3050 = 0
replace age3050 = 1 if age>=30&age<50

global age_group "age2550 age3045 age3035 age3040 age3050"

global parent_string "_10 _15 _18"

**# Regressions * * * * * * * * * 
* Table 2 & 4 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group{
foreach par of global parent_string {
log using "./tables/sqtreg_table_simple_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.covid##i.sexo1 ///
                if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                q(.25 .5 .75)
log close

log using "./tables/sqtreg_table_advanced_simple_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close	
}
}
				
				
				
				
				
				
				
				
				