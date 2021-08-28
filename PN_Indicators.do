* Get average of selected indicators over years 2010-2018 (2010-2014 for France)

replace countrycode = "NL" if countrycode == "NLD"
replace countrycode = "AT" if countrycode == "AUT"
replace countrycode = "BE" if countrycode == "BEL"
replace countrycode = "DE" if countrycode == "DEU"
replace countrycode = "CZ" if countrycode == "CZE"
replace countrycode = "FI" if countrycode == "FIN"
replace countrycode = "PT" if countrycode == "PRT"
replace countrycode = "HU" if countrycode == "HUN"
replace countrycode = "ES" if countrycode == "ESP"
replace countrycode = "IT" if countrycode == "ITA"
replace countrycode = "FR" if countrycode == "FRA"

keep if countrycode == "NL" | countrycode == "AT" | countrycode == "BE" | countrycode == "DE" ///
| countrycode == "CZ" | countrycode == "FI" | countrycode == "PT" | countrycode == "HU" ///
| countrycode == "ES" | countrycode == "IT" | countrycode == "FR"

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
keep countrycode year gdpo gdpe tfp OutputPerCapita CapitalToLabor CapitalToOutput
drop if year < 2010
drop if year > 2018
if "${CountryID}" == "FR" {
	drop if year > 2014
}
collapse (mean) gdpo gdpe tfp OutputPerCapita CapitalToLabor CapitalToOutput, by(countrycode)
rename countrycode Country

save "Data_Cleaned/PennWorldIndicators.dta", replace