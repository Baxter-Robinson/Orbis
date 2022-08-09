**************************
* Construct Summary Info
**************************

*------------------
* Age
*------------------
gen Year=year(Closing_date)
egen FirstYear=min(Year), by(BvD_ID_Number)
replace FirstYear=year(IPO_date) if ((year(IPO_date)<year(FirstYear)) & ~missing(FirstYear))
replace FirstYear=year(Date_of_incorporation) if ((year(Date_of_incorporation)<year(FirstYear)) & ~missing(Date_of_incorporation) & (year(Date_of_incorporation)<year(IPO_date)) )
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

*---------------------------
* Financials
*---------------------------

rename Operating_revenue_Turnover Revenue
rename Costs_of_goods_sold COGS
rename Costs_of_employees WageBill
rename Total_assets Assets
rename P_L_before_tax GrossProfits

replace Sales = Revenue if (Sales == 0) & (Revenue > 0)

*---------------------------
* Number of Employees
*---------------------------
rename Number_of_employees nEmployees

gen SalesPerEmployee=Sales/nEmployees if (nEmployees>0)

*---------------------------
* Sector
*---------------------------
destring NACE_Rev_2_Core_code_4_digits , generate(Industry_4digit)

gen Industry_2digit=floor(Industry_4digit/100)


*---------------------------
* Growth Rates
*---------------------------
cap xtset IDNum Year

* Employment Growth Rate (Haltiwanger)
bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)
	
* Sales Growth Rate (Haltiwanger)
bysort IDNum: gen SalesGrowth_h = (Sales-L.Sales)/((Sales+L.Sales)/2)

* Profit Growth Rate (Haltiwanger)
bysort IDNum: gen ProfitGrowth_h = (GrossProfits-L.GrossProfits)/((GrossProfits+L.GrossProfits)/2)


*----------------------
* Winsorization Employment Growth from the bottom and top 0.5%
*----------------------
*winsor2 EmpGrowth_h, cuts(0.5 99.5) replace


*----------------------
* Trim firms with Haltiwanger Employment Growth from the bottom and top 0.5%
*----------------------
gen EmpGrowth_h2 = EmpGrowth_h
winsor2 EmpGrowth_h,  replace cuts(0.5 99.5) trim
gen dropFirm = 0
replace dropFirm=1 if (EmpGrowth_h==.) & (EmpGrowth_h2!=.)
sort dropFirm
keep if dropFirm==0
drop EmpGrowth_h2 dropFirm

*---------------------------
* IPO Info
*---------------------------


* Convert IPO date from monthly to yearly
gen IPO_year = year(IPO_date)
gen Delisted_year = yofd(Delisted_date)

*---------------------------
* Ownership
*---------------------------
destring No_of_recorded_shareholders, generate(nShareholders)

egen MinShareHolders=min(nShareholders), by(IDNum)
egen MaxShareHolders=max(nShareholders), by(IDNum)
gen DiffShareHolders=MaxShareHolders-MinShareHolders

drop MinShareHolders MaxShareHolders


gen EverPublic = 1
replace EverPublic = 0 if Main_exchange=="Unlisted"

** Generate Firm Types
*drop if missing(nShareholders) & ~(EverPublic)

gen FirmType=.
replace FirmType=1 if (nShareholders==1) & ~(EverPublic)
replace FirmType=2 if (nShareholders==2) & ~(EverPublic)
replace FirmType=3 if (nShareholders>2) & ~missing(nShareholders) &  ~(EverPublic)
replace FirmType=4 if FirmType==. & ~(EverPublic)
replace FirmType=6 if (EverPublic)


gen Private=0
replace Private = 1 if Main_exchange=="Unlisted" | (Main_exchange=="Delisted")  & (Year >= Delisted_year)

*----------------------
* Inclusion Criteria
*----------------------
drop if (Year<2009)
drop if (Year>2018)

drop if missing(nEmployees)

*----------------------
* Size Category 
*----------------------

