

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
	
	drop if nEmployees==.   //  THIS IS FOR THE STACK BAR - Lets see if it does not mess up the figures 1.1 and 1.4
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Listed==1	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Listed==0
	
	
	
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h nFirms_Public nFirms_Private (sd) EmpGrowth_sd=EmpGrowth_h (p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_median=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h, by(SizeCategory Listed)



	twoway (scatter EmpGrowth_mean SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Listed==1), connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Listed==0), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" ))
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateStd.pdf, replace  
	
	* By percentiles
	twoway (scatter EmpGrowth_p25 SizeCategory if (Listed==1), connect(l) msymbol(circle) lcolor(orange) mcolor(orange)) ///
	(scatter EmpGrowth_median SizeCategory if (Listed==1), connect(l) msymbol(diamond) lcolor(orange_red) mcolor(orange_red) ) ///
	(scatter EmpGrowth_p75 SizeCategory if (Listed==1), connect(l) msymbol(triangle) lcolor(red) mcolor(red) ) ///
	(scatter EmpGrowth_p25 SizeCategory if (Listed==0), connect(l) msymbol(circle) lcolor(emidblue) mcolor(emidblue)) ///
	(scatter EmpGrowth_median SizeCategory if (Listed==0), connect(l) msymbol(diamond) lcolor(ebblue) mcolor(ebblue) ) ///
	(scatter EmpGrowth_p75 SizeCategory if (Listed==0), connect(l) msymbol(triangle) lcolor(navy) mcolor(navy) ) ///
	, xlabel(`Labels')  xtitle("Size Category")  ytitle("Employment Growth Rate") graphregion(color(white)) ///
	legend(label(1 "Public P25") label(2 "Public P50" ) label(3 "Public P75") label(4 "Private P25") label(5 "Private P50")  label(6 "Private P75")) 
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRatePercentiles.pdf, replace  
	
	
	
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
			sum Nfirms
			return list
			local add2top = r(min)
		}
		
		gen endp`i' = Nfirms + `add2top' if (Listed==0) & (SizeCategory==`i')
		su endp`i', meanonly
		local endpoint`i' = r(max)
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
		xtitle("Size Category") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white) size(small)) /// 
		text(`endpoint1' 1 "`nfirmspublic1'", color(red) size(small)) /// Begin labels for public firms
		text(`endpoint3' 3 "`nfirmspublic3'", color(red) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(red) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(red) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(red) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(red) size(small)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(red) size(small)) ///
		 graphregion(color(white))
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
		xtitle("Size Category") ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`nFirms2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`midpoint8' 8 "`nFirms8'", color(white) size(small)) /// 
		text(`endpoint1' 1 "`nfirmspublic1'", color(red) size(small)) /// Begin labels for public firms
		text(`endpoint2' 2 "`nfirmspublic2'", color(red) size(small)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(red) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(red) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(red) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(red) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(red) size(small)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(red) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_BySize_PubVPrivate_NumFirms.pdf, replace  
	 }
	
	egen tot_nFirms_Private = total(nFirms_Private)
	egen tot_nFirms_Public = total(nFirms_Public)
	
	gen prop_nFirms_Private = nFirms_Private / tot_nFirms_Private
	gen prop_nFirms_Public = nFirms_Public / tot_nFirms_Public
	
	sort prop_nFirms_Private
	generate order_private = _n if Listed==0
	
	sort prop_nFirms_Public
	generate order_public = _n if Listed==1
	
	
	sort SizeCategory 
	
	twoway (scatter EmpGrowth_mean SizeCategory if (Listed==1) [w=order_public] , connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Listed==0) [w=order_private], connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateAvg_Weighted.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Listed==1) [w=order_public] , connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Listed==0) [w=order_private], connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" ))
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateStd_Weighted.pdf, replace 
	
	
	
	 
restore
