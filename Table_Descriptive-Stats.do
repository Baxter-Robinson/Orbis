preserve

	file close _all

	file open TabDescStats using Output/$CountryID/Table_Descriptive-Stats.tex, write replace


	* Full Sample
	*-------------
	file write TabDescStats "Full Sample: & "



	*n Employees
	su nEmployees
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' & "


	*n Shareholders
	su nShareholders
	local Moment: di %8.2fc r(mean)
	file write TabDescStats "`Moment' & "


	*Sales (Thousands)
	replace Sales=Sales/1000
	su Sales
	local Moment: di %12.2fc r(mean)
	file write TabDescStats "`Moment' \\ "_n


	* Subsample 1
	*-------------
	file write TabDescStats "Subsample 1: & "

	file close _all

restore
