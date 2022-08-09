*------------------
* Save Balanced Panel
*------------------
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear

* Narrower year range for France
if "${CountryID}" == "FR"{
	drop if (Year<2010)
	drop if (Year>2014)
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2010, 2014)), by(IDNum)
	su nyear 
	keep if nyear == r(max)
	drop nyear
}
* Regular year range for other countries
else {
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2009, 2018)), by(IDNum)
	su nyear 
	keep if nyear == r(max)
	drop nyear
}


* Making sure it is strongly balanced 
xtset IDNum Year 


save "Data_Cleaned/${CountryID}_Balanced.dta", replace