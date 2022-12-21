





	preserve
		file close _all
		
		file open CrossCountry using Output/${CountryID}/OB_Share_Emp_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "
		
		keep IDNum Year nEmployees SizeCategoryAR

		drop if SizeCategoryAR==.
		
		bysort SizeCategoryAR Year : egen nEmpCat = total(nEmployees) 
	
		collapse (mean) nEmpCat, by(SizeCategoryAR)
		egen TotEmp = total(nEmpCat)
			
		gen pct_nEmpCat = 100*nEmpCat/TotEmp
		
		levelsof SizeCategoryAR, local(SizeCat)
		foreach i of local SizeCat{
			sum pct_nEmpCat if SizeCategoryAR==`i', detail
			local SizeCat`i' = r(mean)
		}
		
		file write CrossCountry %10.1fc (`SizeCat1')
		file write CrossCountry " &  "
		file write CrossCountry %10.1fc (`SizeCat2')
		file write CrossCountry " &  "
		file write CrossCountry %10.1fc (`SizeCat3')
		file write CrossCountry " &  "
		file write CrossCountry %4.1fc (`SizeCat4')
		file write CrossCountry " &  "
		file write CrossCountry %4.1fc (`SizeCat5')
		file write CrossCountry " &  "
		file write CrossCountry %4.1fc (`SizeCat6')
		file write CrossCountry " &  "
		file write CrossCountry %4.1fc (`SizeCat7')
		file write CrossCountry " \\  "
	
		file close _all
		
	restore
