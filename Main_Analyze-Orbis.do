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
*set trace on

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


* Javier PATH
* Laptop
*cd "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

* HOME
*cd "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

*

*---------------------
* Loop over countries 
*---------------------
* Alphabetical:
*global Countries AT BE CZ DE ES FI FR NL IT PT  // HU US GB
* Size
global Countries NL AT BE DE FI CZ PT ES FR IT

local Country="NL"
*local Country="FR"
*foreach Country of global Countries {
	clear all
	global CountryID="`Country'"
	global FirstYear="2009"
	global LastYear="2016"
	
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
	*do OB_Clean-Data.do
	*do OB_Create-Balanced-Panel.do
	*do OB_Create-Country-Level-Data.do
	
	* Compustat
	*do CS_Clean-Data.do
	
	* EuroStat
	* XXX do EuroStat_Enterprise_Statistics.do
	* XXX do EuroStat_Clean-Data.do
	*do Validation_CreateBySize_ES.do
	
	*Create Weights
	*do CleanData_CreateWeights.do
	
	
	*-------------------------------------------------------
	* Orbis (OB): Unbalanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear
	
	
	**** Summary Statistics
	*do OB_SumStats_ByCountry.do
	*do OB_SumStats_ByVariable.do
	*do OB_Graph_BySize_PubVPrivate.do
	*do OB_Share_Graphs.do 
	*do OB_Graph_HaltiGrowth_Employment-Dist.do 
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
	*do OB_Table_IPO-Years.do
	*do OB_Graph_IPOyear-Dist.do
	*do OB_Graph_HaltiGrowth_Employment-Dist.do
	

	
	*-------------------------------------------------------
	* Orbis (OB): Balanced Panel
	*-------------------------------------------------------
	*use "Data_Cleaned/`Country'_Balanced.dta",clear
	*use "Data_Cleaned/`Country'_OnePercent.dta",clear
	
	
	*** Section 3
	*do OB_Static_Firm_Share.do
	*do OB_Table_PubVsPri.do
	*XXX TBF XXX do OB_CrossCountry_Moments_Balanced.do
	
	
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
	
	* do OB_Validation_EuroStatOrbis_Comparison.do
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
*do PN_Clean.do

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
