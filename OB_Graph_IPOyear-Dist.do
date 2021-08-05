preserve

	
	keep IDNum Year IPO_year
	reshape wide IPO_year, i(IDNum) j(Year)
	egen IPO_year = rowmean(IPO_year*)
	
	histogram IPO_year if (IPO_year>1960), width(1)  graphregion(color(white)) xlabel(1960[20]2020) frequency
         graph export Output/$CountryID/Distribution_IPO-Year.pdf, replace  

restore