********************************************
* Change variable names to match Orbis data
********************************************

rename fyear Year
rename at Assets
rename emp nEmployees
*rename sale Sales
rename revt Sales
rename opprft GrossProfits
rename cshr nShareholders
replace nShareholders = nShareholders*1000
replace nShareholders = . if nShareholders == 0

*************
* Clean data
*************

egen FirstYear=min(Year), by(gvkey)
gen Age = Year-FirstYear
egen IDNum=group(gvkey)
gen IPO_year = year(ipodate)

* Convert to same units as Orbis
replace nEmployees = nEmployees*1000 // Thousand to actual number 
replace Sales = Sales*1000 // Millions to thousands
*replace Revenue = Revenues*1000 // Millions to thousands
replace Assets = Assets*1000 // Millions to thousands
replace GrossProfits = GrossProfits*1000 // Millions to Thousands

* Drop outliers
drop if Sales < 0
drop if nEmployees < 0

**************************
* Convert currency to USD
**************************

merge m:1 Year using "Data_Raw/Exchange_rate.dta"
replace eur = ecu if eur == .
keep if (curcd == "FRF") | (curcd == "EUR") | (curcd == "USD") | (curcd == "CHF") | (curcd == "HUF") | (curcd == "CZK") | (curcd == "ITL") | (curcd == "PLN")
local varlists Sales Assets GrossProfits
local N = _N
forvalues i = 1/`N' {
	foreach v of local varlists {
		if curcd[`i'] == "FRF" {
			qui replace `v' = `v'/frf in `i'
		}
		else if curcd[`i'] == "EUR" {
			qui replace `v' = `v'/eur in `i'
		}
		else if curcd[`i'] == "CHF" {
			qui replace `v' = `v'/chf in `i'
		}
		else if curcd[`i'] == "HUF" {
			qui replace `v' = `v'/huf in `i'
		}
		else if curcd[`i'] == "CZK" {
			qui replace `v' = `v'/czk in `i'
		}
		else if curcd[`i'] == "ITL" {
			qui replace `v' = `v'/itl in `i'
		}
		else if curcd[`i'] == "PLN" {
			qui replace `v' = `v'/pln in `i'
		}
	}
}

*----------------------
* Save unbalanced panel
*----------------------

keep Year gvkey IDNum IPO_year Age nEmployees Sales Assets GrossProfits nShareholders
save "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta", replace

*------------------
* Balanced Panel
*------------------

* Narrower year range for France
if "${CountryID}" == "FR"{
	drop if (Year<2010)	
	drop if (Year>2014)
	drop if Sales == .
	drop if nEmployees == .
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2010, 2014)), by(IDNum)
	keep if nyear == 5
	drop nyear
}
* Regular year range for other countries
else {
	drop if (Year<2009)
	drop if (Year>2018)
	drop if Sales == .
	drop if nEmployees == .
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2009, 2018)), by(IDNum)
	keep if nyear == 10
	drop nyear
}

* Making sure it is strongly balanced 
xtset IDNum Year 

*--------------------
* Save balanced panel
*--------------------

save "Data_Cleaned/${CountryID}_CompustatBalanced.dta", replace

