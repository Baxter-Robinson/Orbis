clear all

foreach Country of global Countries {
    append using "Data_Cleaned/`Country'_CountryLevel.dta"
	
}

merge 1:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/WB_MarketCapToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/WB_DomCreditToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/WB_DomCreditBanksToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/IMF_PrivateDebtToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/IMF_PrivateDebtAllToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/IMF_HHDebtToGDP.dta"
drop _merge


merge 1:1 Country using "Data_Cleaned/IMF_HHDebtAllToGDP.dta"
drop _merge

merge 1:1 Country using "Data_Cleaned/IMF_NonFinancialDebtToGDP.dta"
drop _merge


merge 1:1 Country using "Data_Cleaned/IMF_NonFinancialDebtAllToGDP.dta"
drop _merge



gen EquityMktDepth_CSyearend = mve_yearend/gdpo
gen EquityMktDepth_CSAnnual = mve_annual/gdpo
gen EquityMktDepth_CSAnnual2 = mve_annual2/gdpo  // Added due to second way of defining annual value (cfr. CS_EquityMarketDepth.do)
gen EquityMktDepth_OB = MarketCap/gdpo


save "Data_Cleaned/CrossCountry_Dataset.dta",replace
