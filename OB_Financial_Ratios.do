


	preserve

		file close _all

		file open FinRatios using Output/${CountryID}/OB_Financial_Ratios.tex, write replace

/*

- Look into leverage ratios, capital-output ratios in this data
   - What does it look like?
   - Many missing observations?
   - Many zeros?
   - What does this look like Public vs. Private

*/

		keep Assets EBITDA EverPublic GrossProfits IDNum Market_capitalisation_mil No_of_recorded_shareholders Private Stock nShareholders Revenue

		gen Assets_EBITDA = Assets/EBITDA
		gen Assets_Revenue = Assets/Revenue
		gen Assets_Profits = Assets/GrossProfits
		gen MktCap_Assets = Market_capitalisation_mil/Assets

		* Firm x Year Observations

		gen firm_year_obs = _n
		sum firm_year_obs, detail
		return list
		local fy_obs = r(N)	

		rename Market_capitalisation_mil MktCap
		
		* Full sample
*		foreach x in Assets EBITDA GrossProfits MktCap Stock nShareholders Revenue Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
		foreach x in Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
		
			file write FinRatios " ${CountryID}"
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Full Sample"
			}
			else if `x'==Assets_Revenue{
				file write FinRatios " & Assets to Revenue & Full Sample"
			}
			else if `x'==Assets_Profits{
				file write FinRatios " & Assets to Profits & Full Sample"
			}
			else if `x'==MktCap_Assets{
				file write FinRatios " & Market Cap to Assets & Full Sample"
			}
			else{
				file write FinRatios " & `x' & Full Sample"
			}
			
			
			* Missing observations
			sum `x' if `x'==. , detail
			return list
			local missing_`x' = r(N)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios " & `pct_missing_`x''"
			
			* Zero-valued observations
			sum `x' if `x'==0 , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios " & `pct_zeros_`x''"
			
			* Average
			sum `x' if `x'!=. , detail
			return list
			local mean_`x' = r(mean)
			file write FinRatios " & `mean_`x''"
			
			* Min
			sum `x' if `x'!=. , detail
			return list
			local min_`x' = r(min)
			file write FinRatios " & `min_`x''"
			
			* Max
			sum `x' if `x'!=. , detail
			return list
			local max_`x' = r(max)
			file write FinRatios " & `max_`x''"
			
			* Variance
			sum `x' if `x'!=. , detail
			return list
			local Var_`x' = r(Var)
			file write FinRatios " & `Var_`x'' \\ "
			
			*file write FinRatios "  \hline "
			
			* Private firms only ------------------------------------------------------------------------------------------------------
			
			file write FinRatios " ${CountryID} "
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Private Firms"
			}
			else if `x'==Assets_Revenue{
				file write FinRatios " & Assets to Revenue & Private Firms"
			}
			else if `x'==Assets_Profits{
				file write FinRatios " & Assets to Profits & Private Firms"
			}
			else if `x'==MktCap_Assets{
				file write FinRatios " & Market Cap to Assets & Private Firms"
			}
			else{
				file write FinRatios " & `x' & Private Firms"
			}
			
			* Missing observations
			sum `x' if (`x'==.) & (Private==1), detail
			return list
			local missing_`x' = r(N)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios " & `pct_missing_`x''"
			
			* Zero-valued observations
			sum `x' if (`x'==0) & (Private==1) , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios " & `pct_zeros_`x''"
			
			* Average
			sum `x' if (`x'!=.) & (Private==1) , detail
			return list
			local mean_`x' = r(mean)
			file write FinRatios " & `mean_`x''"
			
			* Min
			sum `x' if (`x'!=.) & (Private==1) , detail
			return list
			local min_`x' = r(min)
			file write FinRatios " & `min_`x''"
			
			* Max
			sum `x' if (`x'!=.) & (Private==1) , detail
			return list
			local max_`x' = r(max)
			file write FinRatios " & `max_`x''"
			
			* Variance
			sum `x' if (`x'!=.) & (Private==1) , detail
			return list
			local Var_`x' = r(Var)
			file write FinRatios " & `Var_`x'' \\ "
			
			*file write FinRatios " \hline "
			
			* Public firms only ------------------------------------------------------------------------------------------------------
			
			file write FinRatios " ${CountryID}"
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Public Firms"
			}
			else if `x'==Assets_Revenue{
				file write FinRatios " & Assets to Revenue & Public Firms"
			}
			else if `x'==Assets_Profits{
				file write FinRatios " & Assets to Profits & Public Firms"
			}
			else if `x'==MktCap_Assets{
				file write FinRatios " & Market Cap to Assets & Public Firms"
			}
			else{
				file write FinRatios " & `x' & Public Firms"
			}
			
			* Missing observations
			sum `x' if (`x'==.) & (Private==0), detail
			return list
			local missing_`x' = r(N)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios " & `pct_missing_`x''"
			
			* Zero-valued observations
			sum `x' if (`x'==0) & (Private==0) , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios " & `pct_zeros_`x''"
			
			* Average
			sum `x' if (`x'!=.) & (Private==0) , detail
			return list
			local mean_`x' = r(mean)
			file write FinRatios " & `mean_`x''"
			
			* Min
			sum `x' if (`x'!=.) & (Private==0) , detail
			return list
			local min_`x' = r(min)
			file write FinRatios " & `min_`x''"
			
			* Max
			sum `x' if (`x'!=.) & (Private==0) , detail
			return list
			local max_`x' = r(max)
			file write FinRatios " & `max_`x''"
			
			* Variance
			sum `x' if (`x'!=.) & (Private==0) , detail
			return list
			local Var_`x' = r(Var)
			file write FinRatios " & `Var_`x'' \\ "
			
			file write FinRatios " \hline \hline"
			
		}

		file close _all
		
		
	restore
		
		
