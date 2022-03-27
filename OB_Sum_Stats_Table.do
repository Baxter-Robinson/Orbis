
/*
New Summary Statistics Table
Rows: Full sample/Private Firms/Public Firms
Columns: Employment (Min, P10,P50 p90, Max), Sales (Min, P10, P50, P90, Max)
*/
		
preserve
	keep Sales nEmployees Year IDNum Private
	replace Sales = Sales/1000000

	file close _all

	file open TexFile using Output/${CountryID}/OB_Sum_Stats.tex, write replace
				
	file write TexFile " Full Sample " 
				
	file write TexFile " & "


	bysort IDNum: gen nvals = _n == 1 
	sum nvals, detail
	return list
	local nFirms = r(sum) 
	file write TexFile %12.0fc (`nFirms')
	file write TexFile " & "
	drop nvals

	bysort IDNum Year: gen nvals = _n == 1 
	bysort Year: egen nYearsFirm = total(nvals)
	sum nYearsFirm, detail
	local AvenYearsFirm = r(mean)
	file write TexFile %12.0gc ( `AvenYearsFirm')
	file write TexFile " & "

	sort IDNum Year

	sum nEmployees, detail
	local minEmp = r(min)
	local p10Emp = r(p10)
	local p50Emp = r(p50)
	local p90Emp = r(p90)
	local maxEmp = r(max)

	file write TexFile %12.2gc ( `minEmp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p10Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxEmp')
	file write TexFile  "   &   "


	sum Sales, detail 
	local minSales = r(min)
	local p10Sales = r(p10)
	local p50Sales = r(p50)
	local p90Sales = r(p90)
	local maxSales = r(max)

	file write TexFile %12.2gc ( `minSales')
	file write TexFile " & "
	file write TexFile %20.2gc ( `p10Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxSales')
	file write TexFile  "   \\   "

	file close _all

restore

* Private Firms
preserve
	keep Sales nEmployees Year IDNum Private
	keep if Private==1
	replace Sales = Sales/1000000


	file close _all

	file open TexFile using Output/${CountryID}/OB_Sum_Stats_Private.tex, write replace
				
	file write TexFile " Private " 
				
	file write TexFile " & "


	bysort IDNum: gen nvals = _n == 1 
	sum nvals, detail
	return list
	local nFirms = r(sum) 
	file write TexFile %12.0fc ( `nFirms')
	file write TexFile " & "
	drop nvals

	bysort IDNum Year: gen nvals = _n == 1 
	bysort Year: egen nFirmsYear = total(nvals)
	sum nFirmsYear, detail
	return list
	local AvenFirmsYear = r(mean)
	file write TexFile %12.2gc ( `AvenFirmsYear')
	file write TexFile " & "


	sort IDNum Year

	sum nEmployees, detail
	return list
	local minEmp = r(min)
	local p10Emp = r(p10)
	local p50Emp = r(p50)
	local p90Emp = r(p90)
	local maxEmp = r(max)

	file write TexFile %12.2gc ( `minEmp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p10Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxEmp')
	file write TexFile  "   &   "

	sum Sales, detail 
	return list
	local minSales = r(min)
	local p10Sales = r(p10)
	local p50Sales = r(p50)
	local p90Sales = r(p90)
	local maxSales = r(max)

	file write TexFile %12.2gc ( `minSales')
	file write TexFile " & "
	file write TexFile %20.2gc ( `p10Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxSales')
	file write TexFile  "   \\   "

	file close _all

restore


* Public Firms
preserve
	keep Sales nEmployees Year IDNum Private
	keep if Private==0
	replace Sales = Sales/1000000

	file close _all

	file open TexFile using Output/${CountryID}/OB_Sum_Stats_Public.tex, write replace
				
	file write TexFile " Public " 
				
	file write TexFile " & "


	bysort IDNum: gen nvals = _n == 1 
	sum nvals, detail
	local nFirms = r(sum) 
	file write TexFile %12.0fc ( `nFirms')
	file write TexFile " & "
	drop nvals

	bysort IDNum Year: gen nvals = _n == 1 
	bysort Year: egen nFirmsYear = total(nvals)
	sum nFirmsYear, detail
	local AvenFirmsYear = r(mean)
	file write TexFile %12.2gc ( `AvenFirmsYear')
	file write TexFile " & "

	sort IDNum Year

	sum nEmployees, detail
	return list
	local minEmp = r(min)
	local p10Emp = r(p10)
	local p50Emp = r(p50)
	local p90Emp = r(p90)
	local maxEmp = r(max)

	file write TexFile %12.2gc ( `minEmp')
	file write TexFile " & "
	file write TexFile %20.2gc ( `p10Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Emp')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxEmp')
	file write TexFile  "   &   "

	sum Sales, detail 
	return list
	local minSales = r(min)
	local p10Sales = r(p10)
	local p50Sales = r(p50)
	local p90Sales = r(p90)
	local maxSales = r(max)

	file write TexFile %12.2gc ( `minSales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p10Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p50Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `p90Sales')
	file write TexFile " & "
	file write TexFile %12.2gc ( `maxSales')
	file write TexFile  "   \\   "

	file close _all

restore

