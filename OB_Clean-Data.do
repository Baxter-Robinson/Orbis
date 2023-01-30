**************************
* Construct Summary Info
**************************
use "${DATAPATH}/${CountryID}_merge.dta", clear

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
rename var15 RaDExpenses

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

* Asset Growth Rate (Haltiwanger)
bysort IDNum: gen AssetGrowth_h = (Assets-L.Assets)/((Assets+L.Assets)/2)

* SalesPerEmployee Growth Rate (Haltiwanger)
bysort IDNum: gen SalePerEmpGrowth_h = (SalesPerEmployee-L.SalesPerEmployee)/((SalesPerEmployee+L.SalesPerEmployee)/2)



*---------------------------
* IPO Info
*---------------------------


* Convert IPO date from monthly to yearly
gen IPO_year = year(IPO_date)
gen Delisted_year = yofd(Delisted_date)
* Generate variable that tells number of years before/after IPO
gen IPO_timescale = Year - IPO_year

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


gen Public=0
replace Public=1 if Main_exchange !="Unlisted" & (Main_exchange !="Delisted" | (Year< Delisted_year))


*-------------------------------------------------
* For Public Firms Merge In Compustat Data
*-------------------------------------------------
gen DataSet="OB"
append using "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta"
replace DataSet="CS" if missing(DataSet)

replace Public=1 if DataSet=="CS"


* Find unique year-nEmployee Pairs within both datasets 
gen ones=1 if (Public==1)
 by DataSet Year nEmployees, sort: gen nObs=sum(ones)
 by DataSet Year nEmployees, sort: replace nObs=nObs[_N]
 
 gen UniqueInDataSet=0
 replace UniqueInDataSet=1 if (nObs==1)

 
 * Check if these unique year-nEmployee Pairs are matched across datasets
 by Year nEmployees, sort: gen nDataSetsForYearnEmpCombo=sum(UniqueInDataSet)
 by Year nEmployees, sort: replace nDataSetsForYearnEmpCombo=nDataSetsForYearnEmpCombo[_N]
 gen PotentialMatch=1 if (nDataSetsForYearnEmpCombo==2)

  * Figure out Orbis IDNum for the Compustat Firms
 gen OrbisIDNum=IDNum if (DataSet=="OB") & (PotentialMatch==1)
 by Year nEmployees, sort: egen OrbisIDNumByMatch=mode(OrbisIDNum)
 by IDNum DataSet, sort: egen OrbisIDNumByFirm=mode(OrbisIDNumByMatch)
 

* If multiple CS firms match the same Orbis firm, keep the OB-CS matches with the highest number of years matched
by DataSet IDNum OrbisIDNumByMatch, sort: gen nMatchingYears=sum(PotentialMatch)
by DataSet IDNum OrbisIDNumByMatch, sort: replace nMatchingYears=nMatchingYears[_N]

by DataSet OrbisIDNumByMatch, sort: egen MaxnYearMatch=max(nMatchingYears)
gen ValidMatch=1 if (PotentialMatch==1) & (nMatchingYears==MaxnYearMatch)

* If multiple CS firms still match the same Orbis firm, keep the OB-CS matches with the largest number of employees
by DataSet OrbisIDNumByMatch, sort: egen MaxnEmpMatch=max(nEmployees) if (ValidMatch==1)
by DataSet IDNum OrbisIDNumByMatch, sort: egen MaxnEmpFirmMatch=max(nEmployees) if (ValidMatch==1)
replace ValidMatch=. if (MaxnEmpFirmMatch<MaxnEmpMatch)

replace OrbisIDNumByMatch=. if missing(ValidMatch)
drop OrbisIDNumByFirm
by IDNum DataSet, sort: egen OrbisIDNumByFirm=mode(OrbisIDNumByMatch)

* If multiple CS firms still match the same Orbis firm, drop them
by DataSet IDNum OrbisIDNumByFirm, sort: gen FirmMatched=_n==1
by OrbisIDNumByFirm DataSet, sort: gen nFirms=sum(FirmMatched)
by  OrbisIDNumByFirm DataSet, sort: replace nFirms=nFirms[_N]

drop if (nFirms>1) & (DataSet=="CS")

 
sort  DataSet OrbisIDNumByFirm IDNum Year
br DataSet Year IDNum nEmployees ones nObs UniqueInDataSet nDataSetsForYearnEmpCombo PotentialMatch OrbisIDNum OrbisIDNumByMatch OrbisIDNumByFirm nMatchingYears  MaxnYearMatch ValidMatch MaxnEmpFirmMatch MaxnEmpMatch  FirmMatched nFirms

 * Unmatched Orbis firms
 replace OrbisIDNumByFirm=IDNum if (DataSet=="OB")

 * Drop unmatched Compustate Firms
 drop if (DataSet=="CS") & missing(OrbisIDNumByFirm)
 
 
 local Variables Revenue Sales COGS Export_revenue Assets Fixed_assets Tangible_fixed_assets Intangible_fixed_assets Working_capital Material_costs Loans Interest_paid RaDExpenses Gross_profit Long_term_debt Shareholders_funds WageBill nEmployees GrossProfits EBITDA Stock Market_capitalisation_mil Type_of_entity Category_of_the_company Main_exchange IPO_date nShareholders NACE_Rev_2_main_section NACE_Rev_2_Core_code_4_digits Industry_4digit NACE_Rev_2_Primary_code_s NACE_Rev_2_SEcondary_code_s US_SIC_Core_code_3_digits US_SIC_Primary_code_s US_SIC_Secondary_code_s BvD_major_sector Age SalesPerEmployee Industry_2digit SalesGrowth_h ProfitGrowth_h AssetGrowth_h SalePerEmpGrowth_h IPO_year Delisted_year IPO_timescale EverPublic FirmType Public
 
 keep `Variables' OrbisIDNumByFirm Year DataSet


 reshape wide `Variables', i(OrbisIDNumByFirm Year)  j(DataSet) string
 
 
 gen OriginOB=0
 replace OriginOB=1 if ~missing(nEmployeesOB)
 replace nEmployeesOB=nEmployeesCS if ~missing(nEmployeesCS)
 replace OriginOB=0 if ~missing(nEmployeesCS)

