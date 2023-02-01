
local BinWidth=0.2
local MinVal=-2

* Public vs private
preserve	
	twoway (hist EmpGrowth_h if Public == 1, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if Public == 0, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms") label(2 "Private Firms")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Dist-EmpGrowth_PriVsPub.pdf, replace 
restore


* Public: Year of IPO vs other years
preserve
	keep if Public==1
	* Distribution of plants by employment growth (Haltiwanger) - Comparing Year of IPO
	twoway (hist EmpGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Dist-EmpGrowth_IPOYear.pdf, replace 
	
	twoway (hist SalesGrowth_h if IPO_year == Year, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist SalesGrowth_h if IPO_year > Year | IPO_year < Year, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Sales growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Dist-SalesGrowth_IPOYear.pdf, replace 
	
	*Remove 
	replace ProfitGrowth_h=-2 if (ProfitGrowth_h<-2)
	replace ProfitGrowth_h=2 if (ProfitGrowth_h>2)

	twoway (hist ProfitGrowth_h if (IPO_year == Year), frac lcolor(gs12) fcolor(gs12)  width(0.4) start(`MinVal') ) ///
	(hist ProfitGrowth_h if (IPO_year ~= Year), frac lcolor(red) fcolor(none)  width(0.4) start(`MinVal') ), ///
	legend(label(1 "Public Firms - Year of IPO") label(2 "Public Firms - Other years")) ///
	xtitle("Profits growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Dist-ProfitGrowth_IPOYear.pdf, replace 

restore

* Delisted vs non-delisted public
preserve
	keep if Public==1
	gen public_delisted = 1 if Delisted_year <= Year & Delisted_year != .
	twoway (hist EmpGrowth_h if Public == 1, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')) ///
	(hist EmpGrowth_h if public_delisted == 1, frac lcolor(red) fcolor(none) width(`BinWidth') start(`MinVal')), ///
	legend(label(1 "Public Firms - Not delisted") label(2 "Public Firms - Delisted")) ///
	xtitle("Employment growth - Haltiwanger") graphregion(color(white))
	graph export Output/$CountryID/Dist-EmpGrowth_PublicVsDelisted.pdf, replace 
restore
