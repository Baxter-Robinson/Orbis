



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

*global javier_faraday "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/javier_faraday"
*mkdir $javier_faraday


* Subsection 7.1 Valid Equity Market Depth Calculations vs. World Bank Numbers
/* Cross country graph is done as follows:
	* 1. Calculate the equity market depth for Orbis, Compustat and the World Bank per country
	* 2. Integrate it in the same file and create the scatter plots that you find in 7.1 

*/

* 1. Calculate the equity market depth for Orbis, Compustat and the World Bank per country	
*global Countries IT PT ES FR DE NL
global Countries AT BE CZ DE ES FI FR IT NL PT   // HU US GB


* ----------------------------------------------------------------------------------------------------------------------------------
local Country="IT"

use "Data_Raw/`Country'_StockPrice.dta", clear // This is needed for the following do file written here...

* -------------------------- do CS_EquityMarketDepth.do --------------------------
	
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


/* Cannot employ the command written by emmanuel(?)

		collapse (max) StockPrice cshoc, by(gvkey Year) 

because this collapses the higher stock price and the issuance without regard to the issue id, and for the same firm at same year,
the value for type of emmission (issuance) varies.
See the example below:

*keep  if gvkey=="015549" & Year==2010

Notice that for 2010, this firm has 4 emmissions so collapsing makes a measurement error

*/

* This only works for Italy as I was doing the example with it.
/*
preserve
keep if gvkey=="015549" & Year==2010
scatter StockPrice cshoc  , legend(pos(3) col(1)) title("Italy - Firm 015549 Stock Prices and Quantities", box lcolor(red)) 
restore
*/

bysort gvkey Year: egen n_Emmisions = count(iid)


* Then the collapse of the data imposes a problem? 
collapse (max) StockPrice cshoc, by(gvkey Year) 



*keep if Month == 12 & Day == 31 // keeps only end of year values. what if you dont have the 31 for all days...

collapse (max) StockPrice cshoc, by(gvkey Year) // You are collapsing over issue iD? dont this means that you lose the data that you have for the emmissions that are not the max? Shouldn't be collapsing for the sum ?


gen mve_yearend = StockPrice*cshoc



save Data_Cleaned/${CountryID}_StockPrice.dta,replace


* Get single average over 2010-2018 (2010-2014 for France)
merge 1:1 gvkey Year using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta"
drop _merge
drop if Year < 2010
drop if Year > 2018
if "${CountryID}" =="FR" {
	drop if Year > 2014
}
gen mve_annual = StockPrice*cshoi
replace mve_annual = mve_yearend if mve_annual == . & mve_yearend != .
replace mve_yearend = mve_annual if mve_yearend == . & mve_annual != .
collapse (sum) mve_yearend mve_annual cshoc cshoi, by(Year)
collapse (mean) mve_yearend mve_annual cshoc cshoi
lab var mve_yearend "Market Value of Equity - Millions (Compustat Global - Security Daily)"
lab var mve_annual "Market Value of Equity - Millions (Compustat Global - Annual)"
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Security Daily)" // why two different labels for the same variable? 
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Annual)"

gen Country = "${CountryID}"
merge 1:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
drop _merge
save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace

	
* ----------------------------------------------------------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------------------------------------------------------
* -------------------------- do Load_Cross-Country-Dataset.do --------------------------

clear all

foreach Country of global Countries {
    append using "Data_Cleaned/`Country'_CountryLevel.dta"
	
}

merge 1:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
drop _merge


merge 1:1 Country using "Data_Cleaned/WB_MarketCapToGDP.dta"
drop _merge


drop avgEmpGrowth_Private varEmpGrowth_Private empShare_Private avgEmpGrowth_Public varEmpGrowth_Public empShare_Public empShare_LargeFirms nEmployees tfp OutputPerCapita CapitalToLabor CapitalToOutput

gen EquityMktDepth_CSyearend = mve_yearend/gdpo
gen EquityMktDepth_CSAnnual = mve_annual/gdpo
gen EquityMktDepth_OB = MarketCap/gdpo


save "Data_Cleaned/CrossCountry_Dataset.dta",replace
* ----------------------------------------------------------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------------------------------------------------------
* -------------------------- do Graph_CrossCountry.do --------------------------

* Country-level scatter plots between Eequity market depth and selected indicators

* Compare Equity Market Depth
twoway (scatter EquityMktDepth_OB EquityMktDepth_WB , mlabel(Country)) ///
(line EquityMktDepth_OB EquityMktDepth_OB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Orbis Equity Market Depth") graphregion(color(white))
graph export Output/Cross-Country/EquityMktDepth_OBvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSyearend EquityMktDepth_WB, mlabel(Country)) ///
(line EquityMktDepth_OB EquityMktDepth_OB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (year end) Equity Market Depth") graphregion(color(white))
graph export Output/Cross-Country/EquityMktDepth_CSyearendvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSAnnual EquityMktDepth_WB , mlabel(Country)) ///
(line EquityMktDepth_OB EquityMktDepth_OB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (annual) Equity Market Depth") graphregion(color(white))
graph export Output/Cross-Country/EquityMktDepth_CSAnnualvsWB.pdf, replace



