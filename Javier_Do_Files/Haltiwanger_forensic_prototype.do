cls
clear all
*version 13
*set maxvar 10000
set type double
set more off



* Javier PATH
* Home
cd "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

global javier_faraday "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/javier_faraday"
*mkdir $javier_faraday


local Country="DE"
use "Data_Cleaned/`Country'_Unbalanced.dta",clear

*global BinWidth=0.1
*global MinVal=-2


*Public or Private Indicator variables
gen private = 1 if FirmType != 6 | (FirmType == 6 & Year >= Delisted_year)
gen public = 1 if FirmType == 6
replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year
	* Keep only the variables I need for now
keep IDNum nEmployees EmpGrowth_h private public Year
* Create a 2nd variable for the Haltiwanger growth rate to avoid the fact that Stata takes the . as higher than the abs()>1.90
gen halti2 = EmpGrowth_h
replace halti2 =0.000000000001 if halti2==.
gen abs_EmpGrowth_h = abs(halti2)



preserve
keep if public == 1 & abs_EmpGrowth_h>1.90
bysort IDNum: gen dup = cond(_n==1,0,_n)
drop if dup>1
tab2xl IDNum using "$javier_faraday/`Country'_firms_to_investigate_public", col(1) row(1)
restore


preserve
keep if private == 1 & abs_EmpGrowth_h>1.90
bysort IDNum: gen dup = cond(_n==1,0,_n)
drop if dup>1
tab IDNum
tab2xl IDNum using "$javier_faraday/`Country'_firms_to_investigate_private", col(1) row(1)
restore

* Public firms only
keep if public == 1


gen ftocheck = 0 // indicator for firm to check 
sum IDNum, meanonly
return list
local minIDNum = r(min)
local maxIDNum = r(max)  // These previous commands are just to create the iteration numbers
forval i = `minIDNum' /`maxIDNum'{ // Loop to go through each firm and check if the firm has a Haltiwanger growth rate greater than 1.90
	su abs_EmpGrowth_h if IDNum==`i', meanonly   // If the firm has at least 1 HGR>1.90 then the firm for all its periods is marked with 1 to check it
	return list
	replace ftocheck=1 if r(max)>1.90 & IDNum==`i'
	di `i'
}

keep if ftocheck==1  // I keep only the firms that where flagged.
bysort IDNum: gen firmchanging = 1 if abs(halti2)>1.90  // For the firms that I keep, I write a 1 for the period in which they have the HGR>1.90
* replace firmchanging=0 if firmchanging==.


* Now I want to see what is the difference in employment between the period previous to a HGR>1.90 and the period when HGR>1.90
gen previous =.  // Indicator for the previous period


local tot = _N
forval i = 2 /`tot'{  // What this loop does is that it will add a 1 in the previous period in which a HGR>1.90 was observed
	local j=`i'-1
	di `i'
	if firmchanging[`i']==1 {
		replace previous = 1 in `j'
	}
}

replace previous=0 if previous==.   // Set all other periods to 0 if they are not related to a HGR>1.90

gen keepers = firmchanging+previous  // I need a way to only keep the periods that matter to me, so to have full control I will keep all those periods
									// in which I observe a 1 either because HGR>1.90 or because it is observed


* Before creating the tables, I want to create an ugly graph to see the ups and downs of employment
preserve
keep if Year>2006					
separate nEmployees, by(IDNum) veryshortlabel 
local yvars `r(varlist)' 
line `yvars' Year, legend(pos(3) col(1)) title("Country `Country' - Firms' jumps in employment", box lcolor(red)) 
graph export "$javier_faraday/`Country'_employment_raw.png" 
restore
* So what this ugly graph tells me is that the values in the middle are too noisy st it might be useful 
* to use the growth over the full period they are in the sample

* How about doing this graph firm by firm even though there are plenty of them? 
sum IDNum, meanonly
return list
levelsof(IDNum), local(idfirms)
foreach i of local idfirms{ // Loop to go through each firm and check if the firm has a Haltiwanger growth rate greater than 1.90
	line nEmployees Year if IDNum==`i', legend(size(medsmall)) title("Country `Country' - Firm `i'  jumps in employment", box lcolor(red)) 
	graph export "$javier_faraday/`Country'_firm_`i'_employment.png" 
	
}


preserve
xtset IDNum Year
gen difnEmployees = nEmployees - L.nEmployees
drop if keepers==.

estpost summarize difnEmployees, listwise
esttab using "$javier_faraday/`Country'_employment_sum_stats.tex", cells("mean sd min max") nomtitle nonumber ///
title("Summary statistics for `Country' on changes in employment" )

separate difnEmployees, by(IDNum) veryshortlabel 
local yvars `r(varlist)' 
scatter `yvars' Year, legend(pos(3) col(1)) title("Country `Country' - Firms' jumps in employment", box lcolor(red)) 
graph export "$javier_faraday/`Country'_employment_scatter.png" 
restore



preserve
drop if nEmployees==.
bysort IDNum: gen period = _n  
gen nyear = -Year
by IDNum (nyear), sort:gen  period2 = _n
drop nyear
keep if Year>2006
sort IDNum Year
drop if period!=1 & period2!=1 // First and last period for every firm is identified with period = period2 = 1
separate nEmployees, by(IDNum) veryshortlabel 
local yvars `r(varlist)' 
line `yvars' Year, legend(pos(3) col(1)) title("Country `Country' - Firms' jumps in employment", box lcolor(red)) 
graph export "$javier_faraday/`Country'_employment_first_last.png" 
restore








