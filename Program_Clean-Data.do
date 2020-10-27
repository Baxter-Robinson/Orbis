**************************
* Construct Summary Info
**************************

*------------------
* Age
*------------------
gen Year=year(Closing_date)
egen FirstYear=min(Year), by(BvD_ID_Number)
replace FirstYear=year(IPO_date) if ((year(IPO_date)<year(FirstYear)) & ~missing(FirstYear))
replace FirstYear=year(Date_of_incorporation) if ((year(IPO_date)<year(Date_of_incorporation)) & ~missing(Date_of_incorporation))

gen Age=Year-FirstYear
drop FirstYear

drop if (Year<1997)
drop if (Year>2017)

*---------------------------
* Number of Employees
*---------------------------
rename Number_of_employees nEmployees

drop if (nEmployees<=0)


*---------------------------
* Ownership
*---------------------------
destring No_of_recorded_shareholders, generate(nShareholders)

egen MinShareHolders=min(nShareholders), by(BvD_ID_Number)
egen MaxShareHolders=max(nShareholders), by(BvD_ID_Number)
gen DiffShareHolders=MaxShareHolders-MinShareHolders

drop MinShareHolders MaxShareHolders

gen Listed=1
replace Listed=0 if (Main_exchange=="Unlisted")

*---------------------------
* Financials
*---------------------------

rename Operating_revenue_Turnover Revenue
rename Costs_of_goods_sold COGS
rename Costs_of_employees WageBill
rename Total_assets Assets
rename P_L_before_tax GrossProfits

gen TotalCosts=COGS+WageBill

drop if (Revenue<0)
drop if (Sales<0)
drop if (Assets<0)
