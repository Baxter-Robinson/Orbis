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

gen SalesPerEmployee=Sales/nEmployees

**************************
* Convert currency to USD
**************************

merge m:1 Year using "${DATAPATH}/Exchange_rate.dta"
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
* Remove duplicates (updated)
replace nEmployees = 0.5 if nEmployees==0
replace nEmployees = 0 if nEmployees==.
replace Sales = 0.5 if Sales == 0
replace Sales = 0 if Sales == .
sort IDNum Year
by IDNum Year: egen minE = min(nEmployees)
by IDNum Year: egen maxE = max(nEmployees)
by IDNum Year: egen minS = min(Sales)
by IDNum Year: egen maxS = max(Sales)
* Drop the duplicate with missing number of employees 
duplicates tag IDNum Year, gen(dup)
gen tagMaxE = 1 if nEmployees == maxE & nEmployees > minE & dup > 0
gen tagMinE = 1 if nEmployees == minE & nEmployees < maxE & minE <= 0.5 & dup > 0
drop if tagMinE == 1
drop dup
* Drop the duplicate with missing Sales
duplicates tag IDNum Year, gen(dup)
gen tagMaxS = 1 if nEmployees == maxS & Sales > minE & dup > 0
gen tagMinS = 1 if nEmployees == minS & Sales < maxE & minE <= 0.5 & dup > 0
drop if tagMinS == 1
drop dup
* Drop remaining duplicates where there is no disrepancy
duplicates drop IDNum Year, force
replace nEmployees = . if nEmployees==0
replace nEmployees = 0 if nEmployees==0.5
replace Sales = . if Sales == 0
replace Sales = 0 if Sales == 0.5

drop minE minS maxE maxS tagMaxE tagMaxS tagMinE tagMinS

xtset IDNum Year
keep Year gvkey IDNum IPO_year Age nEmployees Sales Assets GrossProfits nShareholders SalesPerEmployee cshoi
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

