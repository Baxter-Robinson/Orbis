
use "${DATAPATH}/pwt100.dta", clear


rename countrycode CountryCode_3Digit
* GDP (Expenditures and Output)
rename cgdpo gdpo
rename cgdpe gdpe
* TFP
rename ctfp tfp
* Output per Capita
gen OutputPerCapita = gdpo/pop
* Capital to Labor ratio
gen LaborSpending = labsh*gdpo
gen CapitalStock = cn
gen CapitalToLabor = cn/LaborSpending
* Capital to Output ratio
gen CapitalToOutput = CapitalStock/gdpo

* Aggregate
keep CountryCode_3Digit year gdpo gdpe tfp OutputPerCapita CapitalToLabor CapitalToOutput
drop if year < 2010
drop if year > 2018
if "${CountryID}" == "FR" {
	drop if year > 2014
}
collapse (mean) gdpo gdpe tfp OutputPerCapita CapitalToLabor CapitalToOutput, by(CountryCode_3Digit)

save "Data_Cleaned/PennWorldIndicators.dta", replace