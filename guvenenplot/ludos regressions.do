** run this with all variables known at around line 178 of qtregs_interactions_diff.do

capture drop occgroup
gen occgroup=.
replace occgroup=1 if ocup1==1 | ocup1==2
replace occgroup=2 if ocup1==3 | ocup1==4
replace occgroup=3 if ocup1==5
replace occgroup=4 if ocup1==6 | ocup1==7 | ocup1==8
replace occgroup=5 if ocup1==9


capture drop covid
gen covid = 0
replace covid = 1 if ciclo>=191 & ciclo<=193
replace covid = 2 if ciclo>=194 & ciclo<=197

cap n log close _all
log using "./results/ludo.log", replace nomsg

display "-------------------------"
display "       basic regression with unemployment, no ten_y"
display "sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate  i.covid##i.sexo1 if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ,		q(.25 .5 .75)"

sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate  i.covid##i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)

display ""
display "-------------------------"
display "       add controls, demographics, etc, non-time varying"
display ""
sqreg ten_y ttrend i.sexo i.sexo1#c.ttrend i.sexo1#c.urate i.college#i.sexo i.less_hs#i.sexo i.ocup1##i.sexo1 i.covid i.covid#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
		
display ""
display "investigate how this changes with time window?"
display ""
display "window starting 2015"
sqreg ten_y ttrend i.sexo i.sexo1#c.ttrend i.sexo1#c.urate i.college#i.sexo i.less_hs#i.sexo i.ocup1##i.sexo1 i.covid i.covid#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 & ciclo>=177, ///
		q(.25 .5 .75)
		


display ""
display "-------------------------"
display "       for those with employed partner, tenure of partner incl"
display ""
sqreg ten_y other_ten_y ttrend i.sexo i.sexo1#c.ttrend i.sexo1#c.urate i.college#i.sexo i.less_hs#i.sexo i.ocup1 i.covid#i.sexo1 ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35, ///
		q(.25 .5 .75)
		
		
display " -- HETEROGENEOUS RESPONSES? ---"

display "       heterogeneous responses across occupation group"
display ""
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup  i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		 , ///
		q(.25 .5 .75)		
		

display "---------------------------"
display " 2015+ window"
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup  i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		 & ciclo>177, ///
		q(.25 .5 .75)		
display "===="
sqreg ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup#i.sexo1 i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		, ///
		q(.25 .5 .75)	

display ""
display " incl tenure partner"
sqreg ten_y other_ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		, ///
		q(.25 .5 .75)	
display "===="
sqreg ten_y other_ten_y ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		& ciclo>=177, ///
		q(.25 .5 .75)	

display "===="
sqreg ten_y c.other_ten_y#i.sexo1 ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		, ///
		q(.25 .5 .75)	
display "===="
sqreg ten_y c.other_ten_y#i.sexo1 ttrend i.sexo1#c.ttrend i.sexo1#c.urate i.occgroup i.covid##i.sexo1#i.occgroup ///
		if ((mother==1&wife==1)|(father==1&husband==1))&employed&age>=30&age<35 ///
		& ciclo>=177, ///
		q(.25 .5 .75)	
log close

