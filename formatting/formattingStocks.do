* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Formatting file for Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
cd rawfiles_stocks

* 1 Lower case conversion * * * * * * * * * * * * * * * * * * 
use EPA_2020T4, clear

foreach v of varlist _all{
rename `v' `=lower("`v'")'
}
save EPA_2020T4, replace

forvalues Y = 21/22 {
	forvalues Q = 1/4 {
 		use EPA_20`Y'T`Q'
 		foreach v of varlist _all{
 			rename `v' `=lower("`v'")'
 		}
 		save EPA_20`Y'T`Q', replace
 	}
	}

* 2 Appending * * * * * * * * * * * * * * * * * * 
clear
use EPA_2005T1
forvalues Y = 5/22 {
	local year= 2000+`Y'
	forvalues Q = 1/4 {
		append using EPA_`year'T`Q'
	}
}

replace edad5 = edad1 if edad5==""
drop edad1

destring edad5, replace
destring sexo1, replace
destring eciv1, replace
destring npers, replace

destring ducon1, replace
destring ducon2, replace
destring situ, replace
destring aoi, replace

destring rznotb rzdifh, replace
destring  nmadre npadre, replace

destring ciclo, replace

// CLEAN HOURS //

destring horase horasp horash, replace

foreach var of varlist horase horasp horash {
	replace `var' = . if `var' == 9999
	gen minutes = mod(`var',100)
	replace minutes = minutes/60
	replace `var' = floor(`var'/100) + minutes
	drop minutes
}
*

gen facexp = factorel*100

save EPA_stocks20.dta, replace

cd ..
