cls
clear all
*version 13
*set maxvar 10000
set type double
set more off



* Javier PATH
* Home
cd "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

global javier_faraday "/Volumes/HD710/Dropbox/Shared-Folder_Baxter-Javier/Orbis/javier_faraday"
*mkdir $javier_faraday


*local Country="AT"


global Countries AT BE CZ DE ES FI FR IT NL PT  // HU US GB

foreach Country of global Countries {
	use "$DATAPATH/`Country'_merge.dta", clear


	**************************
	* Construct Summary Info
	**************************

	*------------------
	* Age
	*------------------
	gen Year=year(Closing_date)
	egen FirstYear=min(Year), by(BvD_ID_Number)
	replace FirstYear=year(IPO_date) if ((year(IPO_date)<year(FirstYear)) & ~missing(FirstYear))
	replace FirstYear=year(Date_of_incorporation) if ((year(Date_of_incorporation)<year(FirstYear)) & ~missing(Date_of_incorporation))

	gen Age=Year-FirstYear
	drop FirstYear


	*------------------
	* Set Panel Structure
	*------------------
	egen IDNum=group(BvD_ID_Number)

	* Remove duplicates (updated)
	replace Number_of_employees = 0.5 if Number_of_employees==0
	replace Number_of_employees = 0 if Number_of_employees==.
	replace Sales = 0.5 if Sales == 0
	replace Sales = 0 if Sales == .
	sort IDNum Year
	by IDNum Year: egen minE = min(Number_of_employees)
	by IDNum Year: egen maxE = max(Number_of_employees)
	by IDNum Year: egen minS = min(Sales)
	by IDNum Year: egen maxS = max(Sales)
	* Drop the duplicate with missing number of employees 
	duplicates tag IDNum Year, gen(dup)
	gen tagMaxE = 1 if Number_of_employees == maxE & Number_of_employees > minE & dup > 0
	gen tagMinE = 1 if Number_of_employees == minE & Number_of_employees < maxE & minE <= 0.5 & dup > 0
	drop if tagMinE == 1
	drop dup
	* Drop the duplicate with missing Sales
	duplicates tag IDNum Year, gen(dup)
	gen tagMaxS = 1 if Number_of_employees == maxS & Sales > minE & dup > 0
	gen tagMinS = 1 if Number_of_employees == minS & Sales < maxE & minE <= 0.5 & dup > 0
	drop if tagMinS == 1
	drop dup
	* Drop remaining duplicates where there is no disrepancy
	duplicates drop IDNum Year, force
	replace Number_of_employees = . if Number_of_employees==0
	replace Number_of_employees = 0 if Number_of_employees==0.5
	replace Sales = . if Sales == 0
	replace Sales = 0 if Sales == 0.5

	drop minE minS maxE maxS tagMaxE tagMaxS tagMinE tagMinS

	xtset IDNum Year

	/*
	duplicates drop IDNum Year Sales Number_of_employees, force
	duplicates tag IDNum Year, gen(dup)
	gen duptemp = Sales + Number_of_employees
	drop if dup == 1 & duptemp == .
	drop if dup == 2 & duptemp == .
	duplicates drop IDNum Year, force
	*/

	/*
	* XXX Currently it just retains the first observation - need to code this to take a consistent closing date with the other years XXX
	duplicates drop IDNum Year , force

	xtset IDNum Year
	*/

	*---------------------------
	* Financials
	*---------------------------

	rename Operating_revenue_Turnover Revenue
	rename Costs_of_goods_sold COGS
	rename Costs_of_employees WageBill
	rename Total_assets Assets
	rename P_L_before_tax GrossProfits


	drop if (Revenue<0)
	drop if (Sales<0)
	drop if (Assets<0)
	replace Sales = Revenue if (Sales == 0) & (Revenue > 0)
	*drop if Sales == .

	*---------------------------
	* Number of Employees
	*---------------------------
	rename Number_of_employees nEmployees

	sum nEmployees
	estpost summarize  nEmployees
	esttab using "$javier_faraday/`Country'_table_sum_nEmployees", cells("count mean sd min max")





	drop if (nEmployees<0)
	replace nEmployees = . if (nEmployees == 0 & Sales > 0) | (nEmployees == 0 & Revenue > 0)
	gen SalesPerEmployee=Sales/nEmployees

	*---------------------------
	* Growth Rates
	*---------------------------

	* Employment Growth Rate (Regular)
	bysort IDNum: gen EmpGrowth_r=(nEmployees-L.nEmployees)/(L.nEmployees)

	* Employment Growth Rate (Haltiwanger)
	bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)
		
	* Sales Growth Rate (Haltiwanger)
	bysort IDNum: gen SalesGrowth_h = (Sales-L.Sales)/((Sales+L.Sales)/2)

	* Profit Growth Rate (Haltiwanger)
	bysort IDNum: gen ProfitGrowth_h = (GrossProfits-L.GrossProfits)/((GrossProfits+L.GrossProfits)/2)


}
 
* ------------------------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------------------------
* ------------------------------------------------------------------------------------------------------------
local Country="AT"
use "Data_Cleaned/`Country'_Unbalanced.dta",clear
