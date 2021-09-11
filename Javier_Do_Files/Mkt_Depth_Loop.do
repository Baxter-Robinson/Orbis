




*----------------
* Initial Set Up
*----------------


cls
clear all
*version 13
*set maxvar 10000
set type double
set more off


* Baxter PATH
*if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
*if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
*cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
*global DATAPATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"


* Emmanuel PATH
* Desktop
*cd "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"
* Laptop
*cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"


* Javier PATH
* Home
cd "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"
* School
*cd "/Volumes/MacMiniExt/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Volumes/MacMiniExt/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

global javier_faraday "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/javier_faraday"
*mkdir $javier_faraday


* Subsection 7.1 Valid Equity Market Depth Calculations vs. World Bank Numbers
/* Cross country graph is done as follows:
	* 1. Calculate the equity market depth for Orbis, Compustat and the World Bank per country
	* 2. Integrate it in the same file and create the scatter plots that you find in 7.1 

*/

* 1. Calculate the equity market depth for Orbis, Compustat and the World Bank per country	



global Countries AT BE CZ DE ES FI FR IT    //  NL PT		 HU US GB 
foreach Country of global Countries {


	*local Country = "AT"
	clear all
	global CountryID="`Country'"
	
	use "Data_Raw/`Country'_StockPrice.dta", clear // This is needed for the following do file written here...
	
	
	gen Year = year(datadate)
	gen Month = month(datadate)
	gen Day = day(datadate)

	keep if Month == 12 
	bysort Year: egen t=max(Day)
	keep if t==Day
	sort gvkey iid Year
	drop t

	rename prccd StockPrice // Stock price
	replace cshoc = cshoc/1000000  // So everything is per million of outstanding shares
	gen mve_yearend = StockPrice*cshoc
	
	
	* Difference between my measure and emmanuel's
	preserve
	collapse (sum) mve_yearend,  by(gvkey Year) 
	gen  mve_yearend_J = mve_yearend
	*local Country = "AT"
	merge 1:1 gvkey Year using "Data_Cleaned/${CountryID}_StockPrice.dta", keepusing(mve_yearend) 
	rename mve_yearend mve_yearend_E
	ttest mve_yearend_J mve_yearend_E
	gen dif_mve = mve_yearend_J - mve_yearend_E	
	gen l_dif_mve =log(dif_mve)
	graph box dif_mve, title("`Country' Boxplot of differences in market value") subtitle("New value - Old value") ytitle("Millions of euros?")
	graph export   "$javier_faraday/`Country'_Mkt_Value_Box_Comparison.png", replace
	graph box l_dif_mve, title("`Country' Boxplot of differences in market value") subtitle("New value - Old value") ytitle("(Log of) Millions of euros?")
	graph export   "$javier_faraday/`Country'_Mkt_Value_Box_Log_Comparison.png", replace
	restore
	
	
	
	bysort gvkey Year: egen n_Emmisions = count(iid)
	hist n_Emmisions, freq legend(pos(3) col(1)) title("`Country' stock issuances", box lcolor(red)) xtitle("Number of different emissions") ytitle("Number of firms")
	graph export "$javier_faraday/`Country'_Firms_and_emmissions.png", replace
	
	
	
}










