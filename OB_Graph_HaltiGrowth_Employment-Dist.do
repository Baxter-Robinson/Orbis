
local BinWidth=0.1
local MinVal=-2
* Public: Year of IPO vs other years
preserve
	keep if FirmType == 6
	* Distribution of plants by employment growth (Haltiwanger) - Comparing Year of IPO
	twoway (hist EmpGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-IPOyear.pdf, replace 
	twoway (hist SalesGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist SalesGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Sales growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_SalesHaltiwanger-IPOyear.pdf, replace 

	twoway (hist ProfitGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12) ) ///
	(hist ProfitGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none) ), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Profits growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_ProfitsHaltiwanger-IPOyear.pdf, replace 

restore
* Public vs private
preserve	
	twoway (hist EmpGrowth_h if Private == 0, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if Private == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms") label(2 "Private Firms")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-PublicPrivate.pdf, replace 
restore


* Delisted vs non-delisted public
preserve
	keep if FirmType == 6
	gen public_delisted = 1 if Delisted_year <= Year & Delisted_year != .
	twoway (hist EmpGrowth_h if Private == 0, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if public_delisted == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Not delisted") label(2 "Public Firms - Delisted")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-PublicDelisted.pdf, replace 
restore