********************************************************************************
*** PERCENTILE PLOTS
********************************************************************************


	** FIRST, TOTAL QUANTITIES (BEFORE DISTRIBUTIONS)
	capture n drop year
	gen year=yofd(dofq(quarter))
	replace year=2019 if ciclo==190
	
	capture drop motheremp
	capture drop mothercount
	capture drop motheremp_w
	capture drop mothercount_w
	
	sort year wife mother father
	
	by year: egen motheremp=sum(employed) if mother==1 & wife==1 
	by year: egen mothercount=sum(mother) if mother==1 & wife==1 
	by year: egen motheremp_w=sum(factorel) if mother==1 & wife==1 & employed==1 
	by year: egen mothercount_w=sum(factorel) if mother==1 & wife==1 
	
	tab year motheremp_w if year>2016
	tab year mothercount_w if year>2016
	
	replace motheremp=motheremp/mothercount
	replace motheremp_w=motheremp_w/mothercount_w
	replace mothercount=mothercount/4 if year!=2019 & year!=2020
	replace mothercount=mothercount/5 if year==2019
	replace mothercount=mothercount/3 if year==2020
	replace mothercount_w=mothercount_w/4 if year!=2019 & year!=2020
	replace mothercount_w=mothercount_w/5 if year==2019
	replace mothercount_w=mothercount_w/3 if year==2020
	
	
	* wife, no kids
	
	capture drop wifeemp
	capture drop wifecount
	capture drop wifeemp_w
	capture drop wifecount_w
	
	sort year wife wife father
	
	by year: egen wifeemp=sum(employed) if wife==1 & mother==0
	by year: egen wifecount=sum(wife) if wife==1 & mother==0
	by year: egen wifeemp_w=sum(factorel) if wife==1 & mother==0 & employed==1 
	by year: egen wifecount_w=sum(factorel) if wife==1 & mother==0
	
	tab year wifeemp_w if year>2016
	tab year wifecount_w if year>2016
	
	replace wifeemp=wifeemp/wifecount
	replace wifeemp_w=wifeemp_w/wifecount_w
	replace wifecount=wifecount/4 if year!=2019 & year!=2020
	replace wifecount=wifecount/5 if year==2019
	replace wifecount=wifecount/3 if year==2020
	replace wifecount_w=wifecount_w/4 if year!=2019 & year!=2020
	replace wifecount_w=wifecount_w/5 if year==2019
	replace wifecount_w=wifecount_w/3 if year==2020
	
	** father
	
	capture drop fatheremp
	capture drop fathercount
	capture drop fatheremp_w
	capture drop fathercount_w
	
	sort year husband father father
	
	by year: egen fatheremp=sum(employed) if father==1 & husband==1 
	by year: egen fathercount=sum(father) if father==1 & husband==1 
	by year: egen fatheremp_w=sum(factorel) if father==1 & husband==1 & employed==1 
	by year: egen fathercount_w=sum(factorel) if father==1 & husband==1 
	
	tab year fatheremp_w if year>2016
	tab year fathercount_w if year>2016
	
	replace fatheremp=fatheremp/fathercount
	replace fatheremp_w=fatheremp_w/fathercount_w
	replace fathercount=fathercount/4 if year!=2019 & year!=2020
	replace fathercount=fathercount/5 if year==2019
	replace fathercount=fathercount/3 if year==2020
	replace fathercount_w=fathercount_w/4 if year!=2019 & year!=2020
	replace fathercount_w=fathercount_w/5 if year==2019
	replace fathercount_w=fathercount_w/3 if year==2020
	
	
	capture drop husbandemp
	capture drop husbandcount
	capture drop husbandemp_w
	capture drop husbandcount_w
	
	
	by year: egen husbandemp=sum(employed) if father==0 & husband==1 
	by year: egen husbandcount=sum(husband) if father==0 & husband==1 
	by year: egen husbandemp_w=sum(factorel) if father==0 & husband==1 & employed==1 
	by year: egen husbandcount_w=sum(factorel) if father==0 & husband==1 
	
	tab year husbandemp_w if year>2016
	tab year husbandcount_w if year>2016
	
	replace husbandemp=husbandemp/husbandcount
	replace husbandemp_w=husbandemp_w/husbandcount_w
	replace husbandcount=husbandcount/4 if year!=2019 & year!=2020
	replace husbandcount=husbandcount/5 if year==2019
	replace husbandcount=husbandcount/3 if year==2020
	replace husbandcount_w=husbandcount_w/4 if year!=2019 & year!=2020
	replace husbandcount_w=husbandcount_w/5 if year==2019
	replace husbandcount_w=husbandcount_w/3 if year==2020
	
	** noncollege
	
	
	capture drop ncol_motheremp
	capture drop ncol_mothercount
	capture drop ncol_motheremp_w
	capture drop ncol_mothercount_w
	
	
	by year: egen ncol_motheremp=sum(employed) if college==0 & mother==1 & wife==1 
	by year: egen ncol_mothercount=sum(mother) if college==0 & mother==1 & wife==1 
	by year: egen ncol_motheremp_w=sum(factorel) if college==0 & mother==1 & wife==1 & employed==1 
	by year: egen ncol_mothercount_w=sum(factorel) if college==0 & mother==1 & wife==1 
	
	tab year ncol_motheremp_w if year>2016
	tab year ncol_mothercount_w if year>2016
	
	replace ncol_motheremp=ncol_motheremp/ncol_mothercount
	replace ncol_motheremp_w=ncol_motheremp_w/ncol_mothercount_w
	replace ncol_mothercount=ncol_mothercount/4 if year!=2019 & year!=2020
	replace ncol_mothercount=ncol_mothercount/5 if year==2019
	replace ncol_mothercount=ncol_mothercount/3 if year==2020
	replace ncol_mothercount_w=ncol_mothercount_w/4 if year!=2019 & year!=2020
	replace ncol_mothercount_w=ncol_mothercount_w/5 if year==2019
	replace ncol_mothercount_w=ncol_mothercount_w/3 if year==2020
	
	
	* wife, no kids
	
	capture drop ncol_wifeemp
	capture drop ncol_wifecount
	capture drop ncol_wifeemp_w
	capture drop ncol_wifecount_w
	
	sort year wife wife father
	
	by year: egen ncol_wifeemp=sum(employed) if college==0 & wife==1 & mother==0
	by year: egen ncol_wifecount=sum(wife) if college==0 & wife==1 & mother==0
	by year: egen ncol_wifeemp_w=sum(factorel) if college==0 & wife==1 & mother==0 & employed==1 
	by year: egen ncol_wifecount_w=sum(factorel) if college==0 & wife==1 & mother==0
	
	tab year ncol_wifeemp_w if year>2016
	tab year ncol_wifecount_w if year>2016
	
	replace ncol_wifeemp=ncol_wifeemp/ncol_wifecount
	replace ncol_wifeemp_w=ncol_wifeemp_w/ncol_wifecount_w
	replace ncol_wifecount=ncol_wifecount/4 if year!=2019 & year!=2020
	replace ncol_wifecount=ncol_wifecount/5 if year==2019
	replace ncol_wifecount=ncol_wifecount/3 if year==2020
	replace ncol_wifecount_w=ncol_wifecount_w/4 if year!=2019 & year!=2020
	replace ncol_wifecount_w=ncol_wifecount_w/5 if year==2019
	replace ncol_wifecount_w=ncol_wifecount_w/3 if year==2020
	
	** father
	
	capture drop ncol_fatheremp
	capture drop ncol_fathercount
	capture drop ncol_fatheremp_w
	capture drop ncol_fathercount_w
	
	
	by year: egen ncol_fatheremp=sum(employed) if college==0 & father==1 & husband==1 
	by year: egen ncol_fathercount=sum(father) if college==0 & father==1 & husband==1 
	by year: egen ncol_fatheremp_w=sum(factorel) if college==0 & father==1 & husband==1 & employed==1 
	by year: egen ncol_fathercount_w=sum(factorel) if college==0 & father==1 & husband==1 
	
	tab year ncol_fatheremp_w if year>2016
	tab year ncol_fathercount_w if year>2016
	
	replace ncol_fatheremp=ncol_fatheremp/ncol_fathercount
	replace ncol_fatheremp_w=ncol_fatheremp_w/ncol_fathercount_w
	replace ncol_fathercount=ncol_fathercount/4 if year!=2019 & year!=2020
	replace ncol_fathercount=ncol_fathercount/5 if year==2019
	replace ncol_fathercount=ncol_fathercount/3 if year==2020
	replace ncol_fathercount_w=ncol_fathercount_w/4 if year!=2019 & year!=2020
	replace ncol_fathercount_w=ncol_fathercount_w/5 if year==2019
	replace ncol_fathercount_w=ncol_fathercount_w/3 if year==2020
	
	
	capture drop ncol_husbandemp
	capture drop ncol_husbandcount
	capture drop ncol_husbandemp_w
	capture drop ncol_husbandcount_w
	
	sort year husband husband father
	
	by year: egen ncol_husbandemp=sum(employed) if college==0 & father==0 & husband==1 
	by year: egen ncol_husbandcount=sum(husband) if college==0 & father==0 & husband==1 
	by year: egen ncol_husbandemp_w=sum(factorel) if college==0 & father==0 & husband==1 & employed==1 
	by year: egen ncol_husbandcount_w=sum(factorel) if college==0 & father==0 & husband==1 
	
	tab year ncol_husbandemp_w if year>2016
	tab year ncol_husbandcount_w if year>2016
	
	replace ncol_husbandemp=ncol_husbandemp/ncol_husbandcount
	replace ncol_husbandemp_w=ncol_husbandemp_w/ncol_husbandcount_w
	replace ncol_husbandcount=ncol_husbandcount/4 if year!=2019 & year!=2020
	replace ncol_husbandcount=ncol_husbandcount/5 if year==2019
	replace ncol_husbandcount=ncol_husbandcount/3 if year==2020
	replace ncol_husbandcount_w=ncol_husbandcount_w/4 if year!=2019 & year!=2020
	replace ncol_husbandcount_w=ncol_husbandcount_w/5 if year==2019
	replace ncol_husbandcount_w=ncol_husbandcount_w/3 if year==2020
	
	** College 
	
	capture drop col_motheremp
	capture drop col_mothercount
	capture drop col_motheremp_w
	capture drop col_mothercount_w
	
	
	by year: egen col_motheremp=sum(employed) if college==1 & mother==1 & wife==1 
	by year: egen col_mothercount=sum(mother) if college==1 & mother==1 & wife==1 
	by year: egen col_motheremp_w=sum(factorel) if college==1 & mother==1 & wife==1 & employed==1 
	by year: egen col_mothercount_w=sum(factorel) if college==1 & mother==1 & wife==1 
	
	tab year col_motheremp_w if year>2016
	tab year col_mothercount_w if year>2016
	
	replace col_motheremp=col_motheremp/col_mothercount
	replace col_motheremp_w=col_motheremp_w/col_mothercount_w
	replace col_mothercount=col_mothercount/4 if year!=2019 & year!=2020
	replace col_mothercount=col_mothercount/5 if year==2019
	replace col_mothercount=col_mothercount/3 if year==2020
	replace col_mothercount_w=col_mothercount_w/4 if year!=2019 & year!=2020
	replace col_mothercount_w=col_mothercount_w/5 if year==2019
	replace col_mothercount_w=col_mothercount_w/3 if year==2020
	
	
	* wife, no kids
	
	capture drop col_wifeemp
	capture drop col_wifecount
	capture drop col_wifeemp_w
	capture drop col_wifecount_w
	
	sort year wife wife father
	
	by year: egen col_wifeemp=sum(employed) if college==1 & wife==1 & mother==0
	by year: egen col_wifecount=sum(wife) if college==1 & wife==1 & mother==0
	by year: egen col_wifeemp_w=sum(factorel) if college==1 & wife==1 & mother==0 & employed==1 
	by year: egen col_wifecount_w=sum(factorel) if college==1 & wife==1 & mother==0
	
	tab year col_wifeemp_w if year>2016
	tab year col_wifecount_w if year>2016
	
	replace col_wifeemp=col_wifeemp/col_wifecount
	replace col_wifeemp_w=col_wifeemp_w/col_wifecount_w
	replace col_wifecount=col_wifecount/4 if year!=2019 & year!=2020
	replace col_wifecount=col_wifecount/5 if year==2019
	replace col_wifecount=col_wifecount/3 if year==2020
	replace col_wifecount_w=col_wifecount_w/4 if year!=2019 & year!=2020
	replace col_wifecount_w=col_wifecount_w/5 if year==2019
	replace col_wifecount_w=col_wifecount_w/3 if year==2020
	
	** father
	
	capture drop col_fatheremp
	capture drop col_fathercount
	capture drop col_fatheremp_w
	capture drop col_fathercount_w
	
	
	by year: egen col_fatheremp=sum(employed) if college==1 & father==1 & husband==1 
	by year: egen col_fathercount=sum(father) if college==1 & father==1 & husband==1 
	by year: egen col_fatheremp_w=sum(factorel) if college==1 & father==1 & husband==1 & employed==1 
	by year: egen col_fathercount_w=sum(factorel) if college==1 & father==1 & husband==1 
	
	tab year col_fatheremp_w if year>2016
	tab year col_fathercount_w if year>2016
	
	replace col_fatheremp=col_fatheremp/col_fathercount
	replace col_fatheremp_w=col_fatheremp_w/col_fathercount_w
	replace col_fathercount=col_fathercount/4 if year!=2019 & year!=2020
	replace col_fathercount=col_fathercount/5 if year==2019
	replace col_fathercount=col_fathercount/3 if year==2020
	replace col_fathercount_w=col_fathercount_w/4 if year!=2019 & year!=2020
	replace col_fathercount_w=col_fathercount_w/5 if year==2019
	replace col_fathercount_w=col_fathercount_w/3 if year==2020
	
	
	capture drop col_husbandemp
	capture drop col_husbandcount
	capture drop col_husbandemp_w
	capture drop col_husbandcount_w
	
	sort year husband husband father
	
	by year: egen col_husbandemp=sum(employed) if college==1 & father==0 & husband==1 
	by year: egen col_husbandcount=sum(husband) if college==1 & father==0 & husband==1 
	by year: egen col_husbandemp_w=sum(factorel) if college==1 & father==0 & husband==1 & employed==1 
	by year: egen col_husbandcount_w=sum(factorel) if college==1 & father==0 & husband==1 
	
	tab year col_husbandemp_w if year>2016
	tab year col_husbandcount_w if year>2016
	
	replace col_husbandemp=col_husbandemp/col_husbandcount
	replace col_husbandemp_w=col_husbandemp_w/col_husbandcount_w
	replace col_husbandcount=col_husbandcount/4 if year!=2019 & year!=2020
	replace col_husbandcount=col_husbandcount/5 if year==2019
	replace col_husbandcount=col_husbandcount/3 if year==2020
	replace col_husbandcount_w=col_husbandcount_w/4 if year!=2019 & year!=2020
	replace col_husbandcount_w=col_husbandcount_w/5 if year==2019
	replace col_husbandcount_w=col_husbandcount_w/3 if year==2020
	
	
	** PERCENTILE PLOTS


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop motherten_y_`year'
capture  drop ptile_motherten_y_`year'
pctile ptile_motherten_y_`year'=ten_y if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(motherten_y_`year')
}

