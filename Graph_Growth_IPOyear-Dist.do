preserve
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	
	bysort IDNum: gen SalesGrowth_h = (Sales[_n]-Sales[_n-1])/((Sales[_n]+Sales[_n-1])/2)
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	bysort IDNum: gen ProfitGrowth_h = (GrossProfits[_n]-GrossProfits[_n-1])/((GrossProfits[_n]+GrossProfits[_n-1])/2)
	
	keep if IPO_year == Year
	
	histogram SalesGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_SalesGrowth-IPOYear.pdf, replace  
		 
	histogram EmpGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_EmpGrowth-IPOYear.pdf, replace  
		 
	histogram ProfitGrowth_h if (IPO_year>1960), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_GrossProfits-IPOYear.pdf, replace  

restore