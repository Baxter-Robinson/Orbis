* input is the OB unbalanced panel by country
* output is a dataset for comparing the size distribution of firms and percentage
* of employment with the EuroStat dataset

use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear



	keep IDNum Year nEmployees SizeCategoryES ESWeights NoWeights
		

	gen nEmployees_ESwgt=nEmployees*ESWeights

	bysort SizeCategoryES Year : egen nFirms1 = total(NoWeights)
	bysort SizeCategoryES Year : egen nFirms2 = total(ESWeights)
	bysort SizeCategoryES Year : egen nEmpCat1 = total(nEmployees) 
	bysort SizeCategoryES Year : egen nEmpCat2 = total(nEmployees_ESwgt) 

	collapse (mean) nEmpCat* nFirms* , by(SizeCategory Year)
	
	collapse (mean) nEmpCat* nFirms* , by(SizeCategory)

	reshape long nEmpCat nFirms , i(SizeCategory) j(Weights_temp)
	
	gen Weights="ES" if (Weights_temp==2)
	replace Weights="No" if (Weights_temp==1)
	
	drop Weights_temp
	
	gen DataSet="OB"
	
	rename nEmpCat nEmployees
	
	gen Country="${CountryID}"
	append using "Data_Cleaned/EuroStat_Cleaned.dta"
	keep if (Country=="${CountryID}")
	replace DataSet="ES" if (DataSet!="OB")
	
	drop Country
	
	
	gen xAxis1=SizeCategory-0.3
	gen xAxis2=SizeCategory
	gen xAxis3=SizeCategory+0.3
		
	local Labels  1 "0-9" 2 "10-19"  3 "20-49" 4 "50-249" 5 "250+" 
	
	replace nEmployees=nEmployees/1000000
	
	
	graph twoway (bar nEmployees xAxis1 if (DataSet=="ES") ,barwidth(0.3)) ///
	 (bar nEmployees xAxis2 if (DataSet=="OB") & (Weights=="No"), barwidth(0.3))   ///
	 (bar nEmployees xAxis3 if (DataSet=="OB") & (Weights=="ES"), lcolor(gs12) fcolor(gs12) barwidth(0.3))   ///
	,legend(label(1 "EuroStat") label( 2 "Orbis (Unweighted)" ) label( 3 "Orbis (Weighted)" ) ) ///
	ylabel(, format(%3.0fc))  ///
	xlabel(`Labels') ///
	xtitle("Size Category")  ytitle("Millions of Employees") graphregion(color(white))
	graph export Output/$CountryID/Valid_OB-EuroStat_nEmployees.pdf, replace 
	
	
	replace nFirms=nFirms/1000000
	
	graph twoway (bar nFirms xAxis1 if (DataSet=="ES") ,barwidth(0.3)) ///
	 (bar nFirms xAxis2 if (DataSet=="OB") & (Weights=="No"), barwidth(0.3))   ///
	 (bar nFirms xAxis3 if (DataSet=="OB") & (Weights=="ES"), lcolor(gs12) fcolor(gs12) barwidth(0.3))   ///
	,legend(label(1 "EuroStat") label( 2 "Orbis (Unweighted)" ) label( 3 "Orbis (Weighted)" ) ) ///
	ylabel(, format(%3.1fc))  ///
	xlabel(`Labels') ///
	xtitle("Size Category")  ytitle("Millions of Firms") graphregion(color(white))
	graph export Output/$CountryID/Valid_OB-EuroStat_nFirms.pdf, replace 
	
	
		
	graph twoway (bar nFirms xAxis1 if (DataSet=="ES") & (SizeCategoryES>1) ,barwidth(0.3)) ///
	 (bar nFirms xAxis2 if (DataSet=="OB") & (Weights=="No") & (SizeCategoryES>1), barwidth(0.3))   ///
	 (bar nFirms xAxis3 if (DataSet=="OB") & (Weights=="ES") & (SizeCategoryES>1), lcolor(gs12) fcolor(gs12) barwidth(0.3))   ///
	,legend(label(1 "EuroStat") label( 2 "Orbis (Unweighted)" ) label( 3 "Orbis (Weighted)" ) ) ///
	ylabel(, format(%3.1fc))  ///
	xlabel(`Labels') ///
	xtitle("Size Category")  ytitle("Millions of Firms") graphregion(color(white))
	graph export Output/$CountryID/Valid_OB-EuroStat_nFirms_Zoomed.pdf, replace 
	
	