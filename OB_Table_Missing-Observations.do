file close _all

* Use Raw Data
use "${DATAPATH}/${CountryID}_merge.dta", clear

file open TabMissingObs using Output/${CountryID}/Table_Missing-Observations.tex, write replace

* Table format for latex (top)

*Name of variables
*file write TabMissingObs "Full Sample & No Employees & No Sales & No Revenues & No Assets & Missing shareholders \\ \midrule"_n

* Compare number of observations (firm-years) lost when for each data cleaning step

* Number of obs before any cleaning
su Closing_date
global N_tot = r(N)
local N_tot_di: di %12.0fc $N_tot
file write TabMissingObs "& `N_tot_di' (100 \%)  &"

* No employees
preserve
	rename Number_of_employees nEmployees
	drop if (nEmployees<0) | (nEmployees==.)
	su Closing_date
	local N_emp = $N_tot - r(N)
	local N_emp_di: di %12.0fc `N_emp'
	local perc: di %3.1fc (`N_emp'/$N_tot)*100
	file write TabMissingObs "`N_emp_di' (`perc' \%)  &"
restore
* No Sales
preserve
	drop if (Sales<0) | (Sales == .)
	su Closing_date
	local N_sale = $N_tot - r(N)
	local N_sale_di: di %12.0fc `N_sale'
	local perc: di %3.1fc (`N_sale'/$N_tot)*100
	file write TabMissingObs "`N_sale_di' (`perc' \%)  &"
restore
* No Revenues
preserve
	rename Operating_revenue_Turnover Revenue
	drop if (Revenue<0) | (Revenue==.)
	su Closing_date
	local N_rev = $N_tot - r(N)
	local N_rev_di: di %12.0fc `N_rev'
	local perc: di %3.1fc (`N_rev'/$N_tot)*100
	file write TabMissingObs "`N_rev_di' (`perc' \%)  &"
restore
* No Assets
preserve
	rename Total_assets Assets
	drop if (Assets<0) | (Assets==.)
	su Closing_date
	local N_asset = $N_tot - r(N)
	local N_asset_di: di %12.0fc `N_asset'
	local perc: di %3.1fc (`N_asset'/$N_tot)*100
	file write TabMissingObs "`N_asset_di' (`perc' \%)  &"
restore
* Missing Shareholders
preserve
	destring No_of_recorded_shareholders, generate(nShareholders)
	gen Listed=1
	replace Listed=0 if (Main_exchange=="Unlisted")
	drop if missing(nShareholders) & ~(Listed)
	su Closing_date
	local N_share = $N_tot - r(N)
	local N_share_di: di %12.0fc `N_share'
	local perc: di %3.1fc (`N_share'/$N_tot)*100
	file write TabMissingObs "`N_share_di' (`perc' \%)  \\"_n
restore
*file write TabMissingObs "\bottomrule"
file close _all