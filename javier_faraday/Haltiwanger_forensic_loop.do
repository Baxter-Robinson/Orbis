

*----------------
* Initial Set Up
*----------------
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
mkdir $javier_faraday


global Countries AT BE DE CZ ES FI FR IT NL PT  // HU US GB

*global BinWidth=0.1
*global MinVal=-2


global 

foreach Country of global Countries {
	clear all
	global CountryID="`Country'"
	
	use "Data_Cleaned/`Country'_Unbalanced.dta",clear

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
	
	
	* Public firms by country to investigate
	preserve
	keep if public == 1 & abs_EmpGrowth_h>1.90
	bysort IDNum: gen dup = cond(_n==1,0,_n)
	drop if dup>1
	tab2xl IDNum using "$javier_faraday/`Country'_firms_to_investigate_public", col(1) row(1)
	restore
	
	
	* private firms by country to investigate
	preserve
	keep if private == 1 & abs_EmpGrowth_h>1.90
	bysort IDNum: gen dup = cond(_n==1,0,_n)
	drop if dup>1
	tab2xl IDNum using "$javier_faraday/`Country'_firms_to_investigate_private", col(1) row(1)
	restore
	
	* Now the work to get some summary statistics for these firms
	
	* Public
	preserve
	
	keep if public == 1

	gen ftocheck = .
	sum IDNum, meanonly
	return list
	local minIDNum = r(min)
	local maxIDNum = r(max)
	forval i = `minIDNum' /`maxIDNum'{
		su abs_EmpGrowth_h if IDNum==`i', meanonly 
		return list
		replace ftocheck=1 if r(max)>1.90 & IDNum==`i'
		di `i'
	}

	keep if ftocheck==1
	bysort IDNum: gen firmchanging = 1 if abs(halti2)>1.90
	replace firmchanging=0 if firmchanging==.


	gen previous =.


	local tot = _N
	forval i = 2 /`tot'{
		local j=`i'-1
		di `i'
		if firmchanging[`i']==1 {
			replace previous = 1 in `j'
		}
	}

	replace previous=0 if previous==.
	gen keepers = firmchanging+previous


	keep if keepers>=1
	
	
	restore
	
	
	
	
	
	
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
