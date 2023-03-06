********************************************
* Change variable names to match Orbis data
********************************************
use "${DATAPATH}/${CountryID}_Compustat.dta", clear

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


*---------------------------
* Growth Rates
*---------------------------

* Employment Growth Rate (Regular)
bysort IDNum: gen EmpGrowth_r=(nEmployees-L.nEmployees)/(L.nEmployees)

* Employment Growth Rate (Haltiwanger)
bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)
	
* Sales Growth Rate (Haltiwanger)
bysort IDNum: gen SalesGrowth_h = (Sales-L.Sales)/((Sales+L.Sales)/2)

* Profit Growth Rate (Haltiwanger)
bysort IDNum: gen ProfitGrowth_h = (GrossProfits-L.GrossProfits)/((GrossProfits+L.GrossProfits)/2)

* Shares outstanding (Haltiwanger)
bysort IDNum: gen COGS_h = (cshoi -L.cshoi )/((cshoi +L.cshoi )/2)
		
* Assets (Haltiwanger)
bysort IDNum: gen Assets_h = (Assets  - L.Assets )/((Assets  + L.Assets )/2)


save "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta", replace


**************************
* Convert currency to USD
**************************
use "${DATAPATH}/${CountryID}_StockPrice.dta", clear



* Get closing stock price and outstanding shares at calendar year-end (dec 31) and compute market capitalization (market value of equity)
*local Country="IT"


gen Year = year(datadate)
gen Month = month(datadate)
gen Day = day(datadate)
rename prccd StockPrice
replace cshoc = cshoc/1000000



merge m:1 Year using "${DATAPATH}/Exchange_rate.dta"

drop pln chf czk huf frf itl ecu _merge

gen float e_rate = 1/eur

drop eur

replace StockPrice = StockPrice*e_rate

**************************
**************************

bysort gvkey Year: egen StockPrice_ave = mean(StockPrice) // Yearly average stock price of each firm
label var StockPrice_ave "Average stock price (all issuances)"



bysort gvkey datadate: egen cshoc_tot = total(cshoc) // 

bysort gvkey Year: egen cshoc_ave = mean(cshoc_tot) // Yearly average outstanding shares.
label var cshoc_ave "Average outsanding shares (all issuances)"
drop cshoc_tot


gen daily_value_iid = StockPrice*cshoc 
bysort gvkey datadate: egen daily_value_firm = total(daily_value_iid) // Adding the market value of all the issuances of every firm per day
label var daily_value_firm "Firm market value (each day for all issuances)"


bysort gvkey Year: egen mve_annual =  mean(daily_value_firm) // Average daily value for the year
label var mve_annual "Average total market value of the firm"


keep if Month == 12 
bysort Year: egen t=max(Day)
keep if t==Day
sort gvkey iid Year
drop t 

rename daily_value_firm mve_yearend   // For each firm, rename the market value by adding over issues.

drop daily_value_iid Month Day

collapse (first) StockPrice_ave cshoc_ave mve_yearend mve_annual , by(gvkey Year)

rename StockPrice_ave StockPrice
rename cshoc_ave cshoc

save Data_Cleaned/${CountryID}_StockPrice.dta,replace

* Get single average over 2010-2018 (2010-2014 for France)
*merge 1:1 gvkey Year using "Data_Cleaned/`Country'_CompustatUnbalanced"

merge 1:1 gvkey Year using "Data_Cleaned/${CountryID}_CompustatUnbalanced"


drop _merge

drop if Year < 2009
drop if Year > 2016

/*
if "${CountryID}" =="FR" {
	drop if Year > 2014
}
*/

*gen mve_annual = StockPrice*cshoi
gen mve_annual2 = StockPrice*cshoi 
label var mve_annual2 "Market value - annual (from merged data)"

drop if (mve_annual==.) & (mve_yearend==.) & (mve_annual2==.)

*replace mve_annual = mve_yearend if mve_annual == . & mve_yearend != .
replace mve_annual2 = mve_annual if mve_annual2 == . & mve_yearend != .

*replace mve_yearend = mve_annual if mve_yearend == . & mve_annual != .
replace mve_yearend = mve_annual2 if mve_yearend == . & mve_annual != .

rename nEmployees nPubEmp_CS

collapse (sum) mve_yearend mve_annual mve_annual2 cshoc cshoi nPubEmp_CS, by(Year)
collapse (mean) mve_yearend mve_annual mve_annual2 cshoc cshoi nPubEmp_CS
lab var mve_yearend "Market Value of Equity - Millions (Compustat Global - Security Daily)"  // mve_yearend is generated before merging
lab var mve_annual "Market Value of Equity - Millions (Compustat Global - Security Daily)"  // mve_annual is generated before merging
lab var mve_annual2 "Market Value of Equity - Millions (Compustat Global - Annual)" // mve_annual2 is generated after the merge
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Security Daily)"
lab var cshoi "Outstanding Shares - Dec31 (Compustat Global - Annual)"

gen Country = "${CountryID}"
save "Data_Cleaned/${CountryID}_CountryLevel_CS.dta", replace


