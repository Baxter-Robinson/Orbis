
cls
insheet using "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Enterprise_Statistics.csv", comma clear
drop v1

rename v11110-v94310, upper
label var V11110 "Enterprises - number "
label var V12110 "Turnover or gross premiums written - million euro "
label var V12120 "Production value - million euro "
*label var V12130 "Gross margin on goods for resale - million euro "
label var V12150 "Value added at factor cost - million euro "
label var V12170 "Gross operating surplus - million euro "
label var V13110 "Total purchases of goods and services - million euro "
*label var V13120 "Purchases of goods and services purchased for resale in the same condition as received - million euro "
*label var V13131  "Payments for agency workers - million euro "
label var V13310 "Personnel costs - million euro "
label var V13320 "Wages and Salaries - million euro "
label var V13330 "Social security costs - million euro "
*label var V15110 "Gross investment in tangible goods - million euro "
label var V16110 "Persons employed - number "
label var V16120 "Unpaid persons employed - number "
label var V16130 "Employees - number "
*label var V16140 "Employees in full time equivalent units - number "
label var V16150 "Hours worked by employees"
label var V91100 "Turnover per person employed - thousand euro "
label var V91110 "Apparent labour productivity (Gross value added per person employed) - thousand euro "
label var V91120 "Wage adjusted labour productivity (Apparent labour productivity by average personnel costs) - percentage "
label var V91130 "Gross value added per employee - thousand euro "
label var V91150 "Gross value added per hour worked by employees"
label var V91170 "Share of personnel costs in production - percentage "
label var V91210 "Average personnel costs (personnel costs per employee) - thousand euro "
label var V91275 "Share of employees in persons employed - percentage "
label var V91290 "Growth rate of employment - percentage "
label var V91310 "Employer's social charges as a percentage of personnel costs - percentage "
label var V92100 "Persons employed per enterprise - number "
label var V92110 "Gross operating surplus/turnover (gross operating rate) - percentage "
label var V92111 "Value added at factor cost in production value - percentage "
label var V92112 "Share of personnel costs in total purchases of goods and services - percentage "
*label var V92113 "Share of gross operating surplus in value added - percentage "
*label var V94414 "Investment per person employed - thousands euro "
*label var V94415 "Investment rate (investment/value added at factors cost) - percentage "

rename country Country
rename year Year
rename nace_rev2 NACE_Rev2
rename size Size
rename index Index
rename 	 	V11110	Firms
rename 	 	V12110	Turnover
rename 	 	V12120	Production
*rename 	 	V12130	ResaleMargin
rename 	 	V12150	ValueAdded
rename 	 	V12170	GrossSurplus
rename 	 	V13110	TotalIntermediates
*rename 	 	V13120	PurchaseResaleGoods
*rename 	 	V13131 	PaymentsAgencyWorkers
rename 	 	V13310	LaborBill
rename 	 	V13320	Wages
rename 	 	V13330	SocialSecurityPayments
*rename 	 	V15110	InvestmentTangible
rename 	 	V16110	nEmployees1
rename 	 	V16120	UnpaidEmployees
rename 	 	V16130	nEmployees2
*rename 	 	V16140	nEmployees3
rename      V16150 HoursWorked
rename 	 	V91100	TurnoverPerEmployee
rename 	 	V91110	LaborProductivity
rename 	 	V91120	WageAdj_LaborProductivity
rename 	 	V91130	GrossValueEmployee
rename 	 	V91150  GrossValueHour
rename 	 	V91170	LaborCostProduction_PCT
rename 	 	V91210	AvgLaborCosts
rename 	 	V91275	ShareEmployment_PCT
rename 	 	V91290	EmploymentGrowth_PCT
rename 	 	V91310	SocialSecuritytoLaborBill_PCT
rename 	 	V92100	nEmployees_per_Firm
rename 	 	V92110	Gross_Surplus_PCT
rename 	 	V92111	ValueAdded_PCT
rename 	 	V92112	SharePersonnel_Intermediates_PCT
*rename 	 	V92113	Gross_Surplus_Intermediates_PCT
*rename 	 	V94414	Investment_nEmployees_PCT
*rename 	 	V94415	Investment_ValueAdded_PCT


label var V94210 "Share of value added in manufacturing total - percentage"
rename V94210 ShareValueAddedManufacturing_PCT

label var V94240 "Share of production value in manufacturing total - percentage"
rename V94240 ShareProductionManufacturing_PCT

label var V94270 "Share of turnover in manufacturing total - percentage"
rename V94270 ShareTurnoverManufacturing_PCT

label var V94310 "Share of employment in manufacturing total"
rename V94310 ShareEmpManufacturing

label var V91230 "Labor Cost per Hour Worked"
rename V91230 LaborCostHour



save "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Cleaned/EuroStat_Enterprise_Statistics.dta", replace






