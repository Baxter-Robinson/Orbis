
/*
** By Size Relative to percentiles **

preserve

	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategory=.
	
	replace SizeCategory=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategory=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategory=8 if (nEmployees>`7')
	di ``7''
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h (sd) EmpGrowth_sd=EmpGrowth_h ///
	(p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_p50=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h, by(SizeCategory)

	gen SharesOfEmployment=nEmployees/`Total'
	
	graph bar SharesOfEmployment , over(SizeCategory, relabel(`Labels'))  ///
	ytitle("Share of Employment ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_EmpShares.pdf, replace  

	twoway (scatter EmpGrowth_mean SizeCategory, connect(l)), xlabel(`Labels')  ///
	ytitle("Average Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_p25 SizeCategory, connect(l)) ///
	 (scatter EmpGrowth_p50 SizeCategory, connect(l)) ///
	  (scatter EmpGrowth_p75 SizeCategory, connect(l)) ///
	, xlabel(`Labels')   ytitle("Percentiles") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_GrowthRatePerc.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory, connect(l)), xlabel(`Labels')  ///
	ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_GrowthRateStd.pdf, replace  
	 
restore



** By Size Categories **
preserve

	su nEmployees, detail
	local Categories 1 5 10 50 100 1000
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategory=.
	
	replace SizeCategory=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/6{
		local prior=`i'-1
		replace SizeCategory=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategory=7 if ((nEmployees>`6') & ~missing(nEmployees))
	di ``7''
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h (sd) EmpGrowth_sd=EmpGrowth_h ///
	(p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_p50=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h, by(SizeCategory)

	gen SharesOfEmployment=nEmployees/`Total'
	
	graph bar SharesOfEmployment , over(SizeCategory, relabel(`Labels'))  ///
	ytitle("Share of Employment ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategory_EmpShares.pdf, replace  

	twoway (scatter EmpGrowth_mean SizeCategory, connect(l)), xlabel(`Labels')  ///
	ytitle("Average Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategory_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_p25 SizeCategory, connect(l)) ///
	 (scatter EmpGrowth_p50 SizeCategory, connect(l)) ///
	  (scatter EmpGrowth_p75 SizeCategory, connect(l)) ///
	, xlabel(`Labels')   ytitle("Percentiles") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategory_GrowthRatePerc.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory, connect(l)), xlabel(`Labels')  ///
	ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategory_GrowthRateStd.pdf, replace  
	 
restore
*/


