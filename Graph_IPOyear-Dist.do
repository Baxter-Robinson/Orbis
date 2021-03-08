preserve
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	
	histogram IPO_year if (IPO_year>1960), width(1)  graphregion(color(white)) xlabel(1960[20]2020) frequency
         graph export Output/$CountryID/Distribution_IPO-Year.pdf, replace  

restore