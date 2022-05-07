* input is the OB unbalanced panel by country
* output is a dataset for comparing the size distribution of firms and percentage
* of employment with the EuroStat dataset


/*
preserve

		keep IDNum Year nEmployees 
		
		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if (groups==0) | (groups==9)
		replace SizeCategory = 2 if (groups==10) | (groups==19)
		replace SizeCategory = 3 if (groups==20) | (groups==49)
		replace SizeCategory = 4 if (groups==50) | (groups==249)
		replace SizeCategory = 5 if (groups==250) | (groups==`max')
		drop groups 
		drop if SizeCategory==.
		
		bysort IDNum Year : gen nvals = _n == 1 
		bysort SizeCategory Year : egen nFirms = total(nvals) 
		bysort SizeCategory Year : egen nEmpCat = total(nEmployees) 
		
		sort IDNum Year SizeCategory
		
		collapse (mean) nEmpCat nFirms, by(SizeCategory)
		egen TotEmp = total(nEmpCat)
		gen pct_nEmpCat = 100*nEmpCat/TotEmp
		egen TotFirms = total(nFirms)
		
		
		frame create EuroStat
		frame change EuroStat
		use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta"
		
		
		keep if Country=="${CountryID}"
		*keep if Country=="IT"
		
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
		collapse (sum) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory Year)
		collapse (mean) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory)
		
		egen TotEmployees1_EuroStat = total(nEmployees1)
		egen TotEmployees2_EuroStat = total(nEmployees2)
		egen TotFirms_EuroStat = total(Firms)
		
		gen pct_nEmp1Cat_EuroStat = 100*nEmployees1/TotEmployees1_EuroStat
		gen pct_nEmp2Cat_EuroStat = 100*nEmployees2/TotEmployees2_EuroStat
		
		rename Firms Firms_EuroStat 
		rename nEmployees1 nEmployees1_EuroStat
		rename nEmployees2 nEmployees2_EuroStat
		drop Country Size
		
		
		frame change default
		frlink 1:1 SizeCategory, frame(EuroStat)
		frget Firms_EuroStat nEmployees1_EuroStat nEmployees2_EuroStat TotEmployees1_EuroStat TotEmployees2_EuroStat TotFirms_EuroStat pct_nEmp1Cat_EuroStat pct_nEmp2Cat_EuroStat, from(EuroStat)
		
		drop EuroStat
		
		gen floor = 0
		
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		graph twoway (rbar floor pct_nEmpCat SizeCategory, lcolor(gs12) fcolor(gs12))  ///
		(rbar floor pct_nEmp1Cat_EuroStat  SizeCategory, lcolor(red) fcolor(none) ), ///
		legend(label(1 "Orbis") label( 2 "EuroStat" ) ) ///
		ylabel(, format(%3.0fc))  ///
		xlabel(`Labels') ///
		xtitle("Size Category")  ytitle("(Average) Share of Employment") graphregion(color(white))
		graph export Output/$CountryID/OB_EuroStat_BySizeCat_ShareEmployment.pdf, replace 
		
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		graph twoway (rbar floor nEmpCat SizeCategory, lcolor(gs12) fcolor(gs12))  ///
		(rbar floor nEmployees1_EuroStat  SizeCategory, lcolor(red) fcolor(none) ), ///
		legend(label(1 "Orbis") label( 2 "EuroStat" ) ) ///
		ylabel(, format(%14.0fc))  ///
		xlabel(`Labels') ///
		xtitle("Size Category")  ytitle("(Average) Total Employment") graphregion(color(white))
		graph export Output/$CountryID/OB_EuroStat_BySizeCat_nEmployees.pdf, replace 
		
		local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
		graph twoway (rbar floor nFirms SizeCategory, lcolor(gs12) fcolor(gs12))  ///
		(rbar floor Firms_EuroStat  SizeCategory, lcolor(red) fcolor(none) ), ///
		legend(label(1 "Orbis") label( 2 "EuroStat" ) ) ///
		ylabel(, format(%3.0fc))  ///
		xlabel(`Labels') ///
		xtitle("Size Category")  ytitle("(Average) Number of Firms") graphregion(color(white))
		graph export Output/$CountryID/OB_EuroStat_BySizeCat_nFirms.pdf, replace 


restore
*/


preserve

		keep IDNum Year nEmployees 
		
		sum nEmployees, detail
		local max= r(max)
		egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')

		gen SizeCategory = . 
		replace SizeCategory = 1 if (groups==0) | (groups==9)
		replace SizeCategory = 2 if (groups==10) | (groups==19)
		replace SizeCategory = 3 if (groups==20) | (groups==49)
		replace SizeCategory = 4 if (groups==50) | (groups==249)
		replace SizeCategory = 5 if (groups==250) | (groups==`max')
		drop groups 
		drop if SizeCategory==.
		
		bysort IDNum Year : gen nvals = _n == 1 
		bysort SizeCategory Year : egen nFirms = total(nvals) 
		bysort SizeCategory Year : egen nEmpCat = total(nEmployees) 
		
		sort IDNum Year SizeCategory
		
		collapse (mean) nEmpCat nFirms, by(SizeCategory)
		egen TotEmp = total(nEmpCat)
		gen pct_nEmpCat = 100*nEmpCat/TotEmp
		egen TotFirms = total(nFirms)
		
		
		frame create EuroStat
		frame change EuroStat
		use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta"
		
		
		keep if Country=="${CountryID}"
		*keep if Country=="IT"
		
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
		collapse (sum) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory Year)
		collapse (mean) Firms nEmployees1 nEmployees2 (first) Country Size, by(SizeCategory)
		
		egen TotEmployees1_EuroStat = total(nEmployees1)
		egen TotEmployees2_EuroStat = total(nEmployees2)
		egen TotFirms_EuroStat = total(Firms)
		
		gen pct_nEmp1Cat_EuroStat = 100*nEmployees1/TotEmployees1_EuroStat
		gen pct_nEmp2Cat_EuroStat = 100*nEmployees2/TotEmployees2_EuroStat
		
		rename Firms Firms_EuroStat 
		rename nEmployees1 nEmployees1_EuroStat
		rename nEmployees2 nEmployees2_EuroStat
		drop Country Size
		
		
		frame change default
		frlink 1:1 SizeCategory, frame(EuroStat)
		frget Firms_EuroStat nEmployees1_EuroStat nEmployees2_EuroStat TotEmployees1_EuroStat TotEmployees2_EuroStat TotFirms_EuroStat pct_nEmp1Cat_EuroStat pct_nEmp2Cat_EuroStat, from(EuroStat)
		
		drop EuroStat
		
		gen floor = 0
		
		drop if SizeCategory==1
		drop if SizeCategory==2
		drop if SizeCategory==3
		
		local Labels  4 "50-249"  5 "250+" 
		graph twoway (rbar floor nFirms SizeCategory, lcolor(gs12) fcolor(gs12))  ///
		(rbar floor Firms_EuroStat  SizeCategory, lcolor(red) fcolor(none) ), ///
		legend(label(1 "Orbis") label( 2 "EuroStat" ) ) ///
		ylabel(, format(%3.0fc))  ///
		xlabel(`Labels') ///
		xtitle("Size Category")  ytitle("(Average) Number of Firms") graphregion(color(white))
		graph export Output/$CountryID/OB_EuroStat_BySizeCat_nFirms_50Plus.pdf, replace 


restore
