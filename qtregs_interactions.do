* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Quatile regresisons
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "formatting/rawfiles/EPA_stocks20_parents.dta", clear

**# Part 1: Generate key indicator variables * * * * * * * * * 

destring(relpp1), replace

sort ciclo nvivi relpp1

by ciclo nvivi: gen wife = (sexo1==6&((relpp1==1&relpp1[_n+1]==2)|(relpp1==2&relpp1[_n-1]==1)))
by ciclo nvivi: gen husband = (sexo1==1&((relpp1==1&relpp1[_n+1]==2)|(relpp1==2&relpp1[_n-1]==1)))

* Age restriction
replace wife = 0 if wife==1&(edad5<20|edad5>50)
replace husband = 0 if husband==1&(edad5<20|edad5>50)

**#  Part 2: Generate labour market x 0k variables * * * * * * * * *

sort ciclo nvivi wife
by ciclo nvivi: gen wife_state = state[_N] if wife[_N]==1
by ciclo nvivi: gen wife_erte = erte[_N] if wife[_N]==1
by ciclo nvivi: gen wife_ten = dcom[_N] if wife[_N]==1
by ciclo nvivi: gen wife_ten0 = dcom[_N] if wife[_N]==1
by ciclo nvivi: replace wife_ten0 = 0 if wife[_N]==1&(state[_N]=="U"|state[_N]=="I")
by ciclo nvivi: gen wife_age = edad5[_N] if wife[_N]==1
by ciclo nvivi: gen wife_college = (nforma[_N]=="SU") if wife[_N]==1
by ciclo nvivi: gen wife_less_hs = (nforma[_N]=="P2"|nforma[_N]=="P1"|nforma[_N]=="AN") if wife[_N]==1
by ciclo nvivi: gen no_wife = wife[_N]==0

by ciclo nvivi: gen educ_level_wife = "high_school" if wife[_N]==1&nforma[_N]!=""
by ciclo nvivi: replace educ_level_wife = "less_than_hs" if wife_less_hs==1
by ciclo nvivi: replace educ_level_wife = "college" if wife_college==1

sort ciclo nvivi husband
by ciclo nvivi: gen hub_state = state[_N] if husband[_N]==1
by ciclo nvivi: gen hub_erte = erte[_N] if husband[_N]==1
by ciclo nvivi: gen hub_ten = dcom[_N] if husband[_N]==1
by ciclo nvivi: gen hub_ten0 = dcom[_N] if husband[_N]==1
by ciclo nvivi: replace hub_ten0 = 0 if husband[_N]==1&(state[_N]=="U"|state[_N]=="I")
by ciclo nvivi: gen hub_age = edad5[_N] if husband[_N]==1
by ciclo nvivi: gen hub_college = (nforma[_N]=="SU") if husband[_N]==1
by ciclo nvivi: gen hub_less_hs = (nforma[_N]=="P2"|nforma[_N]=="P1"|nforma[_N]=="AN") if husband[_N]==1
by ciclo nvivi: gen no_hub = husband[_N]==0

by ciclo nvivi: gen educ_level_hub = "high_school" if husband[_N]==1&nforma[_N]!=""
by ciclo nvivi: replace educ_level_hub = "less_than_hs" if hub_less_hs==1
by ciclo nvivi: replace educ_level_hub = "college" if hub_college==1

* Go back to normal order
sort ciclo nvivi npers

gen tenure_ratio_0k = log(dcom/hub_ten) if wife==1

gen wife_ten_y = wife_ten/12
gen hub_ten_y = hub_ten/12
gen wife_ten_y2 = wife_ten_y^2
gen hub_ten_y2 = hub_ten_y^2

gen wife_ten0_y = wife_ten0/12
gen hub_ten0_y = hub_ten0/12
gen wife_ten0_y2 = wife_ten0_y^2
gen hub_ten0_y2 = hub_ten0_y^2

* Coarse tenure groups: in 5 year goups up until 30
gen wife_ten_g5 = 0 if wife_ten_y!=.&wife_ten_y<1
gen hub_ten_g5 = 0 if hub_ten_y!=.&hub_ten_y<1

forvalues t = 5(5)25  {

	replace wife_ten_g5 = `t' if (wife_ten_y<=`t'+5&wife_ten_y>`t'&wife_ten_y!=.)
	replace hub_ten_g5 = `t' if (hub_ten_y<=`t'+5&hub_ten_y>`t'&hub_ten_y!=.)
}

replace wife_ten_g5 = 30 if wife_ten_y>30&wife_ten_y!=.
replace hub_ten_g5 = 30 if hub_ten_y>30&hub_ten_y!=.

**# Part 2: indicator variables for regressions * * * * * * * * * 

