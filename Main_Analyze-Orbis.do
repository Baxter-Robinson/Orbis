*-----------------------------------------------------------------------------
* Clean SCF Data
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
clear all
version 15
set maxvar 10000
set type double
set more off


* Baxter PATH
if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
if `"`c(os)'"' == "Windows"   global   stem  `"D:/The-Beast-Files/Dropbox/"'

cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code"

*---------------------
* Loop over countries 
*----------------------
local Countries IT CZ GB

local Country="GB"
*foreach Country of local Countries {
	clear all
	global CountryID="`Country'"

	local PATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis/`Country'_merge.dta"
	use `PATH', clear


	* Cut Sample for test runs
	*drop if (BvD_ID_Number>"IT00709040455") // IT




	do BR/Program_Clean-Data.do


	*----------------
	* Graphs
	*----------------
	
	do BR/Graph_Age-Dist.do
	do BR/Graph_Change-No-Shareholders-Dist.do
	do BR/Graph_Lifecycle.do
	do BR/Graph_Shareholders.do


*}
