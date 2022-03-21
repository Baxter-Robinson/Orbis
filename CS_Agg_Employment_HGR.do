

preserve

	*Compustat Haltiwanger Growth Rates and Employment
	if "${CountryID}" == "PT" {
			bysort Year: egen AggEmployment = total(nEmployees)
			replace AggEmployment = AggEmployment/1000
			line AggEmployment Year, legend(label(1 "Aggregate Employment") ) ///
			xtitle("Year") graphregion(color(white)) ytitle("Aggregate Employment (1000s employees)", axis(1))
			graph export Output/$CountryID/CS_Agg_Employment_HGR.pdf, replace 
	}
	else if "${CountryID}" != "PT"  {
			bysort Year: egen AggEmployment = total(nEmployees)
			replace AggEmployment = AggEmployment/1000


			by Year: egen nfirmsHGR = count(IDNum) if (abs(EmpGrowth_h)>1.9) & (abs(EmpGrowth_h)!=.)
			sum nfirmsHGR, detail
				if r(N)>0{
						local y2max = r(max) 

					twoway (line AggEmployment Year, yaxis(1)) (scatter nfirmsHGR Year, yaxis(2)), ///
					legend(label(1 "Aggregate Employment") label(2 "Number of Firms")) xtitle("Year") ///
					graphregion(color(white)) ytitle("Aggregate Employment (1000s employees)", axis(1))  ///
					ytitle("Firms with HGR>|1.90|", axis(2))  yscale(range(0 `y2max') axis(2))
					graph export Output/$CountryID/CS_Agg_Employment_HGR.pdf, replace 

				}


			local BinWidth=0.1
			local MinVal=-2


			* Haltiwanger Growth Rate Distribution
			*preserve	
				twoway (hist EmpGrowth_h, frac lcolor(gs12) fcolor(gs12) width(`BinWidth') start(`MinVal')), ///
				legend(label(1 "$CountryID Public Firms")) ///
				xtitle("Employment growth - Haltiwanger") graphregion(color(white))
				graph export Output/$CountryID/CS_Distribution_EmploymentHaltiwanger-PublicPrivate.pdf, replace 
			*restore



			* Create a 2nd variable for the Haltiwanger growth rate to avoid the fact that Stata takes the . as higher than the abs()>1.90
			gen halti2 = EmpGrowth_h
			replace halti2 =0.000000000001 if halti2==.
			gen abs_EmpGrowth_h = abs(halti2)
			gen ftocheck = 0 // indicator for firm to check 

			* Indicator that a firm has an abs(HGR)>1.9
			bysort IDNum: egen h_review = max(abs_EmpGrowth_h)
			replace ftocheck = 1 if h_review>1.90

			* Creates the number of unique firms in the dataset
			bysort IDNum: gen nvals = _n == 1 
			replace nvals = sum(nvals)
			replace nvals = nvals[_N] 
			gen Firms_total = nvals
			drop nvals

			keep if ftocheck==1  // Keep only the firms that were flagged.
			drop h_review
			
			* Creates the number of unique firms in the dataset with at least one year of abs(HGR)>1.90
			bysort IDNum: gen nvals = _n == 1 
			replace nvals = sum(nvals)
			replace nvals = nvals[_N] 
			gen Firms_HGR_check = nvals
			drop nvals

			gen firmchanging = .
			bysort IDNum: replace firmchanging = 1 if abs(halti2)>1.90  // For the firms that I keep, I write a 1 for the period in which they have the HGR>1.90
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



			*preserve	
				bysort IDNum: egen Numchanges = total(firmchanging) // Gives you the number of jumps per firm
				
				*Percentage of firms with HGR>abs(1.90)
				bysort IDNum: gen nvals = _n == 1 
				replace nvals = sum(nvals)
				replace nvals = nvals[_N] 
				gen FirmsHGR = nvals
				drop nvals
				gen p_HGR = FirmsHGR/Firms
				
				sum nEmployees if firmchanging==1, detail
				
				estpost tabulate  nEmployees if (EmpGrowth_h>=0) & (previous==1) |  (EmpGrowth_h<0) & (firmchanging==1) | (abs_EmpGrowth_h>1.90) 
			   
				esttab . using "Output/$CountryID/CS_Table_Public_nEmployees_freq.tex" , cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") ///
			   varlabels(, blist(Total "{hline @width}{break}"))      ///
			   nonumber nomtitle noobs replace
			*restore
	}
	
restore
