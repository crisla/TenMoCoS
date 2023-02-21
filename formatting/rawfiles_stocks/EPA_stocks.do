* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
*
* Formatting file for Spanish LFS - Stocks version
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
cd rawfiles_stocks

use EPA_2013T4, clear
forvalues Y = 14/20 {
	forvalues Q = 1/4 {
		append using EPA_20`Y'T`Q'
	}
}

