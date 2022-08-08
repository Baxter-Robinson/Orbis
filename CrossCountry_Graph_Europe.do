* Country-level scatter plots between Eequity market depth and selected indicators

use  "Data_Cleaned/CrossCountry_Dataset_Euro.dta", clear


* Compare Equity Market Depth
twoway (scatter EquityMktDepth_OB EquityMktDepth_WB , mlabel(CountryCode_2)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Orbis Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 1)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_OBvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSyearend EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (year end) Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 6)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_CSyearendvsWB.pdf, replace


twoway (scatter EquityMktDepth_CSAnnual EquityMktDepth_WB , mlabel(CountryCode_2Digit)) ///
(line EquityMktDepth_WB EquityMktDepth_WB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("World Bank Equity Market Depth") ytitle("Compustat (annual) Equity Market Depth") graphregion(color(white))   ///
xscale(range(0 1)) xlabel(#6) yscale(range(0 6)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_CSAnnualvsWB.pdf, replace


twoway (scatter EquityMktDepth_OB EquityMktDepth_CSyearend , mlabel(CountryCode_2Digit)) ///
(line EquityMktDepth_OB EquityMktDepth_OB, sort) ///
, legend( label(1 "Equity Market Debt") label(2 "45 Degree Line")) ///
xtitle("Compustat (year end) Equity Market Depth") ytitle("Orbis Equity Market Depth") graphregion(color(white)) ///
xscale(range(0 12)) xlabel(#6) yscale(range(0 1)) ylabel(#6) 
graph export Output/Cross-Country/EquityMktDepth_OBvsCS.pdf, replace


* TFP
scatter tfp EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/TFP_EquityMktDepth_CSyearend.pdf, replace
scatter tfp EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/TFP_EquityMktDepth_CSannual.pdf, replace
scatter tfp EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/TFP_EquityMktDepth_OB.pdf, replace

graph twoway (scatter tfp EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
(lfit tfp EquityMktDepth_WB ) ///
, xtitle("Equity Market Depth") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/TFP_EquityMktDepth_WB.pdf, replace

graph twoway (scatter tfp empShare_Public, mlabel(CountryCode_2Digit)) ///
(lfit tfp empShare_Public ) ///
, xtitle("Employment Share of Public Firms") ytitle("Total Factor Productivity") graphregion(color(white)) legend(off)
graph export Output/Cross-Country/empSharePublic_TFP.pdf, replace

* Output Per Capita
scatter OutputPerCapita EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_CSyearend.pdf, replace
scatter OutputPerCapita EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_CSannual.pdf, replace
scatter OutputPerCapita EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_OB.pdf, replace
scatter OutputPerCapita EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Output Per Capita") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/OutputPerCapita_EquityMktDepth_WB.pdf, replace

* Capital to Labor ratio
scatter CapitalToLabor EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToLabor EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToLabor EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_OB.pdf, replace
scatter CapitalToLabor EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Labor ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToLabor_EquityMktDepth_WB.pdf, replace

* Capital to Output ratio
scatter CapitalToOutput EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToOutput EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToOutput EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_OB.pdf, replace
scatter CapitalToOutput EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_WB.pdf, replace

* Capital to Output ratio
scatter CapitalToOutput EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSyearend.pdf, replace
scatter CapitalToOutput EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_CSannual.pdf, replace
scatter CapitalToOutput EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_OB.pdf, replace
scatter CapitalToOutput EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Capital To Output ratio") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/CapitalToOutput_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Private firms
scatter avgEmpGrowth_Private EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_CSyearend.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_CSannual.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_OB.pdf, replace
scatter avgEmpGrowth_Private EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPrivate_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Public firms
scatter avgEmpGrowth_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_CSyearend.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_CSannual.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_OB.pdf, replace
scatter avgEmpGrowth_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Average Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/avgEmpGrowthPublic_EquityMktDepth_WB.pdf, replace

* Average Employment Growth of Public vs. Private Firms
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_CSyearend, mlabel(CountryCode_2Digit) ) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_CSyearend, mlabel(CountryCode_2Digit) ), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_CSyearend.pdf, replace
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_CSAnnual, mlabel(CountryCode_2Digit)) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_CSAnnual, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_CSannual.pdf, replace
graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_OB, mlabel(CountryCode_2Digit)) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_OB, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_OB.pdf, replace

graph twoway (scatter avgEmpGrowth_Public EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter avgEmpGrowth_Private EquityMktDepth_WB, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Average Employment Growth") graphregion(color(white)) legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/avgEmpGrowthPubVsPri_EquityMktDepth_WB.pdf, replace


* Variance of Employment Growth - Private Firms
scatter varEmpGrowth_Private EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_CSyearend.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_CSannual.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_OB.pdf, replace
scatter varEmpGrowth_Private EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Private Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPrivate_EquityMktDepth_WB.pdf, replace

* Variance of Employment Growth - Public Firms
scatter varEmpGrowth_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_CSyearend.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_CSannual.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_OB.pdf, replace
scatter varEmpGrowth_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Variance of Employment Growth - Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/varEmpGrowthPublic_EquityMktDepth_WB.pdf, replace


* Variance Employment Growth of Public vs. Private Firms
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_CSyearend, mlabel(CountryCode_2Digit)) ///
 (scatter varEmpGrowth_Private EquityMktDepth_CSyearend, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Variance of Employment Growth") graphregion(color(white))  
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_CSyearend.pdf, replace
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_CSAnnual, mlabel(CountryCode_2Digit)) ///
 (scatter varEmpGrowth_Private EquityMktDepth_CSAnnual, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Variance of Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_CSannual.pdf, replace
graph twoway (scatter varEmpGrowth_Public EquityMktDepth_OB, mlabel(CountryCode_2Digit)) ///
 (scatter varEmpGrowth_Private EquityMktDepth_OB, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Variance of Employment Growth") graphregion(color(white))
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_OB.pdf, replace

graph twoway (scatter varEmpGrowth_Public EquityMktDepth_WB, mlabel(CountryCode_2Digit)) ///
 (scatter varEmpGrowth_Private EquityMktDepth_WB, mlabel(CountryCode_2Digit)), xtitle("Equity Market Depth") ytitle("Variance of Employment Growth") graphregion(color(white))  legend(label(1 "Public") label( 2 "Private"))
graph export Output/Cross-Country/varEmpGrowthPubVsPri_EquityMktDepth_WB.pdf, replace


* Share of Employment in Public Firms
scatter empShare_Public EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_CSyearend.pdf, replace
scatter empShare_Public EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_CSannual.pdf, replace
scatter empShare_Public EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_OB.pdf, replace

scatter empShare_Public EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Public Firms") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empSharePublic_EquityMktDepth_WB.pdf, replace


* Share of Employment in Large Firms
scatter empShare_LargeFirms EquityMktDepth_CSyearend, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (>99 Workers)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_CSyearend.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_CSAnnual, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99 Workers)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_CSannual.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_OB, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99 Workers)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_OB.pdf, replace
scatter empShare_LargeFirms EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Employment Share of Large Firms (> 99  Workers)") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/empShareLargeFirms_EquityMktDepth_WB.pdf, replace



* Additional debt variables and Equity Market Depth
preserve
*keep if EquityMktDepth_WB!=. 

scatter DomCredit_WB EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Domestic Credit") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/WB_DomCredit_EquityMktDepth.pdf, replace

scatter DomCreditBanks_WB EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Domestic Credit by Banks") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 2)) ylabel(#5)
graph export Output/Cross-Country/WB_DomCreditBanks_EquityMktDepth.pdf, replace

scatter PrivateDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Private Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/IMF_PrivateDebt_EquityMktDepth.pdf, replace

scatter PrivateDebtAll_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Private Debt (all instruments)") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 3)) ylabel(#5)
graph export Output/Cross-Country/IMF_PrivateDebtAll_EquityMktDepth.pdf, replace

scatter HHDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Household Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/IMF_HHDebt_EquityMktDepth.pdf, replace

scatter HHDebtAll_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("Household Debt (all instruments)") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(0 1.5)) ylabel(#6)
graph export Output/Cross-Country/IMF_HHDebtAll_EquityMktDepth.pdf, replace

scatter NonFinancialDebt_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("NonFinancial Debt") graphregion(color(white)) mlabel(CountryCode_2Digit)
graph export Output/Cross-Country/IMF_NonFinancialDebt_EquityMktDepth.pdf, replace

scatter NonFinancialDebtAll_IMF EquityMktDepth_WB, xtitle("Equity Market Depth") ytitle("NonFinancial Debt (all instruments)") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 1)) xlabel(#5) ysc(r(1 2)) ylabel(#5)
graph export Output/Cross-Country/IMF_NonFinancialDebtAll_EquityMktDepth.pdf, replace

restore


* Additional Debt variables and Total Factor Productivity

preserve
        *keep if EquityMktDepth_WB!=. 

        scatter tfp DomCredit_WB,  xtitle("Domestic Credit") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/WB_DomCredit_TFP.pdf, replace

        scatter tfp DomCreditBanks_WB, xtitle("Domestic Credit by Banks") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit) xsc(r(0 2)) xlabel(#5) ylabel(#5)
        graph export Output/Cross-Country/WB_DomCreditBanks_TFP.pdf, replace

        scatter tfp PrivateDebtIMF, xtitle("Private Debt") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_PrivateDebt_TFP.pdf, replace

        scatter tfp PrivateDebtAllIMF, xtitle("Private Debt (all instruments)") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_PrivateDebtAll_TFP.pdf, replace

        scatter tfp HHDebtIMF, xtitle("Household Debt") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_HHDebt_TFP.pdf, replace

        scatter tfp HHDebtAllIMF, xtitle("Household Debt (all instruments)") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_HHDebtAll_TFP.pdf, replace

        scatter tfp NonFinancialDebtIMF, xtitle("NonFinancial Debt") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_NonFinancialDebt_TFP.pdf, replace

        scatter tfp NonFinancialDebtAllIMF, xtitle("NonFinancial Debt (all instruments)") ytitle("Total Factor Productivity") graphregion(color(white)) mlabel(CountryCode_2Digit)
        graph export Output/Cross-Country/IMF_NonFinancialDebtAll_TFP.pdf, replace

restore

preserve
        *keep if EquityMktDepth_WB!=. 
        gen line90 = _n/4
        graph twoway (scatter DomCredit_WB DomCreditBanks_WB ) (scatter PrivateDebtIMF PrivateDebtAllIMF) (scatter HHDebtIMF HHDebtAllIMF) (scatter NonFinancialDebtIMF NonFinancialDebtAllIMF) (line line90 line90 ) , ytitle("Constrained Set of Instruments") xtitle("All instruments") graphregion(color(white)) legend(label(1 "Domestic Credit") label(2 "Private Debt") label(3 "Household Debt") label(4 "Non Financial Debt"))
        graph export Output/Cross-Country/WB_IMF_Measure_Comparison.pdf, replace
restore

