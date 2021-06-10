*-----------------------------------
* Public vs. Private Firms
*---------------------------------
preserve

	file close _all

	file open TabPubPri using Output/${CountryID}/Table_CountryStats_PubVsPri.tex, write replace

	
	*Name of variables
	* file write TabPubPri " & Employment                   Employment Growth     Employment Volatility"
	*file write TabPubPri " & Public & Private & Ratio  & Public & Private  & Public & Private   \\ \midrule"_n
	
	file write TabPubPri " ${CountryID} "
		
	*Public Average Employment
	su nEmployees if (Listed)
	local Public=r(mean)
	file write TabPubPri  " & " %12.1fc (`Public')
	
	*Public Average Employment
	su nEmployees if (FirmType<=3)
	local Private=r(mean)
	file write TabPubPri  " & " %12.1fc (`Private')

	* Public/Private Ratio
	file write TabPubPri  " & " %12.1fc (`Public'/`Private')
	

	*--------------------------------
	* Employment Growth
	*--------------------------------
	* Create Haltwinger measure of growth rate
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	
	su EmpGrowth if (Listed)
	local Public=r(mean)
	local PublicSD=r(sd)
	file write TabPubPri   " & " %12.1fc (`Public')
	
	su EmpGrowth if (FirmType<=3)
	local Private=r(mean)
	local PrivateSD=r(sd)
	file write TabPubPri   " & " %12.1fc (`Private')

	file write TabPubPri   " & " %12.1fc (`PublicSD')
	file write TabPubPri   " & " %12.1fc (`PrivateSD')
	
	
*/
	file write TabPubPri "\\"


	file close _all


restore

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
