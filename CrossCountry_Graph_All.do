
use "Data_Cleaned/CrossCountry_Dataset_All.dta", clear

scatter tfp EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white))
graph export Output/Cross-Country/TFP_EquityMktDepth_WB_All.pdf, replace

drop if EquityMktDepth_WB>127
scatter tfp EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white))
graph export Output/Cross-Country/TFP_EquityMktDepth_WB_All-Trimmed.pdf, replace