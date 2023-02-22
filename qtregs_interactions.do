* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Part 1: descriptive stats by group * * * * * * * * * 
log using "./results/descriptive_stats_tenure.log", replace nomsg

levelsof educ_level, local(levels) 
foreach l of local levels {
* All
tabstat hub_ten_y if wife==1&mother==1&employed&age<45&educ_level==`l', s(mean p25 p50 p75) by(educ_level_hub)
tabstat hub_ten_y if wife==1&mother==0&employed&age<45&educ_level==`l', s(mean p25 p50 p75) by(educ_level_hub)

tabstat wife_ten_y if husband==1&father==1&employed&age<45&educ_level==`l', s(mean p25 p50 p75) by(educ_level_wife)
tabstat wife_ten_y if husband==1&father==0&employed&age<45&educ_level==`l', s(mean p25 p50 p75) by(educ_level_wife)

* Early 30s
tabstat hub_ten_y if wife==1&mother==1&employed&edad5>=30&edad5<35&educ_level==`l', s(mean p25 p50 p75) by(educ_level_hub)
tabstat hub_ten_y if wife==1&mother==0&employed&edad5>=30&edad5<35&educ_level==`l', s(mean p25 p50 p75) by(educ_level_hub)

tabstat wife_ten_y if husband==1&father==1&employed&edad5>=30&edad5<35&educ_level==`l', s(mean p25 p50 p75) by(educ_level_wife)
tabstat wife_ten_y if husband==1&father==0&employed&edad5>=30&edad5<35&educ_level==`l', s(mean p25 p50 p75) by(educ_level_wife)

 }
 *
 
**# Part 2: Descriptive stats by percentile * * * * * * * * * * * * * * * * * *
log close _all

// Based on
//tabstat wife_ten_y if mother==1&wife==1&age>=30&age<35, s(p25 p50 mean p75)
//     Variable |       p25       p50      Mean       p75
// -------------+----------------------------------------
//   wife_ten_y |       1.5  4.833333  5.419765  8.583333
// ------------------------------------------------------

log using "./results/descriptive_stats_tenure_mothers_all.log", replace nomsg
local t0 = 0
foreach t1 in 1.5  4.833333  8.583333 20{
	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_mothers_college.log", replace nomsg
local t0 = 0
foreach t1 in 1.5  4.833333  8.583333 20{
	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close

// Based on
// tabstat wife_ten_y if mother==0&wife==1&age>=30&age<35, s(p25 p50 mean p75)
//     Variable |       p25       p50      Mean       p75
// -------------+----------------------------------------
//   wife_ten_y |       1.5         4  4.673674  7.083333
// ------------------------------------------------------

log using "./results/descriptive_stats_tenure_mothers_all_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.5 4 7.083333 20{
	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_mothers_college_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.5 4 7.083333 20{
	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close

//Based on
//tabstat hub_ten_y if father==1&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
//     Variable |       p25       p50       p75      Mean
// -------------+----------------------------------------
//    hub_ten_y |  1.666667         5      9.25  5.912302
// ------------------------------------------------------
log using "./results/descriptive_stats_tenure_fathers_all.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667 5 9.25 20{
	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_fathers_college.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667 5 9.25 20{
	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close

//Based on
//tabstat hub_ten_y if father==0&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
//     Variable |       p25       p50       p75      Mean
// -------------+----------------------------------------
//    hub_ten_y |  1.666667       4.5  		  8  5.329261
// ------------------------------------------------------
log using "./results/descriptive_stats_tenure_fathers_all_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667       4.5  8 20{
	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_fathers_college_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667       4.5  8 20{
	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close


**# Part 3: regressions * * * * * * * * * 


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


