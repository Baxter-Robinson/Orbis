preserve

	file close _all

	file open TabEmpShares using Output/${CountryID}/Table_BySize_EmpShares.tex, write replace
	file open TabAgeDist using Output/${CountryID}/Table_BySize_AgeDist.tex, write replace
	file open TabNFirms using Output/${CountryID}/Table_BySize_NFirms.tex, write replace
	file open TabNFirmsShare using Output/${CountryID}/Table_BySize_nFirmShares.m, write replace
	file open TabEmpSharesMATLAB using Output/${CountryID}/Table_BySize_EmpShares.m, write replace
	file open TabGrowth using Output/${CountryID}/Table_BySize_EmpGrowth.m, write replace
	
	*Name of variables
	*file write EmpShares " & 1-9 & 10-99 & 100-999 & 1,000-4,999 & 5,000-14,999 & 15,000-49,999 & 50,000-99,999 & 100,000-199,999 & 200,000+  \\ \midrule"_n
	
	
	file write TabEmpShares " ${CountryID} "
	file write TabEmpSharesMATLAB " ${CountryID} "
	file write TabAgeDist " ${CountryID} "
	file write TabNFirms " ${CountryID} "
	file write TabNFirmsShare " ${CountryID} "
	file write TabGrowth " ${CountryID} "
	
	local Categories 10 100 1000 5000 15000 50000 100000 200000
	
	
	su nEmployees, detail
	local Total=r(sum)
	local TotalNFirms=r(N)
	disp `TotalNFirms'
	
	
	tokenize "`Categories'"
	su nEmployees if (nEmployees<`1')
	local Moment: di %8.1fc r(sum)/`Total'*100
	local nObs: di %10.0fc r(N)
	file write TabEmpShares " & `Moment' "
	file write TabEmpSharesMATLAB " =[ `Moment' "
	
	file write TabNFirms " &  `nObs' "
	disp `TotalNFirms'
	disp `nObs'/`TotalNFirms'
	local Moment: di %8.2f r(N)/`TotalNFirms'*100
	file write TabNFirmsShare " =[  `Moment' "
	
	su EmpGrowth_h if (nEmployees<`1')
	local Moment: di %8.2fc r(mean)*100
	file write TabGrowth "=[`Moment'"
	
	
	su Age if (nEmployees<`1')
	local Moment: di %8.1fc r(mean)
	file write TabAgeDist " & `Moment' "
	
	
	forval i=2/8{
		local prior=`i'-1
		su nEmployees if (nEmployees<``i'') & (nEmployees>=``prior'')
		local Moment: di %8.1fc r(sum)/`Total'*100
		local nObs: di %8.0fc r(N)
		file write TabEmpShares " & `Moment' "
		file write TabEmpSharesMATLAB " , `Moment' "
		
		file write TabNFirms " & `nObs' "
		local Moment: di %8.2f r(N)/`TotalNFirms'*100
		file write TabNFirmsShare " , `Moment' "
		
		su EmpGrowth_h if (nEmployees<``i'') & (nEmployees>=``prior'')
		local Moment: di %8.2fc r(mean)*100
		file write TabGrowth ", `Moment'"
		
		su Age if (nEmployees<``i'') & (nEmployees>=``prior'')
		local Moment: di %8.1fc r(mean)
		file write TabAgeDist " & `Moment' "
		
	}
	
	su nEmployees if (nEmployees>=`8') 
	local Moment: di %8.1fc r(sum)/`Total'*100
	local nObs: di %8.0fc r(N)
	file write TabEmpShares " & `Moment' \\ "
	file write TabEmpSharesMATLAB " , `Moment' ]; "
	
	file write TabNFirms " & `nObs' \\ "
	local Moment: di %8.2f r(N)/`TotalNFirms'*100
	file write TabNFirmsShare " , `Moment' ]; "
	
		
	su EmpGrowth_h if (nEmployees>=`8')
	local Moment: di %8.2fc r(mean)*100
	file write TabGrowth ", `Moment'];"
	
	su Age if (nEmployees>=`8')
	local Moment: di %8.1fc r(mean)
	file write TabAgeDist " & `Moment' \\ "
		

	
		file close _all
	
restore