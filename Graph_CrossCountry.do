* Country-level scatter plots between Eequity market depth and selected indicators

* Compare Equity Market Depth
twoway (scatter EquityMktDepth_OB EquityMktDepth_WB , mlabel(Country)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Orbis Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 1)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_OBvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSyearend EquityMktDepth_WB, mlabel(Country)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (year end) Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 6)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_CSyearendvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSAnnual EquityMktDepth_WB , mlabel(Country)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (annual) Equity Market Depth") graphregion(color(white))   ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 6)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_CSAnnualvsWB.pdf, replace


twoway (scatter EquityMktDepth_OB EquityMktDepth_CSyearend , mlabel(Country)) ///
(line EquityMktDepth_OB EquityMktDepth_OB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("Compustat (year end) Equity Market Depth") ytitle("Orbis Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 12)) xlabel(#6) yscale(range(0 1)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_OBvsCS.pdf, replace


* TFP
scatter tfp EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/TFP_EquityMktDepth_CSyearend.pdf, replace
scatter tfp EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/TFP_EquityMktDepth_CSannual.pdf, replace
scatter tfp EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/TFP_EquityMktDepth_OB.pdf, replace
scatter tfp EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/TFP_EquityMktDepth_WB.pdf, replace


* Output Per Capita
scatter OutputPerCapita EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_CSyearend.pdf, replace
scatter OutputPerCapita EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_CSannual.pdf, replace
scatter OutputPerCapita EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_OB.pdf, replace
scatter OutputPerCapita EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_WB.pdf, replace

* Capital to Labor ratio
scatter CapitalToLabor EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToLabor EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToLabor EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_OB.pdf, replace
scatter CapitalToLabor EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_WB.pdf, replace

* Capital to Output ratio
scatter CapitalToOutput EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToOutput EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToOutput EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_OB.pdf, replace
scatter CapitalToOutput EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_WB.pdf, replace

* Capital to Output ratio
scatter CapitalToOutput EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToOutput EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToOutput EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_OB.pdf, replace
scatter CapitalToOutput EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Private firms
scatter avgEmpGrowth_Private EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_CSyearend.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_CSannual.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_OB.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Public firms
scatter avgEmpGrowth_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_CSyearend.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_CSannual.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_OB.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Public vs. Private Firms
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_CSyearend) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_CSyearend), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_CSyearend.pdf, replace
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_CSAnnual) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_CSAnnual), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_CSannual.pdf, replace
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_OB) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_OB), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_OB.pdf, replace
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_WB) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_WB), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_WB.pdf, replace


* Variance of Employment Growth - Private Firms
scatter varEmpGrowth_Private EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_CSyearend.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_CSannual.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_OB.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_WB.pdf, replace

* Variance of Employment Growth - Public Firms
scatter varEmpGrowth_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_CSyearend.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_CSannual.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_OB.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_WB.pdf, replace


* Variance Employment Growth of Public vs. Private Firms
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_CSyearend) ///
 (scatter varEmpGrowth_Private EquityMktDepth_CSyearend), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_CSyearend.pdf, replace
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_CSAnnual) ///
 (scatter varEmpGrowth_Private EquityMktDepth_CSAnnual), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_CSannual.pdf, replace
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_OB) ///
 (scatter varEmpGrowth_Private EquityMktDepth_OB), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_OB.pdf, replace
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_WB) ///
 (scatter varEmpGrowth_Private EquityMktDepth_WB), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_WB.pdf, replace



* Share of Employment in Public Firms
scatter empShare_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_CSyearend.pdf, replace
scatter empShare_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_CSannual.pdf, replace
scatter empShare_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_OB.pdf, replace
scatter empShare_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_WB.pdf, replace
*/

* Share of Employment in Large Firms
scatter empShare_LargeFirms EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (>99 Workers)") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_CSyearend.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99 Workers)") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_CSannual.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99 Workers)") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_OB.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99  Workers)") graphregion(color(white)) mlabel(Country)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_WB.pdf, replace





