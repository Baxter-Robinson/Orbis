
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear
gen DataSet="OB"
append using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta"
replace DataSet="CS" if missing(DataSet)

replace Public=1 if DataSet=="CS"


drop if Public==0
drop if (Year<2010)
drop if (Year>2017)


twoway (histogram EmpGrowth_h if (DataSet=="OB"),  color(maroon) frequency) ///
(histogram EmpGrowth_h if (DataSet=="CS") , color(navy) frequency )
/*
twoway (histogram nEmployees if (DataSet=="OB"),  color(maroon) frequency) ///
(histogram nEmployees if (DataSet=="CS") , color(navy) frequency )


/*
collapse (p10) nEmp_p10=nEmployees (p25) nEmp_p25=nEmployees (p50) nEmp_p50=nEmployees ///
(p75) nEmp_p75=nEmployees (p90) nEmp_p90=nEmployees (count) nEmp_N=nEmployees , by (Year DataSet)


graph twoway ///
( scatter nEmp_p10 Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) color(navy)) ///
( scatter nEmp_p10 Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) color(maroon)) ///
( scatter nEmp_p25 Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) color(navy)) ///
( scatter nEmp_p25 Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) color(maroon)) ///
( scatter nEmp_p50 Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) color(navy)) ///
( scatter nEmp_p50 Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) color(maroon)) ///
,  legend(order(1 "Compustat" 2 "Orbis") ) graphregion(color(white)) ///
yscale(log)


local percentiles 10 25 50 75 90


	file close _all
	file open CleaningGuide using Output/${CountryID}/CleaningGuide.tex, write replace

	local t=2010
forval t=2010/2017{
	local Sum=0
	
	foreach percent of local percentiles{
		sum nEmp_p`percent' if (Year==`t') & (DataSet=="CS")
		local CSmoment=r(mean)
		sum nEmp_p`percent' if (Year==`t') & (DataSet=="OB")
		local OBmoment=r(mean)
		
		local Sum=`Sum'+(`OBmoment'-`CSmoment')^2/(`CSmoment')
	}
	
	local Sum=`Sum'/5
	
	sum nEmp_N if (Year==`t') & (DataSet=="OB")
	local nObs=r(mean)
	
	local Sum: di %12.2f `Sum'
	
	file  write CleaningGuide "`t'   `Sum'    `nObs'" _newline
	
	
	
}
	file close _all

/*

( scatter nEmp_p75 Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) lcolor(navy)) ///
( scatter nEmp_p75 Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) lcolor(maroon)) ///
( scatter nEmp_p90 Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) lcolor(navy)) ///
( scatter nEmp_p90 Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) lcolor(maroon)) ///
( scatter nEmp_N Year if DataSet=="CS", connect(l) lpattern(solid) msymbol(0) color(navy)) ///
( scatter nEmp_N Year if DataSet=="OB", connect(l) lpattern(solid) msymbol(S) color(maroon)) ///