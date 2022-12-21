

preserve

	keep if EverPublic==1
	gen IPOy = 0
	replace IPOy = 1 if IPO_timescale==0
	gen IPO1y = 0
	gen IPO2y = 0
	replace IPO1y=1 if IPO_timescale==1
	replace IPO2y=1 if IPO_timescale==2
	
	* Regression of employment growth on Dummy for year of IPO
	reg EmpGrowth_h IPOy i.Year, vce(robust)
	eststo m1
	estadd local Year "Yes"
	estadd local Robust "Yes"

	* Columns w/ and w/out year after IPO and 2 years after year of IPO
    reg EmpGrowth_h IPO1y i.Year, vce(robust)
	eststo m2
	estadd local Year "Yes"
	estadd local Robust "Yes"
	
	reg EmpGrowth_h  IPOy IPO1y i.Year, vce(robust)
	eststo m2a
	estadd local Year "Yes"
	estadd local Robust "Yes"
	
	reg EmpGrowth_h IPO1y IPO2y i.Year, vce(robust)
	eststo m3
	estadd local Year "Yes"
	estadd local Robust "Yes"
	
	reg EmpGrowth_h IPOy IPO1y IPO2y i.Year, vce(robust)
	eststo m3a
	estadd local Year "Yes"
	estadd local Robust "Yes"
	
	
	* Columns w/ and w/out Public Dummy
	reg EmpGrowth_h IPOy Public i.Year, vce(robust)
	eststo m4
	estadd local Year "Yes"
	estadd local Robust "Yes"
	
    * Columns w/ and w/out number of employees
	reg EmpGrowth_h IPOy Public nEmployees i.Year, vce(robust)
	eststo m5
	estadd local Year "Yes"
	estadd local Robust "Yes"

	    * Columns w/ and w/out number of employees
	reg EmpGrowth_h IPOy IPO1y IPO2y Public nEmployees i.Year, vce(robust)
	eststo m6
	estadd local Year "Yes"
	estadd local Robust "Yes"
		
	esttab m1 m2 m2a m3 m3a m4 m5 m6 using "Output/$CountryID/OB_HGR_IPO_regs.tex", se legend mtitles("1" "2" "2a" "3" "3a"  "4" "5" "6") title("Haltiwanger growth rate") s(N Year Robust, label( "N" "Year Fixed Effect" "Robust S.E."))  varlabels(_cons "Constant" nEmployees "No. employees" IPOy "IPO year indicator" Public "Public firm" IPO1y "IPO year +1 indicator" IPO2y "IPO year +2 indicator") nonumbers keep( _cons nEmployees Public IPOy IPO1y IPO2y) replace fragment
	
restore

