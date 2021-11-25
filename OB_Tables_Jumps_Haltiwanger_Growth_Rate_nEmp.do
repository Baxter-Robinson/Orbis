
* Create a 2nd variable for the Haltiwanger growth rate to avoid the fact that Stata takes the . as higher than the abs()>1.90
gen halti2 = EmpGrowth_h
replace halti2 =0.000000000001 if halti2==.
gen abs_EmpGrowth_h = abs(halti2)
gen ftocheck = 0 // indicator for firm to check 


bysort IDNum: egen h_review = max(abs_EmpGrowth_h)
replace ftocheck = 1 if h_review>1.90

*Total public firms
bysort IDNum: gen nvals = _n == 1  if Private==0
replace nvals = sum(nvals)
replace nvals = nvals[_N] 
gen PublicFirms = nvals
drop nvals
*Total private firms
bysort IDNum: gen nvals = _n == 1  if Private==1
replace nvals = sum(nvals)
replace nvals = nvals[_N] 
gen PrivateFirms = nvals
drop nvals

keep if ftocheck==1  // I keep only the firms that where flagged.
bysort IDNum: gen firmchanging = 1 if abs(halti2)>1.90  // For the firms that I keep, I write a 1 for the period in which they have the HGR>1.90
replace firmchanging=0 if firmchanging==.
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


preserve
	keep if Private==0
	
	bysort IDNum: egen Numchanges = total(firmchanging) // Gives you the number of jumps per firm
	
	*Percentage of firms with HGR>abs(1.90)
	bysort IDNum: gen nvals = _n == 1  if Private==0
	replace nvals = sum(nvals)
	replace nvals = nvals[_N] 
	gen PublicFirmsHGR = nvals
	drop nvals
	gen p_public = PublicFirmsHGR/PublicFirms
	
	sum nEmployees if firmchanging==1, detail
	
	estpost tabulate  nEmployees if (EmpGrowth_h>=0) & (previous==1) & (nEmployees<36) |  (EmpGrowth_h<0) & (firmchanging==1) & (nEmployees<36)
   
    esttab . using "Output/$CountryID/OB_Table_Public_nEmployees_freq.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace
	
	*tab2xl nEmployees if (EmpGrowth_h>=0) & (previous==1)  using "Output/$CountryID/`Country'_nEmployees_up_freqs.xlsx", col(1) row(1) // These are the firms that jumped upward for a HGR>1.95 - Basically this command gives me the  number of employees before the big jump
	
	estpost tabulate  nEmployees if (EmpGrowth_h>=0) & (previous==1) & (nEmployees<36)
   
    esttab . using "Output/$CountryID/OB_Table_Public_nEmployees_freq_upward.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace
	
	
	*tab2xl nEmployees if  (EmpGrowth_h<0) & (firmchanging==1) using "Output/$CountryID/`Country'_nEmployees_down_freqs.xlsx", col(1) row(1) // These are the firms that jumped downward for a HGR < -1.95 - Basically this command gives me the number of employees after the jump down.
	 
	estpost tabulate  nEmployees if (EmpGrowth_h<0) & (firmchanging==1) & (nEmployees<36)
   
    esttab . using "Output/$CountryID/OB_Table_Public_nEmployees_freq_downward.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace
restore

preserve
	keep if private == 1
	
	bysort IDNum: gen nvals = _n == 1  if Private==0
	replace nvals = sum(nvals)
	replace nvals = nvals[_N] 
	gen PrivateFirmsHGR = nvals
	drop nvals
	gen p_public = PrivateFirmsHGR/PrivateFirms
	
	bysort IDNum: egen Numchanges = total(firmchanging)
	
	estpost tabulate  nEmployees if (EmpGrowth_h>=0) & (previous==1)  & (nEmployees<36) |  (EmpGrowth_h<0) & (firmchanging==1) & (nEmployees<36)
   
   esttab . using "Output/$CountryID/OB_Table_Private_nEmployees_freq.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace
	
	*tab2xl nEmployees if (EmpGrowth_h>=0) & (previous==1)  using "Output/$CountryID/`Country'_nEmployees_up_freqs.xlsx", col(1) row(1) // These are the firms that jumped upward for a HGR>1.95 - Basically this command gives me the  number of employees before the big jump
	
	estpost tabulate  nEmployees if (EmpGrowth_h>=0) & (previous==1) & (nEmployees<36)
   
   esttab . using "Output/$CountryID/OB_Table_Private_nEmployees_freq_upward.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace
	
	
	*tab2xl nEmployees if  (EmpGrowth_h<0) & (firmchanging==1) using "Output/$CountryID/`Country'_nEmployees_down_freqs.xlsx", col(1) row(1) // These are the firms that jumped downward for a HGR < -1.95 - Basically this command gives me the number of employees after the jump down.
	 
	 estpost tabulate  nEmployees if (EmpGrowth_h<0) & (firmchanging==1) & (nEmployees<36)
   
   esttab . using "Output/$CountryID/OB_Table_Private_nEmployees_freq_downward.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
   varlabels(, blist(Total "{hline @width}{break}"))      ///
   nonumber nomtitle noobs replace


restore


