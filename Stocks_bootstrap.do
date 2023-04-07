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
global age_group "age3540"

global parent_string "10 15"

**# Part 1: survey weights and uncertainty
svyset [pweight=factorel]
capture log close
log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial_svy.log", replace nomsg
svy: mean permanent if age3040&wife&mother_10,over(ciclo)
log close

log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial_0k_svy.log", replace nomsg
svy: mean permanent if age3040&wife&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial_00k_svy.log", replace nomsg
svy: mean permanent if age3040&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

* Men
log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial_svy.log", replace nomsg
svy: mean permanent if age3040&husband&father_10,over(ciclo)
log close

log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial_0k_svy.log", replace nomsg
svy: mean permanent if age3040&husband&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial_00k_svy.log", replace nomsg
svy: mean permanent if age3040&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

* Singles
log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial_single_svy.log", replace nomsg
svy: mean permanent if age3040&wife==0&woman==1&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial_single_svy.log", replace nomsg
svy: mean permanent if age3040&husband==0&woman==0&(parent_10==0&parent_15==0&parent_5==0),over(ciclo)
log close

**# Part 2: sleek bootstrap
* Women
capture log close
log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial.log", replace nomsg
mean permanent if age3040&wife&parent_10==1,over(ciclo) vce(bootstrap)
log close

log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial_0k.log", replace nomsg
mean permanent if age3040&wife&(parent_10==0&parent_15==0&parent_5==0),over(ciclo) vce(bootstrap)
log close

* Men
log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial.log", replace nomsg
mean permanent if age3040&husband&parent_10==1,over(ciclo) vce(bootstrap)
log close

log using "./regtabs/bootstrap/boot_perm_m_3040_10_trial_0k.log", replace nomsg
mean permanent if age3040&husband&(parent_10==0&parent_15==0&parent_5==0),over(ciclo) vce(bootstrap)
log close

**# Part 3: Old school bootstrap
* Women
// capture log close
// log using "./regtabs/bootstrap/boot_perm_w_3040_10_trial.log", replace nomsg
forvalues i=130/201{ 
	preserve
	keep if age3040&wife&mother_10&ciclo==`i' 
	bootstrap mean=r(mean), reps(100) seed(42) saving("./regtabs/bootstrap/boot_perm_w_3040_10_trial_`i'",replace): summarize permanent 
	restore
}
// log close
* Women, no kids (pulling singles together with women in couples wiht no kids)
forvalues i=130/201{ 
	preserve
	keep if age3040&woman==1&(parent_10==0&parent_15==0&parent_5==0)&ciclo==`i'
	bootstrap mean=r(mean), reps(100) seed(42) saving(		"./regtabs/bootstrap/boot_perm_w_3040_10_trial_0k_`i'",replace): summarize permanent
	restore
}
* Men, kids
forvalues i=130/201{ 
	preserve
	keep if age3040&husband&father_10&ciclo==`i'
	bootstrap mean=r(mean), reps(100) seed(42) saving("./regtabs/bootstrap/boot_perm_m_3040_10_trial_`i'",replace): summarize permanent
	restore
}
* Men, no kids (pulling singles together with women in couples wiht no kids)
forvalues i=130/201{ 
	preserve
	keep if age3040&woman==0&(parent_10==0&parent_15==0&parent_5==0)&ciclo==`i'
	bootstrap mean=r(mean), reps(100) seed(42) saving("./regtabs/bootstrap/boot_perm_m_3040_10_trial_0k_`i'",replace): summarize permanent
	restore
}

