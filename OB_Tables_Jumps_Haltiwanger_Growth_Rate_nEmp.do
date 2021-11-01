


preserve
gen private = 1 if FirmType != 6 | (FirmType == 6 & Year >= Delisted_year)
gen public = 1 if FirmType == 6
replace public = 0 if FirmType == 6 & Delisted_year != . & Delisted_year <= Year

	* Create a 2nd variable for the Haltiwanger growth rate to avoid the fact that Stata takes the . as higher than the abs()>1.90
	gen halti2 = EmpGrowth_h
	replace halti2 =0.000000000001 if halti2==.
	gen abs_EmpGrowth_h = abs(halti2)
	keep if public == 1
	
	
	gen ftocheck = 0 // indicator for firm to check 
	sum IDNum, meanonly
	return list
	local minIDNum = r(min)
	local maxIDNum = r(max)  // These previous commands are just to create the iteration numbers
	forval i = `minIDNum' /`maxIDNum'{ // Loop to go through each firm and check if the firm has a Haltiwanger growth rate greater than 1.90
		su abs_EmpGrowth_h if IDNum==`i', meanonly   // If the firm has at least 1 HGR>1.90 then the firm for all its periods is marked with 1 to check it
		return list
		replace ftocheck=1 if r(max)>1.90 & IDNum==`i'
		di `i'
	}

	keep if ftocheck==1  // I keep only the firms that where flagged.
	bysort IDNum: gen firmchanging = 1 if abs(halti2)>1.90  // For the firms that I keep, I write a 1 for the period in which they have the HGR>1.90
	* replace firmchanging=0 if firmchanging==.


	* Now I want to see what is the difference in employment between the period previous to a HGR>1.90 and the period when HGR>1.90
	gen previous =.  // Indicator for the previous period


	local tot = _N
	forval i = 2 /`tot'{  // What this loop does is that it will add a 1 in the previous period in which a HGR>1.90 was observed
		local j=`i'-1
		di `i'
		if firmchanging[`i']==1 {
			replace previous = 1 in `j'
		}
	}

	replace previous=0 if previous==.   // Set all other periods to 0 if they are not related to a HGR>1.90

* Up to here I have the firms that have a HGR>|1.95| identified, also the period t in which they have that and the previous period in which they have it. So now the doubt is having the values at where they are jumping and how many per value

	* The thing here is that some firms have low employment the first time observed and then they jump, while other firms have high employment, then they jump down, and bounce back
	
	* For the first firms
	*tab nEmployees if (EmpGrowth_h>=0) & (previous==1) |  (EmpGrowth_h<0) & (firmchanging==1)
	tab2xl nEmployees if (EmpGrowth_h>=0) & (previous==1) |  (EmpGrowth_h<0) & (firmchanging==1) using "Output/$CountryID/`Country'_nEmployees_freqs.xlsx", col(1) row(1)
	
	tab2xl nEmployees if (EmpGrowth_h>=0) & (previous==1)  using "Output/$CountryID/`Country'_nEmployees_up_freqs.xlsx", col(1) row(1) // These are the firms that jumped upward for a HGR>1.95 - Basically this command gives me the  number of employees before the big jump
	
	tab2xl nEmployees if  (EmpGrowth_h<0) & (firmchanging==1) using "Output/$CountryID/`Country'_nEmployees_down_freqs.xlsx", col(1) row(1) // These are the firms that jumped downward for a HGR < -1.95 - Basically this command gives me the number of employees after the jump down.
	 
restore

