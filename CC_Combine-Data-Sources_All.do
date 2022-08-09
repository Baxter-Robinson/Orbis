clear all

use "Data_Cleaned/Country-Codes.dta" , clear

merge 1:1 CountryCode_3Digit using "Data_Cleaned/PennWorldIndicators.dta"
drop if _merge==2
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_MarketCapToGDP.dta"
drop if _merge==2
drop _merge

merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_Domestic_credit_to_private_sector.dta"
drop if _merge==2
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/WB_Domestic_credit_private_Sector_by_banks.dta"
drop if _merge==2
drop _merge


merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Private_debt.dta"
drop if _merge==2
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Private_debt_all_instruments.dta"
drop if _merge==2
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Household_debt.dta"
drop if _merge==2
drop _merge




merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Household_debt_all_instruments.dta"
drop if _merge==2
drop _merge



merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Nonfinancial_corporate_debt.dta"
drop if _merge==2
drop _merge




merge 1:1 CountryCode_3Digit using "Data_Cleaned/IMF_Nonfinancial_corporate_debt_all_instruments.dta"
drop if _merge==2
drop _merge


save "Data_Cleaned/CrossCountry_Dataset_All.dta",replace


