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
*if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
*if `"`c(os)'"' == "Windows"   global   stem  `"D:/The-Beast-Files/Dropbox/"'
*cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
*local DATAPATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"


* Emmanuel PATH
* Desktop
cd "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
local DATAPATH =  "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"

* Laptop
*cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*local DATAPATH =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"

*---------------------
* Loop over countries 
*---------------------
local Countries IT CZ HU FR // US GB

*local Country="CZ"
foreach Country of local Countries {
	clear all
	global CountryID="`Country'"

	*----------------
	* Clean Data
	*----------------
	* Orbis
	*use "`DATAPATH'/${CountryID}_merge.dta", clear
	*do Program_Clean-Data.do
	
	* Compustat
	*use "`DATAPATH'/${CountryID}_compustat.dta", clear
	*do Program_Clean-CompustatData.do
	
	*-----------------
	* Use Cleaned data
	*-----------------
	*use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	use "Data_Cleaned/`Country'_Compustat.dta",clear
	
	
	*----------------
	* Graphs
	*----------------
	
	*do Graph_Age-Dist.do
	*do Graph_Change-No-Shareholders-Dist.do
	*do Graph_Lifecycle.do
	*do Graph_FirmTypes.do
	*do Script_DiD-IPO.do
	*do Graph_IPOyear-Dist.do
	*do Graph_Growth_IPOyear-Dist.do
	*do Graph_Employment-Compustat.do
	
	*----------------
	* Regressions 
	*----------------
	*do Regressions_FirmTypes.do

	*----------------
	* Tables
	*----------------
	*do Table_Sample-Comparison.do
	*do Table_Descriptive-Stats.do
	*do Table_Missing-Observations.do // (use with raw data only)
	*do Table_IPO-years.do
	*do Table_IPOyear_Descriptive-Stats.do
	do Table_CompustatOrbis-Comparison.do
}
