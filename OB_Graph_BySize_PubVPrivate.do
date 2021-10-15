

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
	
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Listed==1	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Listed==0
	
	
	
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h nFirms_Public nFirms_Private (sd) EmpGrowth_sd=EmpGrowth_h, by(SizeCategory Listed)



	twoway (scatter EmpGrowth_mean SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels')  ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 *graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" ))
	*graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateStd.pdf, replace  
	
	
	
	replace nFirms_Public = round(nFirms_Public)
	replace nFirms_Private = round(nFirms_Private)
	
	
	gen public = nFirms_Public
	 replace public = 0 if public==.
	 gen private = nFirms_Private
	 replace private = 0 if private==.
	 
	 by SizeCategory: gen Totfirms = public + private
	 by SizeCategory: egen Nfirms = total(Totfirms)
	 
	 drop Totfirms public private
	 
	 gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  nFirms_Private/2  if (Listed==0) & (SizeCategory==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		gen nfirms`i' = nFirms_Private if (Listed==0) & (SizeCategory==`i')
		su nfirms`i', meanonly
		local nFirms`i' = round(r(mean))
		drop nfirms`i'
		
		sum Nfirms
		return list
		local add2top = r(min)
		gen endp`i' = Nfirms + `add2top' if (Listed==0) & (SizeCategory==`i')
		su endp`i', meanonly
		local endpoint`i' = r(mean)
		drop endp`i'
		
		gen nfirmspub`i' = nFirms_Public if (Listed==1) & (SizeCategory==`i')
		su nfirmspub`i', meanonly
		local nfirmspublic`i' = round(r(mean))
		drop nfirmspub`i'
	 }
	 
	 
	 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms_Private SizeCategory)  ///
		(rbar nFirms_Private Nfirms SizeCategory), ///
		legend(label(1 "Private") label( 2 "Public" ) ) ///
		ytitle("Number of firms") ///
		ylabel(, format(%9.0fc)) ///
		xtitle("Size category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`nFirms1'", color(white)) /// first number is y second is x.
		text(`midpoint3' 3 "`nFirms3'", color(white)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white)) /// 
		text(`endpoint1' 1 "`nfirmspublic1'", color(red)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(red)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(red)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(red)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(red)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(red)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(red)) ///
		title("Number of private and public firms per size")
		graph export Output/$CountryID/Graph_BySize_PubVPrivate_NumFirms.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms_Private SizeCategory)  ///
		(rbar nFirms_Private Nfirms SizeCategory), ///
		xlabel(`Labels') ///
		legend(label(1 "Private") label( 2 "Public" ) ) ///
		ytitle("Number of firms") ///
		ylabel(, format(%9.0fc)) ///
		xtitle("Size category") ///
		text(`midpoint1' 1 "`nFirms1'", color(white)) /// first number is y second is x.
		text(`midpoint2' 2 "`nFirms2'", color(white)) /// 
		text(`midpoint3' 3 "`nFirms3'", color(white)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white)) /// 
		text(`endpoint1' 1 "`nfirmspublic1'", color(red)) /// 
		text(`endpoint2' 2 "`nfirmspublic2'", color(red)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(red)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(red)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(red)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(red)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(red)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(red)) /// 
		title("Number of private and public firms per size") 
		graph export Output/$CountryID/Graph_BySize_PubVPrivate_NumFirms.pdf, replace  
	 }
	
	
	 
restore
