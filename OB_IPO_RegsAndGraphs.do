local nYears=5

preserve

	gen LnEmployees=ln(nEmployees)

	gen YearIs_Zero=0
	replace YearIs_Zero=1 if (IPO_timescale==0)
	
	forval t=1/`nYears'{
		gen YearIs_Neg`t'=0
		replace YearIs_Neg`t'=1 if (IPO_timescale==-`t') 
		
		gen YearIs_Pos`t'=0
		replace YearIs_Pos`t'=1 if (IPO_timescale==`t') 
		
	}

	local YearsInOrder 
	forval t=`nYears'(-1)1{
		local YearsInOrder `YearsInOrder' YearIs_Neg`t'
	}
	local YearsInOrder `YearsInOrder' YearIs_Zero
	forval t=1/`nYears'{
		local YearsInOrder `YearsInOrder' YearIs_Pos`t'
	}

	bysort IDNum: egen nEmployees_Mean=mean(nEmployees) 
	gen PropEmployees=nEmployees/nEmployees_Mean*100
	
	
	eststo clear
	** Employment Regressions
	eststo: reg PropEmployees `YearsInOrder'
	eststo: reg PropEmployees `YearsInOrder' Public LnEmployees c.LnEmployees#c.LnEmployees i.Year i.Industry_2digit 
	eststo: reg LnEmployees `YearsInOrder'
	eststo: reg LnEmployees `YearsInOrder'  Public i.Year i.Industry_2digit 
	eststo: reg EmpGrowth_h  `YearsInOrder'
	eststo: reg EmpGrowth_h  `YearsInOrder'  Public LnEmployees c.LnEmployees#c.LnEmployees i.Year i.Industry_2digit 
	
	esttab using "Output/$CountryID/IPO_Reg_Emp.tex", replace se fragment ///
	indicate("Constant=_cons" "Year FE=*.Year" "Industry FE=*.Industry_2digit") label stats(N, labels(N)) ///
	mlabels("PropEmp" "PropEmp" "LnEmployees" "LnEmployees"  "EmpGrowth" "EmpGrowth" )
	
	
	/*
	*reg EmpGrowth_h YearIs_* Public LnEmployees c.LnEmployees#c.LnEmployees //i.Year#Industry_2digit 
	
	gen BetaEmp_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
	gen SEEmp_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
	
	forval t=1/`nYears'{
		
		replace BetaEmp_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
		replace SEEmp_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
		replace BetaEmp_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
		replace SEEmp_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
	}
	
	collapse (mean) BetaEmp_ByIPOYear SEEmp_ByIPOYear   ,  by(IPO_timescale)

		drop if (IPO_timescale<-`nYears')
		drop if (IPO_timescale>`nYears')
		
		gen highEmp=BetaEmp_ByIPOYear+1.96*SEEmp_ByIPOYear
		gen lowEmp=BetaEmp_ByIPOYear-1.96*SEEmp_ByIPOYear

		graph twoway (scatter  BetaEmp_ByIPOYear IPO_timescale) ///
		(rcap highEmp lowEmp IPO_timescale), ///
		xtitle("Years Around IPO") graphregion(color(white))
		*graph export Output/$CountryID/IPO_PropEmployees_`nYears'.pdf, replace 
	
	
	*/
restore