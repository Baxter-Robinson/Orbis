preserve
	* Distribution of number of firms in each year by age
	su Year
	local nyear = `r(max)'-`r(min)'
	forvalues t = `r(min)'/`r(max)' {
		gen year`t' = `t' if Year == `t'
		lab var year`t' "`t'"
	}
	graph bar (count) year* if Age <= `nyear', over(Age) stack nolabel ///
	b1title("Firm age") ytitle("Frequency")
	graph export Output/$CountryID/Distribution_Firm-YearbyAge.pdf, replace  
	
	*drop if (Age > 29)
	
	 collapse (mean) nEmployees Revenue Sales COGS WageBill ///
			Listed nShareholders Assets GrossProfits ///
			(count) nFirms=nEmployees, by(Year)
	 
	* Lifecycle graphs
	 replace Revenue=Revenue/1000000
	 replace Sales=Sales/1000000
	 replace WageBill=WageBill/1000000
	 replace Assets=Assets/1000000
	 replace GrossProfits=GrossProfits/1000	

	 * Assets
	 graph twoway (scatter Assets Year, msymbol(0) connect(l)) ///
		, graphregion(color(white)) ytitle("Average Assets in Thousands") xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_Assets.pdf, replace  
	  
	* Revenue/Sales
	 graph twoway (scatter Revenue Year, msymbol(0) connect(l)) ///
		(scatter Sales Year, msymbol(S) connect(l) lpattern(dash) ) ///
		, graphregion(color(white))  ytitle("Revenue and Sales in Thousands")  ///
		legend( order( 1 "Revenue" 2 "Sales")) xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_Revenue_Sales.pdf, replace  

	* Revenue/Cost 
	  graph twoway (scatter Revenue Year, msymbol(0) connect(l)) ///
		(scatter WageBill Year, msymbol(S) connect(l) lpattern(dash) ) ///
		, graphregion(color(white))  ytitle("Revenue and Costs in Thousands") ///
		legend( order( 1 "Revenue" 2 "Wage Bill")) xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_Revenue_Costs.pdf, replace  

	* Number of public firms 
	   graph twoway (scatter Listed Year, msymbol(0) connect(l)) ///
		, graphregion(color(white))  ytitle("Proportion of Listed Firms") xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_Public.pdf, replace  

	* Number of shareholders
		graph twoway (scatter nShareholders Year if (nShareholders != .), msymbol(0) connect(l)) ///
		, graphregion(color(white))  ytitle("Average Number of Shareholders") xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_nShareholders.pdf, replace  
	 
	* Gross profits
	 graph twoway (scatter GrossProfits Year, msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Gross Profits in Thousands") xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_GrossProfits.pdf, replace  


	* Employment
	graph twoway (scatter nEmployees Year if (nEmployees != .), msymbol(0) connect(l)) ///
				,graphregion(color(white))  ytitle("Average Number of Employees") xtitle("Year (proxy for age)")
			 graph export Output/$CountryID/Lifecycle_Employment.pdf, replace  

	* Number of firms
	 graph twoway scatter nFirms Year, msymbol(0) connect(l) ///
		graphregion(color(white))  ytitle("Number of Firms") xtitle("Year (proxy for age)")
	 graph export Output/$CountryID/Lifecycle_nFirms.pdf, replace  
restore
