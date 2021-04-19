preserve
	* Haltiwanger measure of employment groweth
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Distribution of plants by employment growth (Haltiwanger) - Comparing Year of IPO
	twoway (hist EmpGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12)) ///
	(hist EmpGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none)), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-IPOyear.pdf, replace 
restore