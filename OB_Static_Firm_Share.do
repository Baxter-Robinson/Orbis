
preserve

		file close _all

		file open Static using Output/${CountryID}/OB_Static_Firm.tex, write replace

		file write Static " ${CountryID} "

		* Static Firm Share
		sum nEmployees if  nEmployees!=., detail
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)
		di `Emp_quartile1'

		/*
		* Positive values only
		sum nEmployees if (nEmployees!=.)&(nEmployees>0)
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)
		*/

		bysort IDNum: egen F_review = max(nEmployees)

		gen BelowQ1 = 0 
		replace BelowQ1=1 if F_review < `Emp_quartile1'


		gen BelowMedian = 0
		replace BelowMedian=1 if F_review < `Emp_median'


		bysort IDNum: gen nvals = _n == 1  
		
		replace BelowQ1 = BelowQ1*nvals
		replace BelowMedian = BelowMedian*nvals
		
		
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen numFirms = nvals
		sum numFirms, detail
		local nfirms = r(mean)
		
		file write Static " & `nfirms' "
		
		sum BelowQ1, detail
		return list
		local static_Q1 = 100*r(sum)/`nfirms'
		
		
		sum BelowMedian, detail
		return list
		local static_Q2 = 100*r(sum)/`nfirms'

		file write Static  "   &   "
		
		file write Static  %4.2fc  (`static_Q1')
		
		file write Static  "   &   "
		
		file write Static  %4.2fc  (`static_Q2')
		
		file write Static  "   \\  "
			
		file close _all

restore
