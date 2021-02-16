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
			file write TabSampleComp "Main Sample (Unbalanced): &"
		}
		else if (`i'==2) {
			use "Data_Cleaned/${CountryID}_Balanced.dta", clear
			file write TabSampleComp "Main Sample (Balanced):   &"
		}
		else if (`i'==3) {
			use "Data_Cleaned/${CountryID}_OnePercent.dta", clear
			file write TabSampleComp "One Percent Sample:             &"
		}
		
		if (`i'==0) {
			* Number of firm-years
			su Sales
			global Moment1_full: di r(N)
			file write TabSampleComp " $Moment1_full (100 \%) & "
			
			* Number of unique firms
			egen IDNum=group(BvD_ID_Number)
			egen ID_unique = group(IDNum)
			su ID_unique
			global Moment2_full: di r(max)
			file write TabSampleComp " $Moment2_full (100 \%) \\"_n
		}
		else {
			* Number of firm-years
			su Sales
			local Moment: di r(N)
			local Percent: di %8.2fc (`Moment'/$Moment1_full)*100
			file write TabSampleComp " `Moment' (`Percent' \%) & "
			
			* Number of unique firms
			egen ID_unique = group(IDNum)
			su ID_unique
			local Moment: di r(max)
			local Percent: di %8.2fc (`Moment'/$Moment2_full)*100
			file write TabSampleComp " `Moment' (`Percent' \%) \\"_n
		}
	}
	

	file close _all


	restore