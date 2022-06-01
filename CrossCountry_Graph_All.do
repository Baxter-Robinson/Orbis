
use "Data_Cleaned/CrossCountry_Dataset_All.dta", clear

graph twoway (scatter tfp EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
(lfit tfp EquityMktDepth_WB ) ///
, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/TFP_EquityMktDepth_WB_All.pdf, replace

drop if EquityMktDepth_WB>127

graph twoway (scatter tfp EquityMktDepth_WB) ///
(lfit tfp EquityMktDepth_WB ) ///
, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/TFP_EquityMktDepth_WB_All-Trimmed.pdf, replace

sort EquityMktDepth_WB
br CountryName CountryCode_2Digit EquityMktDepth_WB

reg tfp EquityMktDepth_WB