capture  drop motherten_y_2019
capture  drop ptile_motherten_y_2019
pctile ptile_motherten_y_2019=ten_y if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(motherten_y_2019)

capture  drop motherten_y_2020
capture  drop ptile_motherten_y_2020
pctile ptile_motherten_y_2020=ten_y if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(motherten_y_2020)

capture  drop motherten_y_2021
capture  drop ptile_motherten_y_2021
pctile ptile_motherten_y_2021=ten_y if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(motherten_y_2021)


** weighted [w=factorel] 


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop motherten_yw_`year'
capture  drop ptile_motherten_yw_`year'
pctile ptile_motherten_yw_`year'=ten_y [w=factorel] if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(motherten_yw_`year')
}

capture  drop motherten_yw_2019
capture  drop ptile_motherten_yw_2019
pctile ptile_motherten_yw_2019=ten_y [w=factorel] if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(motherten_yw_2019)


capture  drop motherten_yw_2020
capture  drop ptile_motherten_yw_2020
pctile ptile_motherten_yw_2020=ten_y [w=factorel] if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(motherten_yw_2020)

capture  drop motherten_yw_2021
capture  drop ptile_motherten_yw_2021
pctile ptile_motherten_yw_2021=ten_y [w=factorel] if ((mother==1&wife==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(motherten_yw_2021)


**** BY COLLEGE / NON-COLLEGE 

forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_motherten_y_`year'
capture  drop ptile_ncol_motherten_y_`year'
pctile ptile_ncol_motherten_y_`year'=ten_y if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_motherten_y_`year')
}

capture  drop ncol_motherten_y_2019
capture  drop ptile_ncol_motherten_y_2019
pctile ptile_ncol_motherten_y_2019=ten_y if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_motherten_y_2019)

capture  drop ncol_motherten_y_2020
capture  drop ptile_ncol_motherten_y_2020
pctile ptile_ncol_motherten_y_2020=ten_y if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_motherten_y_2020)

capture  drop ncol_motherten_y_2021
capture  drop ptile_ncol_motherten_y_2021
pctile ptile_ncol_motherten_y_2021=ten_y if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_motherten_y_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_motherten_y_`year'
capture  drop ptile_col_motherten_y_`year'
pctile ptile_col_motherten_y_`year'=ten_y if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_motherten_y_`year')
}

capture  drop col_motherten_y_2019
capture  drop ptile_col_motherten_y_2019
pctile ptile_col_motherten_y_2019=ten_y if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_motherten_y_2019)

capture  drop col_motherten_y_2020
capture  drop ptile_col_motherten_y_2020
pctile ptile_col_motherten_y_2020=ten_y if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_motherten_y_2020)

capture  drop col_motherten_y_2021
capture  drop ptile_col_motherten_y_2021
pctile ptile_col_motherten_y_2021=ten_y if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_motherten_y_2021)


** weighted


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_motherten_yw_`year'
capture  drop ptile_ncol_motherten_yw_`year'
pctile ptile_ncol_motherten_yw_`year'=ten_y [w=factorel] if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_motherten_yw_`year')
}

capture  drop ncol_motherten_yw_2019
capture  drop ptile_ncol_motherten_yw_2019
pctile ptile_ncol_motherten_yw_2019=ten_y [w=factorel] if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_motherten_yw_2019)

capture  drop ncol_motherten_yw_2020
capture  drop ptile_ncol_motherten_yw_2020
pctile ptile_ncol_motherten_yw_2020=ten_y [w=factorel] if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_motherten_yw_2020)

