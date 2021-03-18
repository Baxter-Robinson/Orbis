preserve
	* Desired number of years before and after
	local n = 2
	* Rescale variables
	replace Sales = Sales/1000
	replace SalesPerEmployee = SalesPerEmployee/1000
	replace GrossProfits = GrossProfits/1000
	gen Profitability = GrossProfits/Sales
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	* Only keep first where we have observations for the variable of interest
	drop if missing($v)
	* Only keep IPO firms where we observe them +/- nyear relative to IPO (dealing with sample selection of IPO firms)
	gen PlusMinus_all = 1 if IPO_timescale == 0
	forvalues i = 1/`n'{
		replace PlusMinus_all = 1 if (IPO_timescale == -`i') | (IPO_timescale == `i')
	}
	egen PlusMinus = total(PlusMinus_all), by(IDNum)
	local size = (2*`n')+1
	replace PlusMinus = . if PlusMinus < `size'
	replace PlusMinus = 1 if PlusMinus == `size'
	* Deal with selection in France and Italy
	if ("$CountryID" == "FR") | ("$CountryID" == "IT") {
		drop if (IPO_year != .) & (PlusMinus == .)
	}
	* Only keep firms where we have at least the same number of observations as +/- nyear, i.e. (2*nyear)+1
	egen nyear = total(inrange(Year, 1984, 2019)), by(IDNum)
	drop if (nyear < `size')
	*Number of unique IPO firms after dealing with selection
	egen unique_IPO = group(IDNum) if IPO_year != .
	su unique_IPO 
	local N: di %12.0fc r(max)
	* Create dummy for nyears before and after IPO
	gen D_IPO = 0
	replace D_IPO = 1 if IPO_timescale == 0
	forvalues i = 1/`n' {
		gen D_IPO_minus`i' = 0
		gen D_IPO_plus`i' = 0
		replace D_IPO_minus`i' = 1 if IPO_timescale == -`i'
		replace D_IPO_plus`i' = 1 if IPO_timescale == `i'
	}
	*replace D_IPO_minus2 = 1 if IPO_timescale < -2
	*replace D_IPO_plus2 = 1 if IPO_timescale > 2
	
	* DiD regressions
	local thresh = `size'-`n'
	mat x_axis = J(`size',1,1)
	forvalues i = 1/`size' {
		mat x_axis[`i',1] = `i'-`thresh'
	}
	svmat x_axis
	mat did_$v = J(`size',4,.)
	* Only keep Public firms
	quietly: reg $v D_IPO* if FirmType==6
	forvalues i = 1/`size' {
		if (`i'<`thresh'){
			mat did_$v[`i',1] = _b[D_IPO_minus`i']
		}
		else if (`i'==`thresh'){
			mat did_$v[`i',1] = _b[D_IPO]
		}
		else {
			local j = `i'-`thresh'
			mat did_$v[`i',1] = _b[D_IPO_plus`j']
		}
	}
	* Add non public firms
	quietly: reg $v D_IPO*
	forvalues i = 1/`size' {
		if (`i'<`thresh'){
			mat did_$v[`i',2] = _b[D_IPO_minus`i']
		}
		else if (`i'==`thresh'){
			mat did_$v[`i',2] = _b[D_IPO]
		}
		else {
			local j = `i'-`thresh'
			mat did_$v[`i',2] = _b[D_IPO_plus`j']
		}
	}
	* Add fixed effects
	quietly: xtreg $v D_IPO*, fe
		forvalues i = 1/`size' {
		if (`i'<`thresh'){
			mat did_$v[`i',3] = _b[D_IPO_minus`i']
		}
		else if (`i'==`thresh'){
			mat did_$v[`i',3] = _b[D_IPO]
		}
		else {
			local j = `i'-`thresh'
			mat did_$v[`i',3] = _b[D_IPO_plus`j']
		}
	}
	* Add year dummies
	quietly: xtreg $v Age i.Year D_IPO*, fe
		forvalues i = 1/`size' {
		if (`i'<`thresh'){
			mat did_$v[`i',4] = _b[D_IPO_minus`i']
		}
		else if (`i'==`thresh'){
			mat did_$v[`i',4] = _b[D_IPO]
		}
		else {
			local j = `i'-`thresh'
			mat did_$v[`i',4] = _b[D_IPO_plus`j']
		}
	}
	
	*Create DiD decomposition Graph
	svmat did_$v
	local vname: di "$v"
	graph twoway (connected did_`vname'1 x_axis) (connected did_`vname'2 x_axis) (connected did_`vname'3 x_axis) (connected did_`vname'4 x_axis), ///
	xline(0, lcolor(blue) lpattern(dot)) xtitle("Number of years before/after IPO") ytitle("Difference in `vname'") ///
	legend(label(1 "Only IPO firms") label(2 "Add non IPO firms") label(3 "add fixed effects") label(4 "add Year dummies")) ///
	xlabel(-`n'[1]`n') graphregion(color(white)) title("Number of unique IPO firms = `N'")
	graph export Output/$CountryID/IPO_YearMinusIPO_`vname'_decomposition.pdf, replace 
restore