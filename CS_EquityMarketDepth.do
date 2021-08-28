* Get closing stock price and outstanding shares at calendar year-end (dec 31) and compute market capitalization (market value of equity)

gen Year = year(datadate)
gen Month = month(datadate)
gen Day = day(datadate)
keep if Month == 12 & Day == 31
rename prccd StockPrice
replace cshoc = cshoc/1000000
collapse (max) StockPrice cshoc, by(gvkey Year)
gen mve_yearend = StockPrice*cshoc
save Data_Cleaned/${CountryID}_StockPrice.dta,replace

* Get single average over 2010-2018 (2010-2014 for France)
merge 1:1 gvkey Year using "Data_Cleaned/${CountryID}_CompustatUnbalanced"
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
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Security Daily)"
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Annual)"

gen Country = "${CountryID}"
merge 1:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
drop _merge
save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace
