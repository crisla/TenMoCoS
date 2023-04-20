* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Families in the Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

// capture use "formatting/rawfiles/EPA_stocks20.dta", clear

**#  Part 1: Generate labour market variables * * * * * * * * * 
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

**# Part 2: Generate key indicator variables * * * * * * * * * 
gen ngranny = nmadre if edad5>=18
gen ngranps = npadre if edad5>=18
* Consider ONLY children (18 or less)
replace nmadre = 0 if edad5>18
replace npadre = 0 if edad5>18

* More than two mothers in the houshold - OUT
egen moms_in_house = nvals(nmadre), by(ciclo nvivi)
replace moms_in_house = moms_in_house-1
drop if moms_in_house>1

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
replace mother = 0 if mother==1&(edad5<20|edad5>55)
replace father = 0 if father==1&(edad5<20|edad5>55)

gen single_mom = mother==1&dad_no==0

* Consider ONLY very small children (5 or less)
gen nmadre_5 = nmadre
gen npadre_5 = npadre

replace nmadre_5 = 0 if edad5>5
replace npadre_5 = 0 if edad5>5

sort ciclo nvivi npers

gen mom_in_5 = -(nmadre_5>0)
gen mom_no_5 = nmadre_5
sort ciclo nvivi mom_in_5
by ciclo nvivi: replace mom_no_5 = mom_no_5[_n-1] if mom_no_5==0
gen mother_5 = mom_no_5==npers
replace mom_no_5 = 0 if  mom_no_5 == .

gen dad_in_5 = -(npadre_5>0)
gen dad_no_5 = npadre_5
sort ciclo nvivi dad_in_5
by ciclo nvivi: replace dad_no_5 = dad_no_5[_n-1] if dad_no_5==0
gen father_5 = dad_no_5==npers
replace dad_no_5 = 0 if  dad_no_5 == .

drop mom_in_5 dad_in_5

* Drop weird cases and teen moms
replace mother_5 = 0 if mother_5==1&(edad5<20|edad5>55)
replace father_5 = 0 if father_5==1&(edad5<20|edad5>55)

gen single_mom_5 = mother_5==1&dad_no_5==0

* Consider ONLY small children (10 or less)
gen nmadre_10 = nmadre
gen npadre_10 = npadre

replace nmadre_10 = 0 if edad5>10
replace npadre_10 = 0 if edad5>10

sort ciclo nvivi npers

gen mom_in_10 = -(nmadre_10>0)
gen mom_no_10 = nmadre_10
sort ciclo nvivi mom_in_10
by ciclo nvivi: replace mom_no_10 = mom_no_10[_n-1] if mom_no_10==0
gen mother_10 = mom_no_10==npers
replace mom_no_10 = 0 if  mom_no_10 == .

gen dad_in_10 = -(npadre_10>0)
gen dad_no_10 = npadre_10
sort ciclo nvivi dad_in_10
by ciclo nvivi: replace dad_no_10 = dad_no_10[_n-1] if dad_no_10==0
gen father_10 = dad_no_10==npers
replace dad_no_10 = 0 if  dad_no_10 == .

drop mom_in_10 dad_in_10

* Drop weird cases and teen moms
replace mother_10 = 0 if mother_10==1&(edad5<20|edad5>55)
replace father_10 = 0 if father_10==1&(edad5<20|edad5>55)

gen single_mom_10 = mother_10==1&dad_no_10==0

* Consider young children (16 or less)
gen nmadre_15 = nmadre
gen npadre_15 = npadre

replace nmadre_15 = 0 if edad5>16
replace npadre_15 = 0 if edad5>16

sort ciclo nvivi npers

gen mom_in_15 = -(nmadre_15>0)
gen mom_no_15 = nmadre_15
sort ciclo nvivi mom_in_15
by ciclo nvivi: replace mom_no_15 = mom_no_15[_n-1] if mom_no_15==0
gen mother_15 = mom_no_15==npers
replace mom_no_15 = 0 if  mom_no_15 == .

gen dad_in_15 = -(npadre_15>0)
gen dad_no_15 = npadre_15
sort ciclo nvivi dad_in_15
by ciclo nvivi: replace dad_no_15 = dad_no_15[_n-1] if dad_no_15==0
gen father_15 = dad_no_15==npers
replace dad_no_15 = 0 if  dad_no_15 == .

drop mom_in_15 dad_in_15

* Drop weird cases and teen moms
replace mother_15 = 0 if mother_15==1&(edad5<20|edad5>55)
replace father_15 = 0 if father_15==1&(edad5<20|edad5>55)

gen single_mom_15 = mother_15==1&dad_no_15==0

gen gran_10 = (mother_10&ngranny>0)
gen gran_5 = (mother_5&ngranny>0)

log using "./descriptive_stats/grannies_10.log", replace nomsg
tab ciclo gran_10 if mother_10==1 [fweight=facexp]
log close

log using "./descriptive_stats/grannies_5.log", replace nomsg
tab ciclo gran_5 if mother_5==1 [fweight=facexp]
log close