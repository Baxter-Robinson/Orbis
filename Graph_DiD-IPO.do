preserve
	* Rescale variables
	replace Sales = Sales/1000
	replace SalesPerEmployee = SalesPerEmployee/1000
	replace GrossProfits = GrossProfits/1000
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	
	* Only keep IPO where we observe them +/- 3 years relative to IPO
	sort IDNum
	gen PlusMinus_ThreeYears_all = 1 if (IPO_timescale==-3) | (IPO_timescale==-2) | (IPO_timescale==-1) |/*
	*/ (IPO_timescale==0) | (IPO_timescale==1) | (IPO_timescale==2) | (IPO_timescale==3)
	egen PlusMinus_ThreeYears = total(PlusMinus_ThreeYears_all), by(IDNum)
	replace PlusMinus_ThreeYears = . if PlusMinus_ThreeYears < 7
	replace PlusMinus_ThreeYears = 1 if PlusMinus_ThreeYears == 7
	if ("$CountryID" == "FR") | ("$CountryID" == "IT") | ("$CountryID" == "HU") {
		drop if (IPO_year != .) & (PlusMinus_ThreeYears == .)
	}
	* Only keep firms where we have at least 7 observations
	egen nyear = total(inrange(Year, 1984, 2019)), by(IDNum)
	drop if nyear < 7
	
	* Create dummy for three years before and after IPO
	gen D_IPO = 0
	replace D_IPO = 1 if IPO_timescale == 0
	forvalues i = 1/3 {
		gen D_IPO_minus`i' = 0
		gen D_IPO_plus`i' = 0
		replace D_IPO_minus`i' = 1 if IPO_timescale == -`i'
		replace D_IPO_plus`i' = 1 if IPO_timescale == `i'
	}

	* DiD regressions (number of employees, sales, sales per employees)
	mat x_axis = (-3\-2\-1\0\1\2\3)
	svmat x_axis
	local depvar nEmployees Sales SalesPerEmployee GrossProfits
	foreach v of local depvar {
		mat did_`v' = J(7,3,.)
		quietly: xtreg `v' Age i.Year D_IPO*, fe
		* Store DiD coefficients and 95% confidence intervals in matrices
		forvalues i = 1/7 {
			if (`i'<4){
				mat did_`v'[`i',1] = _b[D_IPO_minus`i']
				mat did_`v'[`i',2] = _b[D_IPO_minus`i'] -(1.96*_se[D_IPO_minus`i'])
				mat did_`v'[`i',3] = _b[D_IPO_minus`i'] +(1.96*_se[D_IPO_minus`i'])
			}
			else if (`i'==4){
				mat did_`v'[`i',1] = _b[D_IPO]
				mat did_`v'[`i',2] = _b[D_IPO] -(1.96*_se[D_IPO])
				mat did_`v'[`i',3] = _b[D_IPO] +(1.96*_se[D_IPO])
			}
			else {
				local j = `i'-4
				mat did_`v'[`i',1] = _b[D_IPO_plus`j']
				mat did_`v'[`i',2] = _b[D_IPO_plus`j'] -(1.96*_se[D_IPO_plus`j'])
				mat did_`v'[`i',3] = _b[D_IPO_plus`j'] +(1.96*_se[D_IPO_plus`j'])
			}
		}
	}
	
	*Number of unique IPO firms for graph
	egen unique_IPO = group(IDNum) if IPO_year != .
	su unique_IPO 
	local N: di %12.0fc r(max)
	
	*Create DiD Graphs
	svmat did_nEmployees
	graph twoway (connected did_nEmployees1 x_axis) (rcap did_nEmployees2 did_nEmployees3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in number of employees") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Employees_3yr.pdf, replace 
	
	svmat did_Sales
	graph twoway (connected did_Sales1 x_axis) (rcap did_Sales2 did_Sales3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Sales_3yr.pdf, replace  
	
	svmat did_SalesPerEmployee
	graph twoway (connected did_SalesPerEmployee1 x_axis) (rcap did_SalesPerEmployee2 did_SalesPerEmployee3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales per employees (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_SalesPerEmployee_3yr.pdf, replace 
	
	svmat did_GrossProfits
	graph twoway (connected did_GrossProfits1 x_axis) (rcap did_GrossProfits2 did_GrossProfits3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in gross profits (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white)) title("Number of unique IPO firms = `N'") 
	graph export Output/$CountryID/IPO_YearMinusIPO_Profitability_3yr.pdf, replace 
	
restore

preserve
	* Rescale variables
	replace Sales = Sales/1000
	replace SalesPerEmployee = SalesPerEmployee/1000
	replace GrossProfits = GrossProfits/1000
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	
	* Only keep IPO where we observe them +/- 2 years relative to IPO
	sort IDNum
	gen PlusMinus_TwoYears_all = 1 if (IPO_timescale==-2) | (IPO_timescale==-1) |/*
	*/ (IPO_timescale==0) | (IPO_timescale==1) | (IPO_timescale==2)
	egen PlusMinus_TwoYears = total(PlusMinus_TwoYears_all), by(IDNum)
	replace PlusMinus_TwoYears = . if PlusMinus_TwoYears < 5
	replace PlusMinus_TwoYears = 1 if PlusMinus_TwoYears == 5
	if ("$CountryID" == "FR") | ("$CountryID" == "IT") | ("$CountryID" == "HU") {
		drop if (IPO_year != .) & (PlusMinus_TwoYears == .)
	}
	* Only keep firms where we have at least 5 observations
	egen nyear = total(inrange(Year, 1984, 2019)), by(IDNum)
	drop if nyear < 5
	
	* Create dummy for two years before and after IPO
	gen D_IPO = 0
	replace D_IPO = 1 if IPO_timescale == 0
	forvalues i = 1/2 {
		gen D_IPO_minus`i' = 0
		gen D_IPO_plus`i' = 0
		replace D_IPO_minus`i' = 1 if IPO_timescale == -`i'
		replace D_IPO_plus`i' = 1 if IPO_timescale == `i'
	}

	* DiD regressions (number of employees, sales, sales per employees)
	mat x_axis = (-2\-1\0\1\2)
	svmat x_axis
	local depvar nEmployees Sales SalesPerEmployee GrossProfits
	foreach v of local depvar {
		mat did_`v' = J(5,3,.)
		quietly: xtreg `v' Age i.Year D_IPO*, fe
		* Store DiD coefficients and 95% confidence intervals in matrices
		forvalues i = 1/5 {
			if (`i'<3){
				mat did_`v'[`i',1] = _b[D_IPO_minus`i']
				mat did_`v'[`i',2] = _b[D_IPO_minus`i'] -(1.96*_se[D_IPO_minus`i'])
				mat did_`v'[`i',3] = _b[D_IPO_minus`i'] +(1.96*_se[D_IPO_minus`i'])
			}
			else if (`i'==3){
				mat did_`v'[`i',1] = _b[D_IPO]
				mat did_`v'[`i',2] = _b[D_IPO] -(1.96*_se[D_IPO])
				mat did_`v'[`i',3] = _b[D_IPO] +(1.96*_se[D_IPO])
			}
			else {
				local j = `i'-3
				mat did_`v'[`i',1] = _b[D_IPO_plus`j']
				mat did_`v'[`i',2] = _b[D_IPO_plus`j'] -(1.96*_se[D_IPO_plus`j'])
				mat did_`v'[`i',3] = _b[D_IPO_plus`j'] +(1.96*_se[D_IPO_plus`j'])
			}
		}
	}
	
	*Number of unique IPO firms for graph
	egen unique_IPO = group(IDNum) if IPO_year != .
	su unique_IPO 
	local N: di %12.0fc r(max)
	
	*Create DiD Graphs
	svmat did_nEmployees
	graph twoway (connected did_nEmployees1 x_axis) (rcap did_nEmployees2 did_nEmployees3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in number of employees") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-2[1]2) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Employees_2yr.pdf, replace 
	
	svmat did_Sales
	graph twoway (connected did_Sales1 x_axis) (rcap did_Sales2 did_Sales3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-2[1]2) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Sales_2yr.pdf, replace  
	
	svmat did_SalesPerEmployee
	graph twoway (connected did_SalesPerEmployee1 x_axis) (rcap did_SalesPerEmployee2 did_SalesPerEmployee3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales per employees (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-2[1]2) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_SalesPerEmployee_2yr.pdf, replace 
	
	svmat did_GrossProfits
	graph twoway (connected did_GrossProfits1 x_axis) (rcap did_GrossProfits2 did_GrossProfits3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in gross profits (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-2[1]2) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Profitability_2yr.pdf, replace 
	
restore

preserve
	* Rescale variables
	replace Sales = Sales/1000
	replace SalesPerEmployee = SalesPerEmployee/1000
	replace GrossProfits = GrossProfits/1000
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	
	* Only keep IPO firms where we observe them +/- x years
	sort IDNum
	gen PlusMinus_OneYear_all = 1 if (IPO_timescale==-1) | (IPO_timescale==0) | (IPO_timescale==1)
	egen PlusMinus_OneYear = total(PlusMinus_OneYear_all), by(IDNum)
	replace PlusMinus_OneYear = . if PlusMinus_OneYear < 3
	replace PlusMinus_OneYear = 1 if PlusMinus_OneYear == 3
	if ("$CountryID" == "FR") | ("$CountryID" == "IT") | ("$CountryID" == "HU") {
		drop if (IPO_year != .) & (PlusMinus_OneYear == .)
	}
	* Only keep firms where we have at least 3 observations
	egen nyear = total(inrange(Year, 1984, 2019)), by(IDNum)
	drop if nyear < 3
	
	* Create dummy for two years before and after IPO
	gen D_IPO = 0
	replace D_IPO = 1 if IPO_timescale == 0
	forvalues i = 1/1 {
		gen D_IPO_minus`i' = 0
		gen D_IPO_plus`i' = 0
		replace D_IPO_minus`i' = 1 if IPO_timescale == -`i'
		replace D_IPO_plus`i' = 1 if IPO_timescale == `i'
	}

	* DiD regressions (number of employees, sales, sales per employees)
	mat x_axis = (-1\0\1)
	svmat x_axis
	local depvar nEmployees Sales SalesPerEmployee GrossProfits
	foreach v of local depvar {
		mat did_`v' = J(3,3,.)
		quietly: xtreg `v' Age i.Year D_IPO*, fe
		* Store DiD coefficients and 95% confidence intervals in matrices
		forvalues i = 1/3 {
			if (`i'<2){
				mat did_`v'[`i',1] = _b[D_IPO_minus`i']
				mat did_`v'[`i',2] = _b[D_IPO_minus`i'] -(1.96*_se[D_IPO_minus`i'])
				mat did_`v'[`i',3] = _b[D_IPO_minus`i'] +(1.96*_se[D_IPO_minus`i'])
			}
			else if (`i'==2){
				mat did_`v'[`i',1] = _b[D_IPO]
				mat did_`v'[`i',2] = _b[D_IPO] -(1.96*_se[D_IPO])
				mat did_`v'[`i',3] = _b[D_IPO] +(1.96*_se[D_IPO])
			}
			else {
				local j = `i'-2
				mat did_`v'[`i',1] = _b[D_IPO_plus`j']
				mat did_`v'[`i',2] = _b[D_IPO_plus`j'] -(1.96*_se[D_IPO_plus`j'])
				mat did_`v'[`i',3] = _b[D_IPO_plus`j'] +(1.96*_se[D_IPO_plus`j'])
			}
		}
	}
	
	*Number of unique IPO firms for graph
	egen unique_IPO = group(IDNum) if IPO_year != .
	su unique_IPO 
	local N: di %12.0fc r(max)
	
	*Create DiD Graphs
	svmat did_nEmployees
	graph twoway (connected did_nEmployees1 x_axis) (rcap did_nEmployees2 did_nEmployees3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in number of employees") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-1[1]1) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Employees_1yr.pdf, replace 
	
	svmat did_Sales
	graph twoway (connected did_Sales1 x_axis) (rcap did_Sales2 did_Sales3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-1[1]1) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Sales_1yr.pdf, replace  
	
	svmat did_SalesPerEmployee
	graph twoway (connected did_SalesPerEmployee1 x_axis) (rcap did_SalesPerEmployee2 did_SalesPerEmployee3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales per employees (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-1[1]1) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_SalesPerEmployee_1yr.pdf, replace 
	
	svmat did_GrossProfits
	graph twoway (connected did_GrossProfits1 x_axis) (rcap did_GrossProfits2 did_GrossProfits3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in gross profits (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-1[1]1) graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_Profitability_1yr.pdf, replace 
	
restore