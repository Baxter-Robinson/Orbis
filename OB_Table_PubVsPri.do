*-----------------------------------
* Public vs. Private Firms
*---------------------------------
preserve

	file close _all

	file open TabPubPri using Output/${CountryID}/Table_PubVsPri.tex, write replace

	
	*Name of variables
	* file write TabPubPri " & Employment                   Employment Growth     Employment Volatility   nObs"
	*file write TabPubPri " & Public & Private & Ratio  & Public & Private  & Public & Private & Public & Private  \\ \midrule"_n
	
	file write TabPubPri " ${CountryID} "
		
	*Public Average Employment
	su nEmployees if Private==0 // (Listed)
	local Public=r(mean)
	file write TabPubPri  " & " %12.1fc (`Public')
	
	*Private Average Employment
	su nEmployees if Private==1 // (FirmType<=3)
	local Private=r(mean)
	file write TabPubPri  " & " %12.1fc (`Private')

	* Public/Private Ratio
	file write TabPubPri  " & " %12.1fc (`Public'/`Private')
	

	*--------------------------------
	* Employment Growth (omit when +/- 1.85)
	*--------------------------------
	
	su EmpGrowth_h if Private==0 & abs(EmpGrowth_h) < 1.85
	local Public=r(mean)
	local PublicSD=r(sd)
	file write TabPubPri   " & " %12.2fc (`Public')
	
	su EmpGrowth_h if Private==1 & abs(EmpGrowth_h) < 1.85 
	local Private=r(mean)
	local PrivateSD=r(sd)
	file write TabPubPri   " & " %12.2fc (`Private')

	file write TabPubPri   " & " %12.2fc (`PublicSD')
	file write TabPubPri   " & " %12.2fc (`PrivateSD')
	
	*--------------------------------
	* N Employees
	*--------------------------------
	*Public Average Employment
	su nEmployees if Private==0 
	local Public=r(N)
	file write TabPubPri  " & " %12.0fc (`Public')
	
	*Private Average Employment
	su nEmployees if Private==1 
	local Private=r(N)
	file write TabPubPri  " & " %12.0fc (`Private')


	file write TabPubPri " \\"


	file close _all


restore

