preserve
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	* Create dummy for two years before and after IPO
	gen D_IPO_minus2 = 0
	replace D_IPO_minus2 = 1 if IPO_timescale == -2
	gen D_IPO_minus1 = 0
	replace D_IPO_minus1 = 1 if IPO_timescale == -1
	gen D_IPO = 0
	replace D_IPO = 1 if IPO_timescale == 0
	gen D_IPO_plus1 = 0
	replace D_IPO_plus1 = 1 if IPO_timescale == 1
	gen D_IPO_plus2 = 0
	replace D_IPO_plus2 = 1 if IPO_timescale == 2

	* DiD regressions
	xtreg nEmployees Age i.Year D_IPO*, fe
	xtreg Sales Age i.Year D_IPO*, fe
	xtreg SalesPerEmployee Age i.Year D_IPO*, fe
	
restore