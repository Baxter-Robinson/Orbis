
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
	gen private = 1 if FirmType != 6 | (FirmType == 6 & Year >= Delisted_year)
	gen public = 1 if FirmType == 6
	replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year
	twoway (hist EmpGrowth_h if public == 1, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if private == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms") label(2 "Private Firms")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-PublicPrivate.pdf, replace 
restore


foreach v in COGS_h Revenue_h Export_revenue_h Assets_h EBITDA_h  SalesGrowth_h ProfitGrowth_h{
		preserve
		gen private = 1 if FirmType != 6 | (FirmType == 6 & Year >= Delisted_year)
		gen public = 1 if FirmType == 6
		replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year
		sum `v', detail
		return list
		gen range_`v' = r(max)-r(min)
		replace `v' = `v'/range_`v'
		drop range_`v'
		twoway (hist `v' if public == 1, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
		(hist `v' if private == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
		legend(label(1 "Public Firms") label(2 "Private Firms")) ///
		xtitle("`v' growth - Haltiwanger") graphregion(color(white))
		graph export Output/$CountryID/Distribution_`v'_Haltiwanger-PublicPrivate.pdf, replace 
	restore
	
	}

* Delisted vs non-delisted public
preserve
	keep if FirmType == 6
	gen public_delisted = 1 if Delisted_year <= Year & Delisted_year != .
	gen public = 1 if FirmType == 6
	replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year
	twoway (hist EmpGrowth_h if public == 1, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if public_delisted == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Not delisted") label(2 "Public Firms - Delisted")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Distribution_EmploymentHaltiwanger-PublicDelisted.pdf, replace 
restore