capture  drop ncol_motherten_yw_2021
capture  drop ptile_ncol_motherten_yw_2021
pctile ptile_ncol_motherten_yw_2021=ten_y [w=factorel] if ((mother==1&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_motherten_yw_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_motherten_yw_`year'
capture  drop ptile_col_motherten_yw_`year'
pctile ptile_col_motherten_yw_`year'=ten_y [w=factorel] if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_motherten_yw_`year')
}

capture  drop col_motherten_yw_2019
capture  drop ptile_col_motherten_yw_2019
pctile ptile_col_motherten_yw_2019=ten_y [w=factorel] if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_motherten_yw_2019)

capture  drop col_motherten_yw_2020
capture  drop ptile_col_motherten_yw_2020
pctile ptile_col_motherten_yw_2020=ten_y [w=factorel] if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_motherten_yw_2020)

capture  drop col_motherten_yw_2021
capture  drop ptile_col_motherten_yw_2021
pctile ptile_col_motherten_yw_2021=ten_y [w=factorel] if ((mother==1&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_motherten_yw_2021)





*****************
** FATHER 
*****************


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop fatherten_y_`year' 
capture  drop ptile_fatherten_y_`year' 
pctile ptile_fatherten_y_`year' =ten_y if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(fatherten_y_`year' )
}

capture  drop fatherten_y_2019
capture  drop ptile_fatherten_y_2019
pctile ptile_fatherten_y_2019=ten_y if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(fatherten_y_2019)

capture  drop fatherten_y_2020
capture  drop ptile_fatherten_y_2020
pctile ptile_fatherten_y_2020=ten_y if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(fatherten_y_2020)

capture  drop fatherten_y_2021
capture  drop ptile_fatherten_y_2021
pctile ptile_fatherten_y_2021=ten_y if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(fatherten_y_2021)


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_fatherten_y_`year'
capture  drop ptile_ncol_fatherten_y_`year'
pctile ptile_ncol_fatherten_y_`year'=ten_y if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_fatherten_y_`year')
}

capture  drop ncol_fatherten_y_2019
capture  drop ptile_ncol_fatherten_y_2019
pctile ptile_ncol_fatherten_y_2019=ten_y if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_fatherten_y_2019)

capture  drop ncol_fatherten_y_2020
capture  drop ptile_ncol_fatherten_y_2020
pctile ptile_ncol_fatherten_y_2020=ten_y if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_fatherten_y_2020)

capture  drop ncol_fatherten_y_2021
capture  drop ptile_ncol_fatherten_y_2021
pctile ptile_ncol_fatherten_y_2021=ten_y if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_fatherten_y_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_fatherten_y_`year'
capture  drop ptile_col_fatherten_y_`year'
pctile ptile_col_fatherten_y_`year'=ten_y if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_fatherten_y_`year')
}

capture  drop col_fatherten_y_2019
capture  drop ptile_col_fatherten_y_2019
pctile ptile_col_fatherten_y_2019=ten_y if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_fatherten_y_2019)

capture  drop col_fatherten_y_2020
capture  drop ptile_col_fatherten_y_2020
pctile ptile_col_fatherten_y_2020=ten_y if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_fatherten_y_2020)

capture  drop col_fatherten_y_2021
capture  drop ptile_col_fatherten_y_2021
pctile ptile_col_fatherten_y_2021=ten_y if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_fatherten_y_2021)

** weighted


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop fatherten_yw_`year' 
capture  drop ptile_fatherten_yw_`year' 
pctile ptile_fatherten_yw_`year' =ten_y [w=factorel] if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(fatherten_yw_`year' )
}

capture  drop fatherten_yw_2019
capture  drop ptile_fatherten_yw_2019
pctile ptile_fatherten_yw_2019=ten_y [w=factorel] if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(fatherten_yw_2019)

capture  drop fatherten_yw_2020
capture  drop ptile_fatherten_yw_2020
pctile ptile_fatherten_yw_2020=ten_y [w=factorel] if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(fatherten_yw_2020)

capture  drop fatherten_yw_2021
capture  drop ptile_fatherten_yw_2021
pctile ptile_fatherten_yw_2021=ten_y [w=factorel] if ((father==1&husband==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(fatherten_yw_2021)


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_fatherten_yw_`year'
capture  drop ptile_ncol_fatherten_yw_`year'
pctile ptile_ncol_fatherten_yw_`year'=ten_y [w=factorel] if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_fatherten_yw_`year')
}

capture  drop ncol_fatherten_yw_2019
capture  drop ptile_ncol_fatherten_yw_2019
pctile ptile_ncol_fatherten_yw_2019=ten_y [w=factorel] if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_fatherten_yw_2019)

capture  drop ncol_fatherten_yw_2020
capture  drop ptile_ncol_fatherten_yw_2020
pctile ptile_ncol_fatherten_yw_2020=ten_y [w=factorel] if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_fatherten_yw_2020)

capture  drop ncol_fatherten_yw_2021
capture  drop ptile_ncol_fatherten_yw_2021
pctile ptile_ncol_fatherten_yw_2021=ten_y [w=factorel] if ((father==1&husband==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_fatherten_yw_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_fatherten_yw_`year'
capture  drop ptile_col_fatherten_yw_`year'
pctile ptile_col_fatherten_yw_`year'=ten_y [w=factorel] if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_fatherten_yw_`year')
}

capture  drop col_fatherten_yw_2019
capture  drop ptile_col_fatherten_yw_2019
pctile ptile_col_fatherten_yw_2019=ten_y [w=factorel] if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_fatherten_yw_2019)

capture  drop col_fatherten_yw_2020
capture  drop ptile_col_fatherten_yw_2020
pctile ptile_col_fatherten_yw_2020=ten_y [w=factorel] if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_fatherten_yw_2020)

capture  drop col_fatherten_yw_2021
capture  drop ptile_col_fatherten_yw_2021
pctile ptile_col_fatherten_yw_2021=ten_y [w=factorel] if ((father==1&husband==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_fatherten_yw_2021)



**************
** NO KIDS - WIFE
***************


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop wifeten_y_`year' 
capture  drop ptile_wifeten_y_`year' 
pctile ptile_wifeten_y_`year' =ten_y if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(wifeten_y_`year' )
}

capture  drop wifeten_y_2019
capture  drop ptile_wifeten_y_2019
pctile ptile_wifeten_y_2019=ten_y if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(wifeten_y_2019)

capture  drop wifeten_y_2020
capture  drop ptile_wifeten_y_2020
pctile ptile_wifeten_y_2020=ten_y if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(wifeten_y_2020)

capture  drop wifeten_y_2021
capture  drop ptile_wifeten_y_2021
pctile ptile_wifeten_y_2021=ten_y if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(wifeten_y_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_wifeten_y_`year'
capture  drop ptile_ncol_wifeten_y_`year'
pctile ptile_ncol_wifeten_y_`year'=ten_y if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_wifeten_y_`year')
}

capture  drop ncol_wifeten_y_2019
capture  drop ptile_ncol_wifeten_y_2019
pctile ptile_ncol_wifeten_y_2019=ten_y if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_wifeten_y_2019)

capture  drop ncol_wifeten_y_2020
capture  drop ptile_ncol_wifeten_y_2020
pctile ptile_ncol_wifeten_y_2020=ten_y if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_wifeten_y_2020)

capture  drop ncol_wifeten_y_2021
capture  drop ptile_ncol_wifeten_y_2021
pctile ptile_ncol_wifeten_y_2021=ten_y if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_wifeten_y_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_wifeten_y_`year'
capture  drop ptile_col_wifeten_y_`year'
pctile ptile_col_wifeten_y_`year'=ten_y if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_wifeten_y_`year')
}

