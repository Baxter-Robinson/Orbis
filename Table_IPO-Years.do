preserve

	* Generate variable that tells number of years before/after IPO
	gen IPO_timescale = Year - IPO_year
	* Number of firms for which we have +/- x years relative to IPO
	sort IDNum
	*+/- three years
	gen PlusMinus_ThreeYears_all = 1 if (IPO_timescale==-3) | (IPO_timescale==-2) | (IPO_timescale==-1) |/*
	*/ (IPO_timescale==0) | (IPO_timescale==1) | (IPO_timescale==2) | (IPO_timescale==3)
	egen PlusMinus_ThreeYears = total(PlusMinus_ThreeYears_all), by(IDNum)
	replace PlusMinus_ThreeYears = . if PlusMinus_ThreeYears < 7
	replace PlusMinus_ThreeYears = 1 if PlusMinus_ThreeYears == 7
	replace PlusMinus_ThreeYears = . if (PlusMinus_ThreeYears == 1) & (IPO_timescale < -3)
	replace PlusMinus_ThreeYears = . if (PlusMinus_ThreeYears == 1) & (IPO_timescale > 3)
	*+/- two years
	gen PlusMinus_TwoYears_all = 1 if (IPO_timescale==-2) | (IPO_timescale==-1) |/*
	*/ (IPO_timescale==0) | (IPO_timescale==1) | (IPO_timescale==2)
	egen PlusMinus_TwoYears = total(PlusMinus_TwoYears_all), by(IDNum)
	replace PlusMinus_TwoYears = . if PlusMinus_TwoYears < 5
	replace PlusMinus_TwoYears = 1 if PlusMinus_TwoYears == 5
	replace PlusMinus_TwoYears = . if (PlusMinus_TwoYears == 1) & (IPO_timescale < -2)
	replace PlusMinus_TwoYears = . if (PlusMinus_TwoYears == 1) & (IPO_timescale > 2)
	*+/- one years
	gen PlusMinus_OneYear_all = 1 if (IPO_timescale==-1) | (IPO_timescale==0) | (IPO_timescale==1)
	egen PlusMinus_OneYear = total(PlusMinus_OneYear_all), by(IDNum)
	replace PlusMinus_OneYear = . if PlusMinus_OneYear < 3
	replace PlusMinus_OneYear = 1 if PlusMinus_OneYear == 3
	replace PlusMinus_OneYear = . if (PlusMinus_OneYear == 1) & (IPO_timescale < -1)
	replace PlusMinus_OneYear = . if (PlusMinus_OneYear == 1) & (IPO_timescale > 1)
	
	* Create table for number of IPO firms with observations before and after
	file close _all
	file open TabIPOyears using Output/${CountryID}/Table_IPO-Years.tex, write replace
	*Name of variables
	*file write TabIPOyears "& Total & (+/-) One year & (+/-) Two years & (+/-) Three years \\ \midrule"_n
	* Numer of IPO Firms
	file write TabIPOyears " ${CountryID} &"
	* Total
	egen unique_IPO = group(IDNum) if IPO_year != .
	su unique_IPO 
	local N: di %12.0fc r(max)
	file write TabIPOyears "`N' &"
	* +/- one year
	su PlusMinus_OneYear
	local N: di %12.0fc r(N)/3
	file write TabIPOyears "`N' &"
	* +/- two years
	su PlusMinus_TwoYears
	local N: di %12.0fc r(N)/5
	file write TabIPOyears "`N' &"
	* +/- three years
	su PlusMinus_ThreeYears
	local N: di %12.0fc r(N)/7
	file write TabIPOyears "`N' \\"_n
	file close _all
	
	* Create table for proportion of IPO firms that become delisted
	su unique_IPO
	local N_IPO: di %4.0fc r(max)
	egen unique_IPO_delisted = group(IDNum) if (Delisted_date !=.) & (IPO_year != .)
	su unique_IPO_delisted
	local N_delisted: di %4.0fc r(max)
	local perc_delisted: di (`N_delisted'/`N_IPO')*100
	file open TabDelistedIPO using Output/${CountryID}/Table_IPO-Delisted.tex, write replace
	* Column names
	file write TabDelistedIPO "number of IPO  & number IPO delisted & (\%) delisted \\ \midrule"_n
	* Number of unique IPO firms
	file write TabDelistedIPO "`N_IPO' &"
	* Number of delisted IPO firms
	file write TabDelistedIPO "`N_delisted' &"
	* Percentage of delisted firms
	file write TabDelistedIPO "`perc_delisted' \\"_n
	file write TabDelistedIPO "\bottomrule"
	file close _all
	
	* Create table for Number of firms where we observe 1/2/3 years after delisted
	su unique_IPO_delisted if Year - Delisted_year == 1
	local N_plusone: di %4.0fc r(max)
	su unique_IPO_delisted if Year - Delisted_year == 2
	local N_plustwo: di %4.0fc r(max)
	su unique_IPO_delisted if Year - Delisted_year == 3
	local N_plusthree: di %4.0fc r(max)
	egen unique_IPO_delisted_above3 = group(IDNum) if Year - Delisted_year > 3 & (Delisted_date !=.) & (IPO_year != .)
	su unique_IPO_delisted_above3
	local N_abovethree: di %4.0fc r(max)
	file open TabDelistedIPO_after using Output/${CountryID}/Table_IPO-AfterDelisted.tex, write replace
	* Column names
	file write TabDelistedIPO_after "1 year after & 2 years after & 3 years after & >3 years after \\ \midrule"_n
	* One year after
	file write TabDelistedIPO_after "`N_plusone' &"
	* Two years after
	file write TabDelistedIPO_after "`N_plustwo' &"
	* Three years after
	file write TabDelistedIPO_after "`N_plusthree' &"
	* More than three years after
	file write TabDelistedIPO_after "`N_abovethree' \\"_n
	file write TabDelistedIPO_after "\bottomrule"
	file close _all
restore