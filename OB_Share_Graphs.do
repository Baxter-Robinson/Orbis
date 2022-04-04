


preserve

	/*
	 Share of Firms Graph
	   - X-axis Categories of employment (1, 2-10, 11-99, 100-999, 1000+)
	   - y-axis Stacked bar chart: share of firms that are public vs. private - sum of all bars should add up to 1
	*/
	keep IDNum Year nEmployees Private SizeCategory
		
	keep if nEmployees!=.
	sum nEmployees, detail
	local max= r(max)
	
	drop if SizeCategory==.
	
	bysort SizeCategory Year : egen nFirmsCatPrivate = count(IDNum) if Private==1
	bysort SizeCategory Year : egen nFirmsCatPublic = count(IDNum) if Private==0
	
	collapse (mean)  nFirmsCatPublic nFirmsCatPrivate, by(SizeCategory Private)
	
	replace nFirmsCatPublic = round(nFirmsCatPublic)
	replace nFirmsCatPrivate = round(nFirmsCatPrivate)
	
	
	gen public_firms = nFirmsCatPublic
	replace public_firms = 0 if public_firms==. 
	gen private_firms = nFirmsCatPrivate
	replace private_firms = 0 if private_firms==.
	
	
	
	gen TotFirms = .
	levelsof SizeCategory, local(categories)
	foreach x of local categories{
		sum nFirmsCatPublic if SizeCategory==`x', detail
		local pubf = r(mean)
		sum nFirmsCatPrivate if SizeCategory==`x', detail
		local privf = r(mean)
		replace TotFirms = `pubf'+`privf' if SizeCategory==`x'
	}
	
	bysort Private: egen nFirms = total(TotFirms)
	
	sort Private SizeCategory
	
	gen pct_nFirmsCatPrivate = 100*nFirmsCatPrivate/nFirms
	gen pct_nFirmsCatPublic = 100*nFirmsCatPublic/nFirms
	drop TotFirms
	
	gen floor = 0
	gen roof = .
	 
	 forval i=1/7{
	 	gen mid`i'=  pct_nFirmsCatPrivate/2  if (Private==1) & (SizeCategory==`i') // midpoints for private firms
		su mid`i', meanonly
		local midpoint`i' = r(mean)
		drop mid`i'
		
		gen nfirms`i' = pct_nFirmsCatPrivate if (Private==1) & (SizeCategory==`i') // values for private firms labels
		su nfirms`i', meanonly
		local nFirms`i' = round(r(mean))
		drop nfirms`i'		
		
		gen nfirmspub`i' = pct_nFirmsCatPublic if (Private==0) & (SizeCategory==`i')
		su nfirmspub`i', meanonly
		local nfirmspublic`i' = round(r(mean))
		drop nfirmspub`i'
		
		local endpoint`i' = `nFirms`i''+`nfirmspublic`i'' + 2.5
		replace roof = `nFirms`i''+`nfirmspublic`i'' if (SizeCategory==`i')
		
	 }
	
	
	label define SizeCat  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 
	local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 
	
	graph twoway (rbar floor pct_nFirmsCatPrivate SizeCategory, color(maroon))  ///
		(rbar pct_nFirmsCatPrivate roof SizeCategory, color(navy)), ///
		legend(label(1 "Private") label( 2 "Public" ) ) ///
		ytitle("Percentage of firms") ///
		ylabel(, format(%3.0fc)) ///
		xtitle("Number of Employees") ///
		xlabel(`Labels') ///
		text(`midpoint1' 1 "`nFirms1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
		text(`midpoint2' 2 "`nFirms2'", color(white) size(small)) /// 
		text(`midpoint3' 3 "`nFirms3'", color(white) size(small)) /// 
		text(`midpoint4' 4 "`nFirms4'", color(white) size(small)) /// 
		text(`midpoint5' 5 "`nFirms5'", color(white) size(small)) /// 
		text(`midpoint6' 6 "`nFirms6'", color(white) size(small)) /// 
		text(`midpoint7' 7 "`nFirms7'", color(white) size(small)) /// 
		text(`endpoint1' 1 "`nfirmspublic1'", color(navy) size(small)) /// Begin labels for public firms
		text(`endpoint2' 2 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint3' 3 "`nfirmspublic3'", color(navy) size(small)) /// 
		text(`endpoint4' 4 "`nfirmspublic4'", color(navy) size(small)) /// 
		text(`endpoint5' 5 "`nfirmspublic5'", color(navy) size(small)) /// 
		text(`endpoint6' 6 "`nfirmspublic6'", color(navy) size(small)) /// 
		text(`endpoint7' 7 "`nfirmspublic7'", color(navy) size(small)) /// 
		graphregion(color(white))
		graph export Output/$CountryID/OB_BySizeCat_ShareFirms.pdf, replace 
		
	
restore
	
	
	
	
	************************************************************************************************************
	************************************************************************************************************
	************************************************************************************************************

	
	
	preserve

		/*
		 Share of employment graph
			- X-axis Categories of employment (1, 2-10, 11-99, 100-999, 1000+)
			- y-axis Stacked bar chart: share of employees that are employed by public vs. private firms - sum of all bars should add up to 1
		*/
		
		keep IDNum Year nEmployees Private SizeCategory
			
		keep if nEmployees!=.
		
		drop if SizeCategory==.
		
		bysort SizeCategory Year : egen nEmpCatPrivate = total(nEmployees) if Private==1
		bysort SizeCategory Year : egen nEmpCatPublic = total(nEmployees) if Private==0
		
		collapse (mean) nEmpCatPublic nEmpCatPrivate, by(SizeCategory Private)
		
		replace nEmpCatPublic = round(nEmpCatPublic)
		replace nEmpCatPrivate = round(nEmpCatPrivate)
		
		gen public_firms = nEmpCatPublic
		replace public_firms = 0 if public_firms==. 
		gen private_firms = nEmpCatPrivate
		replace private_firms = 0 if private_firms==.
				
		gen TotEmp = .
		
		levelsof SizeCategory, local(categories)		
		foreach x of local categories{
			sum nEmpCatPublic if SizeCategory==`x', detail
			local pubf = r(mean)
			sum nEmpCatPrivate if SizeCategory==`x', detail
			local privf = r(mean)
			replace TotEmp = `pubf'+`privf' if SizeCategory==`x'
		}
		bysort Private: egen nEmp = total(TotEmp)	
		
		gen pct_nEmpCatPrivate = 100*nEmpCatPrivate/nEmp
		gen pct_nEmpCatPublic = 100*nEmpCatPublic/nEmp
		
		
		gen floor = 0
		gen roof = .
		 
		 forval i=1/7{
			gen mid`i'=  pct_nEmpCatPrivate/2  if (Private==1) & (SizeCategory==`i') // midpoints for private firms
			su mid`i', meanonly
			local midpoint`i' = r(mean)
			drop mid`i'
			
			gen nEmp`i' = pct_nEmpCatPrivate if (Private==1) & (SizeCategory==`i') // values for private firms labels
			su nEmp`i', meanonly
			local nEmp`i' = round(r(mean))
			drop nEmp`i'
			

			gen nEmppub`i' = pct_nEmpCatPublic if (Private==0) & (SizeCategory==`i')
			su nEmppub`i', meanonly
			local nEmppublic`i' = round(r(mean))
			drop nEmppub`i'
			
			local endpoint`i' = `nEmp`i''+`nEmppublic`i'' + 2.5
			replace roof = `nEmp`i''+`nEmppublic`i'' if (SizeCategory==`i')
			
		 }		
		sum roof if SizeCategory==7,detail
		local endp7roof1 = r(mean)
		sum pct_nEmpCatPrivate if SizeCategory==7,detail
		local endp7roof2 = r(mean)
		local endpoint7 = (`endp7roof1'+`endp7roof2')/2
		
		label define SizeCat  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 
		local Labels  1 "1" 2 "2-5"  3 "6-10" 4 "11-50" 5 "51-100" 6 "101-1,000" 7 "1,000+" 
		
		graph twoway (rbar floor pct_nEmpCatPrivate SizeCategory, color(maroon))  ///
			(rbar pct_nEmpCatPrivate roof SizeCategory, color(navy)), ///
			legend(label(1 "Private") label( 2 "Public" ) ) ///
			ytitle("Percentage of Employment") ///
			ylabel(, format(%3.0fc)) ///
			xtitle("Number of Employees") ///
			xlabel(`Labels') ///
			text(`midpoint1' 1 "`nEmp1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
			text(`midpoint2' 2 "`nEmp2'", color(white) size(small)) /// 
			text(`midpoint3' 3 "`nEmp3'", color(white) size(small)) /// 
			text(`midpoint4' 4 "`nEmp4'", color(white) size(small)) /// 
			text(`midpoint5' 5 "`nEmp5'", color(white) size(small)) /// 
			text(`midpoint6' 6 "`nEmp6'", color(white) size(small)) /// 
			text(`midpoint7' 7 "`nEmp7'", color(white) size(small)) /// 
			text(`endpoint1' 1 "`nEmppublic1'", color(navy) size(small)) /// Begin labels for public firms
			text(`endpoint2' 2 "`nEmppublic3'", color(navy) size(small)) /// 
			text(`endpoint3' 3 "`nEmppublic3'", color(navy) size(small)) /// 
			text(`endpoint4' 4 "`nEmppublic4'", color(navy) size(small)) /// 
			text(`endpoint5' 5 "`nEmppublic5'", color(white) size(small)) /// 
			text(`endpoint6' 6 "`nEmppublic6'", color(white) size(small)) /// 
			text(`endpoint7' 7 "`nEmppublic7'", color(white) size(small)) /// 
			graphregion(color(white))
			graph export Output/$CountryID/OB_BySizeCat_ShareEmployment.pdf, replace 
	restore
	
	
	
	************************************************************************************************************
	************************************************************************************************************
	************************************************************************************************************
	
	
	
	preserve
		
		/*
		- Share of employment graph by age
			- X-axis is age of firm (0,1,2,... 15+)
			- y-axis Stacked bar chart: share of employees that are employed by public vs. private firms - sum of all bars should add up to 1
	*/
	
		keep IDNum Year nEmployees Private Age
			
		keep if nEmployees!=.
		sum Age, detail
		local max= r(max)
		cap drop groups
		egen groups  = cut(Age), at (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, `max')

		gen AgeCategory = . 
		replace AgeCategory = 1 if groups==1
		replace AgeCategory = 2 if groups==2
		replace AgeCategory = 3 if groups==3
		replace AgeCategory = 4 if groups==4
		replace AgeCategory = 5 if groups==5
		replace AgeCategory = 6 if groups==6
		replace AgeCategory = 7 if groups==7
		replace AgeCategory = 8 if groups==8
		replace AgeCategory = 9 if groups==9
		replace AgeCategory = 10 if groups==10
		replace AgeCategory = 11 if groups==11
		replace AgeCategory = 12 if groups==12
		replace AgeCategory = 13 if groups==13
		replace AgeCategory = 14 if groups==14
		replace AgeCategory = 15 if (groups==15) | (groups==`max')
		
		drop if AgeCategory==.
		
		bysort AgeCategory Year : egen nEmpCatPrivate = total(nEmployees) if Private==1
		bysort AgeCategory Year : egen nEmpCatPublic = total(nEmployees) if Private==0
		
		collapse (mean) nEmpCatPublic nEmpCatPrivate, by(AgeCategory Private)
		
		replace nEmpCatPublic = round(nEmpCatPublic)
		replace nEmpCatPrivate = round(nEmpCatPrivate)
		
		gen public_firms = nEmpCatPublic
		replace public_firms = 0 if public_firms==. 
		gen private_firms = nEmpCatPrivate
		replace private_firms = 0 if private_firms==.
				
		gen TotEmp = .
		
		levelsof AgeCategory, local(categories)		
		foreach x of local categories{
			sum nEmpCatPublic if AgeCategory==`x', detail
			local pubf = r(mean)
			sum nEmpCatPrivate if AgeCategory==`x', detail
			local privf = r(mean)
			replace TotEmp = `pubf'+`privf' if AgeCategory==`x'
		}
		
		bysort Private: egen nEmp = total(TotEmp)	
		
		gen pct_nEmpCatPrivate = 100*nEmpCatPrivate/nEmp
		gen pct_nEmpCatPublic = 100*nEmpCatPublic/nEmp
		
		gen floor = 0
		gen roof = .
		
		
		levelsof AgeCategory, local(categories)	
		foreach i of local categories{
			sum pct_nEmpCatPrivate if (Private==1) & (AgeCategory==`i'), detail
			local mean_`i' = r(mean)
			di `mean_`i''
			local midpoint`i' = round(`mean_`i''/2,.01)    // midpoints for private firms
						
			su pct_nEmpCatPrivate if (Private==1) & (AgeCategory==`i') , detail // values for private firms labels
			local nEmp`i' = round(r(mean))
	
			su pct_nEmpCatPublic if (Private==0) & (AgeCategory==`i'), detail
			local nEmppublic`i' = round(r(mean))
			
			local endpoint`i' = `nEmp`i''+`nEmppublic`i'' + 1
			replace roof = `nEmp`i''+`nEmppublic`i'' if (AgeCategory==`i')
		 }
		 
		 
		 foreach i of local categories{
		 	di `midpoint`i''
		 	
		 }
		 
		  foreach i of local categories{
		 	
		 	di `endpoint`i''
		 }
		 
		
		label define AgeCategory 1 "1" 2 "2" 3 "3" 4 "4" 5 "5"  6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15+'" 
		local Labels  1 "1" 2 "2" 3 "3" 4 "4" 5 "5"  6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15+" 
		
		
		graph twoway (rbar floor pct_nEmpCatPrivate AgeCategory, color(maroon))  ///
			(rbar pct_nEmpCatPrivate roof AgeCategory, color(navy)), ///
			legend(label(1 "Private") label( 2 "Public" ) ) ///
			ytitle("Percentage of Employment") ///
			ylabel(, format(%3.0fc)) ///
			xtitle("Years in Market") ///
			xlabel(`Labels')  ///
			text(`midpoint1' 1 "`nEmp1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
			text(`midpoint2' 2 "`nEmp2'", color(white) size(small)) /// 
			text(`midpoint3' 3 "`nEmp3'", color(white) size(small)) /// 
			text(`midpoint4' 4 "`nEmp4'", color(white) size(small)) /// 
			text(`midpoint5' 5 "`nEmp5'", color(white) size(small)) /// 
			text(`midpoint6' 6 "`nEmp6'", color(white) size(small)) /// 
			text(`midpoint7' 7 "`nEmp7'", color(white) size(small)) /// 
			text(`midpoint8' 8 "`nEmp8'", color(white) size(small)) /// 
			text(`midpoint9' 9 "`nEmp9'", color(white) size(small)) /// 
			text(`midpoint10' 10 "`nEmp10'", color(white) size(small)) /// 
			text(`midpoint11' 11 "`nEmp11'", color(white) size(small)) /// 
			text(`midpoint12' 12 "`nEmp12'", color(white) size(small)) /// 
			text(`midpoint13' 13 "`nEmp13'", color(white) size(small)) /// 
			text(`midpoint14' 14 "`nEmp14'", color(white) size(small)) /// 
			text(`midpoint15' 15 "`nEmp15'", color(white) size(small)) /// 
			text(`endpoint1' 1 "`nEmppublic2'", color(navy) size(small)) /// 
			text(`endpoint2' 2 "`nEmppublic2'", color(navy) size(small)) /// 
			text(`endpoint3' 3 "`nEmppublic3'", color(navy) size(small)) /// 
			text(`endpoint4' 4 "`nEmppublic4'", color(navy) size(small)) /// 
			text(`endpoint5' 5 "`nEmppublic5'", color(navy) size(small)) /// 
			text(`endpoint6' 6 "`nEmppublic6'", color(navy) size(small)) /// 
			text(`endpoint7' 7 "`nEmppublic7'", color(navy) size(small)) /// 
			text(`endpoint8' 8 "`nEmppublic8'", color(navy) size(small)) /// 
			text(`endpoint9' 9 "`nEmppublic9'", color(navy) size(small)) /// 
			text(`endpoint10' 10 "`nEmppublic10'", color(navy) size(small)) /// 
			text(`endpoint11' 11 "`nEmppublic11'", color(navy) size(small)) /// 
			text(`endpoint12' 12 "`nEmppublic12'", color(navy) size(small)) /// 
			text(`endpoint13' 13 "`nEmppublic13'", color(navy) size(small)) /// 
			text(`endpoint14' 14 "`nEmppublic14'", color(navy) size(small)) /// 
			text(`endpoint15' 15 "`nEmppublic15'", color(navy) size(small)) /// 
			graphregion(color(white))
			graph export Output/$CountryID/OB_ByAge_ShareEmployment.pdf, replace 
	
	restore
	
		
	
	************************************************************************************************************
	************************************************************************************************************
	************************************************************************************************************
	
	
	
	preserve
	* Share of Firms by Age
	
	
		keep IDNum Year nEmployees Private Age
		
		keep if nEmployees!=.
		sum Age, detail
		local max= r(max)
		cap drop groups
		egen groups  = cut(Age), at (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, `max')

		gen AgeCategory = . 
		replace AgeCategory = 1 if groups==1
		replace AgeCategory = 2 if groups==2
		replace AgeCategory = 3 if groups==3
		replace AgeCategory = 4 if groups==4
		replace AgeCategory = 5 if groups==5
		replace AgeCategory = 6 if groups==6
		replace AgeCategory = 7 if groups==7
		replace AgeCategory = 8 if groups==8
		replace AgeCategory = 9 if groups==9
		replace AgeCategory = 10 if groups==10
		replace AgeCategory = 11 if groups==11
		replace AgeCategory = 12 if groups==12
		replace AgeCategory = 13 if groups==13
		replace AgeCategory = 14 if groups==14
		replace AgeCategory = 15 if (groups==15) | (groups==`max')
		
		drop if AgeCategory==.

		bysort AgeCategory IDNum : gen nvals = _n == 1 
		bysort AgeCategory : egen nFirmsAge = total(nvals) 
		bysort AgeCategory : egen nFirmsAgePrivate = total(nvals) if Private==1
		bysort AgeCategory : egen nFirmsAgePublic = total(nvals) if Private==0
				
		collapse (mean) nFirmsAgePrivate nFirmsAgePublic nFirmsAge, by(AgeCategory Private)
		
		replace nFirmsAgePublic = round(nFirmsAgePublic)
		replace nFirmsAgePrivate = round(nFirmsAgePrivate)
		
		gen public_firms = nFirmsAgePublic
		replace public_firms = 0 if public_firms==. 
		gen private_firms = nFirmsAgePrivate
		replace private_firms = 0 if private_firms==.
		
		bysort Private: egen nFirms = total(nFirmsAge)
		
		sort AgeCategory Private 
		
		gen pct_AgeCatPrivate = 100*nFirmsAgePrivate/nFirms
		gen pct_AgeCatPublic = 100*nFirmsAgePublic/nFirms
		
		gen floor = 0
		gen roof = .
		
		levelsof AgeCategory, local(categories)	
		foreach i of local categories{						
			su pct_AgeCatPrivate if (Private==1) & (AgeCategory==`i') , detail // values for private firms labels
			local nEmp`i' = round(r(mean))
	
			su pct_AgeCatPublic if (Private==0) & (AgeCategory==`i'), detail
			local nEmppublic`i' = round(r(mean))

			replace roof = `nEmp`i''+`nEmppublic`i'' if (AgeCategory==`i')
		 }
		
	
		label define AgeCategory 1 "1" 2 "2" 3 "3" 4 "4" 5 "5"  6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15+'" 
		local Labels  1 "1" 2 "2" 3 "3" 4 "4" 5 "5"  6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15+" 
		
		
		graph twoway (rbar floor pct_AgeCatPrivate AgeCategory, color(maroon))  ///
			(rbar pct_AgeCatPrivate roof AgeCategory, color(navy)), ///
			legend(label(1 "Private") label( 2 "Public" ) ) ///
			ytitle("Share of firms") ///
			ylabel(, format(%3.0fc)) ///
			xtitle("Years in Market") ///
			xlabel(`Labels')  ///
			graphregion(color(white))
			graph export Output/$CountryID/OB_ByAge_Share_nFirms.pdf, replace 
	
	
	restore
	
	


************************************************************************************************************
	************************************************************************************************************
	************************************************************************************************************

	
	
	preserve

		/*
		 EUROSTAT Size Categories - Comparison
		*/
		
		keep IDNum Year nEmployees Private 
			
		keep if nEmployees!=.
		
		
		*----------------------
		* Size Category 
		*----------------------

		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20,49, 50, 249,250, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if (groups==0) | (groups==9)
		replace SizeCategory = 2 if (groups==10) | (groups==19)
		replace SizeCategory = 3 if (groups==20) | (groups==49)
		replace SizeCategory = 4 if (groups==50) | (groups==249)
		replace SizeCategory = 5 if (groups==250) | (groups==`max')
		drop groups 
		
		
		drop if SizeCategory==.
		
		bysort SizeCategory Year : egen nEmpCatPrivate = total(nEmployees) if Private==1
		bysort SizeCategory Year : egen nEmpCatPublic = total(nEmployees) if Private==0
		
		collapse (mean) nEmpCatPublic nEmpCatPrivate, by(SizeCategory Private)
		
		replace nEmpCatPublic = round(nEmpCatPublic)
		replace nEmpCatPrivate = round(nEmpCatPrivate)
		
		gen public_firms = nEmpCatPublic
		replace public_firms = 0 if public_firms==. 
		gen private_firms = nEmpCatPrivate
		replace private_firms = 0 if private_firms==.
				
		gen TotEmp = .
		
		levelsof SizeCategory, local(categories)		
		foreach x of local categories{
			sum nEmpCatPublic if SizeCategory==`x', detail
			local pubf = r(mean)
			sum nEmpCatPrivate if SizeCategory==`x', detail
			local privf = r(mean)
			replace TotEmp = `pubf'+`privf' if SizeCategory==`x'
		}
		bysort Private: egen nEmp = total(TotEmp)	
		
		gen pct_nEmpCatPrivate = 100*nEmpCatPrivate/nEmp
		gen pct_nEmpCatPublic = 100*nEmpCatPublic/nEmp
		
		
		gen floor = 0
		gen roof = .
		 
		 forval i=1/5{
			gen mid`i'=  pct_nEmpCatPrivate/2  if (Private==1) & (SizeCategory==`i') // midpoints for private firms
			su mid`i', meanonly
			local midpoint`i' = r(mean)
			drop mid`i'
			
			gen nEmp`i' = pct_nEmpCatPrivate if (Private==1) & (SizeCategory==`i') // values for private firms labels
			su nEmp`i', meanonly
			local nEmp`i' = round(r(mean))
			drop nEmp`i'
			

			gen nEmppub`i' = pct_nEmpCatPublic if (Private==0) & (SizeCategory==`i')
			su nEmppub`i', meanonly
			local nEmppublic`i' = round(r(mean))
			drop nEmppub`i'
			
			local endpoint`i' = `nEmp`i''+`nEmppublic`i'' + 2.5
			replace roof = `nEmp`i''+`nEmppublic`i'' if (SizeCategory==`i')
			
		 }		
		sum roof if SizeCategory==5,detail
		local endp5roof1 = r(mean)
		sum pct_nEmpCatPrivate if SizeCategory==5,detail
		local endp5roof2 = r(mean)
		local endpoint5 = (`endp5roof1'+`endp5roof2')/2
		
		label define SizeCat   1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		
		graph twoway (rbar floor pct_nEmpCatPrivate SizeCategory, color(maroon))  ///
			(rbar pct_nEmpCatPrivate roof SizeCategory, color(navy)), ///
			legend(label(1 "Private") label( 2 "Public" ) ) ///
			ytitle("Percentage of Employment") ///
			ylabel(, format(%3.0fc)) ///
			xtitle("Number of Employees") ///
			xlabel(`Labels') ///
			text(`midpoint1' 1 "`nEmp1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
			text(`midpoint2' 2 "`nEmp2'", color(white) size(small)) /// 
			text(`midpoint3' 3 "`nEmp3'", color(white) size(small)) /// 
			text(`midpoint4' 4 "`nEmp4'", color(white) size(small)) /// 
			text(`midpoint5' 5 "`nEmp5'", color(white) size(small)) /// 
			text(`endpoint1' 1 "`nEmppublic1'", color(navy) size(small)) /// Begin labels for public firms
			text(`endpoint2' 2 "`nEmppublic3'", color(navy) size(small)) /// 
			text(`endpoint3' 3 "`nEmppublic3'", color(navy) size(small)) /// 
			text(`endpoint4' 4 "`nEmppublic4'", color(navy) size(small)) /// 
			text(`endpoint5' 5 "`nEmppublic5'", color(white) size(small)) /// 
			graphregion(color(white))
			graph export Output/$CountryID/OB_By_EuroStat_SizeCat_ShareEmployment.pdf, replace 
	restore
	
	




























