
* Open up BySize Data Sets
use "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", clear
append using "Data_Cleaned/${CountryID}_Validation_bySize_ES.dta"

* Compute Weights
gen EuroStatNumbers=nFirms if (DataSet=="ES")

sort Year SizeCategoryES EuroStatNumbers
bysort Year SizeCategoryES : replace EuroStatNumbers=EuroStatNumbers[1]

gen EuroStatWeights=EuroStatNumbers/nFirms if (DataSet=="OB")

* Save the Weights
drop if missing(EuroStatWeights)
keep Year SizeCategoryES EuroStatWeights

*Open up full Unbalanced Panel and add weights
merge 1:m Year SizeCategoryES using "Data_Cleaned/${CountryID}_Unbalanced.dta"
drop if _merge<3
drop _merge


save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace