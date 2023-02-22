* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Part 1: Generate other key indicator variables * * * * * * * * * 

gen ten_y = wife_ten_y if wife==1
replace ten_y = hub_ten_y if husband==1

gen other_ten_y = hub_ten_y if wife==1
replace other_ten_y = wife_ten_y if husband==1

gen other_se = hub_se if wife==1
replace other_se = wife_se if husband==1

gen ciclo_2 = ciclo*ciclo

replace sexo1 = 0 if sexo1 == 1
replace sexo1 = 1 if sexo1 == 6

gen other_college = hub_college if wife==1
replace other_college = wife_college if husband==1

gen other_less_hs = hub_less_hs if wife==1
replace other_less_hs = wife_less_hs if husband==1

gen covid = 0
replace covid = 1 if ciclo>=190
replace covid = 2 if ciclo>=194

gen ttrend = ciclo-130
gen ttrend2 = ttrend^2

* Add unemployment data
merge m:1 ciclo using "./other_data/urate_spain.dta"
drop _merge

**# Part 2: regressions * * * * * * * * *

log close _all
log using "./results/sqtreg_3035_hemp_time_int_diff_simple.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
log close 

log using "./results/sqtreg_3035_hemp_time_int_diff_simple_0k.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
		if ((mother==0&wife==1)|(father==0&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
log close 

log using "./results/sqtreg_3035_hemp_time_int_diff.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
log close 

log using "./results/sqtreg_3035_hemp_time_int_diff_0k.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==0&wife==1)|(father==0&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
log close 


// * Fewer years * * * * * * * * * * * * * * * * * * * * * * 

log close _all
log using "./results/sqtreg_3035_hemp_time_int_diff_robust.log", replace nomsg
forval t1=1/6{
	local y0 = 158 + `t1'*4

reg ten_y other_ten_y i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0'
		
reg ten_y other_ten_y urate i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0'
		
reg ten_y other_ten_y  i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0'
		
reg ten_y other_ten_y urate i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0'
		

sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)
		
sqreg ten_y other_ten_y ttrend i.sexo1#c.ttrend i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)	
		
sqreg ten_y other_ten_y i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)
		
sqreg ten_y other_ten_y urate i.sexo1#c.urate i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)

sqreg ten_y other_ten_y i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)
		
sqreg ten_y other_ten_y urate i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)
		
sqreg ten_y other_ten_y urate i.sexo1#c.urate i.covid##i.sexo1 ///
		part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
		other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35&ciclo>=`y0', ///
		q(.25 .5 .75)
}
log close
// * More year detail interactions * * * * * * * * * * * * * * * * * * * * * * 
// log close _all
// log using "./results/sqtreg_mothers_3035_hemp_time_int.log", replace nomsg
// sqreg wife_ten_y hub_ten_y i.period_y#c.hub_ten_y part_time /// 
// 		college less_hs hub_age hub_se hub_college hub_less_hs ///
// 		i.period_y  if mother==1&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
// log close
//
// log using "./results/sqtreg_mothers_3035_hemp_time_int_0k.log", replace nomsg
// sqreg wife_ten_y hub_ten_y i.period_y#c.hub_ten_y part_time /// 
// 		college less_hs hub_age hub_se hub_college hub_less_hs ///
// 		i.period_y  if mother==0&wife==1&employed&age>=30&age<35, q(.25 .5 .75) 
// log close
//
//
// log using "./results/sqtreg_fathers_3035_hemp_time_int.log", replace nomsg
// sqreg hub_ten_y wife_ten_y i.period_y#c.wife_ten_y part_time /// 
// 		college less_hs wife_age wife_se wife_college wife_less_hs ///
// 		i.period_y  if father==1&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
// log close
//
// log using "./results/sqtreg_fathers_3035_hemp_time_int_0k.log", replace nomsg
// sqreg hub_ten_y wife_ten_y i.period_y#c.wife_ten_y part_time /// 
// 		college less_hs wife_age wife_se wife_college wife_less_hs ///
// 		i.period_y  if father==0&husband==1&employed&age>=30&age<35, q(.25 .5 .75) 
//
//
// * Descriptive stats by percentile * * * * * * * * * * * * * * * * * *
// log close _all
drop ten_sgroup_other ten_group_quant ten_group_quant_other
gen ten_group_quant = 0
gen ten_group_quant_other = 0

// Based on
tabstat wife_ten_y if father==1&husband==1&age>=30&age<35, s(p25 p50 p75) save

// //     Variable |       p25       p50      Mean       p75
// // -------------+----------------------------------------
// //   wife_ten_y |       1.5  4.833333  5.436043  8.666667
// // ------------------------------------------------------

mat total = r(StatTotal)

local tlow = 0
forval t1=1/3{
	local thigh = total[`t1',1]
// 	replace ten_group_quant = `t1' if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`tlow'&wife_ten_y<`thigh'
	replace ten_group_quant_other = `t1' if father==1&husband==1&age>=30&age<35&wife_ten_y>=`tlow'&wife_ten_y<`thigh'
	local tlow = total[`t1',1]
}
// replace ten_group_quant = 4 if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`tlow'
replace ten_group_quant_other = 4 if father==1&husband==1&age>=30&age<35&wife_ten_y>=`tlow'
//
tabstat wife_ten_y if father==0&husband==1&age>=30&age<35, s(p25 p50 p75) save
mat total = r(StatTotal)

local tlow = 0
forval t1=1/3{
	local thigh = total[`t1',1]
// 	replace ten_group_quant = `t1' if mother==0&wife==1&age>=30&age<35&wife_ten_y>=`tlow'&wife_ten_y<`thigh'
	replace ten_group_quant_other = `t1' if father==0&husband==1&age>=30&age<35&wife_ten_y>=`tlow'&wife_ten_y<`thigh'
	local tlow = total[`t1',1]
}
// replace ten_group_quant = 4 if mother==0&wife==1&age>=30&age<35&wife_ten_y>=`tlow'
replace ten_group_quant_other = 4 if father==0&husband==1&age>=30&age<35&wife_ten_y>=`tlow'
//
// Now men / / / / / / / / /

tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35, s(p25 p50 p75) save
mat total = r(StatTotal)

local tlow = 0
forval t1=1/3{
	local thigh = total[`t1',1]
// 	replace ten_group_quant = `t1' if father==1&husband==1&age>=30&age<35&hub_ten_y>=`tlow'&hub_ten_y<`thigh'
	replace ten_group_quant_other = `t1' if mother==1&wife==1&age>=30&age<35&hub_ten_y>=`tlow'&hub_ten_y<`thigh'
	local tlow = total[`t1',1]
}
// replace ten_group_quant = 4 if father==1&husband==1&age>=30&age<35&hub_ten_y>=`tlow'
replace ten_group_quant_other = 4 if mother==1&wife==1&age>=30&age<35&hub_ten_y>=`tlow'

tabstat hub_ten_y if mother==0&wife==1&age>=30&age<35, s(p25 p50 p75) save
mat total = r(StatTotal)

local tlow = 0
forval t1=1/3{
	local thigh = total[`t1',1]
// 	replace ten_group_quant = `t1' if father==0&husband==1&age>=30&age<35&hub_ten_y>=`tlow'&hub_ten_y<`thigh'
	replace ten_group_quant_other = `t1' if mother==0&wife==1&age>=30&age<35&hub_ten_y>=`tlow'&hub_ten_y<`thigh'
	local tlow = total[`t1',1]
}
// replace ten_group_quant = 4 if father==0&husband==1&age>=30&age<35&hub_ten_y>=`tlow'
replace ten_group_quant_other = 4 if mother==0&wife==1&age>=30&age<35&hub_ten_y>=`tlow'

gen ten_sgroup_other = 0
replace ten_sgroup_other = 1 if ten_group_quant_other<2
replace ten_sgroup_other = 3 if ten_group_quant_other>2
replace ten_sgroup_other = 2 if ten_group_quant_other==2

// Now Regression time!

forval t1=1/3{
	log close _all
	log using "./results/sqtreg_3035_hemp_time_int_diff_simple_t`t1'.log", replace nomsg
	sqreg ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
			if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35& ///
			ten_sgroup_other== `t1', q(.25 .5 .75)
	log close 

	log using "./results/sqtreg_3035_hemp_time_int_diff_simple_t`t1'_0k.log", replace nomsg
	sqreg ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
			if ((mother==0&wife==1)|(father==0&husband==1))&employed&age>=30&age<35& ///
			ten_sgroup_other== `t1', q(.25 .5 .75)
	log close 

	log using "./results/sqtreg_3035_hemp_time_int_diff_t`t1'.log", replace nomsg
	sqreg ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
			part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
			other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
			if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35& ///
			ten_sgroup_other== `t1', q(.25 .5 .75)
	log close 

	log using "./results/sqtreg_3035_hemp_time_int_diff_t`t1'_0k.log", replace nomsg
	sqreg ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
			part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
			other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
			if ((mother==0&wife==1)|(father==0&husband==1))&employed&age>=30&age<35& ///
			ten_sgroup_other== `t1', q(.25 .5 .75)
	log close 
}


// log using "./results/descriptive_stats_tenure_mothers_all.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.5  4.833333  8.666667 20{
// 	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1', s(p25 p50 mean p75 n)
// 	local t0 = `t1'
// }
// log close
//
// log using "./results/descriptive_stats_tenure_mothers_college.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.5  4.833333  8.666667 20{
// 	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
// 	local t0 = `t1'
// }
// log close
//
// // Based on
// // tabstat wife_ten_y if mother==0&wife==1&age>=30&age<35, s(p25 p50 mean p75)
// //     Variable |       p25       p50      Mean       p75
// // -------------+----------------------------------------
// //   wife_ten_y |       1.5         4  4.673674  7.083333
// // ------------------------------------------------------
//
// tabstat wife_ten_y if mother==0&wife==1&age>=30&age<35, s(p25 p50 mean p75)
//
// log using "./results/descriptive_stats_tenure_mothers_all_0k.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.5 4 7.083333 20{
// 	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1', s(p25 p50 mean p75 n)
// 	local t0 = `t1'
// }
// log close
//
// log using "./results/descriptive_stats_tenure_mothers_college_0k.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.5 4 7.083333 20{
// 	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
// 	local t0 = `t1'
// }
// log close
//
// //Based on
// // tabstat hub_ten_y if father==1&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
// //     Variable |       p25       p50       p75      Mean
// // -------------+----------------------------------------
// //    hub_ten_y |  1.666667  5.083333  9.333333  5.918592
// // ------------------------------------------------------
// log using "./results/descriptive_stats_tenure_fathers_all.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.666667  5.083333  9.333333 20{
// 	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
// 	local t0 = `t1'
// }
// log close
//
// log using "./results/descriptive_stats_tenure_fathers_college.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.666667  5.083333  9.333333 20{
// 	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
// 	local t0 = `t1'
// }
// log close
//
// //Based on
// // tabstat hub_ten_y if father==0&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
// //     Variable |       p25       p50       p75      Mean
// // -------------+----------------------------------------
// //    hub_ten_y |  1.666667       4.5  8.083333  5.332496
// // ------------------------------------------------------
// log using "./results/descriptive_stats_tenure_fathers_all_0k.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.666667       4.5  8.083333 20{
// 	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
// 	local t0 = `t1'
// }
// log close
//
// log using "./results/descriptive_stats_tenure_fathers_college_0k.log", replace nomsg
// local t0 = 0
// foreach t1 in 1.666667       4.5  8.083333 20{
// 	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
// 	local t0 = `t1'
// }
// log close