sum nEmployees, detail
local max= r(max)
egen groups  = cut(nEmployees), at (1, 2, 5, 6, 10, 11, 50, 51, 100, 101, 1000, 1001, `max')

gen SizeCategory = . 
replace SizeCategory = 1 if groups==1
replace SizeCategory = 2 if (groups==2) | (groups==5)
replace SizeCategory = 3 if (groups==6) | (groups==10)
replace SizeCategory = 4 if (groups==11) | (groups==50)
replace SizeCategory = 5 if (groups==51) | (groups==100)
replace SizeCategory = 6 if (groups==101) | (groups==1000)
replace SizeCategory = 7 if (groups==1001) | (groups==`max')
drop groups 
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
su nEmployees if (Private==0)
local Public=r(sum)
local PublicAvg=r(mean)

su nEmployees if (Private==1)
local Private=r(sum)
local PrivateAvg=r(mean)

gen PrivateShareOfEmp=`Private'/(`Public'+`Private')
gen PublicAvg=`PublicAvg'
gen PrivateAvg= `PrivateAvg'


* Share of number of firms
su nEmployees if (Private==0) 
local nPublic=r(N)

su nEmployees if (Private==1) 
local nPrivate=r(N)

gen PrivateShareOfFirms=`nPrivate'/(`nPublic'+`nPrivate')


drop if Year < 2009
drop if Year > 2016

if "${CountryID}" == "FR" {
	drop if Year > 2014
}

* Emp Growth
su EmpGrowth_h if (Private==0) 
gen EmpGrowth_PubAll_Avg=r(mean)
gen EmpGrowth_PubAll_Std=r(sd)

su EmpGrowth_h if (Private==1)   
gen EmpGrowth_PriAll_Avg=r(mean)
gen EmpGrowth_PriAll_Std=r(sd)

su EmpGrowth_h if (Private==0) & (nEmployees>99)
gen EmpGrowth_PubLarge_Avg=r(mean)
gen EmpGrowth_PubLarge_Std=r(sd)

su EmpGrowth_h if (Private==1)  & (nEmployees>99)
gen EmpGrowth_PriLarge_Avg=r(mean)
gen EmpGrowth_PriLarge_Std=r(sd)


* Employment shares by Firm Type
bysort Year: egen nEmployeesTot = total(nEmployees)
bysort Year Private: egen nEmployeesTot_byFirmType = total(nEmployees)
gen EmpShare_Public=nEmployeesTot_byFirmType/nEmployeesTot if (Private==0)


bysort Year: egen nEmployeesTot_Large = total(nEmployees) if (nEmployees>99)
gen EmpShare_Large=nEmployeesTot_Large/nEmployeesTot if (nEmployees>99)


collapse (mean) nEmployees EmpGrowthInIPOYear EmpOfIPOingFirm EmpGrowthAroundIPOYear PrivateShareOfEmp ///
PublicAvg PrivateAvg PrivateShareOfFirms EmpGrowth_PubAll_Avg EmpGrowth_PubAll_Std EmpGrowth_PriAll_Avg EmpGrowth_PriAll_Std ///
  EmpGrowth_PubLarge_Avg EmpGrowth_PubLarge_Std EmpGrowth_PriLarge_Avg EmpGrowth_PriLarge_Std ///
  EmpShare_Public  EmpShare_Large , by(Country)

save "Data_Cleaned/${CountryID}_CountryLevel.dta", replace

restore


*------------------
* Save Balanced Panel
*------------------

* Narrower year range for France
if "${CountryID}" == "FR"{
	drop if (Year<2010)
	drop if (Year>2014)
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2010, 2014)), by(IDNum)
	keep if nyear == 5
	drop nyear
}
* Regular year range for other countries
else {
	sort IDNum Year
	*by IDNum: drop if (missing(nEmployees)| missing(Sales))
	egen nyear = total(inrange(Year, 2009, 2018)), by(IDNum)
	su nyear 
	keep if nyear == r(max)
	drop nyear
}


* Making sure it is strongly balanced 
xtset IDNum Year 


save "Data_Cleaned/${CountryID}_Balanced.dta", replace

*---------------------------
* Create One Percent sample
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


