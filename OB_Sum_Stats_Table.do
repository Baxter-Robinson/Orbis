
/*
New Summary Statistics Table
Rows: Full sample/Private Firms/Public Firms
Columns: Employment (Min, P10,P50 p90, Max), Sales (Min, P10, P50, P90, Max)
*/
		
preserve
keep Sales nEmployees Year IDNum Private
sum nEmployees, detail
replace Sales = Sales/1000000

local minEmp = r(min)
local p10Emp = r(p10)
local p50Emp = r(p50)
local p90Emp = r(p90)
local maxEmp = r(max)

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Employment.tex, write replace
			
file write TexFile " Employment & Full Sample " 
			
file write TexFile " & "

file write TexFile %12.2gc ( `minEmp')
file write TexFile " & "
file write TexFile %12.2gc ( `p10Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p50Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p90Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `maxEmp')
file write TexFile  "   \\   "

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Sales.tex, write replace
			
file write TexFile " Sales  & Full Sample " 
			
file write TexFile " & "

sum Sales, detail 
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

* Private Firms
preserve
keep Sales nEmployees Year IDNum Private
keep if Private==1
replace Sales = Sales/1000000
sum nEmployees, detail


local minEmp = r(min)
local p10Emp = r(p10)
local p50Emp = r(p50)
local p90Emp = r(p90)
local maxEmp = r(max)

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Employment_Private.tex, write replace
			
file write TexFile " Employment & Private " 
			
file write TexFile " & "

file write TexFile %12.2gc ( `minEmp')
file write TexFile " & "
file write TexFile %12.2gc ( `p10Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p50Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p90Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `maxEmp')
file write TexFile  "   \\   "

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Sales_Private.tex, write replace
			
file write TexFile " Sales & Private " 
			
file write TexFile " & "

sum Sales, detail 
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


* Public Firms
preserve
keep Sales nEmployees Year IDNum Private
keep if Private==0
replace Sales = Sales/1000000
sum nEmployees, detail

local minEmp = r(min)
local p10Emp = r(p10)
local p50Emp = r(p50)
local p90Emp = r(p90)
local maxEmp = r(max)

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Employment_Public.tex, write replace
			
file write TexFile " Employment & Public " 
			
file write TexFile " & "

file write TexFile %12.2gc ( `minEmp')
file write TexFile " & "
file write TexFile %12.2gc ( `p10Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p50Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `p90Emp')
file write TexFile " & "
file write TexFile %12.2gc ( `maxEmp')
file write TexFile  "   \\   "

file close _all

file open TexFile using Output/${CountryID}/OB_Sum_Stats_Sales_Public.tex, write replace
			
file write TexFile " Sales & Public  " 
			
file write TexFile " & "

sum Sales, detail 
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

