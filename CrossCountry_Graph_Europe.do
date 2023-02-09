* Country-level scatter plots between Equity market depth and selected indicators

use  "Data_Cleaned/CrossCountry_Dataset_Euro.dta", clear

*----------------------------------
* Equity Market Depth
*----------------------------------
* Compare Equity Market Depth
twoway (scatter EquityMktDepth_OB EquityMktDepth_WB , mlabel(CountryCode_2)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("Equity Market Depth (World Bank Measure)") ytitle("Equity Market Depth (Orbis Measure)") graphregion(color(white)) ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 1)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_OBvsWB.pdf, replace

* TFP
graph twoway (lfit tfp EquityMktDepth_WB, lcolor(maroon) ) ///
(scatter tfp EquityMktDepth_WB, mlabel(CountryCode_2Digit) color(navy)  mlabcolor(navy) ) ///
, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/EquityMktDepth_TFP.pdf, replace

* Employment Share of Public Firms
graph twoway (lfit tfp EmpShare_Public, lcolor(maroon) ) ///
(scatter tfp EmpShare_Public, mlabel(CountryCode_2Digit) color(navy)  mlabcolor(navy)) ///
, xtitle("Employment Share of Public Firms") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/EmpSharePublic_TFP.pdf, replace



* Output Per Capita
scatter OutputPerCapita EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Output Per Capita (Thousands of US Dollars)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_OutputPerCap.pdf, replace


* Capital to Labor ratio
scatter CapitalToLabor EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_CapitalToLabor.pdf, replace

* Capital to Output ratio
graph twoway (lfit CapitalToOutput EquityMktDepth_WB, lcolor(maroon) ) ///
(scatter CapitalToOutput EquityMktDepth_WB, mlabel(CountryCode_2Digit) color(navy)  mlabcolor(navy) ) ///
, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white))  legend(off)
graph export Output/Cross-Country/EquityMktDepth_CapitalToOutput.pdf, replace


*----------------------------------
* Average Employment Growth 
*----------------------------------
*Private firms
scatter EmpGrowth_PriAll_Avg EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_AvgEmpGrowth_PriAll.pdf, replace


* Public firms
scatter EmpGrowth_PubAll_Avg EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_AvgEmpGrowth_PubAll.pdf, replace


* Both
graph twoway (scatter EmpGrowth_PubAll_Avg EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter EmpGrowth_PriAll_Avg EquityMktDepth_WB, mlabel(CountryCode_2Digit) msymbol(D)) ///
 , xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) ///
 legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/EquityMktDepth_AvgEmpGrowth_PrivsPubAll.pdf, replace
*/
* Difference
gen DiffEmpGrowth=EmpGrowth_PubAll_Avg-EmpGrowth_PriAll_Avg
graph twoway (scatter DiffEmpGrowth EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 , xtitle("Equity Market Depth") ytitle("Difference in Average Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/EquityMktDepth_AvgEmpGrowth_PrivsPubAll-Diff.pdf, replace

*----------------------------------
* Standard Deviation of Employment Growth 
*----------------------------------
* Public vs. Private Firms
graph twoway (scatter EmpGrowth_PubAll_Std EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter EmpGrowth_PriAll_Std EquityMktDepth_WB, mlabel(CountryCode_2Digit)  msymbol(D)) ///
 , xtitle("Equity Market Depth") ytitle("Standard Deviation of Employment Growth") graphregion(color(white))  legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/EquityMktDepth_SDEmpGrowth_PriVsPubAll.pdf, replace

* Difference
gen DiffStdEmpGrowth=EmpGrowth_PubAll_Std-EmpGrowth_PriAll_Std
graph twoway (scatter DiffStdEmpGrowth EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 , xtitle("Equity Market Depth") ytitle("Difference in Standard Deviation of Employment Growth") graphregion(color(white))  
graph export Output/Cross-Country/EquityMktDepth_SDEmpGrowth_PriVsPubAll-Diff.pdf, replace


graph twoway (scatter EmpGrowth_PubLarge_Std EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter EmpGrowth_PriLarge_Std EquityMktDepth_WB, mlabel(CountryCode_2Digit)  msymbol(D)) ///
 , xtitle("Equity Market Depth") ytitle("Standard Deviation of Employment Growth") graphregion(color(white))  legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/EquityMktDepth_SDEmpGrowth_PriVsPubLarge.pdf, replace
*
*----------------------------------
* Employment Shares
*----------------------------------

* Share of Employment in Public Firms
scatter EmpShare_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_EmpSharePublic.pdf, replace

* Share of Employment in Large Firms
scatter EmpShare_Large EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99  Workers)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_EmpShareLargeFirms.pdf, replace

* Share of Employment in top 50%
scatter EmpShare_Top50Perc EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Top 50% of Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_EmpShare_Top50Perc.pdf, replace


* Share of Employment in top 10%
scatter EmpShare_Top10Perc EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Top 10% of Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_EmpShare_Top10Perc.pdf, replace


* Share of Employment in top 1%
scatter EmpShare_Top01Perc EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Top 1% of Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_EmpShare_Top01Perc.pdf, replace


* Assets to Emp
graph twoway (scatter AssetsPerEmp_PubLarge EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter AssetsPerEmp_PriLarge EquityMktDepth_WB, mlabel(CountryCode_2Digit)  msymbol(D)), xtitle("Equity Market Depth") ytitle("Assets Per Employee") graphregion(color(white))  legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/EquityMktDepth_AssetsPerEmp_PubLarge.pdf, replace

graph twoway (scatter AssetsPerRev_PubLarge EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter AssetsPerRev_PriLarge EquityMktDepth_WB, mlabel(CountryCode_2Digit)  msymbol(D)), xtitle("Equity Market Depth") ytitle("Assets to Revenue") graphregion(color(white))  legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/EquityMktDepth_AssetsPerRev_PubLarge.pdf, replace

*----------------------------------
* Other Financial Development Variables
*----------------------------------
* Domestic Credit
scatter DomCredit_WB EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Domestic Credit") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_DomCredit_WB.pdf, replace

scatter DomCreditBanks_WB EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Domestic Credit by Banks") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 2)) ylabel(#5)
graph export Output/Cross-Country/EquityMktDepth_DomCredit-Banks_WB.pdf, replace


scatter PrivateDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Private Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_PrivateDebt_IMF.pdf, replace

scatter PrivateDebtAll_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Private Debt (all instruments)") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 3)) ylabel(#5)
graph export Output/Cross-Country/EquityMktDepth_PrivateDebtAll_IMF.pdf, replace

scatter HHDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Household Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_HHDebt_IMF.pdf, replace

scatter HHDebtAll_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Household Debt (All Instruments)") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 1.5)) ylabel(#6)
graph export Output/Cross-Country/EquityMktDepth_HHDebtAll_IMF.pdf, replace

scatter NonFinancialDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("NonFinancial Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/EquityMktDepth_NonFinancialDebt_IMF.pdf, replace


