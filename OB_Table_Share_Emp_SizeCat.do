





	preserve
		file close _all
		
		file open CrossCountry using Output/${CountryID}/OB_Share_Emp_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "
		
		keep IDNum Year nEmployees SizeCategory

		drop if SizeCategory==.
		
		bysort SizeCategory Year : egen nEmpCat = total(nEmployees) 
	
		collapse (mean) nEmpCat, by(SizeCategory)
		egen TotEmp = total(nEmpCat)
			
		gen pct_nEmpCat = 100*nEmpCat/TotEmp
		
		levelsof SizeCategory, local(SizeCat)
		foreach i of local SizeCat{
			sum pct_nEmpCat if SizeCategory==`i', detail
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
