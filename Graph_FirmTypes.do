/*
preserve 
* -------------------------------------------------------
* Averages
* -------------------------------------------------------


** For each Firm Type
collapse (mean) nShareholders Sales nEmployees Age ///
 (count) nFirms=nShareholders, by(FirmType)


replace nFirms=nFirms/1000

twoway (bar nFirms FirmType) , xtitle("Number of Shareholders") ytitle("Thousands of Firms ")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_Count.pdf, replace  

	 
 twoway (bar Age FirmType) , xtitle("Number of Shareholders") ytitle("Average Age of Firms")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_Age.pdf, replace  



	
twoway (scatter nEmployees FirmType  [w=nFirms]) , xtitle("Number of Shareholders") ytitle("Number of Employees ")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_AvgEmployees.pdf, replace  

	

gen SalesPerEmployee=Sales/nEmployees/1000
	
twoway (scatter SalesPerEmployee FirmType  [w=nFirms]) , xtitle("Number of Shareholders") ytitle("Average Sales Per Employee (Thousands)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_AvgSalesPerEmployee.pdf, replace  

	 
  

restore
*/

* -------------------------------------------------------
* Growth Rates
* -------------------------------------------------------
preserve

drop Closing_date Export_revenue Stock Market_capitalisation_mil Age  EmpGrowth_* SalesGrowth_h ProfitGrowth_h
drop if missing(nEmployees)

reshape wide nEmployees Revenue Sales COGS Assets WageBill GrossProfits EBITDA SalesPerEmployee , i(BvD_ID_Number) j(Year)

drop if missing(Sales2017)

gen EmpGrowth=(nEmployees2017-nEmployees2009)/nEmployees2009
gen SalesGrowth=(Sales2017-Sales2009)/Sales2009
gen SalesPerEmpGrowth=(SalesPerEmployee2017-SalesPerEmployee2009)/(SalesPerEmployee2009)

** For each Firm Type
collapse (mean) nEmployees2017 nEmployees2009  Sales2017 Sales2009 ///
(p10) EmpGrowth_p10=EmpGrowth SalesGrowth_p10=SalesGrowth SalesPerEmpGrowth_p10=SalesPerEmpGrowth ///
(p50) EmpGrowth_p50=EmpGrowth SalesGrowth_p50=SalesGrowth SalesPerEmpGrowth_p50=SalesPerEmpGrowth ///
(p90) EmpGrowth_p90=EmpGrowth SalesGrowth_p90=SalesGrowth SalesPerEmpGrowth_p90=SalesPerEmpGrowth ///
 (count) nFirms=EmpGrowth, by(FirmType)

gen EmpGrowth=(nEmployees2017-nEmployees2009)/nEmployees2009
gen SalesGrowth=(Sales2017-Sales2009)/Sales2009
gen SalesPerEmpGrowth=(Sales2017/nEmployees2017-Sales2009/nEmployees2009)/(Sales2009/nEmployees2009)

twoway (bar EmpGrowth FirmType) , xtitle("Number of Shareholders") ytitle("Employment Growth (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_Growth-Emp.pdf, replace  
/*	 
twoway (scatter  EmpGrowth_p90 FirmType  , msymbol(Sh) connect(l)  lp(-###) ) ///
	   (scatter  EmpGrowth_p50 FirmType  , msymbol(o) connect(l)  ) ///
	   (scatter  EmpGrowth_p10 FirmType  , msymbol(D) connect(l)  lp(-###)  ) ///
, xtitle("Number of Shareholders") ytitle("Employment Growth (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" ) ///
	legend( order( 1 "90th percentile"  2 "50th Percentile" 3 "10th Percentile" )) 
	 graph export Output/$CountryID/FirmTypes_Growth-Emp-Dispersion.pdf, replace  	 

twoway (bar SalesGrowth FirmType) , xtitle("Number of Shareholders") ytitle("Sales Growth (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_Growth-Sales.pdf, replace  
	 
	 
twoway  (scatter  SalesGrowth_p90 FirmType  , msymbol(Sh) connect(l)  lp(-###) ) ///
		(scatter  SalesGrowth_p50 FirmType  , msymbol(o) connect(l)  ) ///
		(scatter  SalesGrowth_p10 FirmType  , msymbol(D) connect(l)  lp(-###)  ) ///
, xtitle("Number of Shareholders") ytitle("Sales Growth (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" ) ///
	legend( order( 1 "90th percentile"  2 "50th Percentile" 3 "10th Percentile" )) 
	 graph export Output/$CountryID/FirmTypes_Growth-Sales-Dispersion.pdf, replace  	 

	 
twoway (bar SalesPerEmpGrowth FirmType) , xtitle("Number of Shareholders") ytitle("Sales per Employee Growth (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" )
	 graph export Output/$CountryID/FirmTypes_Growth-SalesPerEmp.pdf, replace  


twoway  (scatter  SalesPerEmpGrowth_p90 FirmType  , msymbol(Sh) connect(l)  lp(-###) ) ///
		(scatter  SalesPerEmpGrowth_p50 FirmType  , msymbol(o) connect(l)  ) ///
		(scatter  SalesPerEmpGrowth_p10 FirmType  , msymbol(D) connect(l)  lp(-###)  ) ///
, xtitle("Number of Shareholders") ytitle("Sales per Employee Growth  (2009-2017)")  graphregion(color(white)) xlabel(  1 "1" 2 "2" 3 ">2"  6 "Public" ) ///
	legend( order( 1 "90th percentile"  2 "50th Percentile" 3 "10th Percentile" )) 
	 graph export Output/$CountryID/FirmTypes_Growth-SalesPerEmp-Dispersion.pdf, replace  
	*/ 
restore
