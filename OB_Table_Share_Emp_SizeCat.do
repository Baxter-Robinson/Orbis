





	preserve
		file close _all
		
		file open CrossCountry using Output/${CountryID}/OB_Share_Emp_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "
		/*
		 Table Add: Share of Employment by Size Categories. Similar to 2.1 (Data_Report_02_02_2022 version) but for size categories
		*/
		
		keep IDNum Year nEmployees 
			
		keep if nEmployees!=.
		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (1, 2, 5, 6, 10, 11, 50, 51, 100, 101, 1000, 1001, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if groups==1
		replace SizeCategory = 2 if (groups==2) | (groups==5)
		replace SizeCategory = 3 if (groups==6) | (groups==10)
		replace SizeCategory = 4 if (groups==11) | (groups==50)
		replace SizeCategory = 5 if (groups==51) | (groups==100)
		replace SizeCategory = 6 if (groups==101) | (groups==1000)
		replace SizeCategory = 7 if (groups==1001) | (groups==`max')

		forvalues i=2/7{
			gen SizeGroup`i' = 0
			replace SizeGroup`i' = 1 if SizeCat==`i'
		}

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
		
		file write CrossCountry %12.0gc (`SizeCat1')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat2')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat3')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat4')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat5')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat6')
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`SizeCat7')
		file write CrossCountry " \\  "
	
		file close _all
		
	restore
