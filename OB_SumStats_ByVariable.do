
/*
New Summary Statistics Table
Rows: 
Columns: Employment, Sales, Assets, Sales/Employee
*/
file close _all

forval i=1/3{
	
	
	preserve
	
		if (`i'==1){
			file open OutputFile using Output/${CountryID}/OB_SumStats_byVariable_All.tex, write replace
			
		}
		else if (`i'==2) {
			file open OutputFile using Output/${CountryID}/OB_SumStats_byVariable_Pri.tex, write replace
			drop if (Private==0)
			
		}
		else if (`i'==3){
			file open OutputFile using Output/${CountryID}/OB_SumStats_byVariable_Pub.tex, write replace
			drop if (Private==1)
		}
		

		gen LnnEmployees=ln(nEmployees)
		gen LnSales=ln(Sales)
		gen LnAssets=ln(Assets)
		gen LnSalesPerEmployee=ln(SalesPerEmployee)

		replace Sales=Sales/1000
		replace Assets=Assets/1000
		replace SalesPerEmployee=SalesPerEmployee/1000

		local Variables nEmployees Sales  Assets SalesPerEmployee 
		local VariablesGrowth EmpGrowth_h SalesGrowth_h AssetGrowth_h SalePerEmpGrowth_h
		local VariablesLn  LnnEmployees LnSales  LnAssets LnSalesPerEmployee 


		*file write OutputFile "   & Employment & Sales & Assets & Sales Per Employee \\  \cline{3-5} " _newline
		*file write OutputFile "   &  & \multicolumn{3}{c}{(Thousands)}  \\ " _newline

		
		
		file write OutputFile "Mean " 
		foreach var of local Variables{
			sum `var'
			local Moment: di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std " 
		foreach var of local Variables{
			sum `var'
			local Moment:  di %12.0fc r(sd)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "p10 " 
		foreach var of local Variables{
			sum `var', detail
			local Moment:  di %12.0fc r(p10)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline

		file write OutputFile "p50 " 
		foreach var of local Variables{
			sum `var', detail
			local Moment:  di %12.0fc r(p50)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "p90 " 
		foreach var of local Variables{
			sum `var', detail
			local Moment:  di %12.0fc r(p90)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline		
			
		file write OutputFile "Avg Growth Rate " 
		foreach var of local VariablesGrowth{
			sum `var'
			local Moment: di %12.2fc r(mean)*100
			file write OutputFile " & `Moment'\% "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std Growth Rate " 
		foreach var of local VariablesGrowth{
			sum `var'
			local Moment: di %12.2fc r(sd)*100
			file write OutputFile " & `Moment'\% "
		}
		file write OutputFile " \\ " _newline
		
		
		file write OutputFile "Mean Log " 
		foreach var of local VariablesLn{
			sum `var'
			local Moment: di %12.2fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std Log " 
		foreach var of local VariablesLn{
			sum `var'
			local Moment:  di %12.2fc r(sd)
			file write OutputFile " & `Moment' "
		}
		
	restore


	file close _all


}
