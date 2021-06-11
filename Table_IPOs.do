*-----------------------------------
* IPOs
*---------------------------------
preserve

	file close _all

	file open TabIPOs using Output/${CountryID}/Table_CountryStats_IPOs.tex, write replace

	
	*Name of variables
	* file write TabPubPri "  Employment Growth     "
	*file write TabIPOs " &  Pre-IPO & Post-IPO  & nObs   \\ \midrule"_n
	
	file write TabIPOs " ${CountryID} "
	
	*--------------------------------
	* Growth rates around an IPO
	*--------------------------------
	
	* Create Haltwinger measure of growth rate
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	
	su EmpGrowth_h if (IPO_timescale==-1)
	local PreGrowth: di %12.1fc r(mean)*100
	file write TabIPOs " & `PreGrowth' "
	
	su EmpGrowth_h if (IPO_timescale==1)
	local PostGrowth: di %12.1fc r(mean)*100
	file write TabIPOs " & `PostGrowth' "
	
	count if (IPO_timescale==1)
	local Moment: di %12.0fc r(N)
	file write TabIPOs " & `Moment' "
	
	file write TabIPOs "\\"


	file close _all


restore
