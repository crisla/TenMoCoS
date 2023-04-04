*
* Probability of being permanent and inactive
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all 

* Astrid's version
// global path "C:\Users\asruland\OneDrive - Istituto Universitario Europeo\Spanish_LFS_Cross"
* Cristina's version
// global path "C:\Users\lafuentemart\Documents\TenMoCoS\"
//
// cd $path

use "./formatting/rawfiles/EPA_stocks20_parents.dta", clear

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

capture log close
log using "./descriptive_stats/rznotb_w_age3040_w.log", replace nomsg
tab ciclo rznotb if age3040&woman [fweight=facexp]
log close

log using "./descriptive_stats/rznotb_m_age3040_w.log", replace nomsg
tab ciclo rznotb if age3040&woman==0 [fweight=facexp]
log close

log using "./descriptive_stats/rznotb_w_age3040_10_w.log", replace nomsg
tab ciclo rznotb if age3040&woman&mother_10 [fweight=facexp]
log close

log using "./descriptive_stats/rznotb_m_age3040_10_w.log", replace nomsg
tab ciclo rznotb if age3040&woman==0&father_10 [fweight=facexp]
log close

**# Variable adaptation * * * * * * * * * 
drop period_y
replace period_t = "t22" if (ciclo>=198)
encode period_t, generate(period_y)

drop if age<20
drop if age>50

gen temporary = state=="T"
gen self_emp = state=="A"
gen unemployed = state=="U"

keep permanent temporary self_emp unemployed age act occ public_servant married parent parent_* part_time erte age college tenure ciclo mili woman factorel inactive wife_ten_y hub_ten_y wife_ten_y2 hub_ten_y2 less_hs hub_age wife_age hub_se wife_se hub_college wife_college hub_less_hs wife_less_hs period_y mother mother_* employed father father_* wife husband sexo1 ten_y other_ten_y ttrend ttrend2 covid other_se other_college other_less_hs yd ocup1 married_parent married_parent_* act1


* Add unemployment data
merge m:1 ciclo using "./other_data/urate_spain.dta"
drop _merge

gen age2550 = 0
replace age2550 = 1 if age>=25&age<50

gen age3045 = 0
replace age3045 = 1 if age>=30&age<45

gen age3035 = 0
replace age3035 = 1 if age>=30&age<35

gen age3540 = 0
replace age3540 = 1 if age>=35&age<40

gen age4045 = 0
replace age4045 = 1 if age>=40&age<45

gen age3050 = 0
replace age3050 = 1 if age>=30&age<50

gen age2530 = 0
replace age2530 = 1 if age>=25&age<30

*** Tenure bins
gen tenure_bin=.
replace tenure_bin = 1 if tenure>=0&tenure<24
replace tenure_bin = 2 if tenure>=24&tenure<60
replace tenure_bin = 3 if tenure>=60&tenure<120
replace tenure_bin = 4 if tenure>=120&tenure<180
replace tenure_bin = 5 if tenure>=180&tenure<240
replace tenure_bin = 6 if tenure>=240&tenure<360
replace tenure_bin = 7 if tenure>=360&tenure!=.

gen other_ten_y_bin = .
replace other_ten_y_bin = 1 if other_ten_y>=0&other_ten_y<2
replace other_ten_y_bin = 2 if other_ten_y>=2&other_ten_y<5
replace other_ten_y_bin = 3 if other_ten_y>=5&other_ten_y<10
replace other_ten_y_bin = 4 if other_ten_y>=10&other_ten_y<15
replace other_ten_y_bin = 5 if other_ten_y>=15&other_ten_y<20
replace other_ten_y_bin = 6 if other_ten_y>=20&other_ten_y<30
replace other_ten_y_bin = 7 if other_ten_y>=30&other_ten_y!=.

gen wife_ten_y_bin = .
replace wife_ten_y_bin = 1 if wife_ten_y>=0&wife_ten_y<2
replace wife_ten_y_bin = 2 if wife_ten_y>=2&wife_ten_y<5
replace wife_ten_y_bin = 3 if wife_ten_y>=5&wife_ten_y<10
replace wife_ten_y_bin = 4 if wife_ten_y>=10&wife_ten_y<15
replace wife_ten_y_bin = 5 if wife_ten_y>=15&wife_ten_y<20
replace wife_ten_y_bin = 6 if wife_ten_y>=20&wife_ten_y<30
replace wife_ten_y_bin = 7 if wife_ten_y>=30&wife_ten_y!=.

