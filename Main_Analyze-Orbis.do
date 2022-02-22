*-----------------------------------------------------------------------------
* Clean Orbis Data and Create some Descriptive Statistics 
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
clear all
*version 13
*set maxvar 10000
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
*cd "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis"
*global DATAPATH =  "C:/Users/Emmanuel/Dropbox/Shared-Folder_Baxter-Emmanuel/RA-Work/Orbis/Data_Raw"


* Javier PATH
* Laptop
*cd "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

* HOME
cd "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

*

*---------------------
* Loop over countries 
*---------------------
global Countries IT FR ES PT DE NL
*global Countries AT BE CZ DE ES FI FR IT NL PT  // HU US GB


*local Country="PT"
foreach Country of global Countries {
	clear all
	global CountryID="`Country'"

	*-------------------------------------------------------
	* Raw Data
	*-------------------------------------------------------
	
	*do OB_Table_Missing-Observations.do
	
	do OB_RAW_By_Year_NumFirms_PubVPrivate.do
	
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
	use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	*do OB_Graph_BySize_PubVPrivate.do
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	*do OB_Share_Graphs.do
	do OB_Table_Share_Emp_SizeCat.do
	*do OB_gEmp_Regressions.do
	
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
	
	
	*do OB_HGR_Pattern_Checks.do 
	
	*do OB_HGR_regressions.do
	
	*do OB_Sum_Stats_Table.do
	
	*do OB_Graph_BySize.do
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	
	*do OB_Table_Share_Emp_SizeCat.do
	
	*-------------------------------------------------------
	* Orbis (OB): Balanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	
	*do OB_Graph_BySize.do
	*do OB_Graph_Lifecycle.do
	*do OB_Graph_Lifecycle-ByFirmType.do
	
	*do OB_Table_BySize-Public.do
	*do OB_Graph_Age-Dist.do
	*do OB_Graph_Change-No-Shareholders-Dist.do
	*do OB_Graph_FirmTypes.do
	
	*do OB_Static_Firm_Share.do
	
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
	
	*-------------------------------------------------------
	* Equity Market Depth
	*-------------------------------------------------------
	*use "Data_Raw/`Country'_StockPrice.dta", clear
	*do CS_EquityMarketDepth.do
	
	*-------------------------------------------------------
	* Orbis (OB) Country-level Indicators
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_Unbalanced.dta", clear
	*do OB_CountryIndicators.do
		
		
		
}


*-------------------------------------------------------
* World Bank Data and IMF data
*-------------------------------------------------------
*do WB_CleanData.do

*-------------------------------------------------------
* Penn World Table (PN) Indicators
*-------------------------------------------------------
*use "${DATAPATH}/pwt100.dta", clear
*do PN_Indicators.do

*-----------------------------
* Cross Country Comparisons
*-----------------------------
*do Load_Cross-Country-Dataset.do
*do Graph_CrossCountry.do

*do Table_Model-Moments.do

*do OB_CrossCountry_Moments.do
