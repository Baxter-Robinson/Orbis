 


	
	preserve

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

		rename Market_capitalisation_mil MarketCap
		
		* Full sample
		
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
		
		*foreach x in Assets EBITDA {
		
		
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'.tex, write replace
			
			file write FinRatios " Full Sample " 
			
			file write FinRatios " & "
			file write FinRatios %12.0gc (`fy_obs')
	
			
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
		}			
			
			file close _all
		
		
	restore
	
	
	
	
	***************************** Public Firms ***************************** 

	preserve

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

		rename Market_capitalisation_mil MarketCap
		
		* Public firms
		
		keep if Private==0
		
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
		
		*foreach x in Assets EBITDA {
		
		
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'_public.tex, write replace
			
			file write FinRatios " Public Firms " 
			
			file write FinRatios " & "
			file write FinRatios %12.0gc (`fy_obs')
	
			
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
		}			
			
			file close _all
		
		
	restore
	
	
	
***************************** Private Firms ***************************** 

	preserve

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

		rename Market_capitalisation_mil MarketCap
		
		* Public firms
		
		keep if Private==1
		
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue Assets_EBITDA Assets_Revenue Assets_Profits MktCap_Assets{
				
	
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'_private.tex, write replace
			
			file write FinRatios " Private Firms " 
			
			file write FinRatios " & "
			file write FinRatios %12.0gc (`fy_obs')
	
			
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
		}			
			
			file close _all
		
		
	restore
	
	
	