capture  drop col_wifeten_y_2019
capture  drop ptile_col_wifeten_y_2019
pctile ptile_col_wifeten_y_2019=ten_y if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_wifeten_y_2019)

capture  drop col_wifeten_y_2020
capture  drop ptile_col_wifeten_y_2020
pctile ptile_col_wifeten_y_2020=ten_y if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_wifeten_y_2020)

capture  drop col_wifeten_y_2021
capture  drop ptile_col_wifeten_y_2021
pctile ptile_col_wifeten_y_2021=ten_y if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_wifeten_y_2021)


** weighted 


forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop wifeten_yw_`year' 
capture  drop ptile_wifeten_yw_`year' 
pctile ptile_wifeten_yw_`year' =ten_y [w=factorel] if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(wifeten_yw_`year' )
}

capture  drop wifeten_yw_2019
capture  drop ptile_wifeten_yw_2019
pctile ptile_wifeten_yw_2019=ten_y [w=factorel] if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(wifeten_yw_2019)

capture  drop wifeten_yw_2020
capture  drop ptile_wifeten_yw_2020
pctile ptile_wifeten_yw_2020=ten_y [w=factorel] if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(wifeten_yw_2020)

capture  drop wifeten_yw_2021
capture  drop ptile_wifeten_yw_2021
pctile ptile_wifeten_yw_2021=ten_y [w=factorel] if ((mother==0&wife==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(wifeten_yw_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_wifeten_yw_`year'
capture  drop ptile_ncol_wifeten_yw_`year'
pctile ptile_ncol_wifeten_yw_`year'=ten_y [w=factorel] if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_wifeten_yw_`year')
}

capture  drop ncol_wifeten_yw_2019
capture  drop ptile_ncol_wifeten_yw_2019
pctile ptile_ncol_wifeten_yw_2019=ten_y [w=factorel] if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_wifeten_yw_2019)

capture  drop ncol_wifeten_yw_2020
capture  drop ptile_ncol_wifeten_yw_2020
pctile ptile_ncol_wifeten_yw_2020=ten_y [w=factorel] if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_wifeten_yw_2020)

capture  drop ncol_wifeten_yw_2021
capture  drop ptile_ncol_wifeten_yw_2021
pctile ptile_ncol_wifeten_yw_2021=ten_y [w=factorel] if ((mother==0&wife==1&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_wifeten_yw_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_wifeten_yw_`year'
capture  drop ptile_col_wifeten_yw_`year'
pctile ptile_col_wifeten_yw_`year'=ten_y [w=factorel] if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_wifeten_yw_`year')
}

capture  drop col_wifeten_yw_2019
capture  drop ptile_col_wifeten_yw_2019
pctile ptile_col_wifeten_yw_2019=ten_y [w=factorel] if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_wifeten_yw_2019)

capture  drop col_wifeten_yw_2020
capture  drop ptile_col_wifeten_yw_2020
pctile ptile_col_wifeten_yw_2020=ten_y [w=factorel] if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_wifeten_yw_2020)

capture  drop col_wifeten_yw_2021
capture  drop ptile_col_wifeten_yw_2021
pctile ptile_col_wifeten_yw_2021=ten_y [w=factorel] if ((mother==0&wife==1&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_wifeten_yw_2021)


********
** NO KIDS - HUSBAND
*********

forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop husbandten_y_`year'
capture  drop ptile_husbandten_y_`year'
pctile ptile_husbandten_y_`year'=ten_y if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(husbandten_y_`year')
}

capture  drop husbandten_y_2019
capture  drop ptile_husbandten_y_2019
pctile ptile_husbandten_y_2019=ten_y if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(husbandten_y_2019)


capture  drop husbandten_y_2020
capture  drop ptile_husbandten_y_2020
pctile ptile_husbandten_y_2020=ten_y if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(husbandten_y_2020)

capture  drop husbandten_y_2021
capture  drop ptile_husbandten_y_2021
pctile ptile_husbandten_y_2021=ten_y if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(husbandten_y_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_husbandten_y_`year'
capture  drop ptile_ncol_husbandten_y_`year'
pctile ptile_ncol_husbandten_y_`year'=ten_y if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_husbandten_y_`year')
}

capture  drop ncol_husbandten_y_2019
capture  drop ptile_ncol_husbandten_y_2019
pctile ptile_ncol_husbandten_y_2019=ten_y if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_husbandten_y_2019)

capture  drop ncol_husbandten_y_2020
capture  drop ptile_ncol_husbandten_y_2020
pctile ptile_ncol_husbandten_y_2020=ten_y if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_husbandten_y_2020)

capture  drop ncol_husbandten_y_2021
capture  drop ptile_ncol_husbandten_y_2021
pctile ptile_ncol_husbandten_y_2021=ten_y if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_husbandten_y_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_husbandten_y_`year'
capture  drop ptile_col_husbandten_y_`year'
pctile ptile_col_husbandten_y_`year'=ten_y if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_husbandten_y_`year')
}

capture  drop col_husbandten_y_2019
capture  drop ptile_col_husbandten_y_2019
pctile ptile_col_husbandten_y_2019=ten_y if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_husbandten_y_2019)

capture  drop col_husbandten_y_2020
capture  drop ptile_col_husbandten_y_2020
pctile ptile_col_husbandten_y_2020=ten_y if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_husbandten_y_2020)

capture  drop col_husbandten_y_2021
capture  drop ptile_col_husbandten_y_2021
pctile ptile_col_husbandten_y_2021=ten_y if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_husbandten_y_2021)



** weighted

forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop husbandten_yw_`year'
capture  drop ptile_husbandten_yw_`year'
pctile ptile_husbandten_yw_`year'=ten_y [w=factorel] if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(husbandten_yw_`year')
}

capture  drop husbandten_yw_2019
capture  drop ptile_husbandten_yw_2019
pctile ptile_husbandten_yw_2019=ten_y [w=factorel] if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(husbandten_yw_2019)


capture  drop husbandten_yw_2020
capture  drop ptile_husbandten_yw_2020
pctile ptile_husbandten_yw_2020=ten_y [w=factorel] if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(husbandten_yw_2020)

