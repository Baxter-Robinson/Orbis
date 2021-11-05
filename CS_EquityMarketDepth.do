* Get closing stock price and outstanding shares at calendar year-end (dec 31) and compute market capitalization (market value of equity)
*local Country="IT"


gen Year = year(datadate)
gen Month = month(datadate)
gen Day = day(datadate)
rename prccd StockPrice
replace cshoc = cshoc/1000000




**************************
* Convert currency to USD
**************************

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

collapse (sum) mve_yearend mve_annual mve_annual2 cshoc cshoi, by(Year)
collapse (mean) mve_yearend mve_annual mve_annual2 cshoc cshoi
lab var mve_yearend "Market Value of Equity - Millions (Compustat Global - Security Daily)"  // mve_yearend is generated before merging
lab var mve_annual "Market Value of Equity - Millions (Compustat Global - Security Daily)"  // mve_annual is generated before merging
lab var mve_annual2 "Market Value of Equity - Millions (Compustat Global - Annual)" // mve_annual2 is generated after the merge
lab var cshoc "Outstanding Shares - Dec31 (Compustat Global - Security Daily)"
lab var cshoi "Outstanding Shares - Dec31 (Compustat Global - Annual)"

gen Country = "${CountryID}"
merge 1:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
drop _merge
save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace
