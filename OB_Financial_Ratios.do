


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
		
		foreach x in Assets EBITDA GrossProfits MktCap Stock nShareholders Revenue Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
		
			file write FinRatios " ${CountryID}"
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Full Sample"
			}
			else if `x'== MktCap{
				file write FinRatios " & Market Capitalization & Full Sample"
			}
			else if `x'== nShareholders{
				file write FinRatios " & Number of Shareholders & Full Sample"
			}
			else if `x'== Stock{
				file write FinRatios " & Number of Shares & Full Sample"
			}
			else if `x'==Assets_Revenue{
				file write FinRatios " & Assets to Revenue & Full Sample"
			}
			else if `x'==Assets_Profits{
				file write FinRatios " & Assets to Profits & Full Sample"
			}
			else if `x'== MktCap_Assets {
				file write FinRatios " & Market Cap to Assets & Full Sample"
			}
			else{
				file write FinRatios " & `x' & Full Sample"
			}
			
			
			* Missing observations
			gen mi_`x' = 0
			replace mi_`x' = 1 if missing(`x')
			sum mi_`x' , detail
			return list
			local missing_`x' = r(sum)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc (`pct_missing_`x'')
			
			
			* Zero-valued observations
			sum `x' if `x'==0 , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc ( `pct_zeros_`x'')
			
			* Average
			sum `x' if (`x'!=.) & (mi_`x'==0) , detail
			return list
			local mean_`x' = r(mean)
			local min_`x' = r(min)
			local max_`x' = r(max)
			local p25_`x' = r(p25)
			local p75_`x' = r(p75)
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p75_`x'')
			file write FinRatios  "   \\   "
			drop mi_`x'
			*file write FinRatios "  \hline "
			
			* Private firms only ------------------------------------------------------------------------------------------------------
			
			file write FinRatios " ${CountryID} "
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Private Firms"
			}
			else if `x'== MktCap{
				file write FinRatios " & Market Capitalization & Private Firms"
			}
			else if `x'== nShareholders{
				file write FinRatios " & Number of Shareholders & Private Firms"
			}
			else if `x'== Stock{
				file write FinRatios " & Number of Shares & Private Firms"
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
			gen mi_`x' = 0
			replace mi_`x' = 1 if missing(`x')
			sum mi_`x' if Private==1, detail
			return list
			local missing_`x' = r(sum)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc (`pct_missing_`x'')
			
			
			* Zero-valued observations
			sum `x' if (`x'==0) & (Private==1) , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc ( `pct_zeros_`x'')
			
			* Average
			sum `x' if (`x'!=.) & (Private==1) & (mi_`x'==0) , detail
			return list
			local mean_`x' = r(mean)			
			local min_`x' = r(min)
			local max_`x' = r(max)
			local p25_`x' = r(p25)
			local p75_`x' = r(p75)
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p75_`x'')
			file write FinRatios  "   \\   "
			
			*file write FinRatios " \hline "
			
			drop mi_`x'
			
			* Public firms only ------------------------------------------------------------------------------------------------------
			
			file write FinRatios " ${CountryID}"
			file write FinRatios " & `fy_obs' "
			if `x'==Assets_EBITDA{
				file write FinRatios " & Assets to EBITDA & Public Firms"
			}
			else if `x'== MktCap{
				file write FinRatios " & Market Capitalization & Public Firms"
			}
			else if `x'== nShareholders{
				file write FinRatios " & Number of Shareholders & Public Firms"
			}
			else if `x'== Stock{
				file write FinRatios " & Number of Shares & Public Firms"
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
			gen mi_`x' = 0
			replace mi_`x' = 1 if missing(`x')
			sum mi_`x' if Private==0, detail
			return list
			local missing_`x' = r(sum)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc (`pct_missing_`x'')
			
			
			* Zero-valued observations
			sum `x' if (`x'==0) & (Private==0), detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc ( `pct_zeros_`x'')
			
			* Average
			sum `x' if (`x'!=.) & (Private==0) & (mi_`x'==0)  , detail
			return list
			local mean_`x' = r(mean)
			local mean_`x' = r(mean)			
			local min_`x' = r(min)
			local max_`x' = r(max)
			local p25_`x' = r(p25)
			local p75_`x' = r(p75)
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %8.2fc (`p75_`x'')
			file write FinRatios  "   \\   "
						
			file write FinRatios " \hline \hline"
			
			drop mi_`x'
			
		}

		file close _all
		
		
	restore
		
		
