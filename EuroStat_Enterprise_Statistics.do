*cls
*use "/Users/cyberdim/Dropbox/WESTERN_ECONOMICS/RA_Baxter/Eurostat/Annual_enterprise_Statistics/EuroStat_Enterprise_Statistics.dta", clear
*keep if Country=="IT"

preserve
		keep if Country=="${CountryID}"

		
		destring, replace
		keep Country Year NACE_Rev2 Size Firms nEmployees1 nEmployees2
		keep if Year>=2008
		keep if Year<=2016

		gen SizeCategory = . 
		replace SizeCategory = 1 if Size=="0-9"
		replace SizeCategory = 2 if Size=="10-19"
		replace SizeCategory = 3 if Size=="20-49"
		replace SizeCategory = 4 if Size=="50-249"
		replace SizeCategory = 5 if Size=="GE250"
		
		drop if Size=="TOTAL"
		
		gen keepers = 0
		replace keepers = 1 if inlist(NACE_Rev2,"B","C","D","E","F","G","H")
		replace keepers = 1 if inlist(NACE_Rev2,"I","J","L","M","N","S95")
		
		* The NACE_Rev=="B-N_S95_X_K" is Total Business Economy. Which is the sum of the above categories,
		* I prefer the disaggregation in case Baxter wants by sector 

		drop if keepers==0
		
		collapse (sum) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory Year)
		
		collapse (mean) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory)
		
		egen TotEmployees1 = total(nEmployees1)
		egen TotEmployees2 = total(nEmployees2)
		egen TotFirms = total(Firms)
		
		gen pct_nEmp1Cat = 100*nEmployees1/TotEmployees1
		gen pct_nEmp2Cat = 100*nEmployees2/TotEmployees2
		
		
		gen floor = 0
		gen roof = .
		
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		graph twoway (rbar floor pct_nEmp1Cat SizeCategory, color(maroon)),  ///
			legend(label(1 "Total Firms") ) ///
			ytitle("Percentage of Employment") ///
			ylabel(, format(%3.0fc)) ///
			xtitle("Number of Employees") ///
			xlabel(`Labels') ///
			graphregion(color(white))
		graph export Output/$CountryID/EuroStat_BySizeCat_ShareEmployment.pdf, replace 
		
restore


preserve

		file close _all
		
		file open CrossCountry using Output/${CountryID}/EuroStat_Share_Emp_Eurostat_Size_Category.tex, write replace
		file write CrossCountry " ${CountryID} & "
		keep if Country=="${CountryID}"
		
		destring, replace
		keep Country Year NACE_Rev2 Size Firms nEmployees1 nEmployees2
		keep if Year>=2008
		keep if Year<=2016
		
		gen SizeCategory = . 
		replace SizeCategory = 1 if Size=="0-9"
		replace SizeCategory = 2 if Size=="10-19"
		replace SizeCategory = 3 if Size=="20-49"
		replace SizeCategory = 4 if Size=="50-249"
		replace SizeCategory = 5 if Size=="GE250"
		
		drop if Size=="TOTAL"
		
		gen keepers = 0
		replace keepers = 1 if inlist(NACE_Rev2,"B","C","D","E","F","G","H")
		replace keepers = 1 if inlist(NACE_Rev2,"I","J","L","M","N","S95")
		
		* The NACE_Rev=="B-N_S95_X_K" is Total Business Economy. Which is the sum of the above categories,
		* I prefer the disaggregation in case Baxter wants by sector 

		drop if keepers==0
		
		collapse (sum) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory Year)
		
		collapse (mean) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory)
		
		egen TotEmployees1 = total(nEmployees1)
		egen TotEmployees2 = total(nEmployees2)
		egen TotFirms = total(Firms)
		
		gen pct_nEmp1Cat = 100*nEmployees1/TotEmployees1
		gen pct_nEmp2Cat = 100*nEmployees2/TotEmployees2
		
		levelsof SizeCategory, local(SizeCat)
		foreach i of local SizeCat{
			sum pct_nEmp1Cat if SizeCategory==`i', detail
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
		
		
		
preserve
				
		keep if Country=="${CountryID}"
		
		destring, replace
		keep Country Year NACE_Rev2 Size Firms nEmployees1 nEmployees2
		keep if Year>=2008
		keep if Year<=2016
		
		gen SizeCategory = . 
		replace SizeCategory = 1 if Size=="0-9"
		replace SizeCategory = 2 if Size=="10-19"
		replace SizeCategory = 3 if Size=="20-49"
		replace SizeCategory = 4 if Size=="50-249"
		replace SizeCategory = 5 if Size=="GE250"
		
		drop if Size=="TOTAL"
		
		gen keepers = 0
		replace keepers = 1 if inlist(NACE_Rev2,"B","C","D","E","F","G","H")
		replace keepers = 1 if inlist(NACE_Rev2,"I","J","L","M","N","S95")
		
		drop if keepers==0
		
		collapse (sum) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory Year NACE_Rev2)
		
		collapse (mean) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory)
		
		
		gen floor = 0
		
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		graph twoway (rbar floor Firms SizeCategory, color(maroon)),  ///
			ytitle("Number of Firms") ///
			ylabel(, format(%10.0fc)) ///
			xtitle("Number of Employees") ///
			xlabel(`Labels') ///
			graphregion(color(white))
		graph export Output/$CountryID/EuroStat_BySizeCat_nFirms.pdf, replace 
		
restore
