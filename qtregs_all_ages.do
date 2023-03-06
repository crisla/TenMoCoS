* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

*use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Regressions * * * * * * * * * 

* Old restriction
drop if disc>0

* Age variables
gen age2550 = 0
replace age2550 = 1 if age>=25&age<=50

gen age3045 = 0
replace age3045 = 1 if age>=30&age<=45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<=35

global age_group "age2550 age3045 age3035"
global parent_string "parent_5 parent_10 parent_15 parent_18"

drop woman
gen woman = sexo1==1

log close _all
**# Regressions * * * * * * * * * 
* Figure 2 & 3 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
* 170 - 201 = 2015Q1 = 2022Q4
* age = age
foreach ag of global age_group {
foreach par of global parent_string {
* Women
log using "./regtabs/prob_perm_stocks_w_`ag'_`par'.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college tenure if ciclo==`i'&mili==0&`ag'==1&woman==1 [pw=factorel], vce(robust)
}
esttab using "./regtabs/prob_age_perm_stocks_w.tex", se eform label replace
esttab using "./regtabs/prob_age_perm_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Men
log using "./regtabs/prob_perm_stocks_m_`ag'_`par'.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic permanent i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college tenure if ciclo==`i'&mili==0&`ag'==1&woman==0 [pw=factorel], vce(robust)
}
esttab using "./regtabs/prob_age_perm_stocks_m.tex", se eform label replace
esttab using "./regtabs/prob_age_perm_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear

* Women
log using "./regtabs/prob_inac_stocks_w_`ag'_`par'.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic inactive i.act i.occ `par' married married_`par' divorced widowed age college if mili==0&woman==1&`ag'==1&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "./regtabs/prob_age_inac_stocks_w.tex", se eform label replace
esttab using "./regtabs/prob_age_inac_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Men
log using "./regtabs/prob_inac_stocks_m_`ag'_`par'.log", replace nomsg
forvalues i=170/201{ 
	eststo: logistic inactive i.act i.occ `par' married married_`par' divorced widowed age college if mili==0&woman==0&`ag'==1&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "./regtabs/prob_age_inac_stocks_m.tex", se eform label replace
esttab using "./regtabs/prob_age_inac_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear
}
}

* Figure 5 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
global child_string "5 10 15 18"

foreach ag of global age_group {
foreach par of global child_string {
log using "./results/sqtreg_mothers_`ag'_`par'.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother_`par'==1&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_`ag'_`par'.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother_`par'==0&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_`ag'_`par'.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father_`par'==1&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_`ag'_`par'.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father_`par'==0&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close
}
}

* Figure 6 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group {
foreach par of global child_string {
log using "./results/sqtreg_`ag'_`par'_hemp_time_int_diff.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_`par'==1&wife==1)|(father_`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

log using "./results/sqtreg_`ag'_`par'_hemp_time_int_diff_0k.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_`par'==0&wife==1)|(father_`par'==0&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

}
}

* Figure 8 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group {
foreach par of global parent_string {
log using "./regtabs/prob_perm_stocks_w_year_`ag'_`par'.log"
forval t=2005/2022 { 
eststo: logistic permanent i.act i.occ public_servant `par' married married_`par' divorced widowed part_time erte age college tenure if yd==`t'&mili==0&`ag'==1&woman==0 [pw=factorel], vce(robust)
}
log close
}
}

/*
* All * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
capture log close
log using "./results/sqtreg_mothers.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==1&wife==1&employed&period_y!=8, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==0&wife==1&employed, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&employed, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se  wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&employed, q(.25 .5 .75) 
log close

* Less than 45 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./results/sqtreg_mothers_45.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&employed&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_45.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==0&wife==1&employed&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_45.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&employed&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_45.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&employed&edad5<45, q(.25 .5 .75) 
log close

* In their late 30s * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./results/sqtreg_mothers_3545.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&employed&edad5>=35&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_3545.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==0&wife==1&employed&edad5>=35&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_3545.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&employed&edad5>=35&edad5<45, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_3545.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&employed&edad5>=35&edad5<45, q(.25 .5 .75) 
log close

* In their early 30s * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./results/sqtreg_mothers_3035.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&employed&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_3035.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==0&wife==1&employed&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_3035.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&employed&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_3035.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&employed&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

* More year detail * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./results/sqtreg_mothers_3035_hemp_yy.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd  if mother==1&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_3035_hemp_yy_0k.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd  if mother==0&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3035_hemp_yy.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd  if father==1&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3035_hemp_yy_0k.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd  if father==0&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

* More year detail (mean before 2008) * * * * * * * * * * * * * * * * * * * *
log using "./results/sqtreg_mothers_3035_hemp_ym.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd_mean  if mother==1&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_3035_hemp_ym_0k.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd_mean  if mother==0&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3035_hemp_ym.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd_mean  if father==1&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3035_hemp_ym_0k.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd_mean  if father==0&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

* More year detail, in logs (mean before 2008) * * * * * * * * * * * * * * * * * * * *
log using "./results/sqtreg_log_mothers_3035_hemp_ym.log", replace nomsg
sqreg lwife_ten_y lhub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd_mean  if mother==1&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_log_mothers_3035_hemp_ym_0k.log", replace nomsg
sqreg lwife_ten_y lhub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.yd_mean  if mother==0&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_log_fathers_3035_hemp_ym.log", replace nomsg
sqreg lhub_ten_y lwife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd_mean  if father==1&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_log_fathers_3035_hemp_ym_0k.log", replace nomsg
sqreg lhub_ten_y lwife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.yd_mean  if father==0&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

* More year detail interactions * * * * * * * * * * * * * * * * * * * * * * 
log close _all
log using "./results/sqtreg_mothers_3035_hemp_time_int.log", replace nomsg
sqreg wife_ten_y hub_ten_y i.period_y#c.hub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_3035_hemp_time_int_0k.log", replace nomsg
sqreg wife_ten_y hub_ten_y i.period_y#c.hub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3035_hemp_time_int.log", replace nomsg
sqreg hub_ten_y wife_ten_y i.period_y#c.wife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_3035_hemp_time_int_0k.log", replace nomsg
sqreg hub_ten_y wife_ten_y i.period_y#c.wife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 

log close _all
* Period by Period * * * * * * * * * * * * * * * * * * * * * * 
levelsof period_y, local(levels_y) 
foreach t of local levels_y {	
	log using "./results/sqtreg_mothers_45_`t'.log", replace nomsg
	sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		if mother==1&wife==1&employed&edad5<45&period_y==`t', q(.25 .5 .75) 
	log close

	log using "./results/sqtreg_mothers_0k_45_`t'.log", replace nomsg
	sqreg wife_ten_y hub_ten_y hub_ten_y2 age age2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		if mother==0&wife==1&employed&edad5<45&period_y==`t', q(.25 .5 .75) 
	log close
	
	log using "./results/sqtreg_fathers_45_`t'.log", replace nomsg
	sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
			college less_hs wife_age wife_se wife_college wife_less_hs ///
			if father==1&husband==1&employed&edad5>=35&edad5<45&period_y==`t', q(.25 .5 .75) 
	log close

	log using "./results/sqtreg_fathers_0k_45_`t'.log", replace nomsg
	sqreg hub_ten_y wife_ten_y wife_ten_y2 age age2 part_time /// 
			college less_hs wife_age wife_se wife_college wife_less_hs ///
			if father==0&husband==1&employed&edad5>=35&edad5<45&period_y==`t', q(.25 .5 .75) 
	log close
	
}
*
log close _all
levelsof period_y, local(levels_y) 
foreach t of local levels_y {	
	log using "./results/sqtreg_mothers_3035_`t'.log", replace nomsg
	sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		if mother==1&wife==1&employed&edad5>=30&edad5<35&period_y==`t', q(.25 .5 .75) 
	log close

	log using "./results/sqtreg_mothers_0k_3035_`t'.log", replace nomsg
	sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		if mother==0&wife==1&employed&edad5>=30&edad5<35&period_y==`t', q(.25 .5 .75) 
	log close
	
	log using "./results/sqtreg_fathers_3035_`t'.log", replace nomsg
	sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
			college less_hs wife_age wife_se wife_college wife_less_hs ///
			if father==1&husband==1&employed&edad5>=30&edad5<35&period_y==`t', q(.25 .5 .75) 
	log close

	log using "./results/sqtreg_fathers_0k_3035_`t'.log", replace nomsg
	sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
			college less_hs wife_age wife_se wife_college wife_less_hs ///
			if father==0&husband==1&employed&edad5>=30&edad5<35&period_y==`t', q(.25 .5 .75) 
	log close
	
}

**# Part 3: employed vs ne * * * * * * * * * 
capture log close
log using "./results/logit_mothers_45_hemp.log", replace nomsg
logit wife_emp hub_ten_y age i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&hub_emp&age<45&state!="A" 
	log close
	
log using "./results/logit_mothers_45_hnemp.log", replace nomsg
logit wife_emp hub_ten_y age i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&hub_emp==0&age<45&state!="A" 
	log close
	
log using "./results/logit_mothers_45_noten.log", replace nomsg
logit wife_emp age i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_emp hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&age<45&state!="A" 
log close

log using "./results/logit_mothers_45_hemp_0k.log", replace nomsg
logit wife_emp hub_ten_y age i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&hub_emp&age<45&state!="A"  
	log close
	
log using "./results/logit_mothers_45_hnemp_0k.log", replace nomsg
logit wife_emp hub_ten_y age i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&hub_emp==0&age<45&state!="A"  
	log close
	
log using "./results/logit_mothers_45_noten_0k.log", replace nomsg
logit wife_emp age age2 i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_emp hub_se hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&age<45&state!="A"  
log close

* * * * * * * * * * * * * * * * 
capture log close
log using "./results/logit_fathers_45_hemp.log", replace nomsg
logit hub_emp wife_ten_y age i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y if father==1&husband==1&wife_emp&edad5>=35&edad5<45&state!="A"  
	log close
	
	
log using "./results/logit_fathers_45_noten.log", replace nomsg
logit hub_emp age i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_emp wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&edad5>=35&edad5<45&state!="A"  
log close

log using "./results/logit_fathers_45_hemp_0k.log", replace nomsg
logit hub_emp wife_ten_y age i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&wife_emp&edad5>=35&edad5<45&state!="A"  
	log close
	
log using "./results/logit_fathers_45_noten_0k.log", replace nomsg
logit hub_emp age i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_emp wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&edad5>=35&edad5<45&state!="A"  
log close


* * * Early 30s * * * * * * * * * * * * * * * * * * * * * 
capture log close
log using "./results/logit_mothers_3035_hemp.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&hub_emp&age>=30&age<35&state!="A" 
	log close
	
log using "./results/logit_mothers_3035_hnemp.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&hub_emp==0&age>=30&age<35&state!="A" 
	log close
	
log using "./results/logit_mothers_3035_noten.log", replace nomsg
logit wife_emp i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_emp hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&age>=30&age<35&state!="A" 
log close

log using "./results/logit_mothers_3035_hemp_0k.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&hub_emp&age>=30&age<35&state!="A"  
	log close
	
log using "./results/logit_mothers_3035_hnemp_0k.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2  hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&hub_emp==0&age>=30&age<35&state!="A"  
	log close
	
log using "./results/logit_mothers_3035_noten_0k.log", replace nomsg
logit wife_emp age2 i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_emp hub_se hub_college hub_less_hs ///
		i.period_y  if mother==0&wife==1&age>=30&age<35&state!="A"  
log close

* More year detail * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./results/logit_mothers_3035_hnemp_yy.log", replace nomsg
logit wife_emp i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd  if mother==1&wife==1&hub_emp==0&age>=30&age<35&state!="A" 
log close

log using "./results/logit_mothers_3035_hnemp_yy_0k.log", replace nomsg
logit wife_emp i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd  if mother==0&wife==1&hub_emp==0&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hnemp_yy.log", replace nomsg
logit hub_emp i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd  if father==1&husband==1&wife_emp==0&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hnemp_yy_0k.log", replace nomsg
logit hub_emp i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd  if father==0&husband==1&wife_emp==0&age>=30&age<35&state!="A" 
log close

* More year detail (mean before 2008) * * * * * * * * * * * * * * * * * * 
log using "./results/logit_mothers_3035_hnemp_ym.log", replace nomsg
logit wife_emp i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd_mean  if mother==1&wife==1&hub_emp==0&age>=30&age<35&state!="A" 
log close

log using "./results/logit_mothers_3035_hnemp_ym_0k.log", replace nomsg
logit wife_emp i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd_mean  if mother==0&wife==1&hub_emp==0&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hnemp_ym.log", replace nomsg
logit hub_emp i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd_mean  if father==1&husband==1&wife_emp==0&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hnemp_ym_0k.log", replace nomsg
logit hub_emp i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd_mean  if father==0&husband==1&wife_emp==0&age>=30&age<35&state!="A" 
log close

 * * * * * * * * * * * * * * * * * * * * *
log using "./results/logit_mothers_3035_hemp_yy.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd  if mother==1&wife==1&hub_emp&age>=30&age<35&state!="A" 
log close

log using "./results/logit_mothers_3035_hemp_yy_0k.log", replace nomsg
logit wife_emp hub_ten_y i.ccaa i.act1 /// 
		college less_hs hub_age hub_age2 hub_college hub_less_hs ///
		i.yd  if mother==0&wife==1&hub_emp&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hemp_yy.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd  if father==1&husband==1&wife_emp&age>=30&age<35&state!="A" 
log close


log using "./results/logit_fathers_3035_hemp_yy_0k.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 /// 
		college less_hs wife_age wife_age2 wife_college wife_less_hs ///
		i.yd  if father==0&husband==1&wife_emp&age>=30&age<35&state!="A" 
log close


* * * * * * * * * * * * * * * * 
capture log close
log using "./results/logit_fathers_3035_hemp.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y if father==1&husband==1&wife_emp&edad5>=30&edad5<35&state!="A"  
	log close
	
log using "./results/logit_fathers_3035_hnemp.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y if father==1&husband==1&wife_emp==0&edad5>=30&edad5<35&state!="A"  
	log close	
	
log using "./results/logit_fathers_3035_noten.log", replace nomsg
logit hub_emp i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_emp wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&edad5>=30&edad5<35&state!="A"  
log close

log using "./results/logit_fathers_3035_hemp_0k.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&wife_emp&edad5>=30&edad5<35&state!="A"  
	log close
	
log using "./results/logit_fathers_3035_hnemp_0k.log", replace nomsg
logit hub_emp wife_ten_y i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&wife_emp==0&edad5>=30&edad5<35&state!="A"  
log close
	
log using "./results/logit_fathers_3035_noten_0k.log", replace nomsg
logit hub_emp i.ccaa i.act1 i.ocup1 /// 
		college less_hs wife_age wife_emp wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&edad5>=30&edad5<35&state!="A"  
log close

* In their early 30s - Extensive margin * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

log using "./results/sqtreg_mothers_3035_ext.log", replace nomsg
sqreg wife_ten0_y hub_ten0_y hub_ten0_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother==1&wife==1&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_3035_ext.log", replace nomsg		
sqreg wife_ten0_y hub_ten0_y hub_ten0_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother==0&wife==1&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_3035_ext.log", replace nomsg
sqreg hub_ten0_y wife_ten0_y wife_ten0_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==1&husband==1&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_3035_ext.log", replace nomsg
sqreg hub_ten0_y wife_ten0_y wife_ten0_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father==0&husband==1&edad5>=30&edad5<35, q(.25 .5 .75) 
log close

*/
