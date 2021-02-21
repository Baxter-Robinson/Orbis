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

* XXX Currently it just retains the first observation - need to code this to take a consistent closing date with the other years XXX
duplicates drop IDNum Year , force

xtset IDNum Year



*---------------------------
* Sector
*---------------------------
destring NACE_Rev_2_Core_code_4_digits , generate(Industry_4digit)

gen Industry_2digit=floor(Industry_4digit/100)

*---------------------------
* Number of Employees
*---------------------------
rename Number_of_employees nEmployees

drop if (nEmployees<=0)


gen EmpGrowth=D.nEmployees/nEmployees

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
replace FirmType=6 if (Listed)


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


gen SalesPerEmployee=Sales/max(nEmployees,1)

*----------------------
* Save unbalanced panel
*----------------------

save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace

*------------------
* Balanced Panel
*------------------
drop if (Year<2009)
drop if (Year>2018)

sort IDNum Year
by IDNum: drop if (missing(nEmployees)| missing(Sales))
egen nyear = total(inrange(Year, 2009, 2018)), by(IDNum)
keep if nyear == 10

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
tempfile tmps
duplicates drop IDNum, force
sample 1
sort IDNum
save `tmps'
restore
merge m:1 IDNum using `tmps'
keep if _merge == 3
drop _merge
save Data_Cleaned/${CountryID}_OnePercent.dta, replace