gen hub_ten_y_bin = .
replace hub_ten_y_bin = 1 if hub_ten_y>=0&hub_ten_y<2
replace hub_ten_y_bin = 2 if hub_ten_y>=2&hub_ten_y<5
replace hub_ten_y_bin = 3 if hub_ten_y>=5&hub_ten_y<10
replace hub_ten_y_bin = 4 if hub_ten_y>=10&hub_ten_y<15
replace hub_ten_y_bin = 5 if hub_ten_y>=15&hub_ten_y<20
replace hub_ten_y_bin = 6 if hub_ten_y>=20&hub_ten_y<30
replace hub_ten_y_bin = 7 if hub_ten_y>=30&hub_ten_y!=.

*** Occupation groupscapture drop occgroup
capture drop occgroup
gen occgroup=.
replace occgroup=1 if ocup1==1 | ocup1==2
replace occgroup=2 if ocup1==3 | ocup1==4
replace occgroup=3 if ocup1==5
replace occgroup=4 if ocup1==6 | ocup1==7 | ocup1==8
replace occgroup=5 if ocup1==9

gen season=0
gen count = 1
* Create seasonal dummy
forvalues i=130/201{ 
	replace season = count if ciclo==`i'
	replace count = count + 1
	replace count = 1 if count==5
}

drop woman
gen woman = sexo1==1

*** Occupations for summary statistics
gen occ_0 = ocup1==0
gen occ_1 = ocup1==1
gen occ_2 = ocup1==2
gen occ_3 = ocup1==3
gen occ_4 = ocup1==4
gen occ_5 = ocup1==5
gen occ_6 = ocup1==6
gen occ_7 = ocup1==7
gen occ_8 = ocup1==8
gen occ_9 = ocup1==9

*** Industry for summary statistics
gen act_0 = act==0
gen act_1 = act==1
gen act_2 = act==2
gen act_3 = act==3
gen act_4 = act==4
gen act_5 = act==5
gen act_6 = act==6
gen act_7 = act==7
gen act_8 = act==8
gen act_9 = act==9


drop if age<30
drop if age>40

* Save estimation stings 
global year_0522 "m2005 m2006 m2007 m2008 m2009 m2010 m2011 m2012 m2013 m2014 m2015 m2016 m2017 m2018 m2019 m2020 m2021 m2022"
global q1922 "m186 m187 m188 m189 m190 m191 m192 m193 m194 m195 m196 m197 m198 m199 m200 m201"
global q0522 "m130 m131 m132 m133 m134 m135 m136 m137 m138 m139 m140 m141 m142 m143 m144 m145 m146 m147 m148 m149 m150 m151 m152 m153 m154 m155 m156 m157 m158 m159 m160 m161 m162 m163 m164 m165 m166 m167 m168 m169 m170 m171 m172 m173 m174 m175 m176 m177 m178 m179 m180 m181 m182 m183 m184 m185 m186 m187 m188 m189 m190 m191 m192 m193 m194 m195 m196 m197 m198 m199 m200 m201"

*global age_group "age3035 age3540 age4045 age3040 age3045" 

global age_group "age3035 age3540 age3040" 

*global parent_string "parent_5 parent_10 parent_15"

global parent_string "parent_5 parent_10 parent_15"


**# Regressions * * * * * * * * * 
* Figure 2 & 3 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
* 130 - 201 = 2005Q1 = 2022Q4
* age = age
log using "./regtabs/prob_perm_trial_3040_cohab.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age if ciclo==`i'&mili==0&age3040==1&woman==1&wife==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0)) [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_trial_3040_cohab_restrict.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age if ciclo==`i'&mili==0&age3040==1&woman==1&wife==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0))&act!=. [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_trial_inds_3040_cohab.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age i.act if ciclo==`i'&mili==0&age3040==1&woman==1&wife==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0)) [pw=factorel], vce(robust)
}
log close

* Men - robustness * * * * * * * * * * * * * * * * * * * *

log using "./regtabs/prob_perm_trial_m_3040_cohab.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age if ciclo==`i'&mili==0&age3040==1&woman==0&husband==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0)) [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_trial_3040_m_cohab_restrict.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age if ciclo==`i'&mili==0&age3040==1&woman==0&husband==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0))&act!=. [pw=factorel], vce(robust)
}
log close

log using "./regtabs/prob_perm_trial_inds_3040_m_cohab.log", replace nomsg
forvalues i=170/201{
logistic permanent parent_10 i.age i.act if ciclo==`i'&mili==0&woman==0&husband==1&(parent_10==1|(parent_10==0&parent_15==0&parent_5==0)) [pw=factorel], vce(robust)
}
log close

// i.act i.occ public_servant parent_10  part_time college erte i.age
