
* Set Up Data
use "Data_Cleaned/${CountryID}_AllYears.dta",clear

local nYears=5

drop if (EverPublic==0)
drop if (Public==1 & IPO_timescale>`nYears')

rename nEmployees LevelsEmp
rename Assets LevelsAssets
rename Sales LevelsSales
rename SalesPerEmployee LevelsSalesPerEmp


gen LnEmp=ln(LevelsEmp)
gen LnAssets=ln(LevelsAssets)
gen LnSales=ln(LevelsSales)
gen LnSalesPerEmp=ln(LevelsSalesPerEmp)


bysort IDNum: egen nEmployees_Mean=mean(LevelsEmp) 
gen PropEmp=LevelsEmp/nEmployees_Mean*100

bysort IDNum: egen Assets_Mean=mean(LevelsAssets) 
gen PropAssets=LevelsAssets/Assets_Mean*100

bysort IDNum: egen Sales_Mean=mean(LevelsSales) 
gen PropSales=LevelsSales/Sales_Mean*100

bysort IDNum: egen SalesPerEmp_Mean=mean(LevelsSalesPerEmp) 
gen PropSalesPerEmp=LevelsSalesPerEmp/SalesPerEmp_Mean*100

gen YearIs_Zero=0
replace YearIs_Zero=1 if (IPO_timescale==0)

forval t=1/`nYears'{
	gen YearIs_Neg`t'=0
	replace YearIs_Neg`t'=1 if (IPO_timescale==-`t') 
	
	gen YearIs_Pos`t'=0
	replace YearIs_Pos`t'=1 if (IPO_timescale==`t') 
	
}

local YearsInOrder 
forval t=`nYears'(-1)1{
	local YearsInOrder `YearsInOrder' YearIs_Neg`t'
}
local YearsInOrder `YearsInOrder' YearIs_Zero
forval t=1/`nYears'{
	local YearsInOrder `YearsInOrder' YearIs_Pos`t'
}

local DepVars Emp Assets Sales SalesPerEmp
local var="Emp"

local Formats Levels Ln Prop
local form="Ln"

foreach var of local DepVars{
	eststo clear
	local AllModels
	foreach form of local Formats{
		preserve
		
		disp "`form'`var'"
		
		reghdfe `form'`var' `YearsInOrder', absorb(Year Industry_2digit)
		estimates store Model`form'
		
		local AllModels `AllModels' Model`form'
		
		gen BetaEmp_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
		gen SEEmp_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
		
		forval t=1/`nYears'{
			
			replace BetaEmp_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace BetaEmp_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
		}
		
		collapse (mean) BetaEmp_ByIPOYear SEEmp_ByIPOYear   ,  by(IPO_timescale)

			drop if (IPO_timescale<-`nYears')
			drop if (IPO_timescale>`nYears')
			
			gen highEmp=BetaEmp_ByIPOYear+1.96*SEEmp_ByIPOYear
			gen lowEmp=BetaEmp_ByIPOYear-1.96*SEEmp_ByIPOYear

			graph twoway (scatter  BetaEmp_ByIPOYear IPO_timescale) ///
			(rcap highEmp lowEmp IPO_timescale), ///
			xtitle("Years Around IPO") graphregion(color(white)) ///
			legend(label(1 "Point Estimate") label( 2 "95% Confidence Interval"))
			graph export Output/$CountryID/IPO_`var'_`form'.pdf, replace 
	
		
		restore
		preserve
			
		reghdfe `form'`var' `YearsInOrder', absorb(Year IDNum)
		estimates store Model`form'FFE
		local AllModels `AllModels' Model`form'FFE
		
		gen BetaEmp_ByIPOYear_ByIPOYear=_b[YearIs_Zero] if (IPO_timescale==0)
		gen SEEmp_ByIPOYear=_se[YearIs_Zero] if (IPO_timescale==0)
		
		forval t=1/`nYears'{
			
			replace BetaEmp_ByIPOYear=_b[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Pos`t'] if (IPO_timescale==`t')
			replace BetaEmp_ByIPOYear=_b[YearIs_Neg`t'] if (IPO_timescale==-`t')
			replace SEEmp_ByIPOYear=_se[YearIs_Neg`t'] if (IPO_timescale==-`t')
		}
		
		collapse (mean) BetaEmp_ByIPOYear SEEmp_ByIPOYear   ,  by(IPO_timescale)

			drop if (IPO_timescale<-`nYears')
			drop if (IPO_timescale>`nYears')
			
			gen highEmp=BetaEmp_ByIPOYear+1.96*SEEmp_ByIPOYear
			gen lowEmp=BetaEmp_ByIPOYear-1.96*SEEmp_ByIPOYear

			graph twoway (scatter  BetaEmp_ByIPOYear IPO_timescale) ///
			(rcap highEmp lowEmp IPO_timescale), ///
			xtitle("Years Around IPO") graphregion(color(white)) ///
			legend(label(1 "Point Estimate") label( 2 "95% Confidence Interval"))
			graph export Output/$CountryID/IPO_`var'_`form'_FFE.pdf, replace 

		
		restore
			
		
	}
	

		estfe `AllModels', labels( Year "Year FE"  Industry_2digit "Industry FE" IDNum "Firm FE")
		return list
		

		
		
	esttab `AllModels' using "Output/$CountryID/IPO_Reg_`var'.tex", replace se fragment ///
	indicate( `r(indicate_fe)' ) label stats(N, labels(N)) ///
	mlabels("Levels" "Logs" "Prop" )
	
}

	