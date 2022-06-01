preserve

	gen IPO_timescale = Year - IPO_year
	drop if missing(IPO_timescale)

	
	

	gen YearIs_Zero=0
	replace YearIs_Zero=1 if (IPO_timescale==0)
	
	forval t=1/3{
		gen YearIs_Neg`t'=0
		replace YearIs_Neg`t'=1 if (IPO_timescale==-`t') 
		
		gen YearIs_Pos`t'=0
		replace YearIs_Pos`t'=1 if (IPO_timescale==`t') 
		
	}


	reghdfe nEmployees YearIs_*, absorb(IDNum)
	
	gen Beta_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
	gen SE_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
	
	forval t=1/3{
		
		replace Beta_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
		replace SE_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
		replace Beta_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
		replace SE_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
	}

	collapse (mean) Beta_ByIPOYear SE_ByIPOYear,  by(IPO_timescale)

	drop if (IPO_timescale<-3)
	drop if (IPO_timescale>3)
	
	gen high=Beta_ByIPOYear+1.96*SE_ByIPOYear
	gen low=Beta_ByIPOYear-1.96*SE_ByIPOYear
	
	
	
	
	graph twoway (scatter  Beta_ByIPOYear IPO_timescale) ///
	(rcap high low IPO_timescale)
	


restore