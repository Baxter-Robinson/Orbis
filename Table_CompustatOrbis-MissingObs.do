preserve	
	file close _all

	file open TabSampleComp using Output/${CountryID}/Table_CompustatOrbis-MissingObs.tex, write replace

	*Name of variables
	file write TabSampleComp "Year & \multicolumn{2}{c}{Number of public firms} & \multicolumn{2}{c}{Public Firms (all obs)} "
	file write TabSampleComp "& \multicolumn{2}{c}{Average Employment} & \multicolumn{2}{c}{Total Employment} & \multicolumn{2}{c}{Average Sales (Million)} "
	file write TabSampleComp "& \multicolumn{2}{c}{Total Sales (Million)} \\ \midrule"_n
	file write TabSampleComp  " & Orbis & Compustat & Orbis & Compustat & Orbis & Compustat & Orbis & Compustat & Orbis & Compustat & Orbis & Compustat \\ \cmidrule{2-13}"_n
	* Merge both datasets
	use "Data_Cleaned/${CountryID}_Unbalanced.dta", clear
	*gen Delisted_year = yofd(Delisted_date)
	keep if (FirmType == 6) & (Year < Delisted_year)
	keep Sales nEmployees Year IDNum
	replace Sales = Sales/1000
	append using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta", generate(dataset_id)
	*drop if Sales == .
	*drop if nEmployees == .
	replace Sales = Sales/1000 // Sales in million $
	drop if Year < 1995
	drop if Year > 2018
	bysort Year dataset_id: egen Total_nEmployees = total(nEmployees)
	bysort Year dataset_id: egen Total_Sales = total(Sales)
	su Year
	* Create tables
	forvalues t = `r(min)'/`r(max)' {
		* Number of public firms (Orbis)
		su Year if (Year == `t') & (dataset_id == 0)
		global Moment = r(N)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`t' & `Moment_num' &"
		* Number of public firms (Compustat)
		su Year if (Year == `t') & (dataset_id == 1)
		global Moment = r(N)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Number of public firms without missing observations (Orbis)
		su Year if (Year == `t') & (dataset_id == 0) & (nEmployees != .) & (Sales != .)
		global Moment = r(N)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Number of public firms without missing observations (Compustat)
		su Year if (Year == `t') & (dataset_id == 1) & (nEmployees != .) & (Sales != .)
		global Moment = r(N)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Average Employment (Orbis)
		su nEmployees if (Year == `t') & (dataset_id == 0)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Average Employment (Computstat)
		su nEmployees if (Year == `t') & (dataset_id == 1)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Total Employment (Orbis)
		su Total_nEmployees if (Year == `t') & (dataset_id == 0)
		global Moment = r(mean)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Total Employment (Computstat)
		su Total_nEmployees if (Year == `t') & (dataset_id == 1)
		global Moment = r(mean)
		local Moment_num: di %14.0fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Average Sales (Orbis)
		su Sales if (Year == `t') & (dataset_id == 0)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Average Sales (Compustat)
		su Sales if (Year == `t') & (dataset_id == 1)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Total Sales (Orbis)
		su Total_Sales if (Year == `t') & (dataset_id == 0)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' &"
		* Total Sales (Compustat)
		su Total_Sales if (Year == `t') & (dataset_id == 1)
		global Moment = r(mean)
		local Moment_num: di %14.2fc $Moment
		file write TabSampleComp "`Moment_num' \\"_n
	}
	file write TabSampleComp "\bottomrule"
	file close _all
restore