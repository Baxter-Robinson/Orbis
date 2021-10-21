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


* Loop for setting a similar structure (as Sales and Number of employees) to additional variables to check for the Haltiwanger growth rates


foreach v in COGS Revenue Export_revenue Assets EBITDA{
	gen `v'_fHGR = `v'
	* Remove duplicates (updated)
	replace `v'_fHGR = 0.5 if `v'_fHGR==0
	replace `v'_fHGR = 0 if `v'_fHGR==.
	sort IDNum Year
	by IDNum Year: egen minE = min(`v'_fHGR)
	by IDNum Year: egen maxE = max(`v'_fHGR)

	* Drop the duplicate with missing number of employees 
	duplicates tag IDNum Year, gen(dup)
	gen tagMaxE = 1 if `v'_fHGR == maxE & `v'_fHGR > minE & dup > 0
	gen tagMinE = 1 if `v'_fHGR == minE & `v'_fHGR < maxE & minE <= 0.5 & dup > 0
	drop if tagMinE == 1
	drop dup

	* Drop remaining duplicates where there is no disrepancy
	duplicates drop IDNum Year, force
	replace `v'_fHGR = . if `v'_fHGR==0
	replace `v'_fHGR = 0 if `v'_fHGR==0.5

	drop minE minS maxE maxS tagMaxE tagMaxS tagMinE tagMinS

}



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

drop if (nEmployees<0)
replace nEmployees = . if (nEmployees == 0 & Sales > 0) | (nEmployees == 0 & Revenue > 0)

gen SalesPerEmployee=Sales/nEmployees

*---------------------------
* Sector
*---------------------------
destring NACE_Rev_2_Core_code_4_digits , generate(Industry_4digit)

gen Industry_2digit=floor(Industry_4digit/100)


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

* COGS (Haltiwanger)
bysort IDNum: gen COGS_h = (COGS_fHGR -L.COGS_fHGR )/((COGS_fHGR +L.COGS_fHGR )/2)
		
* Revenue (Haltiwanger)
bysort IDNum: gen Revenue_h = (Revenue_fHGR  - L.Revenue_fHGR )/((Revenue_fHGR  + L.Revenue_fHGR )/2)
		
* Export_revenue (Haltiwanger)
bysort IDNum: gen Export_revenue_h = (Export_revenue_fHGR  - L.Export_revenue_fHGR )/((Export_revenue_fHGR +L.Export_revenue_fHGR )/2)		

* Assets (Haltiwanger)
bysort IDNum: gen Assets_h = (Assets_fHGR  - L.Assets_fHGR )/((Assets_fHGR  + L.Assets_fHGR )/2)
		
* EBITDA (Haltiwanger)
bysort IDNum: gen EBITDA_h = (EBITDA_fHGR  - L.EBITDA_fHGR )/((EBITDA_fHGR  + L.EBITDA_fHGR )/2) 


*---------------------------
* Ownership
*---------------------------
destring No_of_recorded_shareholders, generate(nShareholders)

egen MinShareHolders=min(nShareholders), by(IDNum)
egen MaxShareHolders=max(nShareholders), by(IDNum)
gen DiffShareHolders=MaxShareHolders-MinShareHolders

drop MinShareHolders MaxShareHolders

gen Listed=1
replace Listed=0 if (Main_exchange=="Unlisted")


** Generate Firm Types
*drop if missing(nShareholders) & ~(Listed)

gen FirmType=.
replace FirmType=1 if (nShareholders==1) & ~(Listed)
replace FirmType=2 if (nShareholders==2) & ~(Listed)
replace FirmType=3 if (nShareholders>2) & ~missing(nShareholders) &  ~(Listed)
replace FirmType=4 if FirmType==. & ~(Listed)
replace FirmType=6 if (Listed)


*---------------------------
* IPO Info
*---------------------------


* Convert IPO date from monthly to yearly
gen IPO_year = year(IPO_date)


gen Delisted_year = yofd(Delisted_date)

*----------------------
* Save unbalanced panel
*----------------------

save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace

*--------------------------------------------------------------
* Create country-level-statistics for a country-level database
*--------------------------------------------------------------

preserve

gen Country="${CountryID}"

gen EmpGrowthInIPOYear=EmpGrowth_h if (IPO_year==Year)
gen EmpGrowthAroundIPOYear=EmpGrowth_h if ((IPO_year>=Year-1) & (IPO_year<=Year+1))


gen EmpOfIPOingFirm=nEmployees if  (IPO_year==Year)

* Private Share of Employment
su nEmployees if (Listed)
local Public=r(sum)
local PublicAvg=r(mean)

su nEmployees if (~Listed)
local Private=r(sum)
local PrivateAvg=r(mean)

gen PrivateShareOfEmp=`Private'/(`Public'+`Private')
gen PublicAvg=`PublicAvg'
gen PrivateAvg= `PrivateAvg'


* Share of number of firms
su nEmployees if (Listed) 
local nPublic=r(N)

su nEmployees if (~Listed) 
local nPrivate=r(N)

gen PrivateShareOfFirms=`nPrivate'/(`nPublic'+`nPrivate')




collapse (mean) nEmployees EmpGrowthInIPOYear EmpOfIPOingFirm EmpGrowthAroundIPOYear PrivateShareOfEmp ///
PublicAvg PrivateAvg PrivateShareOfFirms  , by(Country)

save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace

restore


*------------------
* Balanced Panel
*------------------

* Narrower year range for France
if "${CountryID}" == "FR"{
	drop if (Year<2010)
	drop if (Year>2014)
	drop if Sales == .
	drop if nEmployees == .
	drop if GrossProfits == .
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2010, 2014)), by(IDNum)
	keep if nyear == 5
	drop nyear
}
* Regular year range for other countries
else {
	drop if (Year<2009)
	drop if (Year>2018)
	drop if Sales == .
	drop if nEmployees == .
	drop if GrossProfits == .
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2009, 2018)), by(IDNum)
	keep if nyear == 10
	drop nyear
}


* Making sure it is strongly balanced 
xtset IDNum Year 

*--------------------
* Save balanced panel
*--------------------

save "Data_Cleaned/${CountryID}_Balanced.dta", replace

*---------------------------
* Create  One Percent sample
*---------------------------

* Characteristics: 
* One sample = one firm with all its years
preserve
tempfile tmps_public
keep if FirmType == 6 & IPO_year !=.
duplicates drop IDNum, force
sort FirmType
sample 50
save `tmps_public'
restore
preserve 
tempfile tmps
duplicates drop IDNum, force
sort FirmType
by FirmType: sample 1 // Always keep at least one public firm
sort IDNum
save `tmps'
restore
merge m:1 IDNum using `tmps_public'
rename _merge _merge0
merge m:1 IDNum using `tmps'
gen _merge_final = 0 
replace _merge_final = 1 if _merge == 3 | _merge0 == 3
keep if _merge_final == 1
drop _merge _merge_final _merge0
save Data_Cleaned/${CountryID}_OnePercent.dta, replace


