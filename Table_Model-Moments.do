use "Data_Cleaned/CrossCountry_Dataset_Euro.dta", clear

	file close _all

	file open TabModMoments using Output/Cross-Country/Table_ModelMoments.m, write replace


	file write  TabModMoments %25s  ("Countries={")

	** Country Labels

	local First=1
	disp `First'
	foreach Country of global Countries{
		if `First'==1 {
			local First=0
		}
		else{
			file write  TabModMoments " , "	
		}
		
		file write  TabModMoments %13s ("`Country' ")	
	}
	file write  TabModMoments "};"	_n
	

	** All the Variables
	local Variables Emp_Std LnEmp_Std EmpGrowth_All_Avg EmpGrowth_All_Std  RaDToRev EmpShare_Top50Perc /// 
	EmpShare_Public  IPODiff_Emp_5Year IPODiff_Ass_5Year 
	

	foreach var of local Variables{
	
	
	file write  TabModMoments %25s ("`var' =[")
	local First=1
	disp `First'
	foreach Country of global Countries{
		if `First'==1 {
			local First=0
		}
		else{
			file write  TabModMoments " , "	
		}
		quietly su `var' if (CountryCode_2Digit=="`Country'")
		local Moment: di %12.4f r(mean)
		file write  TabModMoments "`Moment' "		
	}
	file write  TabModMoments "];"	_n
	
	
	}
	
	
	
	file close _all