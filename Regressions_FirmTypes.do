preserve

eststo clear

gen MultiShareholder=0
replace MultiShareholder=1 if ((nShareholders>1) & ~(Listed))


eststo: reg EmpGrowth_h MultiShareholder Listed 
eststo: reg EmpGrowth_h MultiShareholder Listed i.Year 
eststo: reg EmpGrowth_h MultiShareholder Listed i.Year i.Industry_2digit

esttab using  Output/$CountryID/Regression_EmploymentGrowth.tex, replace se fragment ///
indicate("Constant=_cons" "Year=*.Year" "Industry FE=*Industry_2digit")

restore
