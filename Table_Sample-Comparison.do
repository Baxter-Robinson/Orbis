preserve	
	file close _all

	file open TabSampleComp using Output/${CountryID}/Table_Sample-Comparison.tex, write replace

	* Table format for latex (top)
	
	*Name of variables
	file write TabSampleComp "& Number (\%) of firm-years & Number (\%) of unique firms \\ \midrule"_n
	
	local Sample 0 1 2 3
	foreach i of local Sample {
		if (`i'==0) {
			use "Data_Raw/${CountryID}_merge.dta", clear
			file write TabSampleComp "Full Sample:                    &"
		}
		else if (`i'==1) {
			use "Data_Cleaned/${CountryID}_Unbalanced.dta", clear
			file write TabSampleComp "Main Sample (Unbalanced):       &"
		}
		else if (`i'==2) {
			use "Data_Cleaned/${CountryID}_Balanced.dta", clear
			file write TabSampleComp "Main Sample (Balanced):         &"
		}
		else if (`i'==3) {
			use "Data_Cleaned/${CountryID}_OnePercent.dta", clear
			file write TabSampleComp "One Percent Sample:             &"
		}
		
		if (`i'==0) {
			* Number of firm-years
			su Sales
			global Moment1_full = r(N)
			local Moment1_full_loc: di %12.0fc $Moment1_full
			file write TabSampleComp "`Moment1_full_loc' (100 \%)  &"
			
			* Number of unique firms
			egen IDNum=group(BvD_ID_Number)
			egen ID_unique = group(IDNum)
			su ID_unique
			global Moment2_full = r(max)
			local Moment2_full_loc: di %12.2fc $Moment2_full
			file write TabSampleComp "`Moment2_full_loc' (100 \%) \\"_n
		}
		else {
			* Number of firm-years
			su Sales
			local Moment_calc = r(N)
			local Moment: di  %12.0fc `Moment_calc'
			local Percent: di %3.1fc (`Moment_calc'/$Moment1_full)*100
			file write TabSampleComp "`Moment' (`Percent' \%)  &"
			
			* Number of unique firms
			egen ID_unique = group(IDNum)
			su ID_unique
			local Moment_calc = r(max)
			local Moment: di %12.0fc `Moment_calc'
			local Percent: di %3.1fc (`Moment_calc'/$Moment2_full)*100
			file write TabSampleComp "`Moment' (`Percent' \%) \\"_n
		}
	}
	file write TabSampleComp "\bottomrule"
	

	file close _all
restore