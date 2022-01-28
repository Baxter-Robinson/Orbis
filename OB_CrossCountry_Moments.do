


preserve



		gen Country="${CountryID}"
		merge m:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
		drop if _merge==2

		
		rename Market_capitalisation_mil MarketCap
		
		
		file close _all

		file open CrossCountry using Output/${CountryID}/OB_Cross_Country.tex, write replace

		file write CrossCountry " ${CountryID} "

		* Static Firm Share

		sum nEmployees if nEmployees!=. , detail
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)

		/*
		* Positive values only
		sum nEmployees if (nEmployees!=.)&(nEmployees>0)
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)
		*/

		bysort IDNum: egen F_review = max(nEmployees)

		gen BelowQ1 = 0
		replace BelowQ1=1 if F_review<`Emp_quartile1'


		gen BelowMedian = 0
		replace BelowMedian=1 if F_review<`Emp_median'


		bysort IDNum: gen nvals = _n == 1  
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen numFirms = nvals
		sum numFirms, detail
		local nfirms = r(mean)
		
		file write CrossCountry " & `nfirms' "
		
		sum BelowQ1, detail
		return list
		local static_Q1 = 100*r(sum)/`nfirms'
		
		sum BelowMedian, detail
		return list
		local static_Q2 = 100*r(sum)/`nfirms'

		
		* ------------------------
		
		sum EmpGrowth_h, detail
		return list
		local meanEmpG = r(mean)
		local sdEmpG = r(sd)
		
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`meanEmpG')
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`sdEmpG')
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`static_Q1')
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`static_Q2')

			
		gen AfterIPO1Y = 0
		replace AfterIPO1Y= 1 if IPO_year-Year==1
		
		sum EmpGrowth_h if AfterIPO1Y==1, detail
		local ave_EmpGrowth_h_IPO1Y = r(mean)
		
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`ave_EmpGrowth_h_IPO1Y')
		
		gen Public = 1-Private
		sum EmpGrowth_h if Public==1, detail
		local ave_EmpGrowth_h_Public = r(mean)
		
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`ave_EmpGrowth_h_Public')
		
		sum Sales, detail
		local TotSales=r(sum)
		
		sum Sales if Public==1,detail
		local PublicSales = r(sum)
 		
		local PctPublicSales = 100*`PublicSales'/`TotSales'
		
		file write CrossCountry " &  "
		file write CrossCountry %4.2fc (`PctPublicSales')
		
		bysort Year: egen MktC = total(MarketCap)
		
		sum MarketCap, detail
		return list
		local ave_MarketCap = r(mean)
		
		sum gdpo, detail
		return list
		local ave_gdpo = r(mean)
		
		local ave_EquityMktDepth_OB = `ave_MarketCap'/`ave_gdpo'
		
		di `ave_EquityMktDepth_OB'
		
		file write CrossCountry " &  "
		file write CrossCountry %08.4fc (`ave_EquityMktDepth_OB')
 		file write CrossCountry "  \\  "		
		
		
		file close _all

restore

	












