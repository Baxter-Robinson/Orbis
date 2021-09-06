
preserve

	drop if (nEmployees==1)
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
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h (sd) EmpGrowth_sd=EmpGrowth_h , by(SizeCategory Listed)


	twoway (scatter EmpGrowth_mean SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels')  ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" ))
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateStd.pdf, replace  
	 
restore