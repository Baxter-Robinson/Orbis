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




********* World Bank Indicators

* Domestic credit to private sector (% of GDP)
clear all
import delimited using "${DATAPATH}/WB_Domestic_credit_to_private_sector.csv", clear

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
    rename v`i'  Credit`year'
	
}
drop v*

br 


gen DomCredit_WB=0
gen nYears=0


forval year=2009/2016{
    replace DomCredit_WB=DomCredit_WB+Credit`year' if (~missing(Credit`year'))
	replace nYears=nYears+1 if  (~missing(Credit`year'))
	
}

replace DomCredit_WB=DomCredit_WB/nYears/100

drop Credit* nYears


save "Data_Cleaned/WB_DomCreditToGDP.dta", replace

* ------------------------------------ *

* Domestic credit to private sector by banks (% of GDP)
clear all
import delimited using "${DATAPATH}/WB_Domestic_credit_private_Sector_by_banks.csv", clear

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
    rename v`i'  CreditBanks`year'
	
}
drop v*

br 


gen DomCreditBanks_WB=0
gen nYears=0


forval year=2009/2016{
    replace DomCreditBanks_WB=DomCreditBanks_WB+CreditBanks`year' if (~missing(CreditBanks`year'))
	replace nYears=nYears+1 if  (~missing(CreditBanks`year'))
	
}

replace DomCreditBanks_WB=DomCreditBanks_WB/nYears/100

drop CreditBanks* nYears



save "Data_Cleaned/WB_DomCreditBanksToGDP.dta", replace


* --------------------------------------------------------------------------------------------- *


********* From the IMF Global Debt Database (https://www.imf.org/external/datamapper/datasets/GDD)

* Private debt, loans and debt securities (Percent of GDP)

import delimited "${DATAPATH}/IMF_Private_debt.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen PrivateDebtIMF=0
gen nYears=0


forval year=2009/2016{
    replace PrivateDebtIMF=PrivateDebtIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace PrivateDebtIMF=PrivateDebtIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_PrivateDebtToGDP.dta", replace

* ------------------------------------ *
* Household debt, loans and debt securities (Percent of GDP)


import delimited "${DATAPATH}/IMF_Household_debt.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen HHDebtIMF=0
gen nYears=0


forval year=2009/2016{
    replace HHDebtIMF=HHDebtIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace HHDebtIMF=HHDebtIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_HHDebtToGDP.dta", replace

* ------------------------------------ *
* Nonfinancial corporate debt, loans and debt securities



import delimited "${DATAPATH}/IMF_Nonfinancial_corporate_debt.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen NonFinancialDebtIMF=0
gen nYears=0


forval year=2009/2016{
    replace NonFinancialDebtIMF=NonFinancialDebtIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace NonFinancialDebtIMF=NonFinancialDebtIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_NonFinancialDebtToGDP.dta", replace


* ------------------------------------ *
* Private debt, all instruments

import delimited "${DATAPATH}/IMF_Private_debt_all_instruments.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen PrivateDebtAllIMF=0
gen nYears=0


forval year=2009/2016{
    replace PrivateDebtAllIMF=PrivateDebtAllIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace PrivateDebtAllIMF=PrivateDebtAllIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_PrivateDebtAllToGDP.dta", replace
* ------------------------------------ *
* Household debt, all instruments


import delimited "${DATAPATH}/IMF_Household_debt_all_instruments.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen HHDebtAllIMF=0
gen nYears=0


forval year=2009/2016{
    replace HHDebtAllIMF=HHDebtAllIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace HHDebtAllIMF=HHDebtAllIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_HHDebtAllToGDP.dta", replace
* ------------------------------------ *
* Nonfinancial corporate debt, all instruments


import delimited "${DATAPATH}/IMF_Nonfinancial_corporate_debt_all_instruments.csv", clear

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
    rename v`i'  Debt`year'
	
}
drop v*

br 

gen NonFinancialDebtAllIMF=0
gen nYears=0


forval year=2009/2016{
    replace NonFinancialDebtAllIMF=NonFinancialDebtAllIMF+Debt`year' if (~missing(Debt`year'))
	replace nYears=nYears+1 if  (~missing(Debt`year'))
	
}

replace NonFinancialDebtAllIMF=NonFinancialDebtAllIMF/nYears/100

drop Debt* nYears


save "Data_Cleaned/IMF_NonFinancialDebtAllToGDP.dta", replace




