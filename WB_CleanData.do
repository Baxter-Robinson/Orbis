
*------------------------------------------------------------------------------------------
** Country Codes ISO-3166
*------------------------------------------------------------------------------------------

import delimited using "${DATAPATH}/ISO-3166_Country-Codes.csv", clear
rename v1 CountryName
rename v3 CountryCode_2Digit
rename v4 CountryCode_3Digit
drop v*

save "Data_Cleaned/Country-Codes.dta", replace



*------------------------------------------------------------------------------------------
** Clean World Bank Data
*------------------------------------------------------------------------------------------


local i=1

forval i=1/3{
	
	if (`i'==1){
		local DataLabel="MarketCapToGDP"
		local VariableLabel="EquityMktDepth"
	}
	else if (`i'==2){
		local DataLabel="Domestic_credit_to_private_sector"
		local VariableLabel="DomCredit"
	}
	else if (`i'==3){
		local DataLabel="Domestic_credit_private_Sector_by_banks"
		local VariableLabel="DomCreditBanks"
	}

		
		
	import delimited using "${DATAPATH}/WB_`DataLabel'.csv", clear


	rename v2 CountryCode_3Digit

	drop if (strlen(CountryCode_3Digit)>3)


	forval i=5/65{
		local year=1955+`i'
		rename v`i'  `VariableLabel'`year'
		
	}
	drop v*


	gen `VariableLabel'_WB=0
	gen nYears=0
	

	forval year=$FirstYear/$LastYear{
		replace `VariableLabel'_WB=`VariableLabel'_WB+`VariableLabel'`year' if (~missing(`VariableLabel'`year'))
		replace nYears=nYears+1 if  (~missing(`VariableLabel'`year'))
		
	}

	replace `VariableLabel'_WB=`VariableLabel'_WB/nYears

	drop `VariableLabel'1* `VariableLabel'2* nYears

	save "Data_Cleaned/WB_`DataLabel'.dta", replace
	
}

*/


