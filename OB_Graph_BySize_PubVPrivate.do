

*********************************** Connected scatter plots By Size Relative to Percentiles
preserve

	drop SizeCategory
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	replace Sales = Sales/1000000
	gen SalesEmployee = Sales/nEmployees
	
	
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
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Private==0 	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Private==1
	
	
	
	collapse (sum) nEmployees (mean) nFirms_Public_mean = nFirms_Public nFirms_Private_mean = nFirms_Private SalesEmployee_mean =SalesEmployee EmpGrowth_mean=EmpGrowth_h nFirms_Public nFirms_Private (sd) SalesEmployee_sd=SalesEmployee EmpGrowth_sd=EmpGrowth_h (p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_median=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h (p90) EmpGrowth_p90=EmpGrowth_h (p95) EmpGrowth_p95=EmpGrowth_h (p99) EmpGrowth_p99=EmpGrowth_h, by(SizeCategory Private)

	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
	twoway (scatter EmpGrowth_mean SizeCategory if (Private==0), connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Private==1), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateAvg.pdf, replace  
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Private==0), connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Private==1), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" ))
	graph export Output/$CountryID/Graph_BySize_PubVPrivate_GrowthRateStd.pdf, replace  
	
	 
	  twoway (scatter nFirms_Public_mean SizeCategory if (Private==0), connect(l) yaxis(2)) ///
	(scatter nFirms_Private_mean SizeCategory if (Private==1), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Number of Private Firms") ytitle("Number of Public Firms ", axis(2)) graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySize_PubVPrivate_nFirms.pdf, replace  
	 
	 twoway (scatter SalesEmployee_mean SizeCategory if (Private==0), connect(l) ) ///
	(scatter SalesEmployee_mean SizeCategory if (Private==1), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Sales per Employee in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySize_PubVPrivate_SalesEmployeeAvg.pdf, replace  
	 
restore



*********************************** Stacked Bars By Size Relative to Percentiles

preserve

	drop SizeCategory
	
	su nEmployees, detail
	local Categories `r(p10)' `r(p25)' `r(p50)' `r(p75)' `r(p90)' `r(p95)' `r(p99)'
	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"

	tokenize `Categories'
	local Total=r(sum)
	local TotalNFirms=r(N)
	
	replace Sales = Sales/1000000
	gen SalesEmployee = Sales/nEmployees
	
	
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
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Private==0 	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Private==1
	
	
	
	collapse (sum) nEmployees (mean) SalesEmployee_mean =SalesEmployee EmpGrowth_mean=EmpGrowth_h nFirms_Public nFirms_Private (sd) SalesEmployee_sd=SalesEmployee EmpGrowth_sd=EmpGrowth_h, by(SizeCategory Private)	
	
	
	replace nFirms_Public = round(nFirms_Public)
	replace nFirms_Private = round(nFirms_Private)
	
	
	 gen public_firms = nFirms_Public
	 replace public_firms = 0 if public_firms==. 
	 gen private_firms = nFirms_Private
	 replace private_firms = 0 if private_firms==.
	 
	 by SizeCategory: gen Totfirms = public_firms + private_firms
	 by SizeCategory: egen Nfirms = total(Totfirms)
	 
	 drop Totfirms public_firms private_firms
	 
	 gen floor = 0
	 
	 forval i=1/8{
	 	gen mid`i'=  nFirms_Private/2  if (Private==1) & (SizeCategory==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		gen nfirms`i' = nFirms_Private if (Private==1) & (SizeCategory==`i')
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
		
		gen endp`i' = Nfirms + `add2top' if (Private==1) & (SizeCategory==`i')
		su endp`i', meanonly
		local endpoint`i' = r(max)
		drop endp`i'
		
		gen nfirmspub`i' = nFirms_Public if (Private==0) & (SizeCategory==`i')
		su nfirmspub`i', meanonly
		local nfirmspublic`i' = round(r(mean))
		drop nfirmspub`i'
	 }
	 
	 
	 
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms_Private SizeCategory, color(maroon))  ///
		(rbar nFirms_Private Nfirms SizeCategory, color(navy)), ///
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
		text(`endpoint1' 1 "`nfirmspublic1'", color(navy) size(small)) /// Begin labels for public firms
		text(`endpoint3' 3 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(navy) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(navy) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(navy) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(navy) size(small)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(navy) size(small)) ///
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_BySize_PubVPrivate_NumFirms.pdf, replace  
	 }
	else {
	 	local Labels  1 "0-10%" 2 "10-25%"  3 "25-50%" 4 "50-75%" 5 "75-90%" 6 "90-95%" 7 "95-99%" 8 "Top 1%"
		graph twoway (rbar floor nFirms_Private SizeCategory, color(maroon))  ///
		(rbar nFirms_Private Nfirms SizeCategory, color(navy)), ///
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
		text(`endpoint1' 1 "`nfirmspublic1'", color(navy) size(small)) /// Begin labels for public firms
		text(`endpoint2' 2 "`nfirmspublic2'", color(navy) size(small)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(navy) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(navy) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(navy) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(navy) size(small)) /// 
		text(`endpoint8' 8 "`nfirmspublic8'", color(navy) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_BySize_PubVPrivate_NumFirms.pdf, replace  
	 }
	
	
	egen totFirms = total(Nfirms)
	replace totFirms = totFirms/2
	
	gen prop_firms = .
	
	replace prop_firms =  nFirms_Private / totFirms if nFirms_Private!=.
	replace prop_firms =  nFirms_Public / totFirms if nFirms_Public!=.
	
	sort SizeCategory 
	
	drop totFirms 	

	 
restore

*********************************** Connected scatter plots By Size Category


preserve

	su nEmployees, detail
	local Categories 1 5 10 50 100 1000
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 

	local Total=r(sum)
	local TotalNFirms=r(N)
	
	drop if SizeCategory==.
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Private==0 	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Private==1
	
	replace Sales = Sales/1000000
	gen SalesEmployee = Sales/nEmployees
	
	replace GrossProfits = GrossProfits/1000000
	gen GrossProfitsEmployee = GrossProfits/nEmployees
	
	replace Assets = Assets/1000000
	
	replace Revenue = Revenue/1000000
	replace EBITDA = EBITDA/1000000
	
	gen RevtoAssets = Revenue/Assets
	gen EBITDAtoAssets = EBITDA/Assets
	gen GrossProfitstoAssets = GrossProfits/Assets
	
	
	collapse (sum) nEmployees (mean)nFirms_Public_mean = nFirms_Public nFirms_Private_mean = nFirms_Private SalesEmployee_mean = SalesEmployee  EmpGrowth_mean=EmpGrowth_h GrossProfitsEmployee_mean = GrossProfitsEmployee Assets_mean = Assets RevtoAssets_mean = RevtoAssets EBITDAtoAssets_mean = EBITDAtoAssets  GrossProfitstoAssets_mean = GrossProfitstoAssets	(sd) EmpGrowth_sd=EmpGrowth_h Assets_sd = Assets, by(SizeCategory Private)

	local MinSize=10 
	
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 
	twoway (scatter EmpGrowth_mean SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter EmpGrowth_mean SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Employment Growth Rate ") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" )) yscale(range(-0.6(0.2)0.6)) ylabel(-0.6(0.2)0.6)
	graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_GrowthRateAvg.pdf, replace  
	 
	 
	 
	twoway (scatter EmpGrowth_sd SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter EmpGrowth_sd SizeCategory if (Private==1)  & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Standard Deviation of Employment Growth Rate ") graphregion(color(white))  ///
	legend(label(1 "Public") label( 2 "Private" )) yscale(range(0.2(0.2)1.0)) ylabel(0.2(0.2)1.0)
	graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_GrowthRateStd.pdf, replace  
	
	 
	 
	  twoway (scatter nFirms_Public_mean SizeCategory if (Private==0), connect(l) yaxis(2)) ///
	(scatter nFirms_Private_mean SizeCategory if (Private==1), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Number of Private Firms ")  ytitle("Number of Public Firms", axis(2)) graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_nFirms.pdf, replace  
	 
	 twoway (scatter SalesEmployee_mean SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter SalesEmployee_mean SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Sales per Employee in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_SalesEmployeeAvg.pdf, replace  
	 
	 
	 	 twoway (scatter GrossProfitsEmployee_mean SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter GrossProfitsEmployee_mean SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Profits per Employee in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_ProfitsEmployeeAvg.pdf, replace  
	 	 	 twoway (scatter Assets_mean SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter Assets_mean SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Assets in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_AssetsAvg.pdf, replace  

	 
	 	 	 twoway (scatter Assets_sd SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter Assets_sd SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Std. Dev. Assets in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_AssetsSD.pdf, replace  
	 
	 
	 twoway (scatter RevtoAssets SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter RevtoAssets SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Revenue to Assets in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_RevenuetoAssetsAvg.pdf, replace  
	 
	 twoway (scatter EBITDAtoAssets SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter EBITDAtoAssets SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average EBITDA to Assets in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_EBITDAtoAssetsAvg.pdf, replace  
	 
	 twoway (scatter GrossProfitstoAssets_mean SizeCategory if (Private==0) & (nFirms_Public>`MinSize'), connect(l)) ///
	(scatter GrossProfitstoAssets_mean SizeCategory if (Private==1) & (nFirms_Private>`MinSize'), connect(l) msymbol(Sh)) ///
	, xlabel(`Labels') xtitle("Size Category") ytitle("Average Profits to Assets in Millions") graphregion(color(white)) ///
	legend(label(1 "Public") label( 2 "Private" ))
	 graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_ProfitstoAssetsAvg.pdf, replace  
	 
restore



*********************************** Stacked Bars By Size Category

preserve

	su nEmployees, detail
	local Categories 1 5 10 50 100 1000
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 


	local Total=r(sum)
	local TotalNFirms=r(N)
	
	
	drop if nEmployees==.   
	
	*Total Firms
	bysort SizeCategory Year : egen nFirms = count(IDNum) 
	* Public number of firms by 
	bysort SizeCategory Year : egen nFirms_Public = count(IDNum) if Private==0 	
	* Private number of firms by 
	bysort SizeCategory Year: egen nFirms_Private = count(IDNum) if Private==1
	
	
	
	collapse (sum) nEmployees (mean) EmpGrowth_mean=EmpGrowth_h nFirms_Public nFirms_Private (sd) EmpGrowth_sd=EmpGrowth_h (p25) EmpGrowth_p25=EmpGrowth_h (p50) EmpGrowth_median=EmpGrowth_h (p75) EmpGrowth_p75=EmpGrowth_h (p90) EmpGrowth_p90=EmpGrowth_h (p95) EmpGrowth_p95=EmpGrowth_h (p99) EmpGrowth_p99=EmpGrowth_h, by(SizeCategory Private)
	
	
	replace nFirms_Public = round(nFirms_Public)
	replace nFirms_Private = round(nFirms_Private)
	
	
	 gen public_firms = nFirms_Public
	 replace public_firms = 0 if public_firms==. 
	 gen private_firms = nFirms_Private
	 replace private_firms = 0 if private_firms==.
	 
	 by SizeCategory: gen Totfirms = public_firms + private_firms
	 by SizeCategory: egen Nfirms = total(Totfirms)
	 
	 drop Totfirms public_firms private_firms
	 
	 gen floor = 0
	 
	 forval i=1/7{
	 	gen mid`i'=  nFirms_Private/2  if (Private==1) & (SizeCategory==`i')
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		gen nfirms`i' = nFirms_Private if (Private==1) & (SizeCategory==`i')
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
		
		gen endp`i' = Nfirms + `add2top' if (Private==1) & (SizeCategory==`i')
		su endp`i', meanonly
		local endpoint`i' = r(max)
		drop endp`i'
		
		gen nfirmspub`i' = nFirms_Public if (Private==0) & (SizeCategory==`i')
		su nfirmspub`i', meanonly
		local nfirmspublic`i' = round(r(mean))
		drop nfirmspub`i'
	 }
	 
	sum Nfirms if SizeCategory==2, detail
	
	 * Currently, only exception is Portugal. Possibly need to modify when more countries are added 
	 * This is needed for the correct labeling in the graph -> 
	 if "${CountryID}" == "PT" {   /// This distinction is done because, surprisingly, Portugal does not have firms in the size bin 2 
		graph twoway (rbar floor nFirms_Private SizeCategory, color(maroon))  ///
		(rbar nFirms_Private Nfirms SizeCategory, color(navy)), ///
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
		text(`endpoint1' 1 "`nfirmspublic1'", color(navy) size(small)) /// Begin labels for public firms
		text(`endpoint3' 3 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(navy) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(navy) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(navy) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(navy) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_NumFirms.pdf, replace  
	 }
	else {
		graph twoway (rbar floor nFirms_Private SizeCategory, color(maroon))  ///
		(rbar nFirms_Private Nfirms SizeCategory, color(navy)), ///
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
		text(`endpoint1' 1 "`nfirmspublic1'", color(navy) size(small)) /// Begin labels for public firms
		text(`endpoint2' 2 "`nfirmspublic2'", color(navy) size(small)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(navy) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(navy) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(navy) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(navy) size(small)) /// 
		 graphregion(color(white))
		graph export Output/$CountryID/Graph_BySizeCategory_PubVPrivate_NumFirms.pdf, replace  
	 }
	
	 
restore