capture  drop husbandten_yw_2021
capture  drop ptile_husbandten_yw_2021
pctile ptile_husbandten_yw_2021=ten_y [w=factorel] if ((father==0&husband==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(husbandten_yw_2021)



forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop ncol_husbandten_yw_`year'
capture  drop ptile_ncol_husbandten_yw_`year'
pctile ptile_ncol_husbandten_yw_`year'=ten_y [w=factorel] if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(ncol_husbandten_yw_`year')
}

capture  drop ncol_husbandten_yw_2019
capture  drop ptile_ncol_husbandten_yw_2019
pctile ptile_ncol_husbandten_yw_2019=ten_y [w=factorel] if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(ncol_husbandten_yw_2019)

capture  drop ncol_husbandten_yw_2020
capture  drop ptile_ncol_husbandten_yw_2020
pctile ptile_ncol_husbandten_yw_2020=ten_y [w=factorel] if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(ncol_husbandten_yw_2020)

capture  drop ncol_husbandten_yw_2021
capture  drop ptile_ncol_husbandten_yw_2021
pctile ptile_ncol_husbandten_yw_2021=ten_y [w=factorel] if ((husband==1&father==0&college==0)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(ncol_husbandten_yw_2021)




forvalues i=0(1)3 {
local year=2015+`i'
local bqtr=170+4*`i'
local eqtr=173+4*`i'

capture  drop col_husbandten_yw_`year'
capture  drop ptile_col_husbandten_yw_`year'
pctile ptile_col_husbandten_yw_`year'=ten_y [w=factorel] if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=`bqtr' & ciclo<=`eqtr', nq(200) gen(col_husbandten_yw_`year')
}

capture  drop col_husbandten_yw_2019
capture  drop ptile_col_husbandten_yw_2019
pctile ptile_col_husbandten_yw_2019=ten_y [w=factorel] if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=186 & ciclo<=190, nq(200) gen(col_husbandten_yw_2019)

capture  drop col_husbandten_yw_2020
capture  drop ptile_col_husbandten_yw_2020
pctile ptile_col_husbandten_yw_2020=ten_y [w=factorel] if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=191 & ciclo<=193, nq(200) gen(col_husbandten_yw_2020)

capture  drop col_husbandten_yw_2021
capture  drop ptile_col_husbandten_yw_2021
pctile ptile_col_husbandten_yw_2021=ten_y [w=factorel] if ((husband==1&father==0&college==1)) & employed&age>=30&age<35 & ciclo>=194 & ciclo<=197, nq(200) gen(col_husbandten_yw_2021)


preserve
keep ptile* husband* wife* mother* father* ncol* col*
drop college
drop wife wife_state wife_erte wife_ten wife_ten0 wife_age wife_college wife_less_hs wife_ten_y wife_ten_y2 wife_ten0_y wife_ten0_y2 wife_ten_g5 wife_age2 wife_pc wife_emp wife_se 
drop mother mother_state mother_erte mother_ten mother_ten_y mother_ten_g mother_ten_g5 
drop father father_state father_erte father_ten father_ten_y father_ten_g father_ten_g5 
drop husband
duplicates drop

save pctiles.dta, replace


** noncol mothers
twoway scatter ptile_ncol_motherten_y_2015 ncol_motherten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_y_2016 ncol_motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_y_2017 ncol_motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_y_2018 ncol_motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_y_2019 ncol_motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_motherten_y_2020 ncol_motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_motherten_y_2021 ncol_motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_motherten_ptile.pdf, replace

twoway scatter ptile_ncol_motherten_yw_2015 ncol_motherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_yw_2016 ncol_motherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_yw_2017 ncol_motherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_yw_2018 ncol_motherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_motherten_yw_2019 ncol_motherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_motherten_yw_2020 ncol_motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_motherten_yw_2021 ncol_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_motherten_wptile.pdf, replace

**college mothers
twoway scatter ptile_col_motherten_y_2015 col_motherten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_y_2016 col_motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_y_2017 col_motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_y_2018 col_motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_y_2019 col_motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_motherten_y_2020 col_motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_motherten_y_2021 col_motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))

graph export col_motherten_ptile.pdf, replace


twoway scatter ptile_col_motherten_yw_2015 col_motherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_yw_2016 col_motherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_yw_2017 col_motherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_yw_2018 col_motherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_motherten_yw_2019 col_motherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_motherten_yw_2020 col_motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_motherten_yw_2021 col_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))

graph export col_motherten_wptile.pdf, replace



twoway scatter ptile_motherten_yw_2015 motherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_yw_2016 motherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_yw_2017 motherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_yw_2018 motherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_yw_2019 motherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_motherten_yw_2020 motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_motherten_yw_2021 motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))

graph export motherten_wptile.pdf, replace



** FATHERS **

** ncollege fathers
twoway scatter ptile_ncol_fatherten_y_2015 ncol_fatherten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_y_2016 ncol_fatherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_y_2017 ncol_fatherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_y_2018 ncol_fatherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_y_2019 ncol_fatherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_fatherten_y_2020 ncol_fatherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_fatherten_y_2021 ncol_fatherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_fatherten_ptile.pdf, replace


twoway scatter ptile_ncol_fatherten_yw_2015 ncol_fatherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_yw_2016 ncol_fatherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_yw_2017 ncol_fatherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_yw_2018 ncol_fatherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_fatherten_yw_2019 ncol_fatherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_fatherten_yw_2020 ncol_fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_fatherten_yw_2021 ncol_fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_fatherten_wptile.pdf, replace


** college fathers
twoway scatter ptile_col_fatherten_y_2015 col_fatherten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_y_2016 col_fatherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_y_2017 col_fatherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_y_2018 col_fatherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_y_2019 col_fatherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_fatherten_y_2020 col_fatherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_fatherten_y_2021 col_fatherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 

graph export col_fatherten_ptile.pdf, replace


twoway scatter ptile_col_fatherten_yw_2015 col_fatherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_yw_2016 col_fatherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_yw_2017 col_fatherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_yw_2018 col_fatherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_fatherten_yw_2019 col_fatherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_fatherten_yw_2020 col_fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_fatherten_yw_2021 col_fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 

graph export col_fatherten_wptile.pdf, replace

** all father
twoway scatter ptile_fatherten_yw_2015 fatherten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_fatherten_yw_2016 fatherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_fatherten_yw_2017 fatherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_fatherten_yw_2018 fatherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_fatherten_yw_2019 fatherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_fatherten_yw_2020 fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_fatherten_yw_2021 fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 

graph export fatherten_wptile.pdf, replace

** WIFE NK **

** noncollege wife, nk
twoway scatter ptile_ncol_wifeten_y_2015 ncol_wifeten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_y_2016 ncol_wifeten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_y_2017 ncol_wifeten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_y_2018 ncol_wifeten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_y_2019 ncol_wifeten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_wifeten_y_2020 ncol_wifeten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_wifeten_y_2021 ncol_wifeten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))

graph export noncol_wifeten_ptile.pdf, replace


twoway scatter ptile_ncol_wifeten_yw_2015 ncol_wifeten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_yw_2016 ncol_wifeten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_yw_2017 ncol_wifeten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_yw_2018 ncol_wifeten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_wifeten_yw_2019 ncol_wifeten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_wifeten_yw_2020 ncol_wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_wifeten_yw_2021 ncol_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))

graph export noncol_wifeten_wptile.pdf, replace


** college wife, nk 
twoway scatter ptile_col_wifeten_y_2015 col_wifeten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_y_2016 col_wifeten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_y_2017 col_wifeten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_y_2018 col_wifeten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_y_2019 col_wifeten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_wifeten_y_2020 col_wifeten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_wifeten_y_2021 col_wifeten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export col_wifeten_ptile.pdf, replace


twoway scatter ptile_col_wifeten_yw_2015 col_wifeten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_yw_2016 col_wifeten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_yw_2017 col_wifeten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_yw_2018 col_wifeten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_wifeten_yw_2019 col_wifeten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_wifeten_yw_2020 col_wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_wifeten_yw_2021 col_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export col_wifeten_wptile.pdf, replace

** all wife,nk
twoway scatter ptile_wifeten_yw_2015 wifeten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_wifeten_yw_2016 wifeten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_wifeten_yw_2017 wifeten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_wifeten_yw_2018 wifeten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_wifeten_yw_2019 wifeten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_wifeten_yw_2020 wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_wifeten_yw_2021 wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export wifeten_wptile.pdf, replace



** HUSBANK NK **

** noncol husband, nk
twoway scatter ptile_ncol_husbandten_y_2015 ncol_husbandten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_y_2016 ncol_husbandten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_y_2017 ncol_husbandten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_y_2018 ncol_husbandten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_y_2019 ncol_husbandten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_husbandten_y_2020 ncol_husbandten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_husbandten_y_2021 ncol_husbandten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_husbandten_ptile.pdf, replace


