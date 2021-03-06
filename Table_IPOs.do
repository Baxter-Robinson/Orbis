*-----------------------------------
* IPOs
*---------------------------------
preserve

	file close _all

	file open TabIPOs using Output/${CountryID}/Table_IPOs.tex, write replace

	
	*Name of variables
	* file write TabPubPri "  Employment Growth     "
	*file write TabIPOs " &  Pre-IPO & Post-IPO  & nObs   \\ \midrule"_n
	
	file write TabIPOs "${CountryID} "
	
	*--------------------------------
	* Growth rates around an IPO
	*--------------------------------
	
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	
	su EmpGrowth_h if (IPO_timescale==-1)
	local PreGrowth: di %12.2fc r(mean)
	file write TabIPOs " & `PreGrowth' "
	
	su EmpGrowth_h if (IPO_timescale==1)
	local PostGrowth: di %12.2fc r(mean)
	file write TabIPOs " & `PostGrowth' "
	
	count if (IPO_timescale==-1)
	local Moment: di %12.0fc r(N)
	file write TabIPOs " & `Moment' "
	
	file write TabIPOs "\\"


	file close _all


restore
