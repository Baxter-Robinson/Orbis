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
*global Countries IT 
*global Countries AT BE CZ DE ES FI FR IT NL PT  // HU US GB


foreach Country of global Countries {
	clear all
	global CountryID="`Country'"
	
	*-------------------------------------------------------
	* Raw Data
	*-------------------------------------------------------
	
	*** Section 4
	*do OB_Table_Missing-Observations.do
	*do OB_RAW_By_Year_NumFirms_PubVPrivate.do
	
	
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
	
	
	**** Section 1
	*do OB_Sum_Stats_Table.do
	*do OB_Graph_BySize_PubVPrivate.do
	*do OB_Share_Graphs.do 
	*do OB_Graph_HaltiGrowth_Employment-Dist.do 
	*do OB_gEmp_Regressions.do
	*do OB_HGR_regressions.do
	
	
	**** Section 2
	*do OB_Table_BySize.do
	*do OB_Table_Share_Emp_SizeCat.do 
	*do OB_Comparison_Eurostat_Enterprise_Statistics.do
	*do OB_Graph_BySize.do
	
	**** Section 3
	do OB_CrossCountry_Moments_Unbalanced.do

	**** Section 4
	*do OB_Financial_Ratios.do
	
	**** Section 5
	*do OB_CS_Dist_Employment.do
	
	**** Section 6
	*do OB_Table_IPO-years.do
	*do OB_Table_IPOs.do
	*do OB_Regressions_HGR_IPOs.do
	*do OB_Table_IPOyear_Descriptive-Stats.do
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	
	**** Section 7
	*do OB_Employment_Firms_EuroStat_comparison.do
	
	
	*-------------------------------------------------------
	* Orbis (OB): Balanced Panel
	*-------------------------------------------------------
	use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	
	*** Section 3
	*do OB_Static_Firm_Share.do
	*do OB_Table_PubVsPri.do
	do OB_CrossCountry_Moments_Balanced.do
	
	
	*** Section 5
	*do OB_Graph_Lifecycle-ByFirmType.do
	
	*-------------------------------------------------------
	* Compustat (CS): Unbalanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_CompustatUnbalanced.dta",clear
	
	*** Section 1
	
	*do CS_Graph_Employment.do
	*do CS_Table_IPOyear_Descriptive-Stats.do
	*do CS_Agg_Employment_HGR.do 
	
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
	
	* Section 5
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
		
	
	*-------------------------------------------------------
	* EuroStat - Comparison
	*-------------------------------------------------------
	*use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta",clear
	*do EuroStat_Enterprise_Statistics.do
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

*** Section 2 
*do OB_CrossCountry_Stack_Bar_Industries.do


*do Load_Cross-Country-Dataset.do
*** Section 3
*do Graph_CrossCountry.do
