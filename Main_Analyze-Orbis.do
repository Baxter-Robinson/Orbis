*-----------------------------------------------------------------------------
* Clean Orbis Data and Create some Descriptive Statistics 
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
clear all
version 13
set maxvar 10000
set type double
set more off


* Baxter PATH
/*
if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
if `"`c(os)'"' == "Windows"   global   stem  `"D:/The-Beast-Files/Dropbox/"'
cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
local PATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"
*/

* Emmanuel PATH
cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
global PATH_glob = "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
local PATH_loc =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"

*---------------------
* Loop over countries 
*----------------------
local Countries IT CZ HU FR // US GB

*local Country="CZ"
foreach Country of local Countries {
	clear all
	global CountryID="`Country'"

	*----------------
	* Clean Data
	*----------------
	use "`PATH_loc'/Data_Raw/`Country'_merge.dta", clear

	*do Program_Clean-Data.do
	
	*----------------
	* Use One Percent Sample
	*----------------
	use "`PATH_loc'/Data_OnePercent/`Country'_OnePercent.dta",clear
	

	*----------------
	* Graphs
	*----------------
	
	*do Graph_Age-Dist.do
	*do Graph_Change-No-Shareholders-Dist.do
	*do Graph_Lifecycle.do
	*do Graph_FirmTypes.do
	
	*----------------
	* Regressions
	*----------------
	*do Regressions_FirmTypes.do

	*----------------
	* Tables
	*----------------
	do Table_Descriptive-Stats.do
}
