	use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta", clear

	keep Country Year NACE_Rev2 Size Firms nEmployees1 
	destring, replace
	
	drop if (Year<${FirstYear})
	drop if (Year>${LastYear})
	
	rename nEmployees1 nEmployees
	rename Firms nFirms

	gen SizeCategoryES = . 
	replace SizeCategoryES = 1 if Size=="0-9"
	replace SizeCategoryES = 2 if Size=="10-19"
	replace SizeCategoryES = 3 if Size=="20-49"
	replace SizeCategoryES = 4 if Size=="50-249"
	replace SizeCategoryES = 5 if Size=="GE250"
	
	drop if Size=="TOTAL"
	
	* Keep Selected Industries
	gen keepers = 0
	replace keepers = 1 if inlist(NACE_Rev2,"B","C","D","E","F","G","H")
	replace keepers = 1 if inlist(NACE_Rev2,"I","J","L","M","N","S95")
	drop if keepers==0
	
	*Sum over industries
	collapse (sum) nFirms nEmployees, by(Country  SizeCategory Year)
	
	* Average over years
	collapse (mean) nFirms nEmployees , by(Country SizeCategory)
	
	egen TotEmployees_EuroStat = total(nEmployees)
	egen TotFirms_EuroStat = total(nFirms)
	
		
save "Data_Cleaned/EuroStat_Cleaned.dta", replace
