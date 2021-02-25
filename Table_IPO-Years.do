preserve
	* Convert IPO date from monthly to yearly
	gen IPO_year = year(IPO_date)
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
	
	* Create table
	file close _all
	file open TabIPOyears using Output/${CountryID}/Table_IPO-Years.tex, write replace
	*Name of variables
	file write TabIPOyears "& Total & (+/-) One year & (+/-) Two years & (+/-) Three years \\ \midrule"_n
	* Numer of IPO Firms
	file write TabIPOyears "Number of IPO Firms &"
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
	
	file write TabIPOyears "\bottomrule"
	
	file close _all
restore