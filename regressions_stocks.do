
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Families in the Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "./formatting/rawfiles/EPA_stocks20.dta", clear

* Part 1: Generate labour market variables * * * * * * * * * 
sort ciclo nvivi npers

* No discontinuous workers
by ciclo nvivi: gen disc = ducon2==6
by ciclo nvivi: replace disc = sum(disc)
by ciclo nvivi: replace disc = disc[_N]
drop if disc>0

* erte variable
gen erte= (rznotb==11)

* Weak erte or hours erte variable
gen erteh = (rzdifh==11)

* (labour) state variable
gen state= ""
replace state="P" if ducon1==1
replace state="T" if ducon1==6
replace state="A" if situ!=7&situ!=8&situ!=.
replace state="U" if aoi==6|aoi==5
replace state="I" if aoi>6

* Part 2: Generate key indicator variables * * * * * * * * * 

* Consider ONLY small children (10 or less)
replace nmadre = 0 if edad5>10
replace npadre = 0 if edad5>10

gen college = nforma=="SU"

sort ciclo nvivi npers

gen child_dummy = (edad5<=16)

gen baby_dummy = (edad5<10)

gen kid_dummy = (edad5>=10&edad5<16)

by ciclo nvivi: gen kids_in_house = sum(child_dummy)
by ciclo nvivi: replace kids_in_house = kids_in_house[_N]

by ciclo nvivi: gen baby_in_house = sum(baby_dummy)
by ciclo nvivi: replace baby_in_house = baby_dummy[_N]

gen mom_in = -(nmadre>0)
gen mom_no = nmadre
sort ciclo nvivi mom_in
by ciclo nvivi: replace mom_no = mom_no[_n-1] if mom_no==0
gen mother = mom_no==npers
replace mom_no = 0 if  mom_no == .

gen dad_in = -(npadre>0)
gen dad_no = npadre
sort ciclo nvivi dad_in
by ciclo nvivi: replace dad_no = dad_no[_n-1] if dad_no==0
gen father = dad_no==npers
replace dad_no = 0 if  dad_no == .

drop mom_in dad_in

* Drop weird cases and teen moms
replace mother = 0 if mother==1&(edad5<20|edad5>50)
replace father = 0 if father==1&(edad5<20|edad5>50)

gen single_mom = mother==1&dad_no==0

* Part 3: Generate labour market x motherhood variables * * * * * * * * *

sort ciclo nvivi mother
by ciclo nvivi: gen mother_state = state[_N] if mother[_N]==1
by ciclo nvivi: gen mother_erte = erte[_N] if mother[_N]==1
by ciclo nvivi: gen no_mother = mother[_N]==0

sort ciclo nvivi father
by ciclo nvivi: gen father_state = state[_N] if father[_N]==1
by ciclo nvivi: gen father_erte = erte[_N] if father[_N]==1
by ciclo nvivi: gen no_father = father[_N]==0

gen partner_perm = (father_state=="P"&mother==1)|(mother_state=="P"&father==1)
replace partner_perm = . if (father_state==""&mother==1)|(mother_state==""&father==1)
gen partner_inac = (father_state=="I"&mother==1)|(mother_state=="I"&father==1)
replace partner_inac = . if (father_state==""&mother==1)|(mother_state==""&father==1)
gen partner_erte = (father_erte==1&mother==1)|(mother_erte==1&father==1)

// gen father_perm = (father_state=="P")
// replace father_perm = . if father_state==""
// gen mother_perm = (mother_state=="P")
// replace mother_perm = . if mother_state==""
// gen mother_inac = (mother_state=="I")
// replace mother_inac = . if mother_state==""
// gen father_inac = (father_state=="I")
// replace father_inac = . if father_state==""

* Indicator variables and regressors * * * * * * * * * * * * * * * * * * * * *
gen working = (state!="U"&state!="I")
gen ne = 1 - working
gen permanent = state=="P"
gen temporary = state=="T"
gen unemployed = state=="U"
gen employee = (state=="P"|state=="T")
gen inactive = state=="I"

destring ocup1 ocupa act1 acta parco1, replace
gen occ = ocup1
replace occ = ocupa if occ==.
gen act = act1
replace act = acta if act==.

gen mili = occ==0

gen public_servant = situ==7

gen woman = sexo1==6

gen part_time = parco1==6

gen married = eciv1==2
gen divorced = eciv1==4
gen widowed = eciv1==3

gen parent = (mother==1|father==1)

rename dcom tenure
rename edad5 age

