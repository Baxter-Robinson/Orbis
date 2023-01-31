
* Open up BySize Data Sets
use "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", clear
gen Country="${CountryID}"

append using "Data_Cleaned/EuroStat_ByYear_Cleaned.dta"

keep if Country=="${CountryID}"

* Compute Weights
gen EuroStatNumbers=nFirms if (DataSet=="ES")

sort Year SizeCategoryES EuroStatNumbers
bysort Year SizeCategoryES : replace EuroStatNumbers=EuroStatNumbers[1]

gen ESWeights=EuroStatNumbers/nFirms if (DataSet=="OB")

* Create Unweighted Weights
gen NoWeights=1

* Save the Weights
drop if missing(ESWeights)
keep Year SizeCategoryES ESWeights NoWeights

*Open up full Unbalanced Panel and add weights
merge 1:m Year SizeCategoryES using "Data_Cleaned/${CountryID}_Unbalanced.dta"
drop if _merge<3
drop _merge

replace ESWeights=1 if (Public==1)


save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace