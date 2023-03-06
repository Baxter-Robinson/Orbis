
use "Data_Cleaned/CrossCountry_Dataset_All.dta", clear
drop if EquityMktDepth_WB>127

** TFP
eststo clear
eststo: reg tfp EquityMktDepth_WB

eststo: reg tfp EquityMktDepth_WB DomCredit_WB

eststo: reg tfp EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB

eststo: reg tfp EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF

*eststo: reg tfp EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF NonFinancialDebt_IMF

*eststo: reg tfp EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF NonFinancialDebt_IMF  HHDebt_IMF 




esttab using Output/Cross-Country/TFP_EquityMktDepth.tex, replace se fragment ///
indicate("Constant=_cons") label stats(N) ///
mlabels(" " " " " ")


** Output Per Capita

eststo clear
eststo: reg gdpe EquityMktDepth_WB

eststo: reg gdpe EquityMktDepth_WB DomCredit_WB

eststo: reg gdpe EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB


eststo: reg gdpe EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF

eststo: reg gdpe EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF NonFinancialDebt_IMF

eststo: reg gdpe EquityMktDepth_WB DomCredit_WB DomCreditBanks_WB PrivateDebt_IMF NonFinancialDebt_IMF  HHDebt_IMF 




esttab using Output/Cross-Country/Output_EquityMktDepth.tex, replace se fragment ///
indicate("Constant=_cons") label stats(N) ///
mlabels(" " " " " ")