quietly do "./formatting/labels_mini.do"
label variable age "Age in 5 year groups"

gen prime_aged = (age>=25&age<=50)
gen in_thirties = (age>=30&age<=35)
gen la_flor_de_la_vida = (age>=30&age<=40)

gen married_parent = married*parent

gen one_year_before = (ciclo<190&ciclo>=184)
gen one_year_later = ciclo > 191

* Regressions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* Bloc 1: On permanent contract * * * * * * * * * * * * * * * * 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure if mili==0&prime_aged&one_year_before [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure if mili==0&prime_aged&one_year_later [pw=factorel], r 

esttab using "prob_perm_all_broad.tex", eform replace
eststo clear 

* * * * * * * 


* One less year
eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==186&mili==0&prime_aged [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==187&mili==0&prime_aged [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==188&mili==0&prime_aged [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==189&mili==0&prime_aged [pw=factorel], r

* 2020
eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==190&mili==0&prime_aged [pw=factorel], r

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==191&mili==0&prime_aged [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==192&mili==0&prime_aged [pw=factorel], r 

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==193&mili==0&prime_aged [pw=factorel], r

* 2020
eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==194&mili==0&prime_aged [pw=factorel], r

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==195&mili==0&prime_aged [pw=factorel], r

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==196&mili==0&prime_aged [pw=factorel], r

eststo: logistic permanent i.act i.occ public_servant woman parent married married_parent divorced widowed part_time erte age tenure college if ciclo==197&mili==0&prime_aged [pw=factorel], r

esttab using "prob_perm_all.tex", se eform replace
eststo clear 

* * * * * * * * * * * * * * * * 
* Bloc 1b: On permanent contract, repeated cross-section * * * * * * * * * * 

log using "./results/prob_perm_stocks_w.log", replace nomsg
* Women
forvalues i=186/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&prime_aged&woman==1 [pw=factorel], vce(robust)
}

esttab using "prob_perm_stocks_w.tex", se eform label replace
esttab using "prob_perm_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

* Women in their 30s
log using "./results/prob_perm_stocks_w_3035.log", replace nomsg
forvalues i=186/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&in_thirties&woman==1 [pw=factorel], vce(robust)
}
log close

* Women 30-45
log using "./results/prob_perm_stocks_w_3045.log", replace nomsg
forvalues i=186/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&la_flor_de_la_vida&woman==1 [pw=factorel], vce(robust)
}
log close

// log using "./results/prob_perm_stocks_w_margins.log", replace nomsg
// forvalues i=186/201{ 
// 	eststo: logit permanent i.act i.occ public_servant i.parent##i.married divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&prime_aged&woman==1 [pw=factorel]
// }
// esttab using "prob_perm_stocks_w_interaction_margins.tex", eform label replace
// log close
// eststo clear

* Men
log using "./results/prob_perm_stocks_m.log", replace nomsg
forvalues i=186/201{ 
	eststo: logistic permanent i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&prime_aged&woman==0 [pw=factorel], vce(robust)
}
esttab using "prob_perm_stocks_m.tex", se eform label replace
esttab using "prob_perm_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear


* * * * * * * * * * * * * * * * 
* Bloc 2: On permanent contract, time aggregated * * * * * * * * * * 
log using "./results/prob_perm_stocks_agg.log", replace nomsg
eststo reg1: logistic permanent i.act i.occ public_servant i.parent##i.married divorced widowed part_time erte age college tenure if mili==0&woman==1&prime_aged&one_year_before [pw=factorel], vce(robust)
// eststo mar1: margins parent##married, at(divorced=0 widowed=0 part_time=0 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg2: logistic permanent i.act i.occ public_servant i.parent##i.married divorced widowed part_time erte age college tenure if mili==0&woman==1&prime_aged&one_year_later [pw=factorel], vce(robust)
// eststo mar2: margins parent##married, at(divorced=0 widowed=0 part_time=0 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg3: logistic permanent i.act i.occ public_servant i.parent##i.married divorced widowed part_time erte age college tenure if mili==0&woman==0&prime_aged&one_year_before [pw=factorel], vce(robust) 
// eststo mar3: margins parent##married, at(divorced=0 widowed=0 part_time=0 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg4: logistic permanent i.act i.occ public_servant i.parent##i.married divorced widowed part_time erte age college tenure if mili==0&woman==0&prime_aged&one_year_later [pw=factorel], vce(robust)
// eststo mar4: margins parent##married, at(divorced=0 widowed=0 part_time=0 public_servant=0 erte=0 (mean) age tenure occ act )

* Conditional on the other spouse state
eststo reg5: logistic permanent i.act i.occ public_servant married divorced widowed part_time erte age college tenure i.partner_perm i.partner_erte i.partner_inac if mili==0&woman==1&prime_aged&one_year_before&parent==1 [pw=factorel], vce(robust)
// eststo mar5: margins partner_perm##partner_erte partner_inac, at(divorced=0 widowed=0 part_time=0 married=1 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg6: logistic permanent i.act i.occ public_servant married divorced widowed part_time erte age college tenure i.partner_perm i.partner_erte i.partner_inac if mili==0&woman==1&prime_aged&one_year_later&parent==1 [pw=factorel], vce(robust)
// eststo mar6: margins partner_perm##partner_erte partner_inac, at(divorced=0 widowed=0 part_time=0 married=1 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg7: logistic permanent i.act i.occ public_servant married divorced widowed part_time erte age college tenure i.partner_perm i.partner_erte i.partner_inac if mili==0&woman==0&prime_aged&one_year_before&parent==1 [pw=factorel], vce(robust) 
// eststo mar7: margins partner_perm##partner_erte partner_inac, at(divorced=0 widowed=0 part_time=0 married=1 public_servant=0 erte=0 (mean) age tenure occ act )

eststo reg8: logistic permanent i.act i.occ public_servant married divorced widowed part_time erte age college tenure i.partner_perm i.partner_erte i.partner_inac if mili==0&woman==0&prime_aged&one_year_later&parent==1 [pw=factorel], vce(robust) 
// eststo mar8: margins partner_perm##partner_erte partner_inac, at(divorced=0 widowed=0 part_time=0 married=1 public_servant=0 erte=0 (mean) age tenure occ act )

esttab reg* using "prob_perm_stocks_w_broad.tex", se eform label replace
// esttab mar1 mar2 mar3 mar4 using "marg_perm_stocks_w_broad.tex", se margin mtitles label replace
// esttab mar5 mar6 mar7 mar8 using "marg_perm_stocks_w_broad_cond.tex", se margin mtitles label replace
eststo clear
log close

* * * * * * * * * * * * * * * * 
* Bloc 3a: On inactivity, q by q * * * * * * * * * * 

log using "./results/prob_inac_stocks_w.log", replace nomsg
* Women
forvalues i=186/201{ 
	eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==1&prime_aged&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "prob_inac_stocks_w.tex", se eform label replace
esttab using "prob_inac_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

log using "./results/prob_inac_stocks_m.log", replace nomsg
* Men
forvalues i=186/201{ 
	eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==0&prime_aged&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "prob_inac_stocks_m.tex", se eform label replace
esttab using "prob_inac_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear

* Bloc 3b: On inactivity, time aggregated * * * * * * * * * * 
log using "./results/prob_inac_stocks_agg.log", replace nomsg
eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman&prime_aged&kids&partner&one_year_before [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman&prime_aged&kids&partner&one_year_later [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==0&prime_aged&one_year_before [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==0&prime_aged&one_year_later [pw=factorel], vce(robust) 

* Conditional on the other parent
eststo: logistic inactive i.act i.occ married divorced widowed age college partner_perm partner_erte partner_inac if mili==0&woman==1&prime_aged&parent&one_year_before [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ married divorced widowed age college partner_perm partner_erte partner_inac if one_year_later&mili==0&woman&prime_aged&parent [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ married divorced widowed age college partner_perm partner_erte partner_inac if mili==0&woman==0&prime_aged&parent&one_year_before [pw=factorel], vce(robust) 

eststo: logistic inactive i.act i.occ married divorced widowed age college partner_perm partner_erte partner_inac if one_year_later&mili==0&woman==0&prime_aged&parent [pw=factorel], vce(robust) 

esttab using "prob_i_stocks_w_broad.tex", eform label replace
eststo clear
log close
* * * * * * * * * * * * * * * * 
* Bloc 4: On temporary and unemployment, q by q * * * * * * * * * * 

log using "./results/prob_temp_stocks_w.log", replace nomsg
* Women
forvalues i=186/201{ 
	eststo: logistic temporary i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&prime_aged&woman==1 [pw=factorel], vce(robust)
}
esttab using "prob_temp_stocks_w.tex", se eform label replace
esttab using "prob_temp_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear

log using "./results/prob_temp_stocks_m.log", replace nomsg
* Men
forvalues i=186/201{ 
	eststo: logistic temporary i.act i.occ public_servant parent married married_parent divorced 	widowed part_time erte age college tenure if ciclo==`i'&mili==0&prime_aged&woman==0 [pw=factorel], vce(robust)
}
esttab using "prob_temp_stocks_m.tex", se eform label replace
esttab using "prob_temp_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear

* Unemployment * * * * * *
log using "./results/prob_unemp_stocks_w.log", replace nomsg
* Women
forvalues i=186/201{ 
	eststo: logistic unemployed i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==1&prime_aged&ciclo==`i' [pw=factorel], vce(robust) 
}
esttab using "prob_unemp_stocks_w.tex", se eform label replace
esttab using "prob_unemp_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear


log using "./results/prob_unemp_stocks_m.log", replace nomsg
* Men
forvalues i=186/201{ 
	eststo: logistic unemployed i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==0&prime_aged&ciclo==`i' [pw=factorel], vce(robust) 
}
esttab using "prob_unemp_stocks_m.tex", se eform label replace
esttab using "prob_unemp_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear

* Non-Employed * * * * * *
log using "./results/prob_ne_stocks_w.log", replace nomsg
* Women
forvalues i=186/201{ 
	eststo: logistic ne i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==1&prime_aged&ciclo==`i' [pw=factorel], vce(robust)

}
esttab using "prob_ne_stocks_w.tex", se eform label replace
esttab using "prob_ne_stocks_w_margins.tex", se margin mtitles label replace
log close
eststo clear


log using "./results/prob_ne_stocks_m.log", replace nomsg
* Men
forvalues i=186/201{ 
	eststo: logistic ne i.act i.occ parent married married_parent divorced widowed age college if mili==0&woman==0&prime_aged&ciclo==`i' [pw=factorel], vce(robust)
}
esttab using "prob_ne_stocks_m.tex", se eform label replace
esttab using "prob_ne_stocks_m_margins.tex", se margin mtitles label replace
log close
eststo clear
 

* Bloc 4: erte * * * * * * * * * * * * * * * * 

* Who is more likley to be on erte in 2020Q2?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time permanent age tenure if ciclo==191&mili==0&employee [pw=factorel], r

* Who is more likley to be on erte in 2020Q2, if permanent?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time age tenure if ciclo==191&mili==0&permanent [pw=factorel], r

* Are mothers more or less likley to be on erte in 2020Q2?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time permanent age tenure if ciclo==191&employee&mili==0&woman&prime_aged [pw=factorel], r

eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time permanent age tenure if ciclo==191&employee&mili==0&woman==0&prime_aged [pw=factorel], r

* Are mothers more or less likley to be on erte in 2020Q2, if permanent?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time age tenure if ciclo==191&permanent&mili==0&woman&prime_aged [pw=factorel], r

esttab using "prob_erte_w_stocks.tex", eform label replace
eststo clear

* * * * * * * * * * * * * * * * 

* Who is more likley to be on erte in 2020Q3?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time permanent age tenure if ciclo==192&mili==0&employee, r
// estimates store M1

* Who is more likley to be on erte in 2020Q3, if permanent?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time age tenure if ciclo==192&mili==0&permanent , r

* Are mothers more or less likley to be on erte in 2020Q3?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time permanent age tenure if ciclo==192&employee&mili==0&woman&prime_aged, r

* Are mothers more or less likley to be on erte in 2020Q3, if permanent?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time age tenure if ciclo==192&permanent&mili==0&woman&prime_aged, r

// esttab using "prob_erte_Q3.tex", eform replace
// eststo clear

* * * * * * * * * * * * * * * * 

* Who is more likley to be on erte in 2020Q4?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time permanent age tenure if ciclo==193&mili==0&employee, r
// estimates store M1

* Who is more likley to be on erte in 2020Q4, if permanent?
eststo: logistic erte i.act i.occ public_servant woman parent married married_parent divorced widowed part_time age tenure if ciclo==193&mili==0&permanent , r

* Are mothers more or less likley to be on erte in 2020Q4?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time permanent age tenure if ciclo==193&employee&mili==0&woman&prime_aged, r

eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time permanent age tenure if ciclo==193&employee&mili==0&woman==0&prime_aged, r

* Are mothers more or less likley to be on erte in 2020Q4, if permanent?
eststo: logistic erte i.act i.occ public_servant parent married married_parent divorced widowed part_time age tenure if ciclo==193&permanent&mili==0&woman&prime_aged, r

esttab using "prob_erte_Q3Q4_stocks.tex", eform label replace
eststo clear



