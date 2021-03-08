

preserve


collapse (mean) nEmployees Revenue Sales COGS WageBill ///
		Listed nShareholders Assets GrossProfits ///
		(count) nFirms=nEmployees, by(Age)

drop if (Age>29)

 
 
 replace Revenue=Revenue/1000000
 replace Sales=Sales/1000000
 replace WageBill=WageBill/1000000
 replace Assets=Assets/1000000
 replace GrossProfits=GrossProfits/1000

 graph twoway (scatter Assets Age if (Age<10), msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Assets in Millions")
 graph export Output/$CountryID/Lifecycle_Assets.pdf, replace  
  

 graph twoway (scatter Revenue Age if (Age<10), msymbol(0) connect(l)) ///
	(scatter Sales Age if (Age<10), msymbol(S) connect(l) lpattern(dash) ) ///
	, graphregion(color(white))  ytitle("Revenue and Sales in Millions")  ///
	legend( order( 1 "Revenue" 2 "Sales"))
 graph export Output/$CountryID/Lifecycle_Revenue_Sales.pdf, replace  

 
  graph twoway (scatter Revenue Age if (Age<10), msymbol(0) connect(l)) ///
	(scatter WageBill Age if (Age<10), msymbol(S) connect(l) lpattern(dash) ) ///
	, graphregion(color(white))  ytitle("Revenue and Costs in Millions") ///
	legend( order( 1 "Revenue" 2 "Wage Bill"))
 graph export Output/$CountryID/Lifecycle_Revenue_Costs.pdf, replace  

   graph twoway (scatter Listed Age if (Age<10), msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Proportion of Listed Firms")
 graph export Output/$CountryID/Lifecycle_Public.pdf, replace  


    graph twoway (scatter nShareholders Age if (Age<10) & (nShareholders != .), msymbol(0) connect(l)) ///
	, graphregion(color(white))  ytitle("Average Number of Shareholders")
 graph export Output/$CountryID/Lifecycle_nShareholders.pdf, replace  
 

  
 graph twoway (scatter GrossProfits Age if (Age<10), msymbol(0) connect(l)) ///
, graphregion(color(white))  ytitle("Average Gross Profits in Thousands") 
 graph export Output/$CountryID/Lifecycle_GrossProfits.pdf, replace  


 
 
graph twoway (scatter nEmployees Age if (Age<10) & (nEmployees != .), msymbol(0) connect(l)) ///
			,graphregion(color(white))  ytitle("Average Number of Employees") 
         graph export Output/$CountryID/Lifecycle_Employment.pdf, replace  

 graph twoway scatter nFirms Age if (Age<10), msymbol(0) connect(l) ///
	graphregion(color(white))  ytitle("Number of Firms")
 graph export Output/$CountryID/Lifecycle_nFirms.pdf, replace  

restore
