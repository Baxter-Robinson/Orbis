** Clean IMF Data
* --------------------------------------------------------------------------------------------- *


********* From the IMF Global Debt Database (https://www.imf.org/external/datamapper/datasets/GDD)

local i=1

forval i=1/6{
	
	if (`i'==1){
		local DataLabel="Private_debt"
		local VariableLabel="PrivateDebt"
	}
	else if (`i'==2){
		local DataLabel="Private_debt_all_instruments"
		local VariableLabel="PrivateDebtAll"
	}
	else if (`i'==3){
		local DataLabel="Household_debt"
		local VariableLabel="HHDebt"
	}
	else if (`i'==4){
		local DataLabel="Household_debt_all_instruments"
		local VariableLabel="HHDebtAll"
	}
	else if (`i'==5){
		local DataLabel="Nonfinancial_corporate_debt"
		local VariableLabel="NonFinancialDebt"
	}
	else if (`i'==6){
		local DataLabel="Nonfinancial_corporate_debt_all_instruments"
		local VariableLabel="NonFinancialDebt"
	}


		
		
	import delimited using "${DATAPATH}/IMF_`DataLabel'.csv", clear


	rename v1 CountryName
	replace Country="Bahamas (the)" if (CountryName=="Bahamas, The")
	replace Country="Central African Republic (the)" if (CountryName=="Central African Republic")
	replace Country="China" if (CountryName=="China, People's Republic of")
	replace Country="Comoros (the)" if (CountryName=="Comoros")
	replace Country="Congo (the Democratic Republic of the)" if (CountryName=="Congo, Dem. Rep. of the")
	replace Country="Congo (the)" if (CountryName=="Congo, Republic of")
	replace Country="Czechia" if (CountryName=="Czech Republic")
	replace Country="Cote d'Ivoire" if (CountryName=="Côte d'Ivoire")
	replace Country="Dominican Republic (the)" if (CountryName=="Dominican Republic")
	replace Country="Gambia (the)" if (CountryName=="Gambia, The")
	replace Country="Hong Kong" if (CountryName=="Hong Kong SAR")
	replace Country="Iran (Islamic Republic of)" if (CountryName=="Iran")
	replace Country="Korea (the Republic of)" if (CountryName=="Korea, Republic of")
	replace Country="Kyrgyzstan" if (CountryName=="Kyrgyz Republic")
	replace Country="Lao People's Democratic Republic (the)" if (CountryName=="Lao P.D.R.")
	replace Country="Micronesia (Federated States of)" if (CountryName=="Micronesia, Fed. States of")
	replace Country="Moldova (the Republic of)" if (CountryName=="Moldova")
	replace Country="Netherlands (the)" if (CountryName=="Netherlands")
	replace Country="North Macedonia" if (CountryName=="North Macedonia")
	replace Country="Philippines (the)" if (CountryName=="Philippines")
	replace Country="Russian Federation (the)" if (CountryName=="Russian Federation")
	replace Country="Slovakia" if (CountryName=="Slovak Republic")
	replace Country="South Sudan" if (CountryName=="South Sudan, Republic of")
	replace Country="Sudan (the)" if (CountryName=="Sudan")
	replace Country="Sao Tome and Principe" if (CountryName=="São Tomé and Príncipe")
	replace Country="Tanzania, the United Republic of" if (CountryName=="Tanzania")
	replace Country="United Arab Emirates (the)" if (CountryName=="United Arab Emirates")
	replace Country="United Kingdom of Great Britain and Northern Ireland (the)" if (CountryName=="United Kingdom")
	replace Country="United States of America (the)" if (CountryName=="United States")
	replace Country="Venezuela (Bolivarian Republic of)" if (CountryName=="Venezuela")
	replace Country="Viet Nam" if (CountryName=="Vietnam")
	
	merge 1:1 CountryName using "Data_Cleaned/Country-Codes.dta"
	drop if _merge<3
	drop _merge
	

	forval i=5/65{
		local year=1955+`i'
		rename v`i'  `VariableLabel'`year'
		
	}
	drop v*


	gen `VariableLabel'_IMF=0
	gen nYears=0

	forval year=2009/2016{
		replace `VariableLabel'_IMF=`VariableLabel'_IMF+`VariableLabel'`year' if (~missing(`VariableLabel'`year'))
		replace nYears=nYears+1 if  (~missing(`VariableLabel'`year'))
		
	}

	replace `VariableLabel'_IMF=`VariableLabel'_IMF/nYears

	drop `VariableLabel'1* `VariableLabel'2* nYears CountryName CountryCode_2Digit 

	save "Data_Cleaned/IMF_`DataLabel'.dta", replace
	

}



