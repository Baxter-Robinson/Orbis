
/*
New Summary Statistics Table
Rows: 
Columns: Employment, Sales, Assets, Sales/Employee
*/
file close _all

local i=1
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
		
		collapse (mean) nEmployees_mean=nEmployees Sales_mean=Sales  Assets_mean=Assets SalesPerEmployee_mean=SalesPerEmployee ///
			(sd) nEmployees_sd=nEmployees Sales_sd=Sales  Assets_sd=Assets SalesPerEmployee_sd=SalesPerEmployee ///
			(p10) nEmployees_p10=nEmployees Sales_p10=Sales  Assets_p10=Assets SalesPerEmployee_p10=SalesPerEmployee ///
			(p50) nEmployees_p50=nEmployees Sales_p50=Sales  Assets_p50=Assets SalesPerEmployee_p50=SalesPerEmployee ///
			(p90) nEmployees_p90=nEmployees Sales_p90=Sales  Assets_p90=Assets SalesPerEmployee_p90=SalesPerEmployee ///
			(mean) EmpGrowth_h_mean=EmpGrowth_h SalesGrowth_h_mean=SalesGrowth_h AssetGrowth_h_mean=AssetGrowth_h SalePerEmpGrowth_h_mean=SalePerEmpGrowth_h ///
            (sd) EmpGrowth_h_sd=EmpGrowth_h SalesGrowth_h_sd=SalesGrowth_h AssetGrowth_h_sd=AssetGrowth_h SalePerEmpGrowth_h_sd=SalePerEmpGrowth_h ///
            (mean) LnnEmployees_mean=LnnEmployees LnSales_mean=LnSales  LnAssets_mean=LnAssets LnSalesPerEmployee_mean=LnSalesPerEmployee ///
            (sd) LnnEmployees_sd=LnnEmployees LnSales_sd=LnSales  LnAssets_sd=LnAssets LnSalesPerEmployee_sd=LnSalesPerEmployee ///
			(count) nEmployees_n=nEmployees Sales_n=Sales  Assets_n=Assets SalesPerEmployee_n=SalesPerEmployee ///
			, by(Year)

		
		file write OutputFile "Mean " 
		foreach var of local Variables{
			sum `var'_mean
			local Moment: di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std " 
		foreach var of local Variables{
			sum `var'_sd
			local Moment:  di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline

		file write OutputFile "p10 " 
		foreach var of local Variables{
			sum `var'_p10
			local Moment:  di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline

		file write OutputFile "p50 " 
		foreach var of local Variables{
			sum `var'_p50
			local Moment:  di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "p90 " 
		foreach var of local Variables{
			sum `var'_p90
			local Moment:  di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline		
			
		file write OutputFile "Avg Growth Rate " 
		foreach var of local VariablesGrowth{
			sum `var'_mean
			local Moment: di %12.2fc r(mean)*100
			file write OutputFile " & `Moment'\% "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std Growth Rate " 
		foreach var of local VariablesGrowth{
			sum `var'_sd
			local Moment: di %12.2fc r(mean)*100
			file write OutputFile " & `Moment'\% "
		}
		file write OutputFile " \\ " _newline
		
		
		file write OutputFile "Mean Log " 
		foreach var of local VariablesLn{
			sum `var'_mean
			local Moment: di %12.2fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Std Log " 
		foreach var of local VariablesLn{
			sum `var'_sd
			local Moment:  di %12.2fc r(mean)
			file write OutputFile " & `Moment' "
		}
		file write OutputFile " \\ " _newline
		
		file write OutputFile "Avg Obs per Year " 
		foreach var of local Variables{
			sum `var'_n
			local Moment: di %12.0fc r(mean)
			file write OutputFile " & `Moment' "
		}
	restore

*/
	file close _all


}
