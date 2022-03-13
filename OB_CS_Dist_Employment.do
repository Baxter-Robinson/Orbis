
gen ORBIS = 1
keep if Private==0
append using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta"
gen Compustat = 1
replace Compustat = 0 if ORBIS==1
replace ORBIS = 0 if Compustat==1


keep nEmployees ORBIS Compustat IDNum Private

replace nEmployees=100000 if nEmployees>=100000

twoway (hist nEmployees if ORBIS == 1, frac lcolor(gs12) fcolor(gs12)) (hist nEmployees if Compustat == 1, frac lcolor(red) fcolor(none) ), ///
	legend(label(1 "Orbis Data") label(2 "Compustat Data")) ///
	xtitle("Number of Employees") graphregion(color(white))
graph export Output/$CountryID/Distribution_Employment_OrbisVCompustat.pdf, replace 
