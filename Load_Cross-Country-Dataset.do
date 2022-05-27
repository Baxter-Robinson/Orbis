clear all

use "Data_Cleaned/Country-Codes.dta" , clear

merge 1:1 CountryCode_3Digit using "Data_Cleaned/PennWorldIndicators.dta"
drop if _merge<3
drop _merge

merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_MarketCapToGDP.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_Domestic_credit_to_private_sector.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_Domestic_credit_private_Sector_by_banks.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Private_debt.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Private_debt_all_instruments.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Household_debt.dta"
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Household_debt_all_instruments.dta"
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Nonfinancial_corporate_debt.dta"
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Nonfinancial_corporate_debt_all_instruments.dta"
drop _merge



save "Data_Cleaned/CrossCountry_Dataset_All.dta",replace

**----------------------------------------
** Europe Only
**----------------------------------------


keep if inlist(CountryCode_2Digit,"NL","AT","BE","DE","CZ") | inlist(CountryCode_2Digit,"FI","PT","HU","ES","IT","FR")

rename CountryCode_2Digit Country

local Country="AT"
foreach Country of global Countries {
    merge 1:1 Country using "Data_Cleaned/`Country'_CountryLevel.dta"
	drop if (_merge==2)
	drop _merge
	
}


gen EquityMktDepth_CSyearend = mve_yearend/gdpo
gen EquityMktDepth_CSAnnual = mve_annual/gdpo
gen EquityMktDepth_CSAnnual2 = mve_annual2/gdpo  // Added due to second way of defining annual value (cfr. CS_EquityMarketDepth.do)
gen EquityMktDepth_OB = MarketCap/gdpo


save "Data_Cleaned/CrossCountry_Dataset_Euro.dta",replace
