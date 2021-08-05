* Public: Year of IPO vs other years
preserve
	duplicates drop IDNum Year , force
	xtset IDNum Year
	* Haltiwanger measure of employment growth
	bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)
	* Distribution of plants by employment growth (Haltiwanger) - Comparing Year of IPO
	twoway (hist EmpGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12)) ///
	(hist EmpGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none)), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger_Compustat-IPOyear.pdf, replace 
restore