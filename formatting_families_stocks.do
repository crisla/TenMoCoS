* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Families in the Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

capture use "rawfiles_stocks/EPA_stocks20.dta", clear

**#  Part 1: Generate labour market variables * * * * * * * * * 
sort ciclo nvivi npers

* No discontinuous workers
by ciclo nvivi: gen disc = ducon2==6
by ciclo nvivi: replace disc = sum(disc)
by ciclo nvivi: replace disc = disc[_N]
drop if disc>0

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

* Part-time and hours
gen state_pt = state
replace state_pt = "PT" if parco1=="6"

**#  Part 3: Generate labour market x motherhood variables * * * * * * * * *

sort ciclo nvivi mother
by ciclo nvivi: gen mother_state = state[_N] if mother[_N]==1
by ciclo nvivi: gen mother_erte = erte[_N] if mother[_N]==1
by ciclo nvivi: gen mother_ten = dcom[_N] if mother[_N]==1
// by ciclo nvivi: gen no_mother = mother[_N]==0

sort ciclo nvivi father
by ciclo nvivi: gen father_state = state[_N] if father[_N]==1
by ciclo nvivi: gen father_erte = erte[_N] if father[_N]==1
by ciclo nvivi: gen father_ten = dcom[_N] if father[_N]==1
by ciclo nvivi: gen no_father = father[_N]==0

gen tenure_ratio = log(dcom/father_ten) if mother==1

gen mother_ten_y = mother_ten/12
gen father_ten_y = father_ten/12

* Tenure groups - from 0 to 10+ years
gen mother_ten_g = 0 if mother_ten_y!=.&mother_ten_y<1
gen father_ten_g = 0 if father_ten_y!=.&father_ten_y<1
gen ten_g = 0 if dcom!=.&dcom<1

forvalues t = 1/30 {

	replace mother_ten_g = `t' if (mother_ten_y<=`t'+1&mother_ten_y>`t'&mother_ten_y!=.)
	replace father_ten_g = `t' if (father_ten_y<=`t'+1&father_ten_y>`t'&father_ten_y!=.)
	replace ten_g = `t' if (dcom<=(`t'+1)*12&dcom>`t'*12&dcom!=.)
}

replace mother_ten_g = 30 if mother_ten_y>30&mother_ten_y!=.
replace father_ten_g = 30 if father_ten_y>30&father_ten_y!=.
replace ten_g = 30 if dcom>360&dcom!=.

* Coarse tenure groups: in 5 year goups up until 30
gen mother_ten_g5 = 0 if mother_ten_y!=.
gen father_ten_g5 = 0 if father_ten_y!=.
gen ten_g5 = 0 if dcom!=.

forvalues t = 5(5)30  {

	replace mother_ten_g5 = `t' if (mother_ten_y<=`t'&mother_ten_y>`t'-5&mother_ten_y!=.)
	replace father_ten_g5 = `t' if (father_ten_y<=`t'&father_ten_y>`t'-5&father_ten_y!=.)
	replace ten_g5 = `t' if (dcom<=(`t')*12&dcom>(`t'-5)*12&dcom!=.)
}
*
* Beginings
replace mother_ten_g5 = 0 if mother_ten_y!=.&mother_ten_y<1
replace father_ten_g5 = 0 if father_ten_y!=.&father_ten_y<1
replace ten_g5 = 0 if dcom!=.&dcom<12

* Endings
replace mother_ten_g5 = 35 if mother_ten_y>30&mother_ten_y!=.
replace father_ten_g5 = 35 if father_ten_y>30&father_ten_y!=.
replace ten_g5 = 35 if dcom>360&dcom!=.

* Save
save "rawfiles_stocks/EPA_stocks20_parents.dta", replace