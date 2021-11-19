***************************
*** Graphs for averages ***
***************************
preserve	
	
	*drop if (Age>29)
	collapse (mean) nEmployees Sales COGS WageBill ///
			Listed nShareholders Assets GrossProfits SalesGrowth_h EmpGrowth_h ///
			(count) nFirms=nEmployees, by(Year Private)
	* Change units
	 replace Sales=Sales/1000
	 
	 * Employment
	 graph twoway (connected nEmployees Year if Private==1, ytitle("Number of Employees")) ///
	 (connected nEmployees Year if Private==0, yaxis(2) ytitle("Number of Employees", axis(2))), ///
	 legend(label(1 "Private Firms (Left)") label(2 "Public Firms (Right)")) graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_Employment_byFirmType.pdf, replace  
	 
	 * Employment Growth (Haltiwanger)
	 graph twoway (connected EmpGrowth_h Year if Private==1) ///
	 (connected EmpGrowth_h Year if Private==0), ytitle("Growth") ///
	 legend(label(1 "Private Firms (Left)") label(2 "Public Firms (Right)")) graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_EmploymentGrowth_byFirmType.pdf, replace  
	 graph twoway (connected EmpGrowth_h Year if Private==0), ytitle("Growth") ///
	 legend(label(1 "Private Firms (Left)") label(2 "Public Firms (Right)")) graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_EmploymentGrowth_Public.pdf, replace  
	 
	 * Sales 
	 graph twoway (connected Sales Year if Private==1, ytitle("Sales (thousands)")) ///
	 (connected Sales Year if Private==0, yaxis(2) ytitle("Sales (thousands)", axis(2))), ///
	 legend(label(1 "Private Firms (Left)") label(2 "Public Firms (Right)")) graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_Sales_ByFirmType.pdf, replace  
	 
	 * Sales Growth (Haltiwanger)
	 graph twoway (connected SalesGrowth_h Year if Private==1) ///
	 (connected SalesGrowth_h Year if Private==0), ytitle("Growth") ///
	 legend(label(1 "Private Firms (Left)") label(2 "Public Firms (Right)")) graphregion(color(white))
	 graph export Output/$CountryID/Lifecycle_SalesGrowth_ByFirmType.pdf, replace  
restore

******************************
*** Graphs for percentiles ***
******************************


preserve
	replace Sales=Sales/1000
	* Generate percentiles for each variables
	local vars nEmployees EmpGrowth_h Sales SalesGrowth_h
	foreach v of local vars {
		forvalues i = 0/1 {
			gen `v'_25_`i' = .
			gen `v'_50_`i' = .
			gen `v'_75_`i' = .
			su Year
			forvalues t = `r(min)'/`r(max)' {
				su `v' if Year == `t' & Private==`i', detail
				replace `v'_25_`i' = r(p25) if Year == `t' & Private==`i'
				replace `v'_50_`i' = r(p50) if Year == `t' & Private==`i'
				replace `v'_75_`i' = r(p75) if Year == `t' & Private==`i'
			}
		}
	} 
	collapse (mean) Sales_25_0 Sales_50_0 Sales_75_0 Sales_25_1 Sales_50_1 Sales_75_1 ///
	SalesGrowth_h_25_0 SalesGrowth_h_50_0 SalesGrowth_h_75_0 SalesGrowth_h_25_1 SalesGrowth_h_50_1 SalesGrowth_h_75_1 ///
	nEmployees_25_0 nEmployees_50_0 nEmployees_75_0 nEmployees_25_1 nEmployees_50_1 nEmployees_75_1 ///		
	EmpGrowth_h_25_0 EmpGrowth_h_50_0 EmpGrowth_h_75_0 EmpGrowth_h_25_1 EmpGrowth_h_50_1 EmpGrowth_h_75_1, ///
	by(Year Private)
	
	drop if Year < 2010
	
	* Sales 
	graph twoway (connected Sales_25_0 Year) (connected Sales_50_0 Year) (connected Sales_75_0 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Sales (thousands)")
	graph export Output/$CountryID/Lifecycle_Sales_Private_ptile.pdf, replace  
	graph twoway (connected Sales_25_1 Year) (connected Sales_50_1 Year) (connected Sales_75_1 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Sales (thousands)")
	graph export Output/$CountryID/Lifecycle_Sales_Public_ptile.pdf, replace 
	
	* Sales growth (Haltiwanger)
	graph twoway (connected SalesGrowth_h_25_0 Year) (connected SalesGrowth_h_50_0 Year) (connected SalesGrowth_h_75_0 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_SalesGrowth_Private_ptile.pdf, replace  
	graph twoway (connected SalesGrowth_h_25_1 Year) (connected SalesGrowth_h_50_1 Year) (connected SalesGrowth_h_75_1 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_Sales_Growth_Public_ptile.pdf, replace 
	
	* Employment
	graph twoway (connected nEmployees_25_0 Year) (connected nEmployees_50_0 Year) (connected nEmployees_75_0 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Number of Employees")
	graph export Output/$CountryID/Lifecycle_Employment_Private_ptile.pdf, replace  
	graph twoway (connected nEmployees_25_1 Year) (connected nEmployees_50_1 Year) (connected nEmployees_75_1 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Number of Employees")
	graph export Output/$CountryID/Lifecycle_Employment_Public_ptile.pdf, replace 
	if "$CountryID" == "ES" {
		graph twoway (connected nEmployees_25_1 Year) (connected nEmployees_50_1 Year) (connected nEmployees_75_1 Year), ///
		legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
		graphregion(color(white)) ytitle("Number of Employees") ylabel(0[10000]100000)
		graph export Output/$CountryID/Lifecycle_Employment_Public_ptile_SameScale.pdf, replace 
	}
	else {
		graph twoway (connected nEmployees_25_1 Year) (connected nEmployees_50_1 Year) (connected nEmployees_75_1 Year), ///
		legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
		graphregion(color(white)) ytitle("Number of Employees") ylabel(0[5000]30000)
		graph export Output/$CountryID/Lifecycle_Employment_Public_ptile_SameScale.pdf, replace 
	}
	
	* Employment growth (Haltiwanger)
	graph twoway (connected EmpGrowth_h_25_0 Year) (connected EmpGrowth_h_50_0 Year) (connected EmpGrowth_h_75_0 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_EmploymentGrowth_Private_ptile.pdf, replace  
	graph twoway (connected EmpGrowth_h_25_1 Year) (connected EmpGrowth_h_50_1 Year) (connected EmpGrowth_h_75_1 Year), ///
	legend(label(1 "25th percentile") label(2 "50th percentile") label(3 "75th percentile ")) ///
	graphregion(color(white)) ytitle("Growth")
	graph export Output/$CountryID/Lifecycle_EmploymentGrowth_Public_ptile.pdf, replace 
restore