gen age = edad5

gen age2 = age*age

gen hub_age2 = hub_age*hub_age

gen wife_age2 = wife_age*wife_age

gen part_time = (parco1=="6")

gen college = (nforma=="SU")

gen less_hs = (nforma=="P2"|nforma=="P1"|nforma=="AN")

gen employed = (state=="P"|state=="T")

gen pc_dummy = (state=="P")

gen hub_pc = (hub_state=="P")

gen hub_emp = (hub_state=="P"|hub_state=="T")

gen hub_se = (hub_state=="A")

gen wife_pc = (wife_state=="P")

gen wife_emp = (wife_state=="P"|wife_state=="T")

gen wife_se = (wife_state=="A")

* For descriptive stats
gen educ_level = 1 if nforma!=""
replace educ_level = 0 if less_hs==1
replace educ_level = 2 if college==1

replace act1 = acta if act1==""
replace ocup1 = ocupa if ocup1==""
destring(act1 ocup1 ccaa), replace

* linear aggreagte trends
gen period_t = "t05_08" if (ciclo>=130&ciclo<142)
replace period_t = "t08_11" if (ciclo>=142&ciclo<154)
replace period_t = "t11_14" if (ciclo>=154&ciclo<166)
replace period_t = "t14_17" if (ciclo>=166&ciclo<178)
replace period_t = "t17_20" if (ciclo>=178&ciclo<190)
// gen t20Q1 = (ciclo==190)
// gen t20Q2 = (ciclo==191)
// gen t20Q3 = (ciclo==192)
// gen t20Q4 = (ciclo==193)
replace period_t = "t20" if (ciclo>=190&ciclo<194)
replace period_t = "t21" if (ciclo>193)
// gen t20_21 = (ciclo>=190)
encode period_t, generate(period_y)

gen yd = 0
local yy = 2005
forvalues t = 130(4)198  {

	replace yd = `yy' if (ciclo>=`t'&ciclo<`t'+4)
	local yy = `yy'+1
}
drop if yd==0

* Mean before 2008
gen yd_mean = yd
replace yd_mean = 2005 if yd_mean<2008

* logs
gen lwife_ten_y = log(wife_ten_y) 
gen lhub_ten_y = log(hub_ten_y)

**# Part 2: regressions * * * * * * * * * 


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


* Descriptive stats by percentile * * * * * * * * * * * * * * * * * *
log close _all

// Based on
// tabstat wife_ten_y if mother==1&wife==1&age>=30&age<35, s(p25 p50 mean p75)
//     Variable |       p25       p50      Mean       p75
// -------------+----------------------------------------
//   wife_ten_y |       1.5  4.833333  5.436043  8.666667
// ------------------------------------------------------

log using "./results/descriptive_stats_tenure_mothers_all.log", replace nomsg
local t0 = 0
foreach t1 in 1.5  4.833333  8.666667 20{
	tabstat hub_ten_y if mother==1&wife==1&age>=30&age<35&wife_ten_y>=`t0'&wife_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_mothers_college.log", replace nomsg
local t0 = 0
foreach t1 in 1.5  4.833333  8.666667 20{
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

tabstat wife_ten_y if mother==0&wife==1&age>=30&age<35, s(p25 p50 mean p75)

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
// tabstat hub_ten_y if father==1&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
//     Variable |       p25       p50       p75      Mean
// -------------+----------------------------------------
//    hub_ten_y |  1.666667  5.083333  9.333333  5.918592
// ------------------------------------------------------
log using "./results/descriptive_stats_tenure_fathers_all.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667  5.083333  9.333333 20{
	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_fathers_college.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667  5.083333  9.333333 20{
	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close

//Based on
// tabstat hub_ten_y if father==0&husband==1&edad5>=30&edad5<35, s(p25 p50 p75 mean)
//     Variable |       p25       p50       p75      Mean
// -------------+----------------------------------------
//    hub_ten_y |  1.666667       4.5  8.083333  5.332496
// ------------------------------------------------------
log using "./results/descriptive_stats_tenure_fathers_all_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667       4.5  8.083333 20{
	tabstat wife_ten_y if father==1&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1', s(p25 p50 mean p75 n)
	local t0 = `t1'
}
log close

log using "./results/descriptive_stats_tenure_fathers_college_0k.log", replace nomsg
local t0 = 0
foreach t1 in 1.666667       4.5  8.083333 20{
	tabstat wife_ten_y if father==0&husband==1&edad5>=30&edad5<35&hub_ten_y>=`t0'&hub_ten_y<`t1'&college==1&hub_college==1, s(p25 p50 p75 mean n)
	local t0 = `t1'
}
log close