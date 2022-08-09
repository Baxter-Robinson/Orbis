local nYears=5
*forval nYears=2/5{
	preserve


		bysort IDNum: egen nEmployees_Mean=mean(nEmployees) 
		bysort IDNum: egen Assets_Mean=mean(Assets) 
		bysort IDNum: egen Revenue_Mean=mean(Revenue)
		gen SalesPerEmp_Mean=Revenue_Mean/nEmployees_Mean
		
		*drop if (nEmployees<nEmployees_Mean*0.50)
		
		gen PropEmployees=nEmployees/nEmployees_Mean*100
		gen PropAssets=Assets/Assets_Mean*100
		gen PropSalesPerEmp=SalesPerEmployee/SalesPerEmp_Mean*100
		
		gen IPO_timescale = Year - IPO_year
		drop if missing(IPO_timescale)

		
		gen YearIs_Zero=0
		replace YearIs_Zero=1 if (IPO_timescale==0)
		
		forval t=1/`nYears'{
			gen YearIs_Neg`t'=0
			replace YearIs_Neg`t'=1 if (IPO_timescale==-`t') 
			
			gen YearIs_Pos`t'=0
			replace YearIs_Pos`t'=1 if (IPO_timescale==`t') 
			
		}

		** Employment
		reg PropEmployees YearIs_*
		
		gen BetaEmp_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
		gen SEEmp_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
		
		forval t=1/`nYears'{
			
			replace BetaEmp_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace BetaEmp_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
		}
		
		** Assets
		reg PropAssets YearIs_*
		gen BetaAss_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
        gen SEAss_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
        
        forval t=1/`nYears'{
            
            replace BetaAss_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
            replace SEAss_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
            replace BetaAss_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
            replace SEAss_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
        }
		
		** Sales Per Employee
		reg PropSalesPerEmp YearIs_*

		    gen BetaSpE_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
        gen SESpE_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
        
        forval t=1/`nYears'{
            
            replace BetaSpE_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
            replace SESpE_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
            replace BetaSpE_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
            replace SESpE_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
        }
		
		collapse (mean) BetaEmp_ByIPOYear SEEmp_ByIPOYear  BetaAss_ByIPOYear SEAss_ByIPOYear BetaSpE_ByIPOYear SESpE_ByIPOYear  ,  by(IPO_timescale)

		drop if (IPO_timescale<-`nYears')
		drop if (IPO_timescale>`nYears')
		
		gen highEmp=BetaEmp_ByIPOYear+1.96*SEEmp_ByIPOYear
		gen lowEmp=BetaEmp_ByIPOYear-1.96*SEEmp_ByIPOYear
		
		gen highAss=BetaAss_ByIPOYear+1.96*SEAss_ByIPOYear
		gen lowAss=BetaAss_ByIPOYear-1.96*SEAss_ByIPOYear
		
		
		
		gen highSpE=BetaSpE_ByIPOYear+1.96*SESpE_ByIPOYear
		gen lowSpE=BetaSpE_ByIPOYear-1.96*SESpE_ByIPOYear

		graph twoway (scatter  BetaEmp_ByIPOYear IPO_timescale) ///
		(rcap highEmp lowEmp IPO_timescale), ///
		xtitle("Years Around IPO") graphregion(color(white))
		graph export Output/$CountryID/IPO_PropEmployees_`nYears'.pdf, replace 
		

		graph twoway (scatter  BetaAss_ByIPOYear IPO_timescale) ///
		(rcap highAss lowAss IPO_timescale), ///
		xtitle("Years Around IPO") graphregion(color(white))
		graph export Output/$CountryID/IPO_PropAssets_`nYears'.pdf, replace 
		
		
		graph twoway (scatter  BetaSpE_ByIPOYear IPO_timescale) ///
		(rcap highSpE lowSpE IPO_timescale), ///
		xtitle("Years Around IPO") graphregion(color(white))
		graph export Output/$CountryID/IPO_PropSalesPerEmp_`nYears'.pdf, replace 
		
		
		** Save Results for Cross-Country-Dataset
		sum BetaEmp_ByIPOYear if (IPO_timescale==2)
		local Post=r(mean)
		sum BetaEmp_ByIPOYear if (IPO_timescale==-2)
		local Prior=r(mean)
		gen IPODiff_Emp_5Year=`Post'-`Prior'
		
		sum BetaAss_ByIPOYear if (IPO_timescale==2)
		local Post=r(mean)
		sum BetaAss_ByIPOYear if (IPO_timescale==-2)
		local Prior=r(mean)
		gen IPODiff_Ass_5Year=`Post'-`Prior'
		
		sum BetaSpE_ByIPOYear if (IPO_timescale==2)
		local Post=r(mean)
		sum BetaSpE_ByIPOYear if (IPO_timescale==-2)
		local Prior=r(mean)
		gen IPODiff_SpE_5Year=`Post'-`Prior'
		

		gen Country="${CountryID}"

		collapse (mean) IPODiff_*, by(Country)

		save "Data_Cleaned/${CountryID}_CountryLevel_OB_IPO.dta", replace

	restore
*}