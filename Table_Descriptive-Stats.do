preserve

	replace Sales=Sales/1000
	file close _all

	file open TabDescStats using Output/${CountryID}/Table_Descriptive-Stats.tex, write replace

	* Table format for latex (top)
	
	*Name of variables
	file write TabDescStats " & Age & Employment & Sales (Thousands) & Sales/employee & Number of shareholders & Number of observations  \\ \midrule"_n
	
	

	*Loop over samples
	local FirmTypes 0 1 2 3 6
	foreach i of local FirmTypes{
	
		if (`i'==0) { 
			file write TabDescStats "Full Sample:                             & "
		}
		else if (`i'==1) {
			file write TabDescStats "Private Firms with One Owner:            & "		
		}
		else if (`i'==2) {
			file write TabDescStats "Private Firms with Two Owners:           & "		
		}
		else if (`i'==3) {
			file write TabDescStats "Private Firms with Three or More Owners: & "		
		}
		else if (`i'==6) {
			file write TabDescStats "Public Firms:                            & "		
		}
		
		*Age
		su Age if (FirmType==`i' | `i'==0)
		local Moment: di %8.2fc r(mean)
		file write TabDescStats "`Moment' &"
		
		*n Employees
		su nEmployees if (FirmType==`i' | `i'==0)
		local Moment: di %8.2fc r(mean)
		file write TabDescStats "`Moment' & "

		*Sales (Thousands)
		su Sales if (FirmType==`i' | `i'==0)
		local Moment: di %12.2fc r(mean)
		file write TabDescStats "`Moment' & "

		*Sales per employee 
		su SalesPerEmployee if (FirmType==`i' | `i'==0)
		local Moment: di %12.2fc r(mean)
		file write TabDescStats "`Moment' & "
		
		*n Shareholders and n observations
		su nShareholders if (FirmType==`i' | `i'==0)
		local Moment: di %8.2fc r(mean)
		file write TabDescStats "`Moment'  &"
		local Moment: di %8.0fc r(N)
		file write TabDescStats "`Moment'  \\"_n
		

	
	}


	file close _all


	restore
