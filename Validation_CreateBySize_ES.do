	** EuroStat
	use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta", clear
	keep if Country=="${CountryID}"
			
	destring, replace
	keep Country Year NACE_Rev2 Size Firms nEmployees1 nEmployees2
	keep if Year>=${FirstYear}
	keep if Year<=${LastYear}

	gen SizeCategory = . 
	replace SizeCategory = 1 if Size=="0-9"
	replace SizeCategory = 2 if Size=="10-19"
	replace SizeCategory = 3 if Size=="20-49"
	replace SizeCategory = 4 if Size=="50-249"
	replace SizeCategory = 5 if Size=="GE250"

	drop if Size=="TOTAL"
			
	gen keepers = 0
	replace keepers = 1 if inlist(NACE_Rev2,"B","C","D","E","F","G","H")
	replace keepers = 1 if inlist(NACE_Rev2,"I","J","L","M","N","S95")
	drop if keepers==0
	
	rename nEmployees1 nEmployees
	rename Firms nFirms

	collapse (sum) nFirms nEmployees , by(SizeCategory Year)
	
	gen DataSet="ES"

	save "Data_Cleaned/${CountryID}_Validation_bySize_ES.dta", replace