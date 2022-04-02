


preserve
		
		file close _all
		
		file open CrossCountry using Output/${CountryID}/OB_Share_Emp_Eurostat_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "

		keep IDNum Year nEmployees
		
		* Reformulation of Size Categories to match the EuroStat Sizes
		
				
		*----------------------
		* Size Category 
		*----------------------

		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if groups==0 | (groups==9)
		replace SizeCategory = 2 if (groups==10) | (groups==19)
		replace SizeCategory = 3 if (groups==20) | (groups==49)
		replace SizeCategory = 4 if (groups==50) | (groups==249)
		replace SizeCategory = 5 if (groups==250) | (groups==`max')
		drop groups 
		
		
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
		file write CrossCountry " \\  "
	
		file close _all
		
restore




*************************** Average Number of Firms per Size Category

preserve
		
		file close _all
		
		file open CrossCountry using Output/${CountryID}/OB_Share_nFirms_Eurostat_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "

		keep IDNum Year nEmployees
		
		* Reformulation of Size Categories to match the EuroStat Sizes
		
				
		*----------------------
		* Size Category 
		*----------------------

		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if groups==0 | (groups==9)
		replace SizeCategory = 2 if (groups==10) | (groups==19)
		replace SizeCategory = 3 if (groups==20) | (groups==49)
		replace SizeCategory = 4 if (groups==50) | (groups==249)
		replace SizeCategory = 5 if (groups==250) | (groups==`max')
		drop groups 
		
		
		drop if SizeCategory==.
		
		bysort SizeCategory Year : gen nvals = _n == 1
		replace nvals = sum(nvals)
        
		collapse (mean) nvals, by(SizeCategory)
		egen TotFirms = total(nvals)
			
		gen pct_nFirmsCat = 100*nvals/TotFirms
		
		levelsof SizeCategory, local(SizeCat)
		foreach i of local SizeCat{
			sum pct_nFirmsCat if SizeCategory==`i', detail
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
		file write CrossCountry " \\  "
	
		file close _all
		
restore