twoway scatter ptile_ncol_husbandten_yw_2015 ncol_husbandten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_yw_2016 ncol_husbandten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_yw_2017 ncol_husbandten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_yw_2018 ncol_husbandten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_ncol_husbandten_yw_2019 ncol_husbandten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_ncol_husbandten_yw_2020 ncol_husbandten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_ncol_husbandten_yw_2021 ncol_husbandten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white))
graph export noncol_husbandten_wptile.pdf, replace

** collge husbank, nk
twoway scatter ptile_col_husbandten_y_2015 col_husbandten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_y_2016 col_husbandten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_y_2017 col_husbandten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_y_2018 col_husbandten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_y_2019 col_husbandten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_husbandten_y_2020 col_husbandten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_husbandten_y_2021 col_husbandten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export col_husbandten_ptile.pdf, replace

scatter ptile_col_husbandten_yw_2015 col_husbandten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_yw_2016 col_husbandten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_yw_2017 col_husbandten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_yw_2018 col_husbandten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_col_husbandten_yw_2019 col_husbandten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_col_husbandten_yw_2020 col_husbandten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_col_husbandten_yw_2021 col_husbandten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export col_husbandten_wptile.pdf, replace

** husband, nk
twoway scatter ptile_husbandten_y_2015 husbandten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_y_2016 husbandten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_y_2017 husbandten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_y_2018 husbandten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_y_2019 husbandten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_husbandten_y_2020 husbandten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_husbandten_y_2021 husbandten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export husbandten_ptile.pdf, replace

scatter ptile_husbandten_yw_2015 husbandten_yw_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_yw_2016 husbandten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_yw_2017 husbandten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_yw_2018 husbandten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_husbandten_yw_2019 husbandten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_husbandten_yw_2020 husbandten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_husbandten_yw_2021 husbandten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2015") label(2 "2016") label(3 "2017") label(4 "2018") label(5 "2019") label(6 "2020") label(7 "2021") row(2)) graphregion(color(white)) 
graph export husbandten_wptile.pdf, replace




scatter ptile_motherten_y_2018 motherten_y_2018 || scatter ptile_motherten_y_2019 motherten_y_2019 || scatter ptile_motherten_y_2020 motherten_y_2020 || scatter ptile_motherten_y_2021 motherten_y_2021

scatter ptile_motherten_y_2015 motherten_y_2015 || scatter ptile_motherten_y_2016 motherten_y_2016 || scatter ptile_motherten_y_2017 motherten_y_2017 || scatter ptile_motherten_y_2018 motherten_y_2018

twoway scatter ptile_motherten_y_2015 motherten_y_2015, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_y_2016 motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_y_2017 motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_y_2018 motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter ptile_motherten_y_2019 motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter ptile_motherten_y_2020 motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter ptile_motherten_y_2021 motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red)


scatter ptile_husbandten_y_2018 husbandten_y_2018 || scatter ptile_husbandten_y_2019 husbandten_y_2019 || scatter ptile_husbandten_y_2020 husbandten_y_2020 || scatter ptile_husbandten_y_2021 husbandten_y_2021



*** difference with previous year
set varabbrev off
capture drop ptile
gen ptile=ptile_motherten_y_2015

local locvarlist "motherten col_motherten ncol_motherten wifeten col_wifeten ncol_wifeten fatherten col_fatherten ncol_fatherten husbandten col_husbandten ncol_husbandten"

foreach locvarname of local locvarlist {
forvalues i=1(1)6 {
local year=2015+`i'
local yearbfr=2015+`i'-1

capture drop gen dptile_`locvarname'_y_`year'
cap n gen dptile_`locvarname'_y_`year'=ptile_`locvarname'_y_`year'-ptile_`locvarname'_y_`yearbfr'
capture drop gen dptile_`locvarname'_yw_`year'
cap n gen dptile_`locvarname'_yw_`year'=ptile_`locvarname'_yw_`year'-ptile_`locvarname'_yw_`yearbfr'
}
}

foreach locvarname of local locvarlist {
forvalues i=1(1)2 {
local year=2019+`i'
local yearbfr=2019

capture drop gen dp_`locvarname'_y_`year'y19
cap n gen dp_`locvarname'_y_`year'y19=ptile_`locvarname'_y_`year'-ptile_`locvarname'_y_`yearbfr'
capture drop gen dp_`locvarname'_yw_`year'y19
cap n gen dp_`locvarname'_yw_`year'y19=ptile_`locvarname'_yw_`year'-ptile_`locvarname'_yw_`yearbfr'
}
}


** pictures

twoway scatter dptile_ncol_motherten_y_2016 ncol_motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_y_2017 ncol_motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_y_2018 ncol_motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_y_2019 ncol_motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_motherten_y_2020 ncol_motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_motherten_y_2021 ncol_motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))
graph export noncol_motherten_dptile.pdf, replace

twoway scatter dptile_ncol_motherten_yw_2016 ncol_motherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_yw_2017 ncol_motherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_yw_2018 ncol_motherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_motherten_yw_2019 ncol_motherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_motherten_yw_2020 ncol_motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_motherten_yw_2021 ncol_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))
graph export noncol_motherten_dptile_wgt.pdf, replace

** noncollege
twoway scatter dp_ncol_motherten_yw_2020y19 ncol_motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_motherten_yw_2021y19 ncol_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_noncol_motherten_dptile_wgt.pdf, replace

twoway scatter dp_ncol_wifeten_yw_2020y19 ncol_wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_wifeten_yw_2021y19 ncol_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_noncol_wifeten_dptile_wgt.pdf, replace


twoway scatter dp_ncol_fatherten_yw_2020y19 ncol_fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_fatherten_yw_2021y19 ncol_fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_noncol_fatherten_dptile_wgt.pdf, replace

twoway scatter dp_ncol_husbandten_yw_2020y19 ncol_husbandten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_husbandten_yw_2021y19 ncol_husbandten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_noncol_husbandten_dptile_wgt.pdf, replace

** within gender comparison
twoway scatter dp_ncol_motherten_yw_2021y19 ncol_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_wifeten_yw_2021y19 ncol_motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "mother") label(2 "wife") row(2)) graphregion(color(white))
graph export d19_noncol_femaleten_dptile_wgt.pdf, replace

twoway scatter dp_ncol_fatherten_yw_2021y19 ncol_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_ncol_husbandten_yw_2021y19 ncol_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "father") label(2 "husband, nk") row(2)) graphregion(color(white))
graph export d19_noncol_maleten_dptile_wgt.pdf, replace


**** SHIFT OF TENURE DISTRIBUTION: MOTHERS/WIVES
capture drop ldp_motherten_yw_2021y19
lowess dp_motherten_yw_2021y19 motherten_yw_2021, gen(ldp_motherten_yw_2021y19) bwidth(0.4)

capture drop ldp_wifeten_yw_2021y19
lowess dp_wifeten_yw_2021y19 wifeten_yw_2021, gen(ldp_wifeten_yw_2021y19) bwidth(0.4)

twoway scatter dp_motherten_yw_2021y19 motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_wifeten_yw_2021y19 motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "mother") label(2 "wife") row(2)) graphregion(color(white)) 
graph export d19_femaleten_dptile_wgt.pdf, replace

