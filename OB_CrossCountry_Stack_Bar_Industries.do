

preserve

do SIC_3d_to_NAICS_2d.do 

gen NAICS_Industry = .
replace NAICS_Industry = 1 if NAICS_2_digit==11
replace NAICS_Industry = 2 if (NAICS_2_digit==21)|(NAICS_2_digit==22)|(NAICS_2_digit==23)
replace NAICS_Industry = 3 if (NAICS_2_digit==31)|(NAICS_2_digit==32)|(NAICS_2_digit==33)
replace NAICS_Industry = 4 if (NAICS_2_digit==41)|(NAICS_2_digit==44)|(NAICS_2_digit==45)|(NAICS_2_digit==48)|(NAICS_2_digit==49)
replace NAICS_Industry = 5 if (NAICS_2_digit==51)|(NAICS_2_digit==52)|(NAICS_2_digit==53)|(NAICS_2_digit==54)|(NAICS_2_digit==55)|(NAICS_2_digit==56)
replace NAICS_Industry = 6 if (NAICS_2_digit==61)|(NAICS_2_digit==62)|(NAICS_2_digit==71)|(NAICS_2_digit==72)|(NAICS_2_digit==81)|(NAICS_2_digit==91)


tab NAICS_Industry
return list
local Total_Industries = r(N) 

levelsof NAICS_Industry, local(NAICS)

foreach x of local NAICS{
	tab NAICS_Industry if NAICS_Industry==`x'
	return list
	local abs = r(N)
	local pct_NAICS_`x' = round(100*`abs'/`Total_Industries', .01)
}


foreach i of local NAICS{
	if `i'==1{
		gen cum_pct_NAICS_`i' = 0+`pct_NAICS_1'
	}
	else if `i'==2{
		gen cum_pct_NAICS_`i' = `pct_NAICS_1'+`pct_NAICS_2'
	}
	else if `i'==3{
		gen cum_pct_NAICS_`i' = `pct_NAICS_1'+`pct_NAICS_2'+`pct_NAICS_3'
	}
	else if `i'==4{
		gen cum_pct_NAICS_`i' = `pct_NAICS_1'+`pct_NAICS_2'+`pct_NAICS_3'+`pct_NAICS_4'
	}
	else if `i'==5{
		gen cum_pct_NAICS_`i' = `pct_NAICS_1'+`pct_NAICS_2'+`pct_NAICS_3'+`pct_NAICS_4'+`pct_NAICS_5'
	}
	else if `i'==6{
		gen cum_pct_NAICS_6 = 100
	}
	
}

foreach i of local NAICS{
	gen pct_NAICS_`i' = `pct_NAICS_`i''
}




