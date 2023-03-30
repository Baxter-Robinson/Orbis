use  "Data_Cleaned/CrossCountry_Dataset_Euro.dta", clear

* Normalize so that French TFP is 1
sum tfpPWT if (CountryCode_2Digit=="FR")
local FrenchTFP=r(mean)

replace tfpPWT=tfpPWT/`FrenchTFP'

outsheet CountryCode_2Digit PubEmpShare EquityMktDepth_WB tfpPWT OutputPerCapita using "Output/Cross-Country/ModelComp_Data.csv", replace comma

