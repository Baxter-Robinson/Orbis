
/*
New Summary Statistics Table
Rows: Full sample/Private Firms/Public Firms
Columns: Employment (P10,P50 p90), Sales (P10, P50, P90)
*/

file close _all

local i=1
forval i=1/3{
	
	
preserve

	replace Sales=Sales/1000
    
        if (`i'==1){
            file open OutputFile using Output/${CountryID}/OB_SumStats_byCountry_All.tex, write replace
            file write OutputFile " Full Sample & " 
            
        }
        else if (`i'==2) {
            file open OutputFile using Output/${CountryID}/OB_SumStats_byCountry_Pri.tex, write replace
            drop if (Private==0)
            file write OutputFile " Private Firms & " 
            
        }
        else if (`i'==3){
            file open OutputFile using Output/${CountryID}/OB_SumStats_byCountry_Pub.tex, write replace
            drop if (Private==1)
            file write OutputFile " Public Firms & " 
        }
                

    * Unique Number of Firms
    bysort IDNum: gen nvals = _n == 1 
    sum nvals, detail
    return list
    local nFirms = r(sum) 
    file write OutputFile %12.0fc (`nFirms')
    file write OutputFile " & "
    drop nvals

    * Employment Percentiles
    sum nEmployees, detail
	
    local p10Emp = r(p10)
    local p50Emp = r(p50)
    local p90Emp = r(p90)

    file write OutputFile %12.2gc ( `p10Emp')
    file write OutputFile " & "
    file write OutputFile %12.2gc ( `p50Emp')
    file write OutputFile " & "
    file write OutputFile %12.2gc ( `p90Emp')
    file write OutputFile " & & "

    * Sales Percentiles
    sum Sales, detail 
    local p10Sales = r(p10)
    local p50Sales = r(p50)
    local p90Sales = r(p90)

    file write OutputFile %20.2gc ( `p10Sales')
    file write OutputFile " & "
    file write OutputFile %12.2gc ( `p50Sales')
    file write OutputFile " & "
    file write OutputFile %12.2gc ( `p90Sales')

    file close _all

restore

}
