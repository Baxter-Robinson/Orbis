


preserve

		file close _all

		file open CrossCountry using Output/${CountryID}/OB_Cross_Country.tex, write replace

		file write CrossCountry " ${CountryID} "

		* Static Firm Share

		sum nEmployees if nEmployees!=.
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)

		/*
		* Positive values only
		sum nEmployees if (nEmployees!=.)&(nEmployees>0)
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)
		*/

		bysort IDNum: egen F_review = max(nEmployees)

		gen BelowQ1 = 0
		replace BelowQ1 if F_review<`Emp_quartile1'


		gen BelowMedian = 0
		replace BelowMedian if F_review<`Emp_median'


		bysort IDNum: gen nvals = _n == 1  
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen numFirms = nvals
		sum numFirms, detail
		local nfirms = r(mean)
		
		file write FinRatios " & `nfirms' "
		
		sum BelowQ1, detail
		return list
		local static_Q1 = 100*r(sum)/`nfirms'
		
		sum BelowMedian, detail
		return list
		local static_Q2 = 100*r(sum)/`nfirms'

		
		* ------------------------
		
		sum EmpGrowth_h, detail
		return list
		local meanEmpG = r(mean)
		local sdEmpG = r(sd)
		
		Avg Employment growth
		
		
		
		
      - Std Employment growth
      - Static Firm Share
      - IPO employment growth
      - Employment share of public firms
      - Sales share of public firms 
		
		
		file write CrossCountry " & `static_Q1' "
		
		file write CrossCountry " & `static_Q2' \\ "

		file close _all

restore

	












