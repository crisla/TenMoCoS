* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Robustness Checks
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all 

* Insert here the path to your local repo folder
global path "C:\Users\lafuentemart\Documents\TenMoCoS\"

cd $path

use "./formatting/rawfiles/EPA_stocks20_parents.dta", clear

* If not using 2022
// drop period_y
// replace period_t = "t22" if (ciclo>=200)
// encode period_t, generate(period_y)

* Age restrictions
drop if age<20
drop if age>50

* State indicators
gen temporary = state=="T"
gen self_emp = state=="A"
gen unemployed = state=="U"

* Make dataset lighter
keep permanent temporary self_emp unemployed age act occ public_servant married parent parent_* divorced widowed part_time erte age college tenure ciclo mili woman factorel inactive wife_ten_y hub_ten_y wife_ten_y2 hub_ten_y2 less_hs hub_age wife_age hub_se wife_se hub_college wife_college hub_less_hs wife_less_hs period_y mother mother_* employed father father_* wife husband sexo1 ten_y other_ten_y ttrend ttrend2 covid other_se other_college other_less_hs yd ocup1 married_parent married_parent_* act1

* Add unemployment data
merge m:1 ciclo using "./other_data/urate_spain.dta"
drop _merge

* Age range indicators
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

gen age3040 = 0
replace age3040 = 1 if age>=30&age<40

gen age3050 = 0
replace age3050 = 1 if age>=30&age<50

gen age2530 = 0
replace age2530 = 1 if age>=25&age<30

* Tenure bins
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

* Occupation groups
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

* Redine gender dummy
drop woman
gen woman = sexo1==1

* Occupations for summary statistics
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

* Industry for summary statistics
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

* Save estimation stings 
global year_0522 "m2005 m2006 m2007 m2008 m2009 m2010 m2011 m2012 m2013 m2014 m2015 m2016 m2017 m2018 m2019 m2020 m2021 m2022"
global q1922 "m186 m187 m188 m189 m190 m191 m192 m193 m194 m195 m196 m197 m198 m199 m200 m201"
global q0522 "m130 m131 m132 m133 m134 m135 m136 m137 m138 m139 m140 m141 m142 m143 m144 m145 m146 m147 m148 m149 m150 m151 m152 m153 m154 m155 m156 m157 m158 m159 m160 m161 m162 m163 m164 m165 m166 m167 m168 m169 m170 m171 m172 m173 m174 m175 m176 m177 m178 m179 m180 m181 m182 m183 m184 m185 m186 m187 m188 m189 m190 m191 m192 m193 m194 m195 m196 m197 m198 m199 m200 m201"

*global age_group "age3035 age3540 age4045 age3040 age3045" 

global age_group "age3035 age3540 age3040" 

*global parent_string "parent_5 parent_10 parent_15"

global parent_string "parent_5 parent_10 parent_15"



**# Quantile regressions: Figure 9 * * * * * * * * * * * * * * * * * * * *

capture log close
log using "./results/sqtreg_mothers_age3040_10_agefix.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.age if mother_10==1&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_age3040_10_agefix.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.age if mother_15==0&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_age3040_10_agefix.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.age if father_10==1&husband==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_age3040_10_agefix.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.age if father_15==0&husband==1&employed&age3040==1, q(.25 .5 .75) 

* Robustness: other age groups (uncomment)	
/*
global parent_string_short "_5 _10 _15"
foreach ag of global age_group{
foreach par of global parent_string_short {
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

log using "./tables/sqtreg_table_industry_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.act1 i.covid##i.sexo1#i.act1 ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close	

log using "./tables/sqtreg_table_urateinteraction_`ag'_`par'.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend urate i.occgroup c.urate##i.sexo1#i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close
}
}

* Robustness: fewer controls
log using "./tables/sqtreg_table_simple_age3040__10_agefix.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.sexo1##i.age i.covid##i.sexo1 ///
                if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                q(.25 .5 .75)
log close

log using "./tables/sqtreg_table_advanced_simple_age3040__10_agefix.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.sexo1##i.age i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)  				
log close
*/

