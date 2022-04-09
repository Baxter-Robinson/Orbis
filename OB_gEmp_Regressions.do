

preserve

	keep IDNum nEmployees Private EmpGrowth_h NACE_Rev_2_Core_code_4_digits Year US_SIC_Core_code_3_digits Industry_4digit

	destring US_SIC_Core_code_3_digits, replace

	gen missingNACE = 0
	replace missingNACE=1 if missing(Industry_4digit) 

	gen missingSIC = 0
	replace missingSIC=1 if missing(US_SIC_Core_code_3_digits) 


	/*
	-regression specifications: 
	gEmp_ft = const + alpha * lnEmp + beta * lnEmp*1{Private} + Sector FE + Time FE + error
	Where lnEmp is log of employment. 
	*/
	destring, replace 
	gen lnEmp = log(nEmployees)
	*gen lnEmp = asinh(nEmployees)
	gen lnEmp_Priv = lnEmp*Private 

	xtset IDNum Year

	* Using the NACE Rev.2 4-digit codes

	reg EmpGrowth_h lnEmp Private, robust
	eststo m1
	estadd local Sector "No"
	estadd local Year "No"
	estadd local Robust "Yes"


	reghdfe EmpGrowth_h lnEmp Private, absorb( Year) vce(robust)
	eststo m1a
	estadd local Sector "No"
	estadd local Year "Yes"
	estadd local Robust "Yes"


	reghdfe EmpGrowth_h lnEmp Private, absorb(Industry_4digit Year) vce(robust)
	eststo m1b
	estadd local Sector "Yes"
	estadd local Year "Yes"
	estadd local Robust "Yes"

	esttab m1 m1a m1b  using "Output/$CountryID/OB_Emp_growth_regs_NACE.tex", se legend mtitles("NACE Rev2 4-digit Sectors" "NACE Rev2 4-digit Sectors" "NACE Rev2 4-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" lnEmp "(Log of) No. employees" Private "Private Firm") nonumbers keep( _cons lnEmp Private) replace fragment

	* Using the SIC 3-digit codes

	reg EmpGrowth_h lnEmp Private, robust
	eststo m2
	estadd local Sector "No"
	estadd local Year "No"
	estadd local Robust "Yes"

	reghdfe EmpGrowth_h lnEmp Private, absorb( Year) vce(robust)
	eststo m2a
	estadd local Sector "No"
	estadd local Year "Yes"
	estadd local Robust "Yes"

	reghdfe EmpGrowth_h lnEmp Private, absorb(US_SIC_Core_code_3_digits Year) vce(robust)
	eststo m2b
	estadd local Sector "Yes"
	estadd local Year "Yes"
	estadd local Robust "Yes"

	esttab m2 m2a m2b using "Output/$CountryID/OB_Emp_growth_regs_SIC.tex", se legend mtitles("US SIC 3-digit Sectors" "US SIC 3-digit Sectors" "US SIC 3-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" lnEmp "(Log of) No. employees" Private "Private Firm") nonumbers keep( _cons lnEmp Private) replace fragment

restore





* ----------------------------------------------------------------------------


preserve


	/* 
	gEmp_ft = const + alpha * SizeCat + beta * SizeCat*1{Private} + Sector FE + Time FE + error

	Where SizeCat is a set of BINARY variables over for the values {1,2-10,11-50,51-200,201-999,1000+} 
	*/


	keep IDNum nEmployees Private EmpGrowth_h NACE_Rev_2_Core_code_4_digits Year US_SIC_Core_code_3_digits Industry_4digit SizeCategory

	destring US_SIC_Core_code_3_digits, replace

	gen missingNACE = 0
	replace missingNACE=1 if missing(Industry_4digit) 

	gen missingSIC = 0
	replace missingSIC=1 if missing(US_SIC_Core_code_3_digits) 

	destring, replace 

	keep if nEmployees!=.

	forvalues i=2/7{
		gen SizeGroup`i' = 0
		replace SizeGroup`i' = 1 if SizeCategory==`i'
	}

	* Interactions

	foreach x of var SizeGroup1 SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7{
		gen `x'_Priv = Private*`x'
	}

	xtset IDNum Year


	* Using the NACE Rev.2 4-digit codes

	reg EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv,  robust
	eststo m1
	estadd local Sector "No"
	estadd local Year "No"
	estadd local Robust "Yes"

	reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv , absorb(Year) vce(robust)
	eststo m1a
	estadd local Sector "No"
	estadd local Year "Yes"
	estadd local Robust "Yes"

	reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv, absorb(Industry_4digit Year) vce(robust)
	eststo m1b
	estadd local Sector "Yes"
	estadd local Year "Yes"
	estadd local Robust "Yes"


	esttab m1 m1a m1b using "Output/$CountryID/OB_Emp_growth_regs_SizeCats_NACE.tex", se legend mtitles("NACE Rev2 4-digit Sectors" "NACE Rev2 4-digit Sectors" "NACE Rev2 4-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" SizeGroup2 "2-5 Employees" SizeGroup3 "6-10 Employees" SizeGroup4 "11-50 Employees" SizeGroup5 "51-100 Employees" SizeGroup6 "101-1000 Employees" SizeGroup7 "More than 1000 Employees"  SizeGroup1_Priv "1 Employee x Private" SizeGroup2_Priv "2-5 Employees x Private" SizeGroup3_Priv "6-10 Employees x Private" SizeGroup4_Priv "11-50 Employees x Private" SizeGroup5_Priv "51-100 Employees x Private" SizeGroup6_Priv "101-1000 Employees x Private" SizeGroup7_Priv "More than 1000 Employees x Private") nonumbers keep( _cons SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv) replace fragment


	* Using the SIC 3-digit codes

	reg EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv, robust
	eststo m2
	estadd local Sector "No"
	estadd local Year "No"
	estadd local Robust "Yes"


	reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv, absorb(Year) vce(robust)
	eststo m2a
	estadd local Sector "No"
	estadd local Year "Yes"
	estadd local Robust "Yes"

	reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv, absorb(US_SIC_Core_code_3_digits Year) vce(robust)
	eststo m2b
	estadd local Sector "Yes"
	estadd local Year "Yes"
	estadd local Robust "Yes"



	esttab m2 m2a m2b using "Output/$CountryID/OB_Emp_growth_regs_SizeCats_SIC.tex", se legend mtitles("US SIC 3-digit Sectors" "US SIC 3-digit Sectors" "US SIC 3-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" SizeGroup2 "2-5 Employees" SizeGroup3 "6-10 Employees" SizeGroup4 "11-50 Employees" SizeGroup5 "51-100 Employees" SizeGroup6 "101-1000 Employees" SizeGroup7 "More than 1000 Employees"   SizeGroup1_Priv "1 Employee x Private"  SizeGroup2_Priv "2-5 Employees x Private" SizeGroup3_Priv "6-10 Employees x Private" SizeGroup4_Priv "11-50 Employees x Private" SizeGroup5_Priv "51-100 Employees x Private" SizeGroup6_Priv "101-1000 Employees x Private" SizeGroup7_Priv "More than 1000 Employees x Private") nonumbers keep( _cons SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6  SizeGroup7 SizeGroup1_Priv SizeGroup2_Priv SizeGroup3_Priv SizeGroup4_Priv SizeGroup5_Priv SizeGroup6_Priv SizeGroup7_Priv) replace fragment




restore 




































