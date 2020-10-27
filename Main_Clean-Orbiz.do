*-----------------------------------------------------------------------------
* Clean SCF Data
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
version 15
clear all
set maxvar 10000
set type double
set more off


* Baxter PATH
if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
if `"`c(os)'"' == "Windows"   global   stem  `"D:/The-Beast-Files/Dropbox/"'

cd "${stem}Shared-Folder_Baxter-Stephen/Data/Code"

*----------------
* Loop over countries 
*----------------


local PATH "${stem}Shared-Folder_Baxter-Stephen/Data/Orbis/IT_merge.dta"
use `PATH', clear


* Cut Sample for test runs
*drop if (BvD_ID_Number>"IT00709040455")

global CountryID="IT"

*----------------
* Initial Set Up
*----------------

do Program_Clean-Data.do


*----------------
* Graphs
*----------------
*do Graph_Age-Dist.do
*do Graph_Change-No-Shareholders-Dist.do
*do Graph_Lifecycle.do
*do Graph_Lifecycle_Industry.do