preserve

	/*
	Mean employment growth, std employment growth, number of firms and sales per employee
	*/
	
	
	keep IDNum Year nEmployees Sales EmpGrowth_h Private
	
	keep if nEmployees!=.
	sum nEmployees, detail
	local max= r(max)
	egen groups  = cut(nEmployees), at (1, 2, 5, 6, 10, 11, 50, 51, 100, 101, 1000, 1001, `max')

	gen SizeCategory = . 
	replace SizeCategory = 1 if groups==1
	replace SizeCategory = 2 if (groups==2) | (groups==5)
	replace SizeCategory = 3 if (groups==6) | (groups==10)
	replace SizeCategory = 4 if (groups==11) | (groups==50)
	replace SizeCategory = 5 if (groups==51) | (groups==100)
	replace SizeCategory = 6 if (groups==101) | (groups==1000)
	replace SizeCategory = 7 if (groups==1001) | (groups==`max')
	
	drop if SizeCategory==.
	
	gen Sales_Employees = Sales/nEmployees
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	
	collapse (mean)  nFirms meanEmpGrowth=EmpGrowth_h mean_Sales_Employees = Sales_Employees (sd) sdEmpGrowth=EmpGrowth_h , by(SizeCategory)
	
	
	replace nFirms = round(nFirms)
	
	
	************************* Graph 1: Mean employment growth by size category
		
	
	gen floor = 0
	gen roof = .
	 
	 forval i=1/7{
		su meanEmpGrowth if (SizeCategory==`i'), detail // midpoints for private firms
		local midpoint`i' = (r(mean)/2)
		local value`i'=round(r(mean),.01)
		
		su meanEmpGrowth if (SizeCategory==`i'), detail // midpoints for private firms
		local endpoint`i' = r(mean)
		replace roof = `endpoint`i'' if (SizeCategory==`i')
		
	 }
	
	
	label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	
	graph twoway (rbar floor meanEmpGrowth SizeCategory, color(edkblue)),  ///
		ytitle("Mean Employment Growth") ///
		ylabel(, format(%8.4gc)) ///
		xtitle("Number of Employees") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`value1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`value2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`value3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`value4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`value5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`value6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`value7'", color(white) size(small)) /// 
		graphregion(color(white))
		graph export Output/$CountryID/OB_BySizeCat_AvgEmpGrowth.pdf, replace 
	
	
	drop floor roof
	
************************* Graph 2: Sd employment growth by size category
	
	gen floor = 0
	gen roof = .
	 
	 forval i=1/7{
		su sdEmpGrowth if (SizeCategory==`i'), detail // midpoints for private firms
		local midpoint`i' = (r(mean)/2)
		local value`i'=round(r(mean),.01)
		
		su sdEmpGrowth if (SizeCategory==`i'), detail // midpoints for private firms
		local endpoint`i' = r(mean)
		replace roof = `endpoint`i'' if (SizeCategory==`i')
		
	 }
	
	*label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	
	graph twoway (rbar floor sdEmpGrowth SizeCategory, color(edkblue)),  ///
		ytitle("Standard Deviation Employment Growth") ///
		ylabel(, format(%8.4gc)) ///
		xtitle("Number of Employees") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`value1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`value2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`value3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`value4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`value5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`value6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`value7'", color(white) size(small)) /// 
		graphregion(color(white))
		graph export Output/$CountryID/OB_BySizeCat_SdEmpGrowth.pdf, replace 
	
	drop floor roof
	
************************* Graph 3: Number of firms by size category
	
	gen floor = 0
	gen roof = .
	 
	 forval i=1/7{
		su nFirms if (SizeCategory==`i'), detail // midpoints for private firms
		local midpoint`i' = (r(mean)/2)
		local value`i'=round(r(mean),.01)
		
		su nFirms if (SizeCategory==`i'), detail // midpoints for private firms
		local endpoint`i' = r(mean)
		replace roof = `endpoint`i'' if (SizeCategory==`i')
		
	 }
	
	*label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	
	graph twoway (rbar floor nFirms SizeCategory, color(edkblue)),  ///
		ytitle("Average Number of Firms") ///
		ylabel(, format(%8.4gc)) ///
		xtitle("Number of Employees") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`value1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`value2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`value3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`value4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`value5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`value6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`value7'", color(navy) size(small)) /// 
		graphregion(color(white))
		graph export Output/$CountryID/OB_BySizeCat_AvgNFirms.pdf, replace 
		
	drop floor roof
	
	************************* Graph 4: Sales per Employee by size category
	
	gen floor = 0
	gen roof = .
	 
	 forval i=1/7{
		su mean_Sales_Employees if (SizeCategory==`i'), detail // midpoints for private firms
		local midpoint`i' = (r(mean)/2)
		local value`i'=round(r(mean),.01)
		
		su mean_Sales_Employees if (SizeCategory==`i'), detail // midpoints for private firms
		local endpoint`i' = r(mean)
		replace roof = `endpoint`i'' if (SizeCategory==`i')
		
	 }
	
	*label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
	
	graph twoway (rbar floor mean_Sales_Employees SizeCategory, color(edkblue)),  ///
		ytitle("Average Sales per Employee") ///
		ylabel(, format(%8.4gc)) ///
		xtitle("Number of Employees") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`value1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`value2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`value3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`value4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`value5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`value6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`value7'", color(white) size(small)) /// 
		graphregion(color(white))
		graph export Output/$CountryID/OB_BySizeCat_AvgSalesEmployee.pdf, replace 
		
	drop floor roof

	
restore
