*-----------------------------------------------------------------------------
* Clean Orbis Data and Create some Descriptive Statistics 
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
clear all
set type double
set more off

* Baxter PATH
*if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code/BR"
global DATAPATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis"

*---------------------
* Sample Options
*---------------------
global FirstYear=2009
global LastYear=2016

*---------------------
* Clean EuroStat Data
*---------------------
*do CleanData_EuroStat.do

*---------------------
* Loop over countries 
*---------------------
global Countries NL AT BE DE FI CZ PT ES FR IT  // HU US GB

*local Country="NL"
local Country="FR"
*foreach Country of global Countries {
	clear all
	global CountryID="`Country'"
	
	*-------------------------------------------------------
	* Raw Data
	*-------------------------------------------------------
	
	*** Section 4
	*do OB_RAW_By_Year_NumFirms_PubVPrivate.do
	
	
	*-------------------------------------------------------
	* Clean Data
	*-------------------------------------------------------	
	* Compustat
	*do CS_Clean-Data.do
	
	* EuroStat
	* XXX do EuroStat_Enterprise_Statistics.do
	* XXX do EuroStat_Clean-Data.do
	
	* Orbis
	*do OB_Clean-Data.do
	*do OB_Create-Country-Level-Data.do

	*Create Weights
	*do CleanData_CreateWeights.do
	
	
	*-------------------------------------------------------
	* Orbis (OB):
	*-------------------------------------------------------
	*use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear
	
	
	**** Summary Statistics
	*do OB_SumStats_ByCountry.do
	*do OB_SumStats_ByVariable.do
	*do OB_Graph_BySize_PubVPrivate.do
	*do OB_Share_Graphs.do 
	*do OB_Dist-EmpGrowth.do 
	*do OB_gEmp_Regressions.do
	
	
	**** Section 2
	*do OB_Table_BySize.do
	*do OB_Table_Share_Emp_SizeCat.do 
	*do OB_Comparison_Eurostat_Enterprise_Statistics.do
	*do OB_Graph_BySize.do


	**** Section 4
	*do OB_Financial_Ratios.do
	
	**** Section 5
	*do OB_CS_Dist_Employment.do
	
	**** Section 6
	*do OB_IPO_YearsTable.do
	*do OB_IPO_Graphs.do
	*do OB_IPO_RegsAndGraphs.do
	*do OB_Regressions_HGR_IPOs.do
	*do OB_Table_IPOyear_Descriptive-Stats.do
	*do OB_Graph_IPOyear-Dist.do
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	
	
	** Section 7
	*do OB_Static_Firm_Share.do
	*do OB_Table_PubVsPri.do
	*do OB_Graph_Lifecycle-ByFirmType.do


	*-------------------------------------------------------
	* Compustat (CS):
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_CompustatUnbalanced.dta",clear
	
	*** Section 1
	
	*do CS_Graph_Employment.do
	*do CS_Table_IPOyear_Descriptive-Stats.do
	*do CS_Agg_Employment_HGR.do 
	*XXX TBF XXX do CS_Graph_HaltiGrowth_Employment-Dist.do
	*do CS_Graph_Lifecycle-ByFirmType.do	


	
	*-------------------------------------------------------
	* Comparisons: 
	*-------------------------------------------------------
	
	* Compustat vs. Orbis
	*do Validation_CreateBySize_OB_Public.do
	*do Validation_CreateBySize_CS.do
	*do Validation_BySize_ObvsCS.do
	
	*use "Data_Cleaned/`Country'_Unbalanced.dta",clear
	*do Table_CompustatOrbis-Comparison.do
	
	* Orbis vs. EuroStat
	*do Validation_BySize_ObvsES.do
	
	*do Valid_OB-ES_Graphs.do
	*do EuroStat_Enterprise_Statistics.do
	*XXX TBF XXX do OB_Employment_Firms_EuroStat_Yearly_Comparison.do
	*XXX TBF XXX use "Data_Cleaned/EuroStat_Enterprise_Statistics.dta",clear
*}


*-------------------------------------------------------
* Create Cross Country Dataset
*-------------------------------------------------------
* World Bank
*do WB_CleanData.do

*IMF
*do IMF_CleanData.do

* Penn World Tables
*do PN_CleanData.do

*do CC_Combine-Data-Sources_All.do
*do CC_Combine-Data-Sources_Eur.do


*-----------------------------
* Cross Country Comparisons
*-----------------------------

*** Section 2 
*do OB_CrossCountry_Stack_Bar_Industries.do


*** Section 3
*do CrossCountry_Graph_Europe.do
*do CrossCountry_Graph_All.do


** Model
*do Table_Model-Moments.do
		
**** Section 3
* XXX TBF XXX do OB_CrossCountry_Moments_Unbalanced.do
