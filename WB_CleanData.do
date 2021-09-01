import delimited using "${DATAPATH}/WB_MarketCapToGDP.csv", clear

gen Country=""

replace Country="NL" if (v1=="Netherlands")
replace Country="AT" if (v1=="Austria")
replace Country="BE" if (v1=="Belgium")
replace Country="DE" if (v1=="Germany")
replace Country="CZ" if (v1=="Czech Republic")
replace Country="FI" if (v1=="Finland")
replace Country="PT" if (v1=="Portugal")
replace Country="ES" if (v1=="Spain")
replace Country="IT" if (v1=="Italy")
replace Country="FR" if (v1=="France")
replace Country="HU" if (v1=="Hungary")


drop if (Country=="")

forval i=5/65{
    local year=1955+`i'
    rename v`i'  MarketCap`year'
	
}
drop v*

br 

gen EquityMktDepth_WB=0
gen nYears=0

forval year=2009/2016{
    replace EquityMktDepth_WB=EquityMktDepth_WB+MarketCap`year' if (~missing(MarketCap`year'))
	replace nYears=nYears+1 if  (~missing(MarketCap`year'))
	
}

replace EquityMktDepth_WB=EquityMktDepth_WB/nYears/100

drop MarketCap* nYears


save "Data_Cleaned/WB_MarketCapToGDP.dta", replace