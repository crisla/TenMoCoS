* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear


**# Regressions * * * * * * * * * 

* Old restriction
drop if disc>0

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

