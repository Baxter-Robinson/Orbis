clear all

foreach Country of global Countries {
    append using "Data_Cleaned/`Country'_CountryLevel.dta"
	
}

merge 1:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
drop _merge
save "Data_Cleaned/CrossCountry_Dataset.dta",replace