twoway scatter ldp_motherten_yw_2021y19 motherten_yw_2021 if motherten_yw_2021>=5 & motherten_yw_2021<=95, msymbol(o ) msize(vsmall ) mcolor(midblue) lcolor(midblue) connect(l) || ///
scatter ldp_wifeten_yw_2021y19 motherten_yw_2021 if motherten_yw_2021>=5 & motherten_yw_2021<=95, msymbol(th ) msize(vsmall ) mcolor(ltblue) lcolor(ltblue)  legend(label(1 "mother") label(2 "wife, no kids") row(1)) graphregion(color(white)) connect(l) xtitle("Percentiles of Tenure Distribution") ytitle("Difference Tenure in Years" "2021 vs 2019 Tenure Distribution") ylabel(-1(0.5)1) yline(0, lcolor(black))
graph export d19_femaleten_dptile_wgt.pdf, replace


**** SHIFT OF TENURE DISTRIBUTION: FATHERS/HUSBANDS
capture drop ldp_fatherten_yw_2021y19
lowess dp_fatherten_yw_2021y19 fatherten_yw_2021, gen(ldp_fatherten_yw_2021y19) bwidth(0.4)

capture drop ldp_husbandten_yw_2021y19
lowess dp_husbandten_yw_2021y19 husbandten_yw_2021, gen(ldp_husbandten_yw_2021y19) bwidth(0.4)

twoway scatter dp_fatherten_yw_2021y19 fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_husbandten_yw_2021y19 fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "father") label(2 "husband") row(2)) graphregion(color(white)) 
graph export d19_femaleten_dptile_wgt.pdf, replace

twoway scatter ldp_fatherten_yw_2021y19 fatherten_yw_2021 if fatherten_yw_2021>=5 & fatherten_yw_2021<=95, msymbol(o ) msize(vsmall ) mcolor(dkgreen) lcolor(dkgreen) connect(l) || ///
scatter ldp_husbandten_yw_2021y19 fatherten_yw_2021 if fatherten_yw_2021>=5 & fatherten_yw_2021<=95, msymbol(th ) msize(vsmall ) mcolor(olive_teal) lcolor(olive_teal)  legend(label(1 "father") label(2 "husband, no kids") row(1)) graphregion(color(white)) connect(l) xtitle("Percentiles of Tenure Distribution") ytitle("Difference Tenure in Years" "2021 vs 2019 Tenure Distribution") ylabel(-1(0.5)1) yline(0, lcolor(black))
graph export d19_maleten_dptile_wgt.pdf, replace

*****
** FOR NON-COLLEGE 

twoway scatter dp_fatherten_yw_2021y19 wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_husbandten_yw_2021y19 wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "father") label(2 "husband, nk") row(2)) graphregion(color(white))
graph export d19_maleten_dptile_wgt.pdf, replace


** all
twoway scatter dp_motherten_yw_2020y19 motherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_motherten_yw_2021y19 motherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_nomotherten_dptile_wgt.pdf, replace

twoway scatter dp_wifeten_yw_2020y19 wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_wifeten_yw_2021y19 wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_nowifeten_dptile_wgt.pdf, replace


twoway scatter dp_fatherten_yw_2020y19 fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_fatherten_yw_2021y19 fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_nofatherten_dptile_wgt.pdf, replace

twoway scatter dp_husbandten_yw_2020y19 husbandten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dp_husbandten_yw_2021y19 husbandten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2020-2019") label(2 "2021-2019") row(2)) graphregion(color(white))
graph export d19_nohusbandten_dptile_wgt.pdf, replace






twoway scatter dptile_ncol_wifeten_y_2016 ncol_wifeten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_y_2017 ncol_wifeten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_y_2018 ncol_wifeten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_y_2019 ncol_wifeten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_wifeten_y_2020 ncol_wifeten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_wifeten_y_2021 ncol_wifeten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export noncol_wifeten_dptile.pdf, replace


twoway scatter dptile_ncol_wifeten_yw_2016 ncol_wifeten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_yw_2017 ncol_wifeten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_yw_2018 ncol_wifeten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_wifeten_yw_2019 ncol_wifeten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_wifeten_yw_2020 ncol_wifeten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_wifeten_yw_2021 ncol_wifeten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export noncol_wifeten_dptile_wgt.pdf, replace



twoway scatter dptile_ncol_fatherten_y_2016 ncol_fatherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_fatherten_y_2017 ncol_fatherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_fatherten_y_2018 ncol_fatherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_fatherten_y_2019 ncol_fatherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_fatherten_y_2020 ncol_fatherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_fatherten_y_2021 ncol_fatherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export noncol_fatherten_dptile.pdf, replace



twoway scatter dptile_ncol_husbandten_y_2016 ncol_husbandten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_husbandten_y_2017 ncol_husbandten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_husbandten_y_2018 ncol_husbandten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_ncol_husbandten_y_2019 ncol_husbandten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_ncol_husbandten_y_2020 ncol_husbandten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_ncol_husbandten_y_2021 ncol_husbandten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export noncol_husbandten_dptile.pdf, replace




twoway scatter dptile_col_motherten_y_2016 col_motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_col_motherten_y_2017 col_motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_col_motherten_y_2018 col_motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_col_motherten_y_2019 col_motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_col_motherten_y_2020 col_motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_col_motherten_y_2021 col_motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export col_motherten_dptile.pdf, replace



twoway scatter dptile_col_wifeten_y_2016 col_wifeten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_col_wifeten_y_2017 col_wifeten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_col_wifeten_y_2018 col_wifeten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_col_wifeten_y_2019 col_wifeten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_col_wifeten_y_2020 col_wifeten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_col_wifeten_y_2021 col_wifeten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export col_wifeten_dptile.pdf, replace




twoway scatter dptile_motherten_y_2016 motherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_motherten_y_2017 motherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_motherten_y_2018 motherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_motherten_y_2019 motherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_motherten_y_2020 motherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_motherten_y_2021 motherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export motherten_dptile.pdf, replace



twoway scatter dptile_wifeten_y_2016 wifeten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_wifeten_y_2017 wifeten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_wifeten_y_2018 wifeten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_wifeten_y_2019 wifeten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_wifeten_y_2020 wifeten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_wifeten_y_2021 wifeten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export wifeten_dptile.pdf, replace




twoway scatter dptile_fatherten_y_2016 fatherten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_y_2017 fatherten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_y_2018 fatherten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_y_2019 fatherten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_fatherten_y_2020 fatherten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_fatherten_y_2021 fatherten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export fatherten_dptile.pdf, replace


twoway scatter dptile_fatherten_yw_2016 fatherten_yw_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_yw_2017 fatherten_yw_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_yw_2018 fatherten_yw_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_fatherten_yw_2019 fatherten_yw_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_fatherten_yw_2020 fatherten_yw_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_fatherten_yw_2021 fatherten_yw_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export fatherten_dptile_wgt.pdf, replace




twoway scatter dptile_husbandten_y_2016 husbandten_y_2016, msymbol(oh ) msize(small ) || ///
scatter dptile_husbandten_y_2017 husbandten_y_2017, msymbol(oh ) msize(small ) || ///
scatter dptile_husbandten_y_2018 husbandten_y_2018, msymbol(oh ) msize(small ) || ///
scatter dptile_husbandten_y_2019 husbandten_y_2019 , msymbol(dh ) msize(small )|| ///
scatter dptile_husbandten_y_2020 husbandten_y_2020 , msymbol(t ) msize(small ) mcolor(black) || ///
scatter dptile_husbandten_y_2021 husbandten_y_2021 , msymbol(t ) msize(small ) mcolor(red) legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019") label(5 "2020") label(6 "2021") row(2)) graphregion(color(white))


graph export husbandten_dptile.pdf, replace