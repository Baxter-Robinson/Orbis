preserve

	file close _all

	file open TabDescStats using Output/$CountryID/Table_Descriptive-Stats.tex, write replace

	* Table format for latex (top)
	file write TabDescStats "\begin{tabular}{@{}lllllll@{}}"_n
	file write TabDescStats "\toprule"
	
	*Name of variables
	file write TabDescStats " & Age & Employment & Sales & Sales/employee & number of shareholders & number of observations  \\ \midrule"_n
	
	
	* Full Sample
	*-------------
	* Open full sample dataset
	foreach a of global CountryID {
		foreach p of global PATH_glob {
			use `p'/Data_Cleaned/`a'_clean.dta, replace
		}
	}
	file write TabDescStats "Full Sample: & "

	*Age
	su Age
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' &"
	
	*n Employees
	su nEmployees
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales (Thousands)
	replace Sales=Sales/1000
	su Sales
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales per employee 
	gen SalesPerWorker=Sales/nEmployees
	su SalesPerWorker
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' & "
	
	*n Shareholders and n observations
	su nShareholders
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment'  &"
	local Moment: di %8.2fc r(N)
	file write TabDescStats "`Moment'  \\"_n


	* Subsample 1
	*-------------
	* Open one percent sample dataset
	foreach a of global CountryID {
		foreach p of global PATH_glob {
			use `p'/Data_OnePercent/`a'_OnePercent.dta, replace
		}
	}
	file write TabDescStats "One Percent Sample: & "

	*Age
	su Age
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' &"
	
	*n Employees
	su nEmployees
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales (Thousands)
	replace Sales=Sales/1000
	su Sales
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' & "

	*Sales per employee 
	gen SalesPerWorker=Sales/nEmployees
	su SalesPerWorker
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' & "
	
	*n Shareholders
	su nShareholders
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment'  &"
	local Moment: di %8.2fc r(N)
	file write TabDescStats "`Moment'  \\ \bottomrule"_n
	
	* Table format for latex (bottom)
	file write TabDescStats "\end{tabular}"

	file close _all

restore
