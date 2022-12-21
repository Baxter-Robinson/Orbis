

** By Size Relative to percentiles **

preserve
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=8 if (nEmployees>`7')
	di ``7''
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h (sd) EmpGrowth_sd=EmpGrowth_h ///
	(p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_p50=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h, by(SizeCategoryPerc)

	gen SharesOfEmployment=nEmployees/`Total'
	
	graph bar SharesOfEmployment , over(SizeCategoryPerc, relabel(`Labels'))  ///
	ytitle("Share of Employment ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_EmpShares.pdf, replace  

	twoway (scatter EmpGrowth_mean SizeCategoryPerc, connect(l)), xlabel(`Labels')  ///
	ytitle("Average Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_p25 SizeCategoryPerc, connect(l)) ///
	 (scatter EmpGrowth_p50 SizeCategoryPerc, connect(l)) ///
	  (scatter EmpGrowth_p75 SizeCategoryPerc, connect(l)) ///
	, xlabel(`Labels')   ytitle("Percentiles") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_GrowthRatePerc.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategoryPerc, connect(l)), xlabel(`Labels')  ///
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
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/6{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=7 if ((nEmployees>`6') & ~missing(nEmployees))
	di ``7''
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h (sd) EmpGrowth_sd=EmpGrowth_h ///
	(p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_p50=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h, by(SizeCategoryPerc)

	gen SharesOfEmployment=nEmployees/`Total'
	
	graph bar SharesOfEmployment , over(SizeCategoryPerc, relabel(`Labels'))  ///
	ytitle("Share of Employment ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategoryPerc_EmpShares.pdf, replace  

	twoway (scatter EmpGrowth_mean SizeCategoryPerc, connect(l)), xlabel(`Labels')  ///
	ytitle("Average Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategoryPerc_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_p25 SizeCategoryPerc, connect(l)) ///
	 (scatter EmpGrowth_p50 SizeCategoryPerc, connect(l)) ///
	  (scatter EmpGrowth_p75 SizeCategoryPerc, connect(l)) ///
	, xlabel(`Labels')   ytitle("Percentiles") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategoryPerc_GrowthRatePerc.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategoryPerc, connect(l)), xlabel(`Labels')  ///
	ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySizeCategoryPerc_GrowthRateStd.pdf, replace  
	 
restore



preserve

    /*
    Mean employment growth, std employment growth, number of firms and sales per employee
    */
    
    
    keep IDNum Year nEmployees Sales EmpGrowth_h Public SizeCategoryAR
    
    keep if nEmployees!=.
    
    drop if SizeCategoryAR==.
    
    gen Sales_Employees = Sales/nEmployees
    
    *Total Firms
    bysort SizeCategoryAR Year : egen nFirms = count(IDNum) 
    
    collapse (mean)  nFirms meanEmpGrowth=EmpGrowth_h mean_Sales_Employees = Sales_Employees (sd) sdEmpGrowth=EmpGrowth_h , by(SizeCategoryAR)
    
    
    replace nFirms = round(nFirms)
    
    
    ************************* Graph 1: Mean employment growth by size category
        
    
    gen floor = 0
    gen roof = .
     
     forval i=1/7{
        su meanEmpGrowth if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local midpoint`i' = (r(mean)/2)
        local value`i'=round(r(mean),.01)
        
        su meanEmpGrowth if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local endpoint`i' = r(mean)
        replace roof = `endpoint`i'' if (SizeCategoryAR==`i')
        
     }
    
    
    label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    
    graph twoway (rbar floor meanEmpGrowth SizeCategoryAR, color(edkblue)),  ///
        ytitle("Average Employment Growth") ///
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
        su sdEmpGrowth if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local midpoint`i' = (r(mean)/2)
        local value`i'=round(r(mean),.01)
        
        su sdEmpGrowth if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local endpoint`i' = r(mean)
        replace roof = `endpoint`i'' if (SizeCategoryAR==`i')
        
     }
    
    *label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    
    graph twoway (rbar floor sdEmpGrowth SizeCategoryAR, color(edkblue)),  ///
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
        su nFirms if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local midpoint`i' = (r(mean)/2)
        local value`i'=round(r(mean),.01)
        
        su nFirms if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local endpoint`i' = r(mean)
        replace roof = `endpoint`i'' if (SizeCategoryAR==`i')
        
     }
    
    *label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    
    graph twoway (rbar floor nFirms SizeCategoryAR, color(edkblue)),  ///
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
        su mean_Sales_Employees if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local midpoint`i' = (r(mean)/2)
        local value`i'=round(r(mean),.01)
        
        su mean_Sales_Employees if (SizeCategoryAR==`i'), detail // midpoints for private firms
        local endpoint`i' = r(mean)
        replace roof = `endpoint`i'' if (SizeCategoryAR==`i')
        
     }
    
    *label define SizeCat 1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+"
    
    graph twoway (rbar floor mean_Sales_Employees SizeCategoryAR, color(edkblue)),  ///
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





	preserve
	* Average Employment Growth
	keep IDNum Year nEmployees Sales EmpGrowth_h Public
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=8 if (nEmployees>`7')
	di ``7''
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategoryPerc Year : egen nFirms = count(IDNum) 	
	gen Sales_Employees = Sales/nEmployees
	
	collapse (sum) nEmployees (mean) Sales_Employees EmpGrowth_mean=EmpGrowth_h nFirms (sd) EmpGrowth_sd=EmpGrowth_h , by(SizeCategoryPerc)

		 
	gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  EmpGrowth_mean/2  if  (SizeCategoryPerc==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		su EmpGrowth_mean if  (SizeCategoryPerc==`i'), detail
		local EmpGrowth_mean`i' = round(r(mean),.01)

	
		if ("${CountryID}" == "ES") | ("${CountryID}" == "DE")  {
			local add2top = 2000
		}
		else if "${CountryID}" == "PT" {
			local add2top = 2000
		}
		else if "${CountryID}" == "NL" {
			local add2top = 50
		}
		else {
			sum EmpGrowth_mean
			return list
			local add2top = r(min)
		}
		
		
	 }
		 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor EmpGrowth_mean SizeCategoryPerc, color(maroon)),  ///
		ytitle("Average Employment Growth") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`EmpGrowth_mean1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint3' 3 "`EmpGrowth_mean3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`EmpGrowth_mean4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`EmpGrowth_mean5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`EmpGrowth_mean6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`EmpGrowth_mean7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`EmpGrowth_mean8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_AvgEmpGrowth.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor EmpGrowth_mean SizeCategoryPerc, color(maroon)),  ///
		xlabel(`Labels') ///
		ytitle("Average Employment Growth") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`EmpGrowth_mean1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`EmpGrowth_mean2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`EmpGrowth_mean3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`EmpGrowth_mean4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`EmpGrowth_mean5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`EmpGrowth_mean6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`EmpGrowth_mean7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`EmpGrowth_mean8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_AvgEmpGrowth.pdf, replace  
	 }
	 
	restore
	 

	 
	preserve
	* Standard Deviation Employment Growth
	keep IDNum Year nEmployees Sales EmpGrowth_h Public
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=8 if (nEmployees>`7')
	di ``7''
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategoryPerc Year : egen nFirms = count(IDNum) 	
	gen Sales_Employees = Sales/nEmployees
	
	collapse (sum) nEmployees (mean) Sales_Employees EmpGrowth_mean=EmpGrowth_h nFirms (sd) EmpGrowth_sd=EmpGrowth_h , by(SizeCategoryPerc)

		 
	gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  EmpGrowth_sd/2  if  (SizeCategoryPerc==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		su EmpGrowth_sd if  (SizeCategoryPerc==`i'), detail
		local EmpGrowth_sd`i' = r(mean)

	
		if ("${CountryID}" == "ES") | ("${CountryID}" == "DE")  {
			local add2top = 2000
		}
		else if "${CountryID}" == "PT" {
			local add2top = 2000
		}
		else if "${CountryID}" == "NL" {
			local add2top = 50
		}
		else {
			sum EmpGrowth_sd
			return list
			local add2top = r(min)
		}
		
		
	 }
		 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor EmpGrowth_sd SizeCategoryPerc, color(maroon)),  ///
		ytitle("Standard Deviation Employment Growth") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`EmpGrowth_sd1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint3' 3 "`EmpGrowth_sd3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`EmpGrowth_sd4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`EmpGrowth_sd5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`EmpGrowth_sd6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`EmpGrowth_sd7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`EmpGrowth_sd8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_SDEmpGrowth.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor EmpGrowth_sd SizeCategoryPerc, color(maroon)),  ///
		xlabel(`Labels') ///
		ytitle("Standard Deviation Employment Growth") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`EmpGrowth_sd1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`EmpGrowth_sd2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`EmpGrowth_sd3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`EmpGrowth_sd4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`EmpGrowth_sd5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`EmpGrowth_sd6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`EmpGrowth_sd7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`EmpGrowth_sd8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_SDEmpGrowth.pdf, replace  
	 }
	 
	restore


	
	preserve
	* Average Sales per Employee
	keep IDNum Year nEmployees Sales EmpGrowth_h Public
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=8 if (nEmployees>`7')
	di ``7''
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategoryPerc Year : egen nFirms = count(IDNum) 	
	replace Sales = Sales/1000
	gen Sales_Employees = Sales/nEmployees
	
	collapse (sum) nEmployees (mean) Sales_Employees EmpGrowth_mean=EmpGrowth_h nFirms (sd) EmpGrowth_sd=EmpGrowth_h , by(SizeCategoryPerc)

		 
	gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  Sales_Employees/2  if  (SizeCategoryPerc==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		su Sales_Employees if  (SizeCategoryPerc==`i'), detail
		local Sales_Employees`i' = r(mean)

	
		if ("${CountryID}" == "ES") | ("${CountryID}" == "DE")  {
			local add2top = 2000
		}
		else if "${CountryID}" == "PT" {
			local add2top = 2000
		}
		else if "${CountryID}" == "NL" {
			local add2top = 50
		}
		else {
			sum Sales_Employees
			return list
			local add2top = r(min)
		}
		
		
	 }
			 
	 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor Sales_Employees SizeCategoryPerc, color(maroon)),  ///
		ytitle("Average Sales per Employee") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`Sales_Employees1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint3' 3 "`Sales_Employees3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`Sales_Employees4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`Sales_Employees5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`Sales_Employees6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`Sales_Employees7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`Sales_Employees8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_AvgSalesEmployee.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor Sales_Employees SizeCategoryPerc, color(maroon)),  ///
		xlabel(`Labels') ///
		ytitle("Average Sales per Employee") ///
		ylabel(, format(%9.4fc)) ///
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`Sales_Employees1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`Sales_Employees2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`Sales_Employees3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`Sales_Employees4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`Sales_Employees5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`Sales_Employees6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`Sales_Employees7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`Sales_Employees8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_AvgSalesEmployee.pdf, replace  
	 }
	 
	restore
	
	
	
	preserve
	keep IDNum Year nEmployees Sales EmpGrowth_h Public
	* Number of firms
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	gen SizeCategoryPerc=.
	
	replace SizeCategoryPerc=1  if (nEmployees<=`1')
	
		di ``1''
	forval i=2/7{
		local prior=`i'-1
		replace SizeCategoryPerc=`i' if (nEmployees<=``i'') & (nEmployees>``prior'')
			di ``i'', ``prior''
	}
	
	replace SizeCategoryPerc=8 if (nEmployees>`7')
	di ``7''
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategoryPerc Year : egen nFirms = count(IDNum) 	
	gen Sales_Employees = Sales/nEmployees
	
	collapse (sum) nEmployees (mean) Sales_Employees EmpGrowth_mean=EmpGrowth_h nFirms (sd) EmpGrowth_sd=EmpGrowth_h , by(SizeCategoryPerc)

		 
	gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  nFirms/2  if  (SizeCategoryPerc==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		su nFirms if  (SizeCategoryPerc==`i'), detail
		local nFirms`i' = r(mean)

	
		if ("${CountryID}" == "ES") | ("${CountryID}" == "DE")  {
			local add2top = 2000
		}
		else if "${CountryID}" == "PT" {
			local add2top = 2000
		}
		else if "${CountryID}" == "NL" {
			local add2top = 50
		}
		else {
			sum nFirms
			return list
			local add2top = r(min)
		}
		
		gen endp`i' = nFirms + `add2top' if  (SizeCategoryPerc==`i')
		su endp`i', meanonly
		local endpoint`i' = r(max)
		drop endp`i'
		
	 }
	 
	 /*
        local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms SizeCategoryPerc, color(maroon)),  ///
		xlabel(`Labels') ///
		ytitle("Number of firms") ///
		ylabel(, format(%9.0fc)) ///
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`nFirms2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white) size(small)) /// 
		 graphregion(color(white))
		 */
		 
	 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms SizeCategoryPerc, color(maroon)),  ///
		ytitle("Number of firms") ///
		ylabel(, format(%9.0fc)) ///
		xtitle("Size Category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_NumFirms.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms SizeCategoryPerc, color(maroon)),  ///
		xlabel(`Labels') ///
		ytitle("Number of firms") ///
		ylabel(, format(%9.0fc)) ///
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`nFirms2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_ByPercentiles_NumFirms.pdf, replace  
	 }
	 
	 restore
	 
	 




















