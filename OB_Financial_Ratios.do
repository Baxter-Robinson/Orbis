 



	preserve

/*

- Look into leverage ratios, capital-output ratios in this data
   - What does it look like?
   - Many missing observations?
   - Many zeros?
   - What does this look like Public vs. Private

*/

		keep Assets EBITDA EverPublic GrossProfits IDNum Market_capitalisation_mil No_of_recorded_shareholders Private Stock nShareholders Revenue Year

		
		rename Market_capitalisation_mil MarketCap
		* Dividing over 1,000,000 to make units visible in the table.
		replace Assets=Assets/1000000
		replace EBITDA = EBITDA/10000
		replace GrossProfits = GrossProfits/1000000
		replace MarketCap = MarketCap/1000000
		replace Revenue =  Revenue/1000000
		
		gen ebitdatoassets = EBITDA/Assets
		gen revenuetoassets = Revenue/Assets
		gen profitstoassets = GrossProfits/Assets
		gen mktcaptoassets = MarketCap/Assets
		
		
		* Firm x Year Observations
		
		bysort IDNum Year: gen nvals = _n == 1
		replace nvals = sum(nvals)
        replace nvals = nvals[_N]
		*sum nvals, detail
		*return list
		*local fy_obs = r(mean)	

		
		
		* Full sample
		
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue ebitdatoassets revenuetoassets profitstoassets mktcaptoassets{	
		*foreach x in Revenue ebitdatoassets revenuetoassets profitstoassets mktcaptoassets{
		
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'.tex, write replace
			
			file write FinRatios " Full Sample " 
			
			file write FinRatios " & "
				sum nvals, detail
				return list
				local fy_obs = r(mean)
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
			file write FinRatios %12.2gc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p75_`x'')
			file write FinRatios  "   \\   "					
			drop mi_`x'	
		}			
			
			file close _all
		
		
	restore
	
	
	***************************** Public Firms ***************************** 

	preserve

		keep Assets EBITDA EverPublic GrossProfits IDNum Market_capitalisation_mil No_of_recorded_shareholders Private Stock nShareholders Revenue Year

		* Public firms
		keep if Private==0
		
		rename Market_capitalisation_mil MarketCap
		* Dividing over 1,000,000 to make units visible in the table.
		replace Assets=Assets/1000000
		replace EBITDA = EBITDA/10000
		replace GrossProfits = GrossProfits/1000000
		replace MarketCap = MarketCap/1000000
		replace Revenue =  Revenue/1000000
		
		gen ebitdatoassets = EBITDA/Assets
		gen revenuetoassets = Revenue/Assets
		gen profitstoassets = GrossProfits/Assets
		gen mktcaptoassets = MarketCap/Assets
		
		
		* Firm x Year Observations
		
		bysort IDNum Year: gen nvals = _n == 1
		replace nvals = sum(nvals)
        

		
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue ebitdatoassets revenuetoassets profitstoassets mktcaptoassets{
		
		*foreach x in Assets EBITDA {
		
		
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'_public.tex, write replace
			
			file write FinRatios " Public Firms " 
			
			file write FinRatios " & "
				sum nvals, detail
				return list
				local fy_obs_pub = r(mean)
			file write FinRatios %12.0gc (`fy_obs_pub')
	
			
			* Missing observations
			gen mi_`x' = 0
			replace mi_`x' = 1 if missing(`x')
			sum mi_`x' , detail
			return list
			local missing_`x' = r(sum)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs_pub'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc (`pct_missing_`x'')
			
			
			* Zero-valued observations
			sum `x' if `x'==0 , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs_pub'
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
			file write FinRatios %12.2gc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p75_`x'')
			file write FinRatios  "   \\   "					
			drop mi_`x'	
		}			
			
			file close _all
		
		
	restore
	
	
	
***************************** Private Firms ***************************** 

	preserve

		keep Assets EBITDA EverPublic GrossProfits IDNum Market_capitalisation_mil No_of_recorded_shareholders Private Stock nShareholders Revenue Year
		
		* Public firms
		keep if Private==1
		
		rename Market_capitalisation_mil MarketCap
		* Dividing over 1,000,000 to make units visible in the table.
		replace Assets=Assets/1000000
		replace EBITDA = EBITDA/10000
		replace GrossProfits = GrossProfits/1000000
		replace MarketCap = MarketCap/1000000
		replace Revenue =  Revenue/1000000
		
		gen ebitdatoassets = EBITDA/Assets
		gen revenuetoassets = Revenue/Assets
		gen profitstoassets = GrossProfits/Assets
		gen mktcaptoassets = MarketCap/Assets
		
		
		* Firm x Year Observations
		
		bysort IDNum Year: gen nvals = _n == 1
		replace nvals = sum(nvals)
        replace nvals = nvals[_N]

				
		foreach x in Assets EBITDA GrossProfits MarketCap Stock nShareholders Revenue ebitdatoassets revenuetoassets profitstoassets mktcaptoassets{
				
	
			file close _all

			file open FinRatios using Output/${CountryID}/OB_Financial_Ratios_`x'_private.tex, write replace
			
			file write FinRatios " Private Firms " 
			
			file write FinRatios " & "
				sum nvals, detail
				return list
				local fy_obs_private = r(mean)
			file write FinRatios %12.0gc (`fy_obs_private')
	
			
			* Missing observations
			gen mi_`x' = 0
			replace mi_`x' = 1 if missing(`x')
			sum mi_`x' , detail
			return list
			local missing_`x' = r(sum)
			local pct_missing_`x' = 100*`missing_`x''/`fy_obs_private'
			file write FinRatios  "   &   "
			file write FinRatios %4.2fc (`pct_missing_`x'')
			
			
			* Zero-valued observations
			sum `x' if `x'==0 , detail
			return list
			local zeros_`x' = r(N)
			local pct_zeros_`x' = 100*`zeros_`x''/`fy_obs_private'
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
			file write FinRatios %12.2gc (`mean_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`min_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`max_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p25_`x'')
			file write FinRatios  "   &   "
			file write FinRatios %12.2gc (`p75_`x'')
			file write FinRatios  "   \\   "					
			drop mi_`x'	
		}			
			
			file close _all
		
		
	restore
	
