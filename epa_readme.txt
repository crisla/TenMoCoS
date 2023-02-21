* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* README - formating the Spanish LFS microdata stock files
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
0. get a working folder. Create inside your working folder one called rawfiles_stocks
1. Download the data here: https://www.ine.es/uc/pNpBaUUm
2. Decompress the data into rawfiles_stocks
3. Harmonize the names:
   	- The data from 2005 on is in dta. format. Older data needs to be imported (code not there yet)
	- Make sure the files are called EPA_yyyyTq.dta, with yyyy = year (ie. 2005, 2020) and q={1,2,3,4}
4. Run formattingStocks.do => this will create EPA_stocks20.dta , a more generical file that can be use for other applications.
5. Run formatting_families_stocks => this will crate EPA_stocks20_parents.dta , a file with info on
	- household composition (indicator for parent, kid, spouse)
	- labour amrket state and variables (state, STW indicator)
	- tenure and labour amrket information of your partner if co-habitating.
6. The data is ready to use with quantile regressions.

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Cristina Lafuente - 21/02/2023