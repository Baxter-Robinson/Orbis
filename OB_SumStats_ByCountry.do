
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
                
				
						
	collapse (p10) nEmployees_p10=nEmployees Sales_p10=Sales  ///
		(p50) nEmployees_p50=nEmployees Sales_p50=Sales  ///
		(p90) nEmployees_p90=nEmployees Sales_p90=Sales  ///
		(count) nEmployees_n=nEmployees Sales_n=Sales ///
		, by(Year)


		* Unique Number of Firms
		sum nEmployees_n
		local nFirms = r(mean) 
		file write OutputFile %12.0fc (`nFirms')
		file write OutputFile " & "

		* Employment Percentiles
		sum nEmployees_p10
		local Moment = r(mean) 
		file write OutputFile %12.0fc ( `Moment')
		file write OutputFile " & "
		
		sum nEmployees_p50
		local Moment = r(mean) 
		file write OutputFile %12.0fc ( `Moment')
		file write OutputFile " & "
		
		sum nEmployees_p90
		local Moment = r(mean) 
		file write OutputFile %12.0fc ( `Moment')
		file write OutputFile " & & "
		
		
		* Sales Percentiles
        sum Sales_p10
        local Moment = r(mean) 
        file write OutputFile %12.0fc ( `Moment')
        file write OutputFile " & "
        
        sum Sales_p50
        local Moment = r(mean) 
        file write OutputFile %12.0fc ( `Moment')
        file write OutputFile " & "
        
        sum Sales_p90
        local Moment = r(mean) 
        file write OutputFile %12.0fc ( `Moment')
		

    file close _all

restore

}
