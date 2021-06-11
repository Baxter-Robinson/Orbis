preserve

	file close _all

	file open TabEmpShares using Output/${CountryID}/Table_BySize_EmpShares.tex, write replace
	file open TabAgeDist using Output/${CountryID}/Table_BySize_AgeDist.tex, write replace
	file open TabNFirms using Output/${CountryID}/Table_BySize_NFirms.tex, write replace

	
	*Name of variables
	*file write EmpShares " & 1-9 & 10-99 & 100-999 & 1,000-4,999 & 5,000-14,999 & 15,000-49,999 & 50,000-99,999 & 100,000-199,999 & 200,000+  \\ \midrule"_n
	
	
	file write TabEmpShares " ${CountryID} "
	file write TabAgeDist " ${CountryID} "
	file write TabNFirms " ${CountryID} "
	
	local Categories 10 100 1000 5000 15000 50000 100000 200000
	
	
	su nEmployees, detail
	local Total=r(sum)
	
	
	tokenize "`Categories'"
	su nEmployees if (nEmployees<`1')
	local Moment: di %8.1fc r(sum)/`Total'*100
	local nObs: di %10.0fc r(N)
	file write TabEmpShares " & `Moment' "
	
	file write TabNFirms " &  `nObs' "
	
	
	su Age if (nEmployees<`1')
	local Moment: di %8.1fc r(mean)
	file write TabAgeDist " & `Moment' "
	
	
	forval i=2/8{
		local prior=`i'-1
		su nEmployees if (nEmployees<``i'') & (nEmployees>=``prior'')
		local Moment: di %8.1fc r(sum)/`Total'*100
		local nObs: di %8.0fc r(N)
		file write TabEmpShares " & `Moment' "
		
		file write TabNFirms " & `nObs' "
		
		su Age if (nEmployees<``i'') & (nEmployees>=``prior'')
		local Moment: di %8.1fc r(mean)
		file write TabAgeDist " & `Moment' "
		
	}
	
	su nEmployees if (nEmployees>=`8') 
	local Moment: di %8.1fc r(sum)/`Total'*100
	local nObs: di %8.0fc r(N)
	file write TabEmpShares " & `Moment' "
	
	file write TabNFirms " & `nObs' "
	
	su Age if (nEmployees>=`8')
	local Moment: di %8.1fc r(mean)
	file write TabAgeDist " & `Moment' "
		
		
	file write TabEmpShares " \\ "
	file write TabAgeDist " \\ "
	file write TabNFirms " \\ "
	
		file close _all
	
restore