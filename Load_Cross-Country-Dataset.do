clear all

foreach Country of global Countries {
    append using "Data_Cleaned/`Country'_CountryLevel.dta"
	
}

merge 1:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
drop _merge


merge 1:1 Country using "Data_Cleaned/WB_MarketCapToGDP.dta"
drop _merge


gen EquityMktDepth_CSyearend = mve_yearend/gdpo
gen EquityMktDepth_CSAnnual = mve_annual/gdpo
gen EquityMktDepth_OB = MarketCap/gdpo


save "Data_Cleaned/CrossCountry_Dataset.dta",replace