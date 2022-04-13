


preserve

		gen Country="${CountryID}"
		merge m:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
		drop if _merge==2
		drop _merge
		merge m:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
		drop _merge
		
		file close _all

		file open CrossCountry using Output/${CountryID}/OB_Cross_Country_Unbalanced.tex, write replace

		file write CrossCountry " ${CountryID} "

		* Static Firm Share
		sum nEmployees if  nEmployees!=., detail
		return list
		local Emp_quartile1 = r(p25)
		local Emp_median = r(p50)
		di `Emp_quartile1'


		bysort IDNum: egen F_review = max(nEmployees)

		gen BelowQ1 = 0 
		replace BelowQ1=1 if F_review < `Emp_quartile1'


		gen BelowMedian = 0
		replace BelowMedian=1 if F_review < `Emp_median'


		bysort IDNum: gen nvals = _n == 1  
		
		replace BelowQ1 = BelowQ1*nvals
		replace BelowMedian = BelowMedian*nvals
		
		
		replace nvals = sum(nvals)
		replace nvals = nvals[_N] 
		gen numFirms = nvals
		sum numFirms, detail
		local nfirms = r(mean)
		
		file write CrossCountry " &  "
		file write CrossCountry %12.0gc (`nfirms')
		
		
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
		replace AfterIPO1Y= 1 if Year-IPO_year==1
		
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
		
		
		
		* Market capitalization
		bysort Year: egen MarketCap1 = total(Market_capitalisation_mil)
		
		sum MarketCap, detail
		local ave_MarketCap = r(mean)
		
		sum gdpo, detail
		local ave_gdpo = r(mean)
		
		local ave_EquityMktDepth_OB = `ave_MarketCap'/`ave_gdpo'
		
		di `ave_EquityMktDepth_OB'
		
		file write CrossCountry " &  "
		file write CrossCountry %08.4fc (`ave_EquityMktDepth_OB')
 		file write CrossCountry "  \\  "		
		
		
		file close _all

restore

	


preserve

		gen Country="${CountryID}"
		merge m:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
		drop if _merge==2
		drop _merge
		merge m:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
		drop _merge
		
		file close _all

		file open CrossCountry2 using Output/${CountryID}/OB_Cross_Country_Employment_Unbalanced.tex, write replace

		file write CrossCountry2 " ${CountryID} "
		file write CrossCountry2 " &  "
		
		sum EmpGrowth_h if Private==0, detail
		return list
		
		file write CrossCountry2 %4.2fc (`r(mean)')
		file write CrossCountry2 " &  "
		file write CrossCountry2 %4.2fc (`r(sd)')
		file write CrossCountry2 " &  "
		
		sum EmpGrowth_h if Private==1, detail
		return list
		
		file write CrossCountry2 %4.2fc (`r(mean)')
		file write CrossCountry2 " &  "
		file write CrossCountry2 %4.2fc (`r(sd)')
 		file write CrossCountry2 "  \\  "		
		
		
		file close _all

restore




preserve

		gen Country="${CountryID}"
		merge m:1 Country using "Data_Cleaned/PennWorldIndicators.dta"
		drop if _merge==2
		drop _merge
		merge m:1 Country using "Data_Cleaned/${CountryID}_CountryLevel.dta"
		drop _merge
		
		file close _all

		file open CrossCountry3 using Output/${CountryID}/OB_Cross_Country_LaborProductivity_Unbalanced.tex, write replace
		
		gen sales_millions = Sales/1000000
		gen labor_productivity = sales_millions/nEmployees
		
		file write CrossCountry3 " ${CountryID} "
		file write CrossCountry3 " &  "
		
		file write CrossCountry3 " All Firms "
		file write CrossCountry3 " &  "
		
		sum labor_productivity , detail
		return list
		file write CrossCountry3 %4.2fc (`r(mean)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(p50)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(sd)')
		file write CrossCountry3 " &  "
		sum labor_productivity , detail
		return list 
		local CoeffVariation = `r(sd)'*100/`r(mean)'
		file write CrossCountry3 %4.2fc (`CoeffVariation')
		file write CrossCountry3 " &  "
		sum labor_productivity , detail
		return list 
		local Ratio9010 = `r(p90)'/`r(p10)'
		file write CrossCountry3 %4.2fc (`Ratio9010')
		file write CrossCountry3 " &  "
		sum labor_productivity , detail
		return list 
		local Ratio9050 = `r(p90)'/`r(p50)'
		file write CrossCountry3 %4.2fc (`Ratio9050')
		file write CrossCountry3 " \\  "
		
		
		file write CrossCountry3 " ${CountryID} "
		file write CrossCountry3 " &  "
		
		file write CrossCountry3 " Public Firms "
		file write CrossCountry3 " &  "
		
		sum labor_productivity if Private==0, detail
		return list
		file write CrossCountry3 %4.2fc (`r(mean)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(p50)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(sd)')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==0, detail
		return list 
		local CoeffVariation = `r(sd)'*100/`r(mean)'
		file write CrossCountry3 %4.2fc (`CoeffVariation')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==0, detail
		return list 
		local Ratio9010 = `r(p90)'/`r(p10)'
		file write CrossCountry3 %4.2fc (`Ratio9010')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==0, detail
		return list 
		local Ratio9050 = `r(p90)'/`r(p50)'
		file write CrossCountry3 %4.2fc (`Ratio9050')
		file write CrossCountry3 " \\  "
		
		
		file write CrossCountry3 " ${CountryID} "
		file write CrossCountry3 " &  "
		
		file write CrossCountry3 " Private Firms "
		file write CrossCountry3 " &  "
		
		sum labor_productivity if Private==1, detail
		return list
		file write CrossCountry3 %4.2fc (`r(mean)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(p50)')
		file write CrossCountry3 " &  "
		file write CrossCountry3 %4.2fc (`r(sd)')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==1, detail
		return list 
		local CoeffVariation = `r(sd)'*100/`r(mean)'
		file write CrossCountry3 %4.2fc (`CoeffVariation')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==1, detail
		return list 
		local Ratio9010 = `r(p90)'/`r(p10)'
		file write CrossCountry3 %4.2fc (`Ratio9010')
		file write CrossCountry3 " &  "
		sum labor_productivity if Private==1, detail
		return list 
		local Ratio9050 = `r(p90)'/`r(p50)'
		file write CrossCountry3 %4.2fc (`Ratio9050')
		file write CrossCountry3 " \\  "		
		
		file write CrossCountry3 " \hline  "
		
		
		file close _all

restore




















