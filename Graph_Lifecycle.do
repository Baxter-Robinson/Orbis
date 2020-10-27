
preserve


collapse (mean) nEmployees Revenue Sales COGS WageBill ///
		TotalCosts Listed nShareholders Assets GrossProfits ///
		(count) nFirms=nEmployees, by(Age)

drop if (Age>29)

graph twoway scatter nEmployees Age, msymbol(0) connect(l) ///
			graphregion(color(white))  ytitle("Average Number of Employees")
         graph export Output/$CountryID/Lifecycle_Employment.pdf, replace  

 
 graph twoway scatter nFirms Age, msymbol(0) connect(l) ///
	graphregion(color(white))  ytitle("Number of Firms")
 graph export Output/$CountryID/Lifecycle_nFirms.pdf, replace  
 
 
  
 graph twoway (scatter Revenue Age, msymbol(0) connect(l)) ///
	(scatter Sales Age, msymbol(S) connect(l) lpattern(dash) ) ///
	, graphregion(color(white))  ytitle("$")
 graph export Output/$CountryID/Lifecycle_Revenue_Sales.pdf, replace  

 
  graph twoway (scatter Revenue Age, msymbol(0) connect(l)) ///
	(scatter TotalCosts Age, msymbol(S) connect(l) lpattern(dash) ) ///
	, graphregion(color(white))  ytitle("$")
 graph export Output/$CountryID/Lifecycle_Revenue_Costs.pdf, replace  
 
 
   graph twoway (scatter Listed Age, msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Proportion of Listed Firms")
 graph export Output/$CountryID/Lifecycle_Public.pdf, replace  

 
    graph twoway (scatter nShareholders Age, msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Number of Shareholders")
 graph export Output/$CountryID/Lifecycle_nShareholders.pdf, replace  
 
     graph twoway (scatter Assets Age, msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Assets")
 graph export Output/$CountryID/Lifecycle_Assets.pdf, replace  
 
 
  
     graph twoway (scatter GrossProfits Age, msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Assets")
 graph export Output/$CountryID/Lifecycle_GrossProfits.pdf, replace  

restore
