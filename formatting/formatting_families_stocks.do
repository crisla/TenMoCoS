* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Families in the Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

capture use "formatting/rawfiles/EPA_stocks20.dta", clear

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



**# Part 4: Generate key indicator variables * * * * * * * * * 

destring(relpp1), replace

sort ciclo nvivi relpp1

by ciclo nvivi: gen wife = (sexo1==6&((relpp1==1&relpp1[_n+1]==2)|(relpp1==2&relpp1[_n-1]==1)))
by ciclo nvivi: gen husband = (sexo1==1&((relpp1==1&relpp1[_n+1]==2)|(relpp1==2&relpp1[_n-1]==1)))

* Age restriction
replace wife = 0 if wife==1&(edad5<20|edad5>50)
replace husband = 0 if husband==1&(edad5<20|edad5>50)

**#  Part 5: Generate labour market x 0k variables of the partner * * * * * * * * *

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

**# Part 6: indicator variables for regressions * * * * * * * * * 

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
replace period_t = "t21" if (ciclo>=194&ciclo<198)
replace period_t = "t22" if (ciclo>198)
// gen t20_21 = (ciclo>=190)
encode period_t, generate(period_y)

gen yd = 0
local yy = 2005
forvalues t = 130(4)201  {

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

**# Part 7: Save * * * * * * * * * 
save "formatting/rawfiles/EPA_stocks20_parents.dta", replace