* Industry tenure qunatile regression for 30-40 with age fixed affects
capture log close
log using "./tables/sqtreg_table_industry_age3040_10_agefix.log", replace nomsg
	eststo: sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.act1 i.covid##i.sexo1#i.act1 i.age ///
               if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, q(.25 .5 .75)  				
log close
esttab using "./regtabs/tex/sqtreg_table_industry_age3040_10_agefix.tex", se eform label replace

* Regressions with occupation controls
capture log close
log using "./results/sqtreg_mothers_age3040_10_occ_agefix.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.occgroup i.age if mother_10==1&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_age3040_10_occ_agefix.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.occgroup i.age if mother_15==0&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_age3040_10_occ_agefix.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.occgroup i.age if father_10==1&husband==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_age3040_10_occ_agefix.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.occgroup i.age if father_15==0&husband==1&employed&age3040==1, q(.25 .5 .75) 
log close

/*
* Regressions with occupation and industry controls
foreach ag of global age_group {
foreach par of global child_string {
log using "./results/sqtreg_mothers_`ag'_`par'_occ.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.occgroup if mother`par'==1&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_`ag'_`par'_occ.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.occgroup if father`par'==1&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_`ag'_`par'_ind.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.act if mother`par'==1&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_`ag'_`par'_ind.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.act if father`par'==1&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close

}
log using "./results/sqtreg_mothers_0k_`ag'_occ.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.occgroup if mother_20==0&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_`ag'_occ.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.occgroup if father_20==0&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_`ag'_ind.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.act1 if mother_20==0&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_`ag'_ind.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.act1 if father_20==0&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close

}
*/

/*
* Regressions with tneure of the partner in bins
log using "./results/sqtreg_mothers_age3040__10_agefixtenbin.log", replace nomsg
sqreg wife_ten_y i.hub_ten_y_bin part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.age if mother_10==1&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_0k_age3040__10_agefixtenbin.log", replace nomsg		
sqreg wife_ten_y i.hub_ten_y_bin part_time /// 
		college less_hs i.hub_age hub_se hub_college hub_less_hs ///
		i.period_y i.age if mother_20==0&wife==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_age3040__10_agefixtenbin.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y_bin part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.age if father_10==1&husband==1&employed&age3040==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_age3040__10_agefixtenbin.log", replace nomsg
sqreg hub_ten_y i.wife_ten_y_bin part_time /// 
		college less_hs i.wife_age wife_se wife_college wife_less_hs ///
		i.period_y i.age if father_20==0&husband==1&employed&age3040==1, q(.25 .5 .75) 
log close
*/
/*
* Figure 9 different age groups (parents and children) * * * * * * * * * * * * * * * * * * * *
foreach ag of global age_group {
foreach par of global child_string {
log using "./results/sqtreg_`ag'_`par'_hemp_time_int_diff.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close
}

log using "./results/sqtreg_`ag'_hemp_time_int_diff_0k.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close
}

*/
/*
* Not conditioning on whether the husband is employed or not
global child_string "_5 _10 _15"
foreach ag of global age_group {
foreach par of global child_string {
log using "./results/sqtreg_mothers_`ag'_`par'.log", replace nomsg
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y  if mother`par'==1&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_`ag'_`par'.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father`par'==1&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close
}
log using "./results/sqtreg_mothers_0k_`ag'.log", replace nomsg		
sqreg wife_ten_y hub_ten_y hub_ten_y2 part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs ///
		i.period_y if mother_20==0&wife==1&employed&`ag'==1, q(.25 .5 .75) 
log close

log using "./results/sqtreg_fathers_0k_`ag'.log", replace nomsg
sqreg hub_ten_y wife_ten_y wife_ten_y2 part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs ///
		i.period_y  if father_20==0&husband==1&employed&`ag'==1, q(.25 .5 .75) 
log close
}
*/

/*
global age_group_short "age3040"
global child_string_short "_10"
foreach ag of global age_group_short {
foreach par of global child_string_short {
log using "./results/sqtreg_`ag'_`par'_hemp_time_int_diff_occ.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.occgroup ///
                 if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

log using "./results/sqtreg_`ag'_`par'_hemp_time_int_diff_ind.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.act1 ///
                 if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

}

log using "./results/sqtreg_`ag'_hemp_time_int_diff_0k_occ.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.occgroup ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

log using "./results/sqtreg_`ag'_hemp_time_int_diff_0k_ind.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.act1 ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)
log close

}
*/

