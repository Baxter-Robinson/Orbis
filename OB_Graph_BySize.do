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
	
	collapse (sum) nEmployees , by(SizeCategory)

	gen SharesOfEmployment=nEmployees/`Total'
	
	graph bar SharesOfEmployment , over(SizeCategory, relabel(`Labels'))  ///
	ytitle("Share of Employment ") graphregion(color(white)) 
	 graph export Output/$CountryID/Graph_BySize_EmpShares.pdf, replace  

restore