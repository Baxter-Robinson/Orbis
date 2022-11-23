
use "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", clear
append using "Data_Cleaned/${CountryID}_Validation_bySize_ES.dta"



** Print out table of nFirms by Size Category for each dataset
local DataSets OB ES
local Set="ES"
foreach Set of local DataSets{
	local t=${FirstYear}
	forval t=$FirstYear/$LastYear{

		file close _all
		file open nFirmsFile using Output/${CountryID}/Validation_`Set'_BySize_nFirms_`t'.tex, write replace
		file open nEmpFile using Output/${CountryID}/Validation_`Set'_BySize_nEmp_`t'.tex, write replace
		file write nFirmsFile " ${CountryID} `Set' (`t') & "
		file write nEmpFile " ${CountryID} `Set' (`t') & "
		local i=1
		forval i=1/5{
			sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="`Set'")
			local Moment: di %12.0fc r(mean)
			file write  nFirmsFile " `Moment' & "	
			sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="`Set'")	
			local Moment: di %12.0fc r(mean)
			file write  nEmpFile " `Moment' & "		
		}
			sum nFirms if ( Year==`t' & DataSet=="`Set'")
			local Moment: di %12.0fc r(sum)
			file write  nFirmsFile " `Moment'  "	
			sum nEmployees if ( Year==`t' & DataSet=="`Set'")
			local Moment: di %12.0fc r(sum)
			file write  nEmpFile " `Moment'  "		
		
		file close _all
	}

}
*/

** Print out table of (nFirms in Orbis)/(nFirms in EuroStat) by Size Category for each dataset
local t=${FirstYear}
forval t=$FirstYear/$LastYear{

	file close _all
	file open nFirmsFile using Output/${CountryID}/Validation_ObvsES_BySize_nFirms_`t'.tex, write replace
	file open nEmpFile using Output/${CountryID}/Validation_ObvsES_BySize_nEmp_`t'.tex, write replace
	file write nFirmsFile " ${CountryID} OB/ES (`t') & "
	file write nEmpFile " ${CountryID}  OB/ES  (`t') & "

	local i=1
	forval i=1/5{
		sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="OB")
		local OBMoment=r(mean)
		sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="ES")
		local ESMoment=r(mean)
		local Moment : di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nFirmsFile " `Moment' & "		

		sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="OB")
		local OBMoment=r(mean)
		sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="ES")
		local ESMoment=r(mean)
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nEmpFile " `Moment' & "			
	}
		sum nFirms if (Year==`t' & DataSet=="OB")
		local OBMoment=r(sum)
		sum nFirms if (Year==`t' & DataSet=="ES")
		local ESMoment=r(sum)
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nFirmsFile " `Moment'  "
		
		sum nEmployees if (Year==`t' & DataSet=="OB")
		local OBMoment=r(sum)
		disp(`OBMoment')
		sum nEmployees if (Year==`t' & DataSet=="ES")
		local ESMoment=r(sum)
		disp(`ESMoment')
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		disp(`Moment')
		file write  nEmpFile " `Moment' "			
	
	file close _all
}



******************************************************************
** Average Across Years
******************************************************************
drop if (Year<${FirstYear} | Year> ${LastYear})

collapse (mean) nFirms nEmployees, by(SizeCategory DataSet)


** Print out table of nFirms by Size Category for each dataset
local DataSets OB ES
local Set="ES"
foreach Set of local DataSets{

	file close _all
	file open nFirmsFile using Output/${CountryID}/Validation_`Set'_BySize_nFirms_AvgOverYears.tex, write replace
	file open nEmpFile using Output/${CountryID}/Validation_`Set'_BySize_nEmp_AvgOverYears.tex, write replace
	file write nFirmsFile " ${CountryID} `Set' (Average) & "
	file write nEmpFile " ${CountryID} `Set' (Average) & "
	local i=1
	forval i=1/5{
		sum nFirms if (SizeCategory==`i' & DataSet=="`Set'")
		local Moment: di %12.0fc r(mean)
		file write  nFirmsFile " `Moment' & "	
		sum nEmployees if (SizeCategory==`i' & DataSet=="`Set'")	
		local Moment: di %12.0fc r(mean)
		file write  nEmpFile " `Moment' & "		
	}
		sum nFirms if ( DataSet=="`Set'")
		local Moment: di %12.0fc r(sum)
		file write  nFirmsFile " `Moment'  "	
		sum nEmployees if ( DataSet=="`Set'")
		local Moment: di %12.0fc r(sum)
		file write  nEmpFile " `Moment'  "		
	
	file close _all

}
*/

** Print out table of (nFirms in Orbis)/(nFirms in EuroStat) by Size Category for each dataset

	file close _all
	file open nFirmsFile using Output/${CountryID}/Validation_ObvsES_BySize_nFirms_AvgOverYears.tex, write replace
	file open nEmpFile using Output/${CountryID}/Validation_ObvsES_BySize_nEmp_AvgOverYears.tex, write replace
	file write nFirmsFile " ${CountryID} OB/ES (Average) & "
	file write nEmpFile " ${CountryID}  OB/ES  (Average) & "

	local i=1
	forval i=1/5{
		sum nFirms if (SizeCategory==`i' & DataSet=="OB")
		local OBMoment=r(mean)
		sum nFirms if (SizeCategory==`i'  & DataSet=="ES")
		local ESMoment=r(mean)
		local Moment : di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nFirmsFile " `Moment' & "		

		sum nEmployees if (SizeCategory==`i'  & DataSet=="OB")
		local OBMoment=r(mean)
		sum nEmployees if (SizeCategory==`i' & DataSet=="ES")
		local ESMoment=r(mean)
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nEmpFile " `Moment' & "			
	}
		sum nFirms if (DataSet=="OB")
		local OBMoment=r(sum)
		sum nFirms if ( DataSet=="ES")
		local ESMoment=r(sum)
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nFirmsFile " `Moment'  "
		
		sum nEmployees if (DataSet=="OB")
		local OBMoment=r(sum)
		sum nEmployees if (DataSet=="ES")
		local ESMoment=r(sum)
		local Moment: di %12.0fc `OBMoment'/`ESMoment'*100
		file write  nEmpFile " `Moment' "			
	
	file close _all
