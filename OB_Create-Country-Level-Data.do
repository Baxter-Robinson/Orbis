*--------------------------------------------------------------
* Create country-level-statistics for a country-level database
*--------------------------------------------------------------
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear

* Private Share of Employment
su nEmployees if (Public==1)
local Public=r(sum)
local PublicAvg=r(mean)

su nEmployees if (Public==0)
local Private=r(sum)
local PrivateAvg=r(mean)

gen PrivateShareOfEmp=`Private'/(`Public'+`Private')
gen PublicAvg=`PublicAvg'
gen PrivateAvg= `PrivateAvg'


* Share of number of firms
su nEmployees if (Public==1)
local nPublic=r(N)

su nEmployees if (Public==0)
local nPrivate=r(N)

gen nFirmsShare_Public=`nPublic'/(`nPublic'+`nPrivate')


drop if Year < 2009
drop if Year > 2016

if "${CountryID}" == "FR" {
	drop if Year > 2014
}

* Emp Growth
su EmpGrowth_h 
gen EmpGrowth_All_Avg=r(mean)
gen EmpGrowth_All_Std=r(sd)

su EmpGrowth_h if (Public==1)
gen EmpGrowth_PubAll_Avg=r(mean)
gen EmpGrowth_PubAll_Std=r(sd)

su EmpGrowth_h if (Public==0)
gen EmpGrowth_PriAll_Avg=r(mean)
gen EmpGrowth_PriAll_Std=r(sd)

su EmpGrowth_h if (Public==1) & (nEmployees>99)
gen EmpGrowth_PubLarge_Avg=r(mean)
gen EmpGrowth_PubLarge_Std=r(sd)

su EmpGrowth_h if (Public==0)  & (nEmployees>99)
gen EmpGrowth_PriLarge_Avg=r(mean)
gen EmpGrowth_PriLarge_Std=r(sd)

** Asset Ratios
su Assets if (Public==1)
local TotAss=r(sum)

su nEmployees if (Public==1)
local TotEmp=r(sum)

su Revenue if (Public==1)
local TotRev=r(sum)

gen AssetsPerEmp_PubAll=`TotAss'/`TotEmp'
gen AssetsPerRev_PubAll=`TotAss'/`TotRev'

su Assets if (Public==0)
local TotAss=r(sum)

su nEmployees if (Public==0)
local TotEmp=r(sum)

su Revenue if (Public==0)
local TotRev=r(sum)

gen AssetsPerEmp_PriAll=`TotAss'/`TotEmp'
gen AssetsPerRev_PriAll=`TotAss'/`TotRev'

su Assets if (Public==1)  & (nEmployees>99)
local TotAss=r(sum)

su nEmployees if (Public==1)  & (nEmployees>99)
local TotEmp=r(sum)

su Revenue if (Public==1)  & (nEmployees>99)
local TotRev=r(sum)

gen AssetsPerEmp_PubLarge=`TotAss'/`TotEmp'
gen AssetsPerRev_PubLarge=`TotAss'/`TotRev'

su Assets if (Public==0)  & (nEmployees>99)
local TotAss=r(sum)

su nEmployees if (Public==0)  & (nEmployees>99)
local TotEmp=r(sum)

su Revenue if (Public==0)  & (nEmployees>99)
local TotRev=r(sum)

gen AssetsPerEmp_PriLarge=`TotAss'/`TotEmp'
gen AssetsPerRev_PriLarge=`TotAss'/`TotRev'



* Employment shares by Firm Type
bysort Year: egen nEmployeesTot = total(nEmployees)
bysort Year Public: egen nEmployeesTot_byFirmType = total(nEmployees)
gen EmpShare_Public=nEmployeesTot_byFirmType/nEmployeesTot*100 if (Public==1)

bysort Year: egen nEmployeesTot_Large = total(nEmployees) if (nEmployees>99)
gen EmpShare_Large=nEmployeesTot_Large/nEmployeesTot*100 if (nEmployees>99)

bysort Year: egen MarketCap = total(Market_capitalisation_mil) if (Public==1)

if "${CountryID}" == "FR" {
	local StartYear=2009
	local FinishYear=2014
}
else {
	local StartYear=2009
	local FinishYear=2016
}

gen Emp_Percentile=.
forvalues t=`StartYear'/`FinishYear'{
	disp "`t'"
	xtile Emp_Percentile_temp= nEmployees  if (Year==`t') , nq(100)
	replace Emp_Percentile=Emp_Percentile_temp if (Year==`t')
	
	 drop Emp_Percentile_temp
	 
}

 gen PercentileGroups=.
 
replace PercentileGroups=5 if (Emp_Percentile>50)
replace PercentileGroups=4 if (Emp_Percentile>80)
replace PercentileGroups=3 if (Emp_Percentile>90) 
replace PercentileGroups=2 if (Emp_Percentile>95)
replace PercentileGroups=1 if (Emp_Percentile==100)

gen EmpShare_Top01Perc=.
gen EmpShare_Top05Perc=.
gen EmpShare_Top10Perc=.
gen EmpShare_Top20Perc=.
gen EmpShare_Top50Perc=.

local t=2009

forvalues t=2009/2016{
	quietly sum nEmployees if (PercentileGroups==1) & (Year==`t')
	replace EmpShare_Top01Perc=r(sum)/nEmployeesTot if (Year==`t')
	
	quietly sum nEmployees if (PercentileGroups<=2) & (Year==`t')
	replace EmpShare_Top05Perc=r(sum)/nEmployeesTot if (Year==`t')
	
	quietly sum nEmployees if (PercentileGroups<=3) & (Year==`t')
	replace EmpShare_Top10Perc=r(sum)/nEmployeesTot if (Year==`t')
	
	quietly sum nEmployees if (PercentileGroups<=4) & (Year==`t')
	replace EmpShare_Top20Perc=r(sum)/nEmployeesTot if (Year==`t')
	
	quietly sum nEmployees if (PercentileGroups<=5) & (Year==`t')
	replace EmpShare_Top50Perc=r(sum)/nEmployeesTot if (Year==`t')

}

* R&D Expenses to Total Revenue
bysort Year: egen TotRandD = total(RaDExpenses) if (Public==1)
bysort Year: egen TotRevenue = total(Revenue) if (Public==1)

gen RaDToRev=TotRandD/TotRevenue


* Standard Deviation of Employment
bysort Year: egen Emp_Std=sd(nEmployees)
bysort Year: egen LnEmp_Std=sd(ln(nEmployees))

* Years Since IPO
gen YearsSinceIPO=IPO_timescale if (IPO_timescale>0)

bysort Year: egen AvgYearsSinceIPO=mean(YearsSinceIPO)


local AllVars EmpGrowth_All_Avg EmpGrowth_All_Std nFirmsShare_Public ///
  EmpGrowth_PubAll_Avg EmpGrowth_PubAll_Std EmpGrowth_PriAll_Avg EmpGrowth_PriAll_Std ///
  EmpGrowth_PubLarge_Avg EmpGrowth_PubLarge_Std EmpGrowth_PriLarge_Avg EmpGrowth_PriLarge_Std ///
  EmpShare_Public  EmpShare_Large MarketCap EmpShare_Top* ///
  AssetsPerEmp_* AssetsPerRev_*  RaDToRev Emp_Std LnEmp_Std AvgYearsSinceIPO
  
collapse (mean) `AllVars', by(Year)
  
gen Country="${CountryID}"

collapse (mean) `AllVars', by(Country)

save "Data_Cleaned/${CountryID}_CountryLevel_OB_Main.dta", replace