rename OrbisIDNumByFirm IDNum

drop *CS

foreach var of local Variables {
	rename `var'OB `var'
}
 
 
bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)


*-------------------------------------------------
* Remove Remaining Outliers
*-------------------------------------------------
gen Rise=0
gen Fall=0

gen Drop=0


replace Rise=1 if ~missing(EmpGrowth_h) & (EmpGrowth_h>1.90) & (nEmployees>20) 
replace Fall=1 if (EmpGrowth_h<-1.90) & (L.nEmployees>20) 

* Before Rises
replace Drop=1 if (F.Rise==1) & (Fall==0)
replace Drop=1 if (F2.Rise==1) & (F1.Drop==1) & (Fall==0) & ~missing(nEmployees)
replace Drop=1 if (F3.Rise==1) & (F1.Drop==1) & (Fall==0) & ~missing(nEmployees)
replace Drop=1 if (F4.Rise==1) & (F1.Drop==1) & (Fall==0) & ~missing(nEmployees)


* After Falls
replace Drop=1 if (Fall==1) 
replace Drop=1 if (L.Fall==1) & (Rise==0)  & ~missing(nEmployees)
replace Drop=1 if (L2.Fall==1) & (L1.Drop==1) & (Rise==0)  & ~missing(nEmployees)
replace Drop=1 if (L3.Fall==1) & (L2.Drop==1) & (Rise==0)  & ~missing(nEmployees)
replace Drop=1 if (L4.Fall==1) & (L3.Drop==1) & (Rise==0)  & ~missing(nEmployees)

drop if Drop==1

drop EmpGrowth_h
bysort IDNum: gen EmpGrowth_h = (nEmployees-L.nEmployees)/((nEmployees+L.nEmployees)/2)
 

*----------------------
* Inclusion Criteria
*----------------------
drop if (Year<2009)
drop if (Year>2018)

drop if missing(nEmployees)


*----------------------
* Winsorization Employment/Assets/Sales/SalesPerEmp/EmpGrowth 
* All Winsorizations should be done based on Public vs. Private
*----------------------
winsor2 nEmployees, cuts(0.5 99.5) replace by(Public Year)
winsor2 Assets, cuts(0.5 99.5) replace by(Public Year)
winsor2 Sales, cuts(0.5 99.5) replace by(Public Year)
winsor2 SalesPerEmployee, cuts(0.5 99.5) replace by(Public Year)
winsor2 EmpGrowth_h, cuts(0.5 99.5) replace by(Public Year)

*----------------------
* Size Categories
*----------------------

sum nEmployees, detail
local max= r(max)

* Ayerst Robinson (AR) Size Categories
egen groups  = cut(nEmployees), at (1, 2, 5, 6, 10, 11, 50, 51, 100, 101, 1000, 1001, `max')
gen SizeCategoryAR = . 
replace SizeCategoryAR = 1 if groups==1
replace SizeCategoryAR = 2 if (groups==2) | (groups==5)
replace SizeCategoryAR = 3 if (groups==6) | (groups==10)
replace SizeCategoryAR = 4 if (groups==11) | (groups==50)
replace SizeCategoryAR = 5 if (groups==51) | (groups==100)
replace SizeCategoryAR = 6 if (groups==101) | (groups==1000)
replace SizeCategoryAR = 7 if (groups==1001) | (groups==`max')
drop groups 

* EuroStat Size Categories
egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')
gen SizeCategoryES = . 
replace SizeCategoryES = 1 if (groups==0) | (groups==9)
replace SizeCategoryES = 2 if (groups==10) | (groups==19)
replace SizeCategoryES = 3 if (groups==20) | (groups==49)
replace SizeCategoryES = 4 if (groups==50) | (groups==249)
replace SizeCategoryES = 5 if (groups==250) | (groups==`max')
drop groups 

*----------------------
* Save unbalanced panel
*----------------------

save "Data_Cleaned/${CountryID}_Unbalanced.dta", replace

*----------------------
* Save BySize Categories
*----------------------
collapse (sum) nEmployees (count) nFirms=nEmployees, by (SizeCategoryES Year)

gen DataSet="OB"

save "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", replace


