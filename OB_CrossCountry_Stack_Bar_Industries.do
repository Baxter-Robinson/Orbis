*----------------
* Initial Set Up
*----------------
cls
clear all
*version 13
*set maxvar 10000
set type double
set more off
set rmsg on

* Javier PATH
* Laptop
*cd "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

* HOME
cd "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"



*---------------------
* Merge over countries
*---------------------

use "Data_Cleaned/IT_Unbalanced.dta",clear

gen Country="IT"

gen CountryID=.
replace CountryID=1 if Country=="IT"

global Countries  FR ES PT DE NL
*global Countries FR 

foreach C of global Countries {
	append using "Data_Cleaned/`C'_Unbalanced.dta"	
	replace Country="`C'" if missing(Country)
	replace CountryID=2 if "`C'"=="FR"
	replace CountryID=3 if "`C'"=="ES"
	replace CountryID=4 if "`C'"=="PT"
	replace CountryID=5 if "`C'"=="DE"
	replace CountryID=6 if "`C'"=="NL"

}

do SIC_3d_to_NAICS_2d.do 

gen NAICS_Industry = .
replace NAICS_Industry = 1 if NAICS_2_digit==11
replace NAICS_Industry = 2 if (NAICS_2_digit==21)|(NAICS_2_digit==22)|(NAICS_2_digit==23)
replace NAICS_Industry = 3 if (NAICS_2_digit==31)|(NAICS_2_digit==32)|(NAICS_2_digit==33)
replace NAICS_Industry = 4 if (NAICS_2_digit==41)|(NAICS_2_digit==44)|(NAICS_2_digit==45)|(NAICS_2_digit==48)|(NAICS_2_digit==49)
replace NAICS_Industry = 5 if (NAICS_2_digit==51)|(NAICS_2_digit==52)|(NAICS_2_digit==53)|(NAICS_2_digit==54)|(NAICS_2_digit==55)|(NAICS_2_digit==56)
replace NAICS_Industry = 6 if (NAICS_2_digit==61)|(NAICS_2_digit==62)|(NAICS_2_digit==71)|(NAICS_2_digit==72)|(NAICS_2_digit==81)|(NAICS_2_digit==91)







tab NAICS_Industry
return list
local Total_Industries = r(N) 

levelsof NAICS_Industry, local(NAICS)


* By Country: Percentages of composition of industries
foreach c of CountryID{
	foreach x of local NAICS{
		tab NAICS_Industry if (NAICS_Industry==`x') & (CountryID==`c') 
		return list
		local abs = r(N)
		local `c'_pct_NAICS_`x' = round(100*`abs'/`Total_Industries', .01)
	}
} 

* By Country: Percentages of composition of industries in variables for stack bar
foreach c of CountryID{
	foreach x of local NAICS{
		gen `c'_pct_NAICS_`i' = ``c'_pct_NAICS_`x'' 
	}
} 


* By Country: Cumulative percentages of composition of industry
foreach c of CountryID{
	foreach i of local NAICS{
		if (`i'==1) & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_`i' = ``c'_pct_NAICS_1'
		}
		else if `i'==2 & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_`i' = ``c'_pct_NAICS_1'+``c'_pct_NAICS_2'
		}
		else if `i'==3 & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_`i' = ``c'_pct_NAICS_1'+``c'_pct_NAICS_2'+``c'_pct_NAICS_3'
		}
		else if `i'==4 & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_`i' = ``c'_pct_NAICS_1'+``c'_pct_NAICS_2'+``c'_pct_NAICS_3'+``c'_pct_NAICS_4'
		}
		else if `i'==5 & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_`i' = ``c'_pct_NAICS_1'+``c'_pct_NAICS_2'+``c'_pct_NAICS_3'+``c'_pct_NAICS_4'+``c'_pct_NAICS_5'
		}
		else if `i'==6 & (CountryID==`c') {
			gen `c'_cum_pct_NAICS_6 = 100
		}
		
	}

}

* Midpoint calculation for labels in graphs
foreach c of CountryID{
	local `c'_midpoint_1 = ``c'_pct_NAICS_1'/2 if 
	local `c'_midpoint_2 = (``c'_pct_NAICS_1'+``c'_pct_NAICS_2')/2
	local `c'_midpoint_3 = (``c'_pct_NAICS_2'+``c'_pct_NAICS_3')/2
	local `c'_midpoint_4 = (``c'_pct_NAICS_3'+``c'_pct_NAICS_4')/2
	local `c'_midpoint_5 = (``c'_pct_NAICS_4'+``c'_pct_NAICS_5')/2
	local `c'_midpoint_6 =  (100+``c'_pct_NAICS_5')/2

}






