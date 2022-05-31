* Country-level Indicators from Orbis Database - average over 2010-2018 (2010-2014 for France)

drop if Year < 2009
drop if Year > 2016

if "${CountryID}" == "FR" {
	drop if Year > 2014
}



* Average Growth rate of Employment
bysort Private: egen avgEmpGrowth = mean(EmpGrowth_h)
* Variance of Growth rate of Employment
bysort Private: egen varEmpGrowth = sd(EmpGrowth_h)
replace varEmpGrowth = varEmpGrowth^2
* Employment shares by Firm Type
bysort Year: egen nEmployeesTot = total(nEmployees)
bysort Year Private: egen nEmployeesTot_byFirmType = total(nEmployees)
gen empShare_byFirmType = nEmployeesTot_byFirmType/nEmployeesTot
* Employment shares by size (large firm >= 99 employees)
gen nEmployees_LargeFirms = .
replace nEmployees_LargeFirms = nEmployees if nEmployees > 99
bysort Year: egen nEmployeesTot_LargeFirm = total(nEmployees_LargeFirms)
gen empShare_LargeFirms = nEmployeesTot_LargeFirm/nEmployeesTot
* Market capitalization
bysort Year: egen MarketCap = total(Market_capitalisation_mil)

* Aggregate
collapse (mean) avgEmpGrowth varEmpGrowth empShare_byFirmType empShare_LargeFirms MarketCap, by(Private)
gen Country = "${CountryID}"
reshape wide avgEmpGrowth varEmpGrowth empShare_byFirmType empShare_LargeFirms MarketCap, i(Country) j(Private)
rename empShare_byFirmType0 empShare_Public
rename empShare_byFirmType1 empShare_Private
rename MarketCap0 MarketCap
drop MarketCap1
egen empShare_LargeFirms = rowmean(empShare_LargeFirms0 empShare_LargeFirms1)
drop empShare_LargeFirms0 empShare_LargeFirms1
local vars avgEmpGrowth varEmpGrowth
foreach var in `vars' {
	rename `var'0 `var'_Public
	rename `var'1 `var'_Private
}
merge 1:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
drop _merge
save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace
