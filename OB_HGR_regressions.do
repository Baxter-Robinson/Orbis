
* REGHDFE installation
* ssc install reghdfe


gen private = 1 if FirmType != 6 | (FirmType == 6 & Year >= Delisted_year)
gen public = 1 if FirmType == 6
replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year
gen nEmployeesSq = nEmployees*nEmployees
gen l_Revenue = log(Revenue)
gen l_nEmployees = log(nEmployees)
gen l_nEmployeesSq = log(nEmployeesSq)


* OLS Regressions, lin-lin (with squared employment)
reg EmpGrowth_h nEmployees i.Year, vce(robust)
eststo m1
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h nEmployees nEmployeesSq i.Year , vce(robust)
eststo m2
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h nEmployees nEmployeesSq public i.Year, vce(robust)
eststo m3
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h nEmployees nEmployeesSq public Revenue Age i.Year, vce(robust)
eststo m4
estadd local Year "Yes"
estadd local Robust "Yes"

esttab m1 m2 m3 m4 using "Output/$CountryID/HGR_OLS_regressions_lin_lin.tex", se legend mtitles("1" "2" "3" "4") title("Haltiwanger growth rate") s(N Year Robust, label( "N" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" nEmployees "No. employees" nEmployeesSq "No. employees (squared)" public "Public firm" Revenue "Revenue"  Age "Age") nonumbers keep( _cons nEmployees nEmployeesSq public Revenue Age ) replace


* OLS Regressions, lin - log (with squared employment)
reg EmpGrowth_h l_nEmployees i.Year
eststo m1a
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h l_nEmployees l_nEmployeesSq i.Year 
eststo m2a
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h l_nEmployees l_nEmployeesSq public i.Year
eststo m3a
estadd local Year "Yes"
estadd local Robust "Yes"

reg EmpGrowth_h l_nEmployees l_nEmployeesSq public l_Revenue Age i.Year
eststo m4a
estadd local Year "Yes"
estadd local Robust "Yes"


esttab m1a m2a m3a m4a using "Output/$CountryID/HGR_OLS_regressions_lin_log.tex", se legend mtitles("1" "2" "3" "4") title("Haltiwanger growth rate") s(N Year Robust, label( "N" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" l_nEmployees "(Log of) No. employees" l_nEmployeesSq "(Log of) No. employees (squared)" public "Public firm" l_Revenue "(Log of) Revenue"  Age "Age") nonumbers keep( _cons l_nEmployees l_nEmployeesSq public l_Revenue Age ) replace



* FE Regressions, lin-lin (with squared employment)
*xtset IDNum Year
*xtreg EmpGrowth_h nEmployees i.Year, fe vce(robust) 
reghdfe EmpGrowth_h nEmployees, absorb(Year IDNum) vce(robust)
eststo m1fe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


*xtreg EmpGrowth_h nEmployees nEmployeesSq i.Year, fe vce(robust) 
reghdfe EmpGrowth_h nEmployees nEmployeesSq,  absorb(Year IDNum) vce(robust)
eststo m2fe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"

*xtreg EmpGrowth_h nEmployees nEmployeesSq public i.Year, fe vce(robust) 
reghdfe EmpGrowth_h nEmployees nEmployeesSq public,   absorb(Year IDNum) vce(robust)
eststo m3fe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


*xtreg EmpGrowth_h nEmployees nEmployeesSq public Revenue Age i.Year, fe vce(robust) 
reghdfe EmpGrowth_h nEmployees nEmployeesSq public Revenue Age, absorb(Year IDNum) vce(robust)
eststo m4fe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


esttab m1fe m2fe m3fe m4fe using "Output/$CountryID/HGR_FE_regressions_lin_lin.tex", se legend mtitles("1" "2" "3" "4") title("Haltiwanger growth rate") s(N Firm Year Robust, label( "N" "Firm Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" nEmployees "No. employees" nEmployeesSq "No. employees (squared)" public "Public firm" Revenue "Revenue"  Age "Age") nonumbers keep( _cons nEmployees nEmployeesSq public Revenue Age ) replace


* FE Regressions, lin-log (with squared employment)
xtset IDNum Year
*xtreg EmpGrowth_h l_nEmployees i.Year, fe vce(robust) 
reghdfe EmpGrowth_h l_nEmployees, absorb(Year IDNum) vce(robust)
eststo m1afe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


*xtreg EmpGrowth_h l_nEmployees l_nEmployeesSq i.Year, fe vce(robust) 
reghdfe EmpGrowth_h l_nEmployees l_nEmployeesSq, absorb(Year IDNum) vce(robust)
eststo m2afe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


*xtreg EmpGrowth_h l_nEmployees l_nEmployeesSq public i.Year, fe vce(robust) 
reghdfe EmpGrowth_h l_nEmployees l_nEmployeesSq public, absorb(Year IDNum) vce(robust)
eststo m3afe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


*xtreg EmpGrowth_h l_nEmployees l_nEmployeesSq public l_Revenue Age i.Year, fe vce(robust) 
reghdfe EmpGrowth_h l_nEmployees l_nEmployeesSq public l_Revenue Age, absorb(Year IDNum) vce(robust)
eststo m4afe
estadd local Firm "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


esttab m1afe m2afe m3afe m4afe using "Output/$CountryID/HGR_FE_regressions_lin_log.tex", se legend mtitles("1" "2" "3" "4") title("Haltiwanger growth rate") s(N Firm Year Robust, label( "N" "Firm Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" l_nEmployees "(Log of) No. employees" l_nEmployeesSq "(Log of) No. employees (squared)" public "Public firm" l_Revenue "(Log of) Revenue"  Age "Age") nonumbers keep( _cons l_nEmployees l_nEmployeesSq public l_Revenue Age ) replace

