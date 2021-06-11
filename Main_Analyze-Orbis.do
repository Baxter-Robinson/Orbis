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
if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
global DATAPATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"


* Emmanuel PATH
* Desktop
*cd "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"
* Laptop
*cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"

*---------------------
* Loop over countries 
*---------------------
global Countries IT CZ HU FR // US GB

local Country="CZ"
foreach Country of global Countries {
	clear all
	global CountryID="`Country'"

	*-----------------
	* Raw Data
	*-----------------
	
	*do Table_Missing-Observations.do // (use with raw data only)
	
	*----------------
	* Clean Data
	*----------------
	* Orbis
	*use "${DATAPATH}/${CountryID}_merge.dta", clear
	*do Program_Clean-OrbisData.do
	
	* Compustat
	*use "${DATAPATH}/${CountryID}_compustat.dta", clear
	*do Program_Clean-CompustatData.do
	
	*-----------------
	* Orbis: Unbalanced Panel
	*-----------------
	*use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	*use "Data_Cleaned/`Country'_CompustatUnbalanced.dta",clear
	
	
	*Graphs
	*------------
	*do Graph_HaltiGrowth_Employment-Dist.do
	
	*Regressions
	*------------
	
	*Tables
	*------------
	*do Table_PubVsPri.do
	
	
	*-----------------
	* Orbis: Balanced Panel
	*-----------------
	*use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	*use "Data_Cleaned/`Country'_CompustatBalanced.dta",clear
	
	*Graphs
	*------------
	*do Graph_Age-Dist.do
	*do Graph_Change-No-Shareholders-Dist.do
	*do Graph_FirmTypes.do
	*do Script_DiD-IPO.do
	*do Graph_IPOyear-Dist.do
	*do Graph_Growth_IPOyear-Dist.do
	*do Graph_Employment-Compustat.do
	*do Graph_HaltiGrowth_Employment_Compustat-Dist.do
	*do Graph_Lifecycle.do
	*do Graph_Lifecycle-ByFirmType.do
	*do Graph_Lifecycle-ByFirmType_Compustat.do
	
	
	*Regressions
	*------------
	*do Regressions_FirmTypes.do
	
	*Tables
	*------------
	*do Table_Descriptive-Stats.do
	*do Table_IPO-years.do
	*do Table_IPOyear_Descriptive-Stats.do
	*do Table_CompustatOrbis-Comparison.do
	*do Table_Sample-Comparison.do
	*do Table_CompustatOrbis-MissingObs.do
	*do Table_IPOyear_Descriptive-Stats_Compustat.do
	*do Table_BySize.do
	*do Table_IPOs.do
		

	

}

*-----------------------------
* Cross Country Comparisons
*-----------------------------
	*do Program_CreateCountryLevelData.do
