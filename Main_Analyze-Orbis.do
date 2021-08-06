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
*if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
*cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
*global DATAPATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"


* Emmanuel PATH
* Desktop
*cd "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "D:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"
* Laptop
cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
global DATAPATH =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"

*---------------------
* Loop over countries 
*---------------------
global Countries NL AT BE DE CZ FI PT HU ES IT FR // US GB


*local Country="NL"
foreach Country of global Countries {
	clear all
	global CountryID="`Country'"

	*-------------------------------------------------------
	* Raw Data
	*-------------------------------------------------------
	
	*do OB_Table_Missing-Observations.do
	
	*-------------------------------------------------------
	* Clean Data
	*-------------------------------------------------------
	* Orbis
	*use "${DATAPATH}/${CountryID}_merge.dta", clear
	*do OB_Program_Clean-Data.do
	
	* Compustat
	*use "${DATAPATH}/${CountryID}_compustat.dta", clear
	*do CS_Program_Clean-Data.do
	
	*-------------------------------------------------------
	* Orbis (OB): Unbalanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	*do OB_Script_DiD-IPO.do
	*do OB_Graph_IPOyear-Dist.do
	*do OB_Graph_Growth_IPOyear-Dist.do
	*do OB_Graph_BySize.do
	
	*do OB_Regressions_FirmTypes.do


	*do OB_Table_Descriptive-Stats.do
	*do OB_Table_PubVsPri.do
	*do OB_Table_BySize.do
	*do OB_Table_BySize-Public.do
	
	*do OB_Table_IPOs.do
	*do OB_Table_IPO-years.do
	*do OB_Table_IPOyear_Descriptive-Stats.do
	
	
	*-------------------------------------------------------
	* Orbis (OB): Balanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	

	*do OB_Graph_Lifecycle.do
	*do OB_Graph_Lifecycle-ByFirmType.do
	
	**do OB_Table_BySize-Public.do
	*do OB_Graph_Age-Dist.do
	*do OB_Graph_Change-No-Shareholders-Dist.do
	*do OB_Graph_FirmTypes.do
	
	
	*-------------------------------------------------------
	* Compustat (CS): Unbalanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_CompustatUnbalanced.dta",clear
	
	*do CS_Graph_Employment.do
	
	*do CS_Table_IPOyear_Descriptive-Stats.do
	
	
	*-------------------------------------------------------
	* Compustat (CS): Balanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_CompustatBalanced.dta",clear
	
	
	*do CS_Graph_Employment.do
	*do CS_Graph_HaltiGrowth_Employment-Dist.do
	*do CS_Graph_Lifecycle-ByFirmType.do	

	
	*-------------------------------------------------------
	* Comparison: Compustat vs. Orbis
	*-------------------------------------------------------
	*do Table_CompustatOrbis-MissingObs.do
	*do Table_Sample-Comparison.do
	*do Table_CompustatOrbis-Comparison.do
	
		
}

*-----------------------------
* Cross Country Comparisons
*-----------------------------

*do Load_Cross-Country-Dataset.do

*do Table_Model-Moments.do