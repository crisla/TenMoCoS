* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Families in the Spanish LFS - Stocks version
* (file previously known as families.do)
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

use "rawfiles_stocks/EPA_stocks20.dta", clear

* Part 1: Generate labour market variables * * * * * * * * * 
sort ciclo nvivi npers

* No discontinuous workers
by ciclo nvivi: gen disc = ducon2==6
*by ciclo nvivi: replace disc = sum(disc)
*by ciclo nvivi: replace disc = disc[_N]
*drop if disc>0

* ERTE variable
gen erte= (rznotb==11)

* Weak ERTE or hours ERTE variable
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

* Part 4: Export * * * * * * * * *

log using "./rawtabs/stocks_mothers.log", replace nomsg
tab ciclo state if mother==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_fathers.log", replace nomsg
tab ciclo state if father==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_mothers_w.log", replace nomsg
tab ciclo state if mother==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

log using "./rawtabs/stocks_fathers_w.log", replace nomsg
tab ciclo state if father==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./rawtabs/stocks_mothers_fatherERTE.log", replace nomsg
tab ciclo state if mother==1&father_erte==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_mothers_fatherERTE_w.log", replace nomsg
tab ciclo state if mother==1&father_erte==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

log using "./rawtabs/stocks_mothers_fatherNoERTE.log", replace nomsg
tab ciclo state if mother==1&father_erte==0&father_state=="P"&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_mothers_fatherNoERTE_w.log", replace nomsg
tab ciclo state if mother==1&father_erte==0&father_state=="P"&(edad5>=30&edad5<=45) [fweight=facexp]
log close

log using "./rawtabs/stocks_mothers_motherERTE.log", replace nomsg
tab ciclo state if mother==1&mother_erte==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_mothers_motherERTE_w.log", replace nomsg
tab ciclo state if mother==1&mother_erte==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
log using "./rawtabs/stocks_fathers_fatherERTE.log", replace nomsg
tab ciclo state if father==1&father_erte==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_fathers_fatherERTE_w.log", replace nomsg
tab ciclo state if father==1&father_erte==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

log using "./rawtabs/stocks_fathers_motherERTE.log", replace nomsg
tab ciclo state if father==1&mother_erte==1&(edad5>=30&edad5<=45)
log close

log using "./rawtabs/stocks_fathers_motherERTE_w.log", replace nomsg
tab ciclo state if father==1&mother_erte==1&(edad5>=30&edad5<=45) [fweight=facexp]
log close

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Coutnerfactuals
log using "./rawtabs/stocks_not_mothers.log", replace nomsg
tab ciclo state if mother==0&(edad5>=30&edad5<=45)&sexo1==6
log close

log using "./rawtabs/stocks_not_fathers.log", replace nomsg
tab ciclo state if father==0&(edad5>=30&edad5<=45)&sexo1==1
log close

log using "./rawtabs/stocks_not_mothers_w.log", replace nomsg
tab ciclo state if mother==0&(edad5>=30&edad5<=45)&sexo1==6 [fweight=facexp]
log close

log using "./rawtabs/stocks_not_fathers_w.log", replace nomsg
tab ciclo state if father==0&(edad5>=30&edad5<=45)&sexo1==1 [fweight=facexp]
log close