**# Official figure 9
log using "./results/sqtreg_age3040_10_hemp_time_int_diff_agefix.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.age ///
                 if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)
log close


log using "./results/sqtreg_age3040_hemp_time_int_diff_0k_agefix.log", replace nomsg
sqreg ten_y other_ten_y ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.age ///
                 if ((mother_10==0&wife==1)|(father_10==0&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)
log close

* figure 9 with partner's tenure in bins
/*
log using "./results/sqtreg_age3040__10_hemp_time_int_diff_agefixtenbin.log", replace nomsg
sqreg ten_y other_ten_y_bin ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.age ///
                 if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)
log close


log using "./results/sqtreg_age3040_hemp_time_int_diff_0k_agefixtenbin.log", replace nomsg
sqreg ten_y other_ten_y_bin ttrend ttrend2 i.sexo1#c.ttrend i.sexo1#c.ttrend2 i.covid##i.sexo1 ///
                 part_time#i.sexo1 college#i.sexo1 less_hs#i.sexo1 ///
                 other_se#i.sexo1 other_college#i.sexo1 other_less_hs#i.sexo1 i.age ///
                 if ((mother_20==0&wife==1)|(father_20==0&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)
log close
*/

* Table 2 & 4 different age groups (parents and children) excluding the last two quarters of 2022 * * * * * * * * * * * * * * * * * * * *
drop if ciclo==200|ciclo==201
global parent_string_short "_10 _15"
foreach ag of global age_group{
foreach par of global parent_string_short {
log using "./tables/sqtreg_table_simple_`ag'_`par'_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.covid##i.sexo1 ///
                if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                q(.25 .5 .75)
log close

log using "./tables/sqtreg_table_advanced_simple_`ag'_`par'_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close

log using "./tables/sqtreg_table_industry_`ag'_`par'_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.act1 i.covid##i.sexo1#i.act1 ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close	

log using "./tables/sqtreg_table_urateinteraction_`ag'_`par'_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend urate i.occgroup c.urate##i.sexo1#i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother`par'==1&wife==1)|(father`par'==1&husband==1))&employed&`ag'==1, ///
                 q(.25 .5 .75)  				
log close
}
}

log using "./tables/sqtreg_table_simple_age3040__10_agefix_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.sexo1##i.age i.covid##i.sexo1 ///
                if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                q(.25 .5 .75)
log close

log using "./tables/sqtreg_table_advanced_simple_age3040__10_agefix_1sthalf22.log", replace nomsg
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.sexo1##i.age i.occgroup i.covid##i.sexo1#i.occgroup ///
               if ((mother_10==1&wife==1)|(father_10==1&husband==1))&employed&age3040==1, ///
                 q(.25 .5 .75)  				
log close

**# Year-by-year results
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log close
log using "./results/sqtreg_mothers_3040_hemp_yy_agefix.log", replace nomsg
sqreg wife_ten_y hub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs i.age ///
		i.yd  if mother_10==1&wife==1&employed&age>=30&age<40, q(.25 .5 .75) 
log close

log using "./results/sqtreg_mothers_3040_hemp_yy_agefix_0k.log", replace nomsg
sqreg wife_ten_y hub_ten_y part_time /// 
		college less_hs hub_age hub_se hub_college hub_less_hs i.age ///
		i.yd  if mother_15==0&wife==1&employed&age>=30&age<40, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3040_hemp_yy_agefix.log", replace nomsg
sqreg hub_ten_y wife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs i.age ///
		i.yd  if father_10==1&husband==1&employed&age>=30&age<40, q(.25 .5 .75) 
log close


log using "./results/sqtreg_fathers_3040_hemp_yy_agefix_0k.log", replace nomsg
sqreg hub_ten_y wife_ten_y part_time /// 
		college less_hs wife_age wife_se wife_college wife_less_hs i.age ///
		i.yd  if father_15==0&husband==1&employed&age>=30&age<40, q(.25 .5 .75) 
log close
