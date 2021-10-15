
*----------------
* Initial Set Up
*----------------
cls
clear all

set type double
set more off

* Javier PATH
* Home
cd "/Volumes/MacMiniExt/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Volumes/MacMiniExt/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"




global Countries IT FR ES PT DE NL

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
	use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	
	do OB_Graph_BySize_PubVPrivate.do 
	
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
	
	
	*do OB_Graph_BySize.do
	*do OB_Graph_Lifecycle.do
	*do OB_Graph_Lifecycle-ByFirmType.do
	
	*do OB_Table_BySize-Public.do
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
