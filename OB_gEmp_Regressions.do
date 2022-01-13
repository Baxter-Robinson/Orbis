

preserve

keep IDNum nEmployees Private EmpGrowth_h NACE_Rev_2_Core_code_4_digits Year US_SIC_Core_code_3_digits

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

reghdfe EmpGrowth_h lnEmp lnEmp_Priv, absorb(NACE_Rev_2_Core_code_4_digits Year)
eststo m1
estadd local Sector "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


* Using the SIC 3-digit codes

reghdfe EmpGrowth_h lnEmp lnEmp_Priv, absorb(US_SIC_Core_code_3_digits Year)
eststo m2
estadd local Sector "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


esttab m1 m2 using "Output/$CountryID/OB_Emp_growth_regs_logs.tex", se legend mtitles("NACE Rev2 4-digit Sectors" "US SIC 3-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" lnEmp "(Log of) No. employees" lnEmp_Priv "(Log of) No. employees x Private") nonumbers keep( _cons lnEmp lnEmp_Priv) replace fragment

restore





* ----------------------------------------------------------------------------


preserve


/* 
gEmp_ft = const + alpha * SizeCat + beta * SizeCat*1{Private} + Sector FE + Time FE + error

Where SizeCat is a set of BINARY variables over for the values {1,2-10,11-50,51-200,201-999,1000+} 
*/


keep IDNum nEmployees Private EmpGrowth_h NACE_Rev_2_Core_code_4_digits Year US_SIC_Core_code_3_digits

destring, replace 
keep if nEmployees!=.
sum nEmployees, detail
local max= r(max)
egen groups  = cut(nEmployees), at (1, 2, 10, 11, 50, 51, 200, 201, 999, 1000, `max')

gen SizeCat = . 
replace SizeCat = 1 if groups==1
replace SizeCat = 2 if (groups==2) | (groups==10)
replace SizeCat = 3 if (groups==11) | (groups==50)
replace SizeCat = 4 if (groups==51) | (groups==200)
replace SizeCat = 5 if (groups==201) | (groups==999)
replace SizeCat = 6 if (groups==1000) | (groups==`max')

forvalues i=2/6{
	gen SizeGroup`i' = 0
	replace SizeGroup`i' = 1 if SizeCat==`i'
}


xtset IDNum Year

* Using the NACE Rev.2 4-digit codes

reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 Private, absorb(NACE_Rev_2_Core_code_4_digits Year)
eststo m1
estadd local Sector "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


* Using the SIC 3-digit codes

reghdfe EmpGrowth_h SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 Private, absorb(US_SIC_Core_code_3_digits Year)
eststo m2
estadd local Sector "Yes"
estadd local Year "Yes"
estadd local Robust "Yes"


esttab m1 m2 using "Output/$CountryID/OB_Emp_growth_regs_SizeCats.tex", se legend mtitles("NACE Rev2 4-digit Sectors" "US SIC 3-digit Sectors") title("Employment growth") s(N Sector Year Robust, label( "N" "Sector Fixed Effect" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" SizeGroup2 "2-10 Employees" SizeGroup3 "11-50 Employees" SizeGroup4 "51-200 Employees" SizeGroup5 "201-999 Employees" SizeGroup6 "More than 1000 Employees" Private "Private Firm") nonumbers keep( _cons SizeGroup2 SizeGroup3 SizeGroup4 SizeGroup5 SizeGroup6 Private) replace fragment




restore 



































