preserve

	drop if missing(IPO_timescale)
	
	*-------------------------------------------------------------------------
	* Create tables for number of IPO firms with observations before and after
	*  Any firms within +/- 3 years of an IPO
	*-------------------------------------------------------------------------
	file close _all
	file open TabIPOyears using Output/${CountryID}/Table_IPO-Years_Any.tex, write replace
	*Name of variables
	*file write TabIPOyears " & -3 & -2 & -1 & Year of IPO & +1 & +2 & +3 \\ \midrule"_n
	* Numer of IPO Firms
	file write TabIPOyears " ${CountryID} "
	* Total
	forval t=-3/3{
		sum IPO_timescale if (IPO_timescale==`t')
		local nFirms : di %12.0fc r(N)
		file write TabIPOyears " & `nFirms' "
		
	}
	file close _all
	
	
	*-------------------------------------------------------------------------
	* Create tables for number of IPO firms with observations before and after
	* Firms that we see continuously between t and 0 
	*-------------------------------------------------------------------------
	file close _all
	file open TabIPOyears using Output/${CountryID}/Table_IPO-Years_Cum1Way.tex, write replace
	*Name of variables
	*file write TabIPOyears " & -3 & -2 & -1 & Year of IPO & +1 & +2 & +3 \\ \midrule"_n
	* Numer of IPO Firms
	file write TabIPOyears " ${CountryID} "

	* -1 
	forval t=-3/3{
		gen PlusMinus_all=1 if (IPO_timescale>=min(`t',0)) & (IPO_timescale<=max(`t',0))
		egen PlusMinus_cum = total(PlusMinus_all), by(IDNum)
		replace PlusMinus_cum=. if PlusMinus_cum< abs(`t')+1
		replace PlusMinus_cum=1 if PlusMinus_cum==abs(`t')+1
		replace PlusMinus_cum=. if IPO_timescale<min(`t',0)
		replace PlusMinus_cum=. if IPO_timescale>max(`t',0)
		sum PlusMinus_cum if ~missing(PlusMinus_cum)
		local nFirms : di %12.0fc r(N)/(abs(`t')+1)
		file write TabIPOyears " & `nFirms' "
		
		drop PlusMinus_all PlusMinus_cum
	}
		
	file close _all
	
	*-------------------------------------------------------------------------
	* Create tables for number of IPO firms with observations before and after
	* Firms that we see continuously from -t to t
	*-------------------------------------------------------------------------
	
	file close _all
	file open TabIPOyears using Output/${CountryID}/Table_IPO-Years_Cum2Way.tex, write replace
	*Name of variables
	*file write TabIPOyears " & -3 & -2 & -1 & Year of IPO & +1 & +2 & +3 \\ \midrule"_n
	* Numer of IPO Firms
	file write TabIPOyears " ${CountryID} "

	* -1 
	forval t=-3/3{
		gen PlusMinus_all=1 if (IPO_timescale>=-abs(`t')) & (IPO_timescale<=abs(`t'))
		egen PlusMinus_cum = total(PlusMinus_all), by(IDNum)
		replace PlusMinus_cum=. if PlusMinus_cum< 2*abs(`t')+1
		replace PlusMinus_cum=1 if PlusMinus_cum==2*abs(`t')+1
		replace PlusMinus_cum=. if IPO_timescale<-abs(`t')
		replace PlusMinus_cum=. if IPO_timescale>abs(`t')
		sum PlusMinus_cum if ~missing(PlusMinus_cum)
		local nFirms : di %12.0fc r(N)/(2*abs(`t')+1)
		file write TabIPOyears " & `nFirms' "
		
		drop PlusMinus_all PlusMinus_cum
	}
		
	file close _all

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
	

	
	* Create table for proportion of IPO firms that become delisted
	egen unique_IPO = group(IDNum) if IPO_year != .
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
	*/
restore