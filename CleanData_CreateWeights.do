
* Open up BySize Data Sets
use "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", clear
append using "Data_Cleaned/${CountryID}_Validation_bySize_ES.dta"

* Compute Weights
gen EuroStatNumbers=nFirms if (DataSet=="ES")

sort Year SizeCategoryES EuroStatNumbers
bysort Year SizeCategoryES : replace EuroStatNumbers=EuroStatNumbers[1]

gen Weights=EuroStatNumbers/nFirms if (DataSet=="OB")

* Save the Weights
drop if missing(Weights)
keep Year SizeCategory Weights
*save "Data_Temp/${CountryID}_OrbisWeights.dta", replace

*Open up full Unbalanced Panel and add weights
*use "Data_Cleaned/${CountryID}_Unbalanced.dta", replace

merge 1:m Year SizeCategoryES using "Data_Cleaned/${CountryID}_Unbalanced.dta"
drop if _merge<3


save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace