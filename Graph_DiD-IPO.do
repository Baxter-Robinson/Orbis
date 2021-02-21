preserve
	* Rescale variables
	replace Sales = Sales/1000
	replace SalesPerEmployee = SalesPerEmployee/1000
	replace GrossProfits = GrossProfits/1000
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
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
		xtreg `v' Age i.Year D_IPO*, fe
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
	
	*Create DiD Graphs
	svmat did_nEmployees
	graph twoway (connected did_nEmployees1 x_axis) (rcap did_nEmployees2 did_nEmployees3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in number of employees") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white))
	graph export Output/$CountryID/IPO_YearMinusIPO_Employees.pdf, replace 
	
	svmat did_Sales
	graph twoway (connected did_Sales1 x_axis) (rcap did_Sales2 did_Sales3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white))
	graph export Output/$CountryID/IPO_YearMinusIPO_Sales.pdf, replace  
	
	svmat did_SalesPerEmployee
	graph twoway (connected did_SalesPerEmployee1 x_axis) (rcap did_SalesPerEmployee2 did_SalesPerEmployee3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in sales per employees (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white))
	graph export Output/$CountryID/IPO_YearMinusIPO_SalesPerEmployee.pdf, replace 
	
	svmat did_GrossProfits
	graph twoway (connected did_GrossProfits1 x_axis) (rcap did_GrossProfits2 did_GrossProfits3 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Change in gross profits (thousands)") ///
	legend(label(1 "DiD Effect of introducting IPO") label(2 "95% Confidence Intervval")) xlabel(-3[1]3) graphregion(color(white))
	graph export Output/$CountryID/IPO_YearMinusIPO_Profitability.pdf, replace 
	
restore