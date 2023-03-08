* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Robustness Checks
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all 
cd "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross"
use "./rawfiles/EPA_stocks20_parents.dta", clear

* Make sure control group are non-parents
gen nmadre_20 = nmadre_help
gen npadre_20 = npadre_help

replace nmadre_20 = 0 if edad5>20
replace npadre_20 = 0 if edad5>20

sort ciclo nvivi npers

gen mom_in_20 = -(nmadre_20>0)
gen mom_no_20 = nmadre_20
sort ciclo nvivi mom_in_20
by ciclo nvivi: replace mom_no_20 = mom_no_20[_n-1] if mom_no_20==0
gen mother_20 = mom_no_20==npers
replace mom_no_20 = 0 if  mom_no_20 == .

gen dad_in_20 = -(npadre_20>0)
gen dad_no_20 = npadre_20
sort ciclo nvivi dad_in_20
by ciclo nvivi: replace dad_no_20 = dad_no_20[_n-1] if dad_no_20==0
gen father_20 = dad_no_10==npers
replace dad_no_20 = 0 if  dad_no_20 == .

drop mom_in_20 dad_in_20

* Drop weird cases and teen moms
replace mother_20 = 0 if mother_20==1&(edad5<20|edad5>50)
replace father_20 = 0 if father_20==1&(edad5<20|edad5>50)

gen parent_20 = (mother_20==1|father_20==1)

drop if age<20
drop if age>50

keep permanent age act occ public_servant married parent parent_* divorced widowed part_time erte age college tenure ciclo mili woman factorel inactive wife_ten_y hub_ten_y wife_ten_y2 hub_ten_y2 less_hs hub_age wife_age hub_se wife_se hub_college wife_college hub_less_hs wife_less_hs period_y mother mother_* employed father father_* wife husband sexo1 ten_y other_ten_y ttrend ttrend2 covid other_se other_college other_less_hs yd ocup1

* Add unemployment data
merge m:1 ciclo using "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross/urate_spain.dta"
drop _merge

gen age2550 = 0
replace age2550 = 1 if age>=25&age<50

gen age3045 = 0
replace age3045 = 1 if age>=30&age<45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<35

gen age3540 = 0
replace age3540 = 1 if age>=35&age<40

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen age3050 = 0
replace age3050 = 1 if age>=30&age<50

gen married_parent_5 = married*parent_5
gen married_parent_10 = married*parent_10
gen married_parent_15 = married*parent_15
gen married_parent_18 = married*parent_18
gen married_parent_20 = married*parent_20

*** Tenure bins
gen tenure_bin=.
replace tenure_bin = 1 if tenure>=0&tenure<6
replace tenure_bin = 2 if tenure>=6&tenure<12
replace tenure_bin = 3 if tenure>=12&tenure<36
replace tenure_bin = 4 if tenure>=36&tenure<60
replace tenure_bin = 5 if tenure>=60&tenure<120
replace tenure_bin = 6 if tenure>=120&tenure<180
replace tenure_bin = 7 if tenure>=180&tenure<240
replace tenure_bin = 8 if tenure>=240&tenure<360
replace tenure_bin = 9 if tenure>=360&tenure!=.

gen other_ten_y_bin = .
replace other_ten_y_bin = 1 if other_ten_y>=0&other_ten_y<0.5
replace other_ten_y_bin = 2 if other_ten_y>=0.5&other_ten_y<1
replace other_ten_y_bin = 3 if other_ten_y>=1&other_ten_y<3
replace other_ten_y_bin = 4 if other_ten_y>=3&other_ten_y<5
replace other_ten_y_bin = 5 if other_ten_y>=5&other_ten_y<10
replace other_ten_y_bin = 6 if other_ten_y>=10&other_ten_y<15
replace other_ten_y_bin = 7 if other_ten_y>=15&other_ten_y<20
replace other_ten_y_bin = 8 if other_ten_y>=20&other_ten_y<30
replace other_ten_y_bin = 9 if other_ten_y>=30&other_ten_y!=.

gen wife_ten_y_bin = .
replace wife_ten_y_bin = 1 if wife_ten_y>=0&wife_ten_y<0.5
replace wife_ten_y_bin = 2 if wife_ten_y>=0.5&wife_ten_y<1
replace wife_ten_y_bin = 3 if wife_ten_y>=1&wife_ten_y<3
replace wife_ten_y_bin = 4 if wife_ten_y>=3&wife_ten_y<5
replace wife_ten_y_bin = 5 if wife_ten_y>=5&wife_ten_y<10
replace wife_ten_y_bin = 6 if wife_ten_y>=10&wife_ten_y<15
replace wife_ten_y_bin = 7 if wife_ten_y>=15&wife_ten_y<20
replace wife_ten_y_bin = 8 if wife_ten_y>=20&wife_ten_y<30
replace wife_ten_y_bin = 9 if wife_ten_y>=30&wife_ten_y!=.

gen hub_ten_y_bin = .
replace hub_ten_y_bin = 1 if hub_ten_y>=0&hub_ten_y<0.5
replace hub_ten_y_bin = 2 if hub_ten_y>=0.5&hub_ten_y<1
replace hub_ten_y_bin = 3 if hub_ten_y>=1&hub_ten_y<3
replace hub_ten_y_bin = 4 if hub_ten_y>=3&hub_ten_y<5
replace hub_ten_y_bin = 5 if hub_ten_y>=5&hub_ten_y<10
replace hub_ten_y_bin = 6 if hub_ten_y>=10&hub_ten_y<15
replace hub_ten_y_bin = 7 if hub_ten_y>=15&hub_ten_y<20
replace hub_ten_y_bin = 8 if hub_ten_y>=20&hub_ten_y<30
replace hub_ten_y_bin = 9 if hub_ten_y>=30&hub_ten_y!=.

*** Occupation groupscapture drop occgroup
capture drop occgroup
gen occgroup=.
replace occgroup=1 if ocup1==1 | ocup1==2
replace occgroup=2 if ocup1==3 | ocup1==4
replace occgroup=3 if ocup1==5
replace occgroup=4 if ocup1==6 | ocup1==7 | ocup1==8
replace occgroup=5 if ocup1==9

drop woman
gen woman = sexo1==1

global age_group "age3045 age3035 age3540 age3040 age3050" 
 
global parent_string "parent_5 parent_10 parent_15"

**# Part of Main Regressions for Figure 8 * * * * * * * * *
* Figure 8 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group {
foreach par of global parent_string {
log using "./regtabs/prob_perm_stocks_w_year_`ag'_`par'.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college tenure if yd==`t'&mili==0&`ag'==1&woman==1 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_stocks_m_year_`ag'_`par'.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college tenure if yd==`t'&mili==0&`ag'==1&woman==0 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_inac_stocks_w_year_`ag'_`par'.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic inactive i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college if yd==`t'&mili==0&`ag'==1&woman==1 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_inac_stocks_m_year_`ag'_`par'.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic inactive i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college if yd==`t'&mili==0&`ag'==1&woman==0 [pw=factorel], vce(robust)
}
log close
}
}

**# Regressions with flexible age and time stuff * * * * * * * * * 

* Figure 2 & 3
* Women
log using "./regtabs/prob_perm_stocks_w_age3045__10_tenagefix.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure if ciclo==`i'&mili==0&age3045==1&woman==1 [pw=factorel], vce(robust)
}
esttab using "prob_perm_stocks_w.tex", se eform label replace
esttab using "prob_perm_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Men
log using "./regtabs/prob_perm_stocks_m_age3045__10_tenagefix.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure if ciclo==`i'&mili==0&age3045==1&woman==0 [pw=factorel], vce(robust)
}
esttab using "prob_perm_stocks_m.tex", se eform label replace
esttab using "prob_perm_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear

* Women
log using "./regtabs/prob_inac_stocks_w_age3045__10_tenagefix.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic inactive i.act i.occ parent_10 married married_parent_10 divorced widowed i.age college if mili==0&woman==1&age3045==1&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "prob_inac_stocks_w.tex", se eform label replace
esttab using "prob_inac_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Men
log using "./regtabs/prob_inac_stocks_m_age3045__10_tenagefix.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic inactive i.act i.occ parent_10 married married_parent_10 divorced widowed i.age college if mili==0&woman==0&age3045==1&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "prob_inac_stocks_m.tex", se eform label replace
esttab using "prob_inac_stocks_m_margins.tex", se margin mtitles label replace
log close

* Figure 5
log using "./results/sqtreg_mothers_age3035__10_tenagefix.log", replace nomsg
sqreg wife_ten_y i.hub_ten_y part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother_10==1&wife==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_age3035__10_tenagefix.log", replace nomsg		
sqreg wife_ten_y i.hub_ten_y part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother_20==0&wife==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_age3035__10_tenagefix.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father_10==1&husband==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_age3035__10_tenagefix.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father_20==0&husband==1&employed&age3035==1, q(.25 .5 .75) 
log close

* Figure 6
log using "./results/sqtreg_age3035__10_hemp_time_int_diff_tenagefix.log", replace nomsg
sqreg ten_y i.other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3035==1, ///
                 q(.25 .5 .75)
log close

log using "./results/sqtreg_age3035__10_hemp_time_int_diff_0k_tenagefix.log", replace nomsg
sqreg ten_y i.other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&age3035==1, ///
                 q(.25 .5 .75)
log close

* Figure 8 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
log using "./regtabs/prob_perm_stocks_w_year_age3035__10_tenagefix.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure if yd==`t'&mili==0&age3035==1&woman==1 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_stocks_m_year_age3035__10_tenagefix.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure if yd==`t'&mili==0&age3035==1&woman==0 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_inac_stocks_w_year_age3035__10_tenagefix.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic inactive i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college if yd==`t'&mili==0&age3035==1&woman==1 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_inac_stocks_m_year_age3035__10_tenagefix.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic inactive i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college if yd==`t'&mili==0&age3035==1&woman==0 [pw=factorel], vce(robust)
}
log close


**# Regressions with flexible age and tenure bins * * * * * * * * * 

* Figure 2 & 3
* Women
log using "./regtabs/prob_perm_stocks_w_age3045__10_tenagebin.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure_bin if ciclo==`i'&mili==0&age3045==1&woman==1 [pw=factorel], vce(robust)
}
esttab using "prob_perm_stocks_w.tex", se eform label replace
esttab using "prob_perm_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Men
log using "./regtabs/prob_perm_stocks_m_age3045__10_tenagebin.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure_bin if ciclo==`i'&mili==0&age3045==1&woman==0 [pw=factorel], vce(robust)
}
esttab using "prob_perm_stocks_m.tex", se eform label replace
esttab using "prob_perm_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear


* Figure 5
log using "./results/sqtreg_mothers_age3035__10_tenagebin.log", replace nomsg
sqreg wife_ten_y i.hub_ten_y_bin part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother_10==1&wife==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_age3035__10_tenagebin.log", replace nomsg		
sqreg wife_ten_y i.hub_ten_y_bin part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother_20==0&wife==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_age3035__10_tenagebin.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y_bin part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y if father_10==1&husband==1&employed&age3035==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_age3035__10_tenagebin.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y_bin part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y if father_20==0&husband==1&employed&age3035==1, q(.25 .5 .75) 
log close

* Figure 6
log using "./results/sqtreg_age3035__10_hemp_time_int_diff_tenagebin.log", replace nomsg
sqreg ten_y i.other_ten_y_bin ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3035==1, ///
                 q(.25 .5 .75)
log close

log using "./results/sqtreg_age3035__10_hemp_time_int_diff_0k_tenagebin.log", replace nomsg
sqreg ten_y i.other_ten_y_bin ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&age3035==1, ///
                 q(.25 .5 .75)
log close

* Figure 8 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
log using "./regtabs/prob_perm_stocks_w_year_age3035__10_tenagebin.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure_bin if yd==`t'&mili==0&age3035==1&woman==1 [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_stocks_m_year_age3035__10_tenagebin.log", replace nomsg
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant parent_10 married married_parent_10 divorced widowed part_time erte i.age college i.tenure_bin if yd==`t'&mili==0&age3035==1&woman==0 [pw=factorel], vce(robust)
}
log close