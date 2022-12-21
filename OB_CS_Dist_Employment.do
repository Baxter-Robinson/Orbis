preserve

	gen ORBIS = 1
	keep if Public==1
	append using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta"
	gen Compustat = 1
	replace Compustat = 0 if ORBIS==1
	replace ORBIS = 0 if Compustat==1


	levelsof Year if ORBIS==1,local(YearOrbis)

	gen yKeep = 0
	foreach i of local YearOrbis{
		replace yKeep = 1 if Year==`i'
	}

	drop if yKeep==0

	levelsof Year if ORBIS==1
	levelsof Year if ORBIS==0

	drop yKeep


	keep nEmployees ORBIS Compustat IDNum Public
	keep if ~missing(nEmployees)
	replace nEmployees=25000 if nEmployees>=25000


	twoway (hist nEmployees if ORBIS == 1, freq lcolor(gs12) fcolor(gs12)) (hist nEmployees if Compustat == 1, freq lcolor(red) fcolor(none) ), ///
		legend(label(1 "Orbis Data") label(2 "Compustat Data")) ///
		xtitle("Number of Employees")  ytitle("Number of firms") graphregion(color(white))
	graph export Output/$CountryID/Distribution_Employment_OrbisVCompustat.pdf, replace 

restore
