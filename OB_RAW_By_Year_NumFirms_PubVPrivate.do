

* Use Raw Data
*use "${DATAPATH}/IT_merge.dta", clear

*use "${DATAPATH}/${CountryID}_merge.dta", clear


* Year
gen Year=year(Closing_date)
egen FirstYear=min(Year), by(BvD_ID_Number)
replace FirstYear=year(IPO_date) if ((year(IPO_date)<year(FirstYear)) & ~missing(FirstYear))
replace FirstYear=year(Date_of_incorporation) if ((year(Date_of_incorporation)<year(FirstYear)) & ~missing(Date_of_incorporation) & (year(Date_of_incorporation)<year(IPO_date)) )
gen Age=Year-FirstYear
drop FirstYear

* Convert IPO date from monthly to yearly
gen IPO_year = year(IPO_date)
gen Delisted_year = yofd(Delisted_date)

* Private/Public firms
gen Private=0
replace Private = 1 if Main_exchange=="Unlisted" | (Main_exchange=="Delisted")  & (Year >= Delisted_year)

egen IDNum=group(BvD_ID_Number)

sort IDNum Year

/*
    - New Bar chart
        - x-axis: year
        - y-axis: Stacked Bar of number of public firms and number of private firms
*/


bysort IDNum Year: gen nvals = _n == 1  

collapse (sum) nvals, by(Year Private)

bysort Year: egen totfirms = total(nvals)

gen fPublic = 0
replace fPublic = nvals if Private==0

gen fPrivate = 0
replace fPrivate = nvals if Private==1

collapse (sum) fPublic fPrivate (first) totfirms, by(Year)

gen floor = 0


graph twoway (rbar floor fPrivate Year, color(maroon))  ///
(rbar fPrivate totfirms Year, color(navy)), ///
legend(label(1 "Private") label( 2 "Public" ) ) ///
ytitle("Number of firms") ///
ylabel(, format(%9.0fc)) ///
xtitle("Year") ///
	graphregion(color(white))
graph export Output/$CountryID/Graph_ByYear_PubVPrivate_NumFirms.pdf, replace  
