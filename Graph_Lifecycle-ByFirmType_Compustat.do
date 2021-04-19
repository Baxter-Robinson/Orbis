***************************
*** Graphs for averages ***
***************************

preserve
	* Generate Employment and Sales growth (Haltiwanger)
	bysort IDNum: gen SalesGrowth_h = (Sales[_n]-Sales[_n-1])/((Sales[_n]+Sales[_n-1])/2)
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	*drop if (Age>29)
	collapse (mean) nEmployees Sales nShareholders GrossProfits SalesGrowth_h EmpGrowth_h ///
			(count) nFirms=nEmployees, by(Year)
	* Change units
	 replace Sales=Sales/1000
	 
	 * Employment
	 graph twoway (connected nEmployees Year), ytitle("Number of Employees") graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_Employment_Compustat.pdf, replace  
	 
	 * Employment Growth (Haltiwanger)
	 graph twoway (connected EmpGrowth_h Year), ytitle("Growth") graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_EmploymentGrowth_Compustat.pdf, replace  
	 
	 * Sales 
	 graph twoway (connected Sales Year), ytitle("Sales (Millions)") graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_Sales_Compustat.pdf, replace  
	 
	 * Sales Growth Haltiwanger)
	 graph twoway (connected SalesGrowth_h Year), ytitle("Growth") graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_SalesGrowth_Compustat.pdf, replace  
restore

******************************
*** Graphs for percentiles ***
******************************

* Sales
preserve
	replace Sales=Sales/1000
	* Generate Employment and Sales growth (Haltiwanger)
	bysort IDNum: gen SalesGrowth_h = (Sales[_n]-Sales[_n-1])/((Sales[_n]+Sales[_n-1])/2)
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	* Generate percentiles for each variables
	local vars nEmployees EmpGrowth_h Sales SalesGrowth_h
	foreach v of local vars {
		gen `v'_25 = .
		gen `v'_50 = .
		gen `v'_75 = .
		su Year
		forvalues t = `r(min)'/`r(max)' {
			su `v' if Year == `t', detail
			replace `v'_25 = r(p25) if Year == `t' 
			replace `v'_50 = r(p50) if Year == `t' 
			replace `v'_75 = r(p75) if Year == `t'
		}
	} 
	collapse (mean) Sales_25 Sales_50 Sales_75 ///
	SalesGrowth_h_25 SalesGrowth_h_50 SalesGrowth_h_75 ///
	nEmployees_25 nEmployees_50 nEmployees_75 ///		
	EmpGrowth_h_25 EmpGrowth_h_50 EmpGrowth_h_75, ///
	by(Year)
	
	* Sales 
	graph twoway (connected Sales_25 Year) (connected Sales_50 Year) (connected Sales_75 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Sales (thousands)")
	graph export Output/$CountryID/Lifecycle_Sales_ptile_Compustat.pdf, replace  
	
	* Sales growth (Haltiwanger)
	graph twoway (connected SalesGrowth_h_25 Year) (connected SalesGrowth_h_50 Year) (connected SalesGrowth_h_75 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_SalesGrowth_ptile_Compustat.pdf, replace  
	
	* Employment
	graph twoway (connected nEmployees_25 Year) (connected nEmployees_50 Year) (connected nEmployees_75 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Number of Employees")
	graph export Output/$CountryID/Lifecycle_Employment_ptile_Compustat.pdf, replace  
	
	* Employment growth (Haltiwanger)
	graph twoway (connected EmpGrowth_h_25 Year) (connected EmpGrowth_h_50 Year) (connected EmpGrowth_h_75 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_EmploymentGrowth_ptile_Compustat.pdf, replace  
restore