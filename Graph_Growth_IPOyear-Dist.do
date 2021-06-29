preserve

	keep if IPO_year == Year
	
	histogram SalesGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_SalesGrowth-IPOYear.pdf, replace  
		 
	histogram EmpGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_EmpGrowth-IPOYear.pdf, replace  
		 
	histogram ProfitGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_GrossProfits-IPOYear.pdf, replace  

restore