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

* Discontinuous as a separate state
replace state="D" if disc==1

log using "./results/stocks.log",replace
tab ciclo state
log close

log using "./results/stocks_w.log",replace
tab ciclo state [fweight=facexp]
log close

* Part-time as a separate state
replace state="H" if parco1=="6"&state=="P"

log using "./results/stocks_pt_w.log",replace
tab ciclo state [fweight=facexp]
log close

log using "./results/stocks_pt.log",replace
tab ciclo state 
log close

* Now for mother/fathers etc.
quietly do "./formatting/formatting_families_stocks.do"

