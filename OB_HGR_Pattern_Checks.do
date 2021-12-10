





preserve 

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
		
		
		quietly sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		egen loopid = group(IDNum)
		gen upward190 =.
		gen downward190 =.
		
		
		
		sum loopid, detail
		local maxloopid = r(max)
		forvalues i = 2/`maxloopid'{
			di `i'
			local j=`i'-1
			if loopid[`i'] == loopid[`j']{
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
		
		file write HGRChecks  " & `totfirms' "
		file write HGRChecks  " & `totfirms_HGR' "
		local percentageHGR = round(`totfirms_HGR'*100/`totfirms',.01)
		file write HGRChecks  " & `percentageHGR' "
		
		tab IDNum upward190
		return list
		local cases190_up = r(N)
		local unique190_up = r(r)
		file write HGRChecks " & `cases190_up' "
		file write HGRChecks " & `unique190_up' "
		local percentage190_up = round(`unique190_up'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage190_up' "
		
		
		tab IDNum downward190
		return list
		local cases190_down = r(N)
		local unique190_down = r(r)
		file write HGRChecks " & `cases190_down' "
		file write HGRChecks " & `unique190_down' "
		local percentage190_down = round(`unique190_down'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage190_down' "		
	
		file write HGRChecks "\\"


		file close _all
		
restore




preserve


		file close _all

		file open HGRChecks using Output/${CountryID}/OB_Table_HGR_Checks_175.tex, write replace

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
		
		quietly sum Firms_total, detail
		return list
		local totfirms=r(mean) 
		
		quietly sum Firms_HGR_check, detail
		return list
		local totfirms_HGR=r(mean) 
		
		by IDNum: gen tfirms= _n
		by IDNum: gen Tfirms= _N
		
		drop if Tfirms<3 
		
		
		egen loopid = group(IDNum)
		gen upward175 =.
		gen downward175 =.
		
		
		sum loopid, detail
		local maxloopid = r(max)
		forvalues i = 2/`maxloopid'{
			di `i'
			local j=`i'-1
			if loopid[`i'] == loopid[`j']{
				if tfirms[`i']>=3 {
					if EmpGrowth_h[`j']<=-1.75{
						if EmpGrowth_h[`i']>=1.75{
							replace upward175 = 1 in `i' // For rebounds of a HGR >1.75 in t+1 after a HGR < -1.75 in t
						}
					}
				else if EmpGrowth_h[`j']>=1.75{
					if EmpGrowth_h[`i']<-1.75{
						replace downward175 = 1 in `i'  // For falls of a HGR <- 1.75 in t+1 after a HGR > 1.75 in t
						}
					}
				}
			}
		}
				
		file write HGRChecks  " & `totfirms' "
		file write HGRChecks  " & `totfirms_HGR' "
		local percentageHGR = round(`totfirms_HGR'*100/`totfirms',.01)
		file write HGRChecks  " & `percentageHGR' "
				
		
		tab IDNum upward175
		return list
		local cases175_up = r(N)
		local unique175_up = r(r)
		file write HGRChecks " & `cases175_up' "
		file write HGRChecks " & `unique175_up' "
		local percentage175_up = round(`unique175_up'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage175_up' "
		
		
		tab IDNum downward175
		return list
		local cases175_down = r(N)
		local unique175_down = r(r)
		file write HGRChecks " & `cases175_down' "
		file write HGRChecks " & `unique175_down' "
		local percentage175_down = round(`unique175_down'*100/`totfirms_HGR',.01)
		file write HGRChecks  " & `percentage175_down' "		
		
		file write HGRChecks "\\"

		file close _all
		

restore
