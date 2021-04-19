preserve

	replace Sales=Sales/1000
	keep if Year == IPO_year
	gen SalesPerEmployee = Sales/nEmployees
	file close _all

	file open TabDescStats using Output/${CountryID}/Table_IPOyear_Descriptive-Compustats.tex, write replace

	* Table format for latex (top)
	
	*Name of variables
	file write TabDescStats " & Age & Employment & Sales (Thousands) & Sales/employee & Number of shareholders & Number of observations  \\ \midrule"_n

	*Loop over samples
	file write TabDescStats "Public Firms (year of IPO) &"
	
	*Age
	su Age
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' &"
	
	*n Employees
	su nEmployees
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales (Thousands)
	su Sales
	local Moment: di %14.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales per employee 
	su SalesPerEmployee
	local Moment: di %14.2fc r(mean)
	file write TabDescStats "`Moment' & "
	
	*n Shareholders and n observations
	su nShareholders
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment'  &"
	local Moment: di %12.0fc r(N)
	file write TabDescStats "`Moment'  \\"_n
	
	file write TabDescStats "\bottomrule"

	file close _all

restore