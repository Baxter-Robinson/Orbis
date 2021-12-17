


*##################################################################################################################
*##################################################################################################################
*##################################################################################################################

preserve 
* This portion of the code checks for jumps in the Haltiwanger Growth Rate higher than abs(1.90) 
		file close _all

		file open HGRChecks using Output/${CountryID}/OB_Table_HGR_Checks_190.tex, write replace

		file write HGRChecks "${CountryID} "
		
		keep nEmployees Year IDNum EmpGrowth_h Private 
		replace EmpGrowth_h =0.000000000001 if EmpGrowth_h==.
		gen ftocheck = 0 // indicator for firm to check 
		* Indicator that a firm has an abs(HGR)>1.9
		bysort IDNum: egen h_review = max(abs(EmpGrowth_h))
		replace ftocheck = 1 if h_review>1.90

		* Creates the number of unique firms in the dataset
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_total = nvals
		drop nvals

		keep if ftocheck==1  // Keep only the firms that were flagged.
		drop h_review
		
		* Creates the number of unique firms in the dataset with at least one year of abs(HGR)>1.90
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_HGR_check = nvals
		drop nvals
		
		
		sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		gen upward190 =.
		gen downward190 =.
		
		gen N_Firms=_N
		sum N_Firms, detail
		return list
		local Nfirms=r(max)

		forvalues i = 2/`Nfirms'{
			di `i'
			local j=`i'-1
			if IDNum[`i'] == IDNum[`j']{
				if tfirms[`i']>=3 {
					if EmpGrowth_h[`j']<=-1.90{
						if EmpGrowth_h[`i']>=1.90{
							replace upward190 = 1 in `i' // For rebounds of a HGR >1.90 in t+1 after a HGR < -1.90 in t
						}
					}
				else if EmpGrowth_h[`j']>=1.90{
					if EmpGrowth_h[`i']<-1.90{
						replace downward190 = 1 in `i' // For falls of a HGR <- 1.90 in t+1 after a HGR > 1.90 in t
						}
					}
				}
			}
		}
		

		
		sum upward190
		local cases190_up = r(N)

		sum downward190 
		local cases190_down = r(N)
		
		collapse (sum) upward190 downward190 (first) Firms_total Firms_HGR_check N_Firms, by(IDNum)
		
		levelsof upward190, local(l_upward190)
		di `l_upward190'
		
		foreach x of local l_upward190 {
			if `x'==0 {
				sum upward190 if upward190==`x'
				local obs=r(N)
				gen unique190_up_zero = `obs'
				}
			else{
				sum IDNum upward if upward190==`x'
				return list
				local obs=r(N)
				gen unique190_up_firms_`x' = `obs'
			}
		}
		
		egen unique_190 = rowtotal(unique190_up_firms_*)
		
		sum unique_190, detail
		return list
		local unique190_up = r(mean)
		di `unique190_up'
		
		
		
		levelsof downward190, local(l_downward190)
		di `l_downward190'
		
		foreach x of local l_downward190 {
			if `x'==0 {
				sum downward190 if downward190==`x'
				local obs=r(N)
				gen unique190_down_zero = `obs'
				}
			else{
				sum IDNum downward if downward190==`x'
				return list
				local obs=r(N)
				gen unique190_down_firms_`x' = `obs'
			}
		}
		
		egen unique_190_down = rowtotal(unique190_down_firms_*)
		sum unique_190_down, detail
		local unique190_down = r(mean)
		di `unique190_down'
		
		
		file write HGRChecks  " & `totfirms' "
		file write HGRChecks  " & `totfirms_HGR' "
		local percentageHGR = round(`totfirms_HGR'*100/`totfirms',.01)
		file write HGRChecks  " & `percentageHGR' "

		file write HGRChecks " & `cases190_up' "		
		file write HGRChecks " & `unique190_up' "
		local percentage190_up = round(`unique190_up'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage190_up' "
		
		file write HGRChecks " & `cases190_down' "		
		file write HGRChecks " & `unique190_down' "
		local percentage190_down = round(`unique190_down'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage190_down' "		
		
		file write HGRChecks "\\"


		file close _all
		
		
		
restore

*##################################################################################################################
*##################################################################################################################
*##################################################################################################################


preserve 
* To be a little more comprehensive in the big jumps in employment, this portion of the code checks 
* for jumps in the Haltiwanger Growth Rate higher than abs(1.75)

		file close _all

		file open HGRChecks using Output/${CountryID}/OB_Table_HGR_Checks_175.tex, write replace

		file write HGRChecks "${CountryID} "
		
		keep nEmployees Year IDNum EmpGrowth_h Private 
		replace EmpGrowth_h =0.000000000001 if EmpGrowth_h==.
		gen ftocheck = 0 // indicator for firm to check 
		* Indicator that a firm has an abs(HGR)>1.75
		bysort IDNum: egen h_review = max(abs(EmpGrowth_h))
		replace ftocheck = 1 if h_review>1.75

		* Creates the number of unique firms in the dataset
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_total = nvals
		drop nvals

		keep if ftocheck==1  // Keep only the firms that were flagged.
		drop h_review
		
		* Creates the number of unique firms in the dataset with at least one year of abs(HGR)>1.75
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_HGR_check = nvals
		drop nvals
		
		
		sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		gen upward175 =.
		gen downward175 =.
		
		gen N_Firms=_N
		sum N_Firms, detail
		return list
		local Nfirms=r(max)

		forvalues i = 2/`Nfirms'{
			di `i'
			local j=`i'-1
			if IDNum[`i'] == IDNum[`j']{
				if tfirms[`i']>=3 {
					if EmpGrowth_h[`j']<=-1.75{
						if EmpGrowth_h[`i']>=1.75{
							replace upward175 = 1 in `i' // For rebounds of a HGR >1.75 in t+1 after a HGR < -1.75 in t
						}
					}
				else if EmpGrowth_h[`j']>=1.75{
					if EmpGrowth_h[`i']<-1.75{
						replace downward175 = 1 in `i' // For falls of a HGR <- 1.75 in t+1 after a HGR > 1.75 in t
						}
					}
				}
			}
		}
		

		
		sum upward175
		local cases175_up = r(N)

		sum downward175 
		local cases175_down = r(N)
		
		collapse (sum) upward175 downward175 (first) Firms_total Firms_HGR_check N_Firms, by(IDNum)
		
		levelsof upward175, local(l_upward175)
		di `l_upward175'
		
		foreach x of local l_upward175 {
			if `x'==0 {
				sum upward175 if upward175==`x'
				local obs=r(N)
				gen unique175_up_zero = `obs'
				}
			else{
				sum IDNum upward if upward175==`x'
				return list
				local obs=r(N)
				gen unique175_up_firms_`x' = `obs'
			}
		}
		
		egen unique_175 = rowtotal(unique175_up_firms_*)
		
		sum unique_175, detail
		return list
		local unique175_up = r(mean)
		di `unique175_up'
		
		
		
		levelsof downward175, local(l_downward175)
		di `l_downward175'
		
		foreach x of local l_downward175 {
			if `x'==0 {
				sum downward175 if downward175==`x'
				local obs=r(N)
				gen unique175_down_zero = `obs'
				}
			else{
				sum IDNum downward if downward175==`x'
				return list
				local obs=r(N)
				gen unique175_down_firms_`x' = `obs'
			}
		}
		
		egen unique_175_down = rowtotal(unique175_down_firms_*)
		sum unique_175_down, detail
		local unique175_down = r(mean)
		di `unique175_down'
		
		
		file write HGRChecks  " & `totfirms' "
		file write HGRChecks  " & `totfirms_HGR' "
		local percentageHGR = round(`totfirms_HGR'*100/`totfirms',.01)
		file write HGRChecks  " & `percentageHGR' "

		file write HGRChecks " & `cases175_up' "		
		file write HGRChecks " & `unique175_up' "
		local percentage175_up = round(`unique175_up'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage175_up' "
		
		file write HGRChecks " & `cases175_down' "		
		file write HGRChecks " & `unique175_down' "
		local percentage175_down = round(`unique175_down'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage175_down' "		
		
		file write HGRChecks "\\"


		file close _all
		
		
		
restore

*##################################################################################################################
*##################################################################################################################
*##################################################################################################################

preserve 

		file close _all

		file open HGRChecks using Output/${CountryID}/OB_Table_HGR_Times_190.tex, write replace

		
		keep nEmployees Year IDNum EmpGrowth_h Private 
		replace EmpGrowth_h =0.000000000001 if EmpGrowth_h==.
		gen ftocheck = 0 // indicator for firm to check 
		* Indicator that a firm has an abs(HGR)>1.9
		bysort IDNum: egen h_review = max(abs(EmpGrowth_h))
		replace ftocheck = 1 if h_review>1.90

		* Creates the number of unique firms in the dataset
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_total = nvals
		drop nvals

		keep if ftocheck==1  // Keep only the firms that were flagged.
		drop h_review
		
		* Creates the number of unique firms in the dataset with at least one year of abs(HGR)>1.90
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_HGR_check = nvals
		drop nvals
		
		
		sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		gen upward190 =.
		gen downward190 =.
		
		gen N_Firms=_N
		sum N_Firms, detail
		return list
		local Nfirms=r(max)

		forvalues i = 2/`Nfirms'{
			di `i'
			local j=`i'-1
			if IDNum[`i'] == IDNum[`j']{
				if tfirms[`i']>=3 {
					if EmpGrowth_h[`j']<=-1.90{
						if EmpGrowth_h[`i']>=1.90{
							replace upward190 = 1 in `i' // For rebounds of a HGR >1.90 in t+1 after a HGR < -1.90 in t
						}
					}
				else if EmpGrowth_h[`j']>=1.90{
					if EmpGrowth_h[`i']<-1.90{
						replace downward190 = 1 in `i' // For falls of a HGR <- 1.90 in t+1 after a HGR > 1.90 in t
						}
					}
				}
			}
		}
		

		
		sum upward190
		local cases190_up = r(N)

		sum downward190 
		local cases190_down = r(N)
		
		collapse (sum) upward190 downward190 (first) Firms_total Firms_HGR_check N_Firms, by(IDNum)
		
		levelsof upward190, local(l_upward190)
		di `l_upward190'
		
		foreach x of local l_upward190 {
			if `x'==0 {
				sum upward190 if upward190==`x'
				local obs=r(N)
				gen unique190_up_zero = `obs'
				}
			else{
				table IDNum upward if upward190==`x'
				return list
				local obs=r(N)
				gen unique190_up_firms_`x' = `obs'
			}
		}
		
		egen unique_190 = rowtotal(unique190_up_firms_*)
		
		sum unique_190, detail
		return list
		local unique190_up = r(mean)
		di `unique190_up'
		
		
		
		levelsof downward190, local(l_downward190)
		di `l_downward190'
		
		foreach x of local l_downward190 {
			if `x'==0 {
				sum downward190 if downward190==`x'
				local obs=r(N)
				gen unique190_down_zero = `obs'
				}
			else{
				sum IDNum downward if downward190==`x'
				return list
				local obs=r(N)
				gen unique190_down_firms_`x' = `obs'
			}
		}
		
		egen unique_190_down = rowtotal(unique190_down_firms_*)
		sum unique_190_down, detail
		local unique190_down = r(mean)
		di `unique190_down'
		
		
		file write HGRChecks "Downward" 
		sum downward190 if downward190==0
		local downward_0 = r(mean)
		
		file write HGRChecks  " & `unique190_down' "
		
		if "${CountryID}" == "PT"{
			forvalues i=1(1)2{
				sum unique190_down_firms_`i' if downward190==`i'
				local downward_`i' = r(mean)
				file write HGRChecks  " & `downward_`i'' "
			}
			
			
			egen unique_190_down_2orless = rowtotal(unique190_down_firms_1-unique190_down_firms_2)
			gen unique_190_down_3ormore = `unique190_down' - unique_190_down_2orless
			sum unique_190_down_3ormore if downward190>=3
			local downward_3 = r(mean)
			file write HGRChecks  " & `downward_3' "
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward190 if upward190==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique190_up' "
			
			forvalues i=1(1)2{
				sum unique190_up_firms_`i' if upward190==`i'
				local upward_`i' = r(mean)
				file write HGRChecks  " & `upward_`i'' "
			}
			
			
			egen unique_190_up_2orless = rowtotal(unique190_up_firms_1-unique190_up_firms_2)
			gen unique_190_up_3ormore = `unique190_up' - unique_190_up_2orless
			sum unique_190_up_3ormore if upward190>=2
			local upward_3 = r(mean)
			file write HGRChecks  " & `upward_3' "
			file write HGRChecks "\\ "		
			file close _all
		}
		
		else if "${CountryID}" == "NL"{
			sum unique190_down_firms_1 if downward190==1
			local downward_1 = r(mean)
			file write HGRChecks  " & `downward_1' "
			
			sum unique190_down_firms_3 if downward190==3
			local downward_3 = r(mean)
			file write HGRChecks  " & `downward_3' "
			
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward190 if upward190==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique190_up' "
			
			sum unique190_up_firms_1 if upward190==1
			local upward_1 = r(mean)
			file write HGRChecks  " & `upward_1' "
			
			sum unique190_up_firms_3 if upward190==3
			local upward_3 = r(mean)
			file write HGRChecks  " & `upward_3' "
			
			file write HGRChecks "\\ "		
			file close _all
		}
		
		else{		
			forvalues i=1(1)3{
				sum unique190_down_firms_`i' if downward190==`i'
				local downward_`i' = r(mean)
				file write HGRChecks  " & `downward_`i'' "
			}
			
			
			egen unique_190_down_3orless = rowtotal(unique190_down_firms_1-unique190_down_firms_3)
			gen unique_190_down_4ormore = `unique190_down' - unique_190_down_3orless
			sum unique_190_down_4ormore if downward190>=4
			local downward_4 = r(mean)
			file write HGRChecks  " & `downward_4' "
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward190 if upward190==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique190_up' "
			
			forvalues i=1(1)3{
				sum unique190_up_firms_`i' if upward190==`i'
				local upward_`i' = r(mean)
				file write HGRChecks  " & `upward_`i'' "
			}
			
			
			egen unique_190_up_3orless = rowtotal(unique190_up_firms_1-unique190_up_firms_3)
			gen unique_190_up_4ormore = `unique190_up' - unique_190_up_3orless
			sum unique_190_up_4ormore if upward190>=4
			local upward_4 = r(mean)
			file write HGRChecks  " & `upward_4' "
			file write HGRChecks "\\ "		
			file close _all
		}
restore


*##################################################################################################################
*##################################################################################################################
*##################################################################################################################


preserve 

		file close _all

		file open HGRChecks using Output/${CountryID}/OB_Table_HGR_Times_175.tex, write replace

		
		keep nEmployees Year IDNum EmpGrowth_h Private 
		replace EmpGrowth_h =0.000000000001 if EmpGrowth_h==.
		gen ftocheck = 0 // indicator for firm to check 
		* Indicator that a firm has an abs(HGR)>1.75
		bysort IDNum: egen h_review = max(abs(EmpGrowth_h))
		replace ftocheck = 1 if h_review>1.75

		* Creates the number of unique firms in the dataset
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_total = nvals
		drop nvals

		keep if ftocheck==1  // Keep only the firms that were flagged.
		drop h_review
		
		* Creates the number of unique firms in the dataset with at least one year of abs(HGR)>1.75
		bysort IDNum: gen nvals = _n == 1 
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen Firms_HGR_check = nvals
		drop nvals
		
		
		sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		gen upward175 =.
		gen downward175 =.
		
		gen N_Firms=_N
		sum N_Firms, detail
		return list
		local Nfirms=r(max)

		forvalues i = 2/`Nfirms'{
			di `i'
			local j=`i'-1
			if IDNum[`i'] == IDNum[`j']{
				if tfirms[`i']>=3 {
					if EmpGrowth_h[`j']<=-1.75{
						if EmpGrowth_h[`i']>=1.75{
							replace upward175 = 1 in `i' // For rebounds of a HGR >1.75 in t+1 after a HGR < -1.75 in t
						}
					}
				else if EmpGrowth_h[`j']>=1.75{
					if EmpGrowth_h[`i']<-1.75{
						replace downward175 = 1 in `i' // For falls of a HGR <- 1.75 in t+1 after a HGR > 1.75 in t
						}
					}
				}
			}
		}
		

		
		sum upward175
		local cases175_up = r(N)

		sum downward175 
		local cases175_down = r(N)
		
		collapse (sum) upward175 downward175 (first) Firms_total Firms_HGR_check N_Firms, by(IDNum)
		
		levelsof upward175, local(l_upward175)
		di `l_upward175'
		
		foreach x of local l_upward175 {
			if `x'==0 {
				sum upward175 if upward175==`x'
				local obs=r(N)
				gen unique175_up_zero = `obs'
				}
			else{
				table IDNum upward if upward175==`x'
				return list
				local obs=r(N)
				gen unique175_up_firms_`x' = `obs'
			}
		}
		
		egen unique_175 = rowtotal(unique175_up_firms_*)
		
		sum unique_175, detail
		return list
		local unique175_up = r(mean)
		di `unique175_up'
		
		
		
		levelsof downward175, local(l_downward175)
		di `l_downward175'
		
		foreach x of local l_downward175 {
			if `x'==0 {
				sum downward175 if downward175==`x'
				local obs=r(N)
				gen unique175_down_zero = `obs'
				}
			else{
				sum IDNum downward if downward175==`x'
				return list
				local obs=r(N)
				gen unique175_down_firms_`x' = `obs'
			}
		}
		
		egen unique_175_down = rowtotal(unique175_down_firms_*)
		sum unique_175_down, detail
		local unique175_down = r(mean)
		di `unique175_down'
		
		
		file write HGRChecks "Downward" 
		sum downward175 if downward175==0
		local downward_0 = r(mean)
		
		file write HGRChecks  " & `unique175_down' "
		
		if "${CountryID}" == "PT"{
			forvalues i=1(1)2{
				sum unique175_down_firms_`i' if downward175==`i'
				local downward_`i' = r(mean)
				file write HGRChecks  " & `downward_`i'' "
			}
			
			
			egen unique_175_down_2orless = rowtotal(unique175_down_firms_1-unique175_down_firms_2)
			gen unique_175_down_3ormore = `unique175_down' - unique_175_down_2orless
			sum unique_175_down_3ormore if downward175>=3
			local downward_3 = r(mean)
			file write HGRChecks  " & `downward_3' "
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward175 if upward175==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique175_up' "
			
			forvalues i=1(1)2{
				sum unique175_up_firms_`i' if upward175==`i'
				local upward_`i' = r(mean)
				file write HGRChecks  " & `upward_`i'' "
			}
			
			
			egen unique_175_up_2orless = rowtotal(unique175_up_firms_1-unique175_up_firms_2)
			gen unique_175_up_3ormore = `unique175_up' - unique_175_up_2orless
			sum unique_175_up_3ormore if upward175>=4
			local upward_3 = r(mean)
			file write HGRChecks  " & `upward_3' "
			file write HGRChecks "\\ "		
			file close _all
		}
		
		else if "${CountryID}" == "NL"{
			sum unique175_down_firms_1 if downward175==1
			local downward_1 = r(mean)
			file write HGRChecks  " & `downward_1' "
			
			sum unique175_down_firms_3 if downward175==3
			local downward_3 = r(mean)
			file write HGRChecks  " & `downward_3' "
			
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward175 if upward175==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique175_up' "
			
			sum unique175_up_firms_1 if upward175==1
			local upward_1 = r(mean)
			file write HGRChecks  " & `upward_1' "
			
			sum unique175_up_firms_3 if upward175==3
			local upward_3 = r(mean)
			file write HGRChecks  " & `upward_3' "
			
			file write HGRChecks "\\ "		
			file close _all
		}
		
		else{		
			forvalues i=1(1)3{
				sum unique175_down_firms_`i' if downward175==`i'
				local downward_`i' = r(mean)
				file write HGRChecks  " & `downward_`i'' "
			}
			
			
			egen unique_175_down_3orless = rowtotal(unique175_down_firms_1-unique175_down_firms_3)
			gen unique_175_down_4ormore = `unique175_down' - unique_175_down_3orless
			sum unique_175_down_4ormore if downward175>=4
			local downward_4 = r(mean)
			file write HGRChecks  " & `downward_4' "
			file write HGRChecks "\\ "


			file write HGRChecks "Upward" 
			sum upward175 if upward175==0
			local upward_0 = r(mean)
			
			
			file write HGRChecks  " & `unique175_up' "
			
			forvalues i=1(1)3{
				sum unique175_up_firms_`i' if upward175==`i'
				local upward_`i' = r(mean)
				file write HGRChecks  " & `upward_`i'' "
			}
			
			
			egen unique_175_up_3orless = rowtotal(unique175_up_firms_1-unique175_up_firms_3)
			gen unique_175_up_4ormore = `unique175_up' - unique_175_up_3orless
			sum unique_175_up_4ormore if upward175>=4
			local upward_4 = r(mean)
			file write HGRChecks  " & `upward_4' "
			file write HGRChecks "\\ "		
			file close _all
		}
		
		
restore


*##################################################################################################################
*##################################################################################################################
*##################################################################################################################


preserve

		keep nEmployees Year IDNum EmpGrowth_h Private 
		replace EmpGrowth_h =0.000000000001 if EmpGrowth_h==.
		gen HGRcheck = 0 // indicator for firm to check 
		* Indicator that a firm has an abs(HGR)>1.9
		gen h_review = abs(EmpGrowth_h)
		replace HGRcheck = 1 if h_review>1.90

		keep if HGRcheck==1  // Keep only the firms that were flagged.
		drop h_review
		
		
		collapse (sum) HGRcheck, by(IDNum)
		sum IDNum, detail
		return list
		
		
		gen ordering = _n
		sum ordering, detail
		local max = r(max)
		local no_groups=round(`max'/25,1)
		di `no_groups'
		
		egen firmgroups = cut(ordering), group(`no_groups')
		
		levelsof firmgroups, local(groups)
		foreach x of local groups{
			quietly sum ordering if firmgroups==`x', detail 
			local min = r(min)
			local max = r(max)
			file close _all
			file open HGR_Tabs using Output/${CountryID}/OB_Tab_firm_HGR_`x'.tex, write replace
			file write HGR_Tabs "Firm IDNum"
			file write HGR_Tabs " & HGR>abs(1.90) [Frequency] \\"
			forvalues i=`min'/`max'{
				local firma = IDNum[`i']
				local frequency = HGRcheck[`i']
				file write HGR_Tabs " `firma' "
				file write HGR_Tabs " & `frequency' "
				file write HGR_Tabs " \\"
			}
			file close _all
		}
		
		
		
		
restore
