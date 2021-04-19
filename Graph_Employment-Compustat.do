preserve
	* Distribution of firms by employment bins
	gen emp_bin = 1 if (nEmployees < 100)
	replace emp_bin = 2 if (nEmployees < 1000) & (nEmployees >= 100)
	replace emp_bin = 3 if (nEmployees < 5000) & (nEmployees >= 1000)
	replace emp_bin = 4 if (nEmployees < 15000) & (nEmployees >= 5000)
	replace emp_bin = 5 if (nEmployees < 50000) & (nEmployees >= 15000)
	replace emp_bin = 6 if (nEmployees < 100000) & (nEmployees >= 50000)
	replace emp_bin = 7 if (nEmployees < 200000) & (nEmployees >= 100000)
	replace emp_bin = 8 if nEmployees >= 200000
	replace emp_bin = . if nEmployees == .
	bysort emp_bin: gen Density = _N
	twoway bar Density emp_bin, bartype(spanning) bstyle(histogram) xtitle("Employment bins") ytitle("Number of firms") ///
	xlabel(1 "1-99"  2 "100-1k" 3 "1k-5k" 4 "5k-15k" 5 "15k-50k" 6 "50k-100k" 7 "100k-200k" 8 "200k+") graphregion(color(white))
	graph export Output/$CountryID/Distribution_Employment-Compustat.pdf, replace 
	* Distribution of employment by firm Age
	collapse (mean) nEmployees, by(Age)
	graph twoway (connected nEmployees Age), ytitle("Average number of employees") graphregion(color(white))
	graph export Output/$CountryID/Age_Employment-Compustat.pdf, replace 
restore