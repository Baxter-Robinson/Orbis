
preserve 
drop if missing(nShareholders)

histogram nShareholders , width(5)  graphregion(color(white))
        * graph export Output/$CountryID/Distribution_NoShareHolders.pdf, replace  

		
gen ShareHolderCategories=.
replace ShareHolderCategories=0 if (nShareholders==0)
replace ShareHolderCategories=1 if (nShareholders==1)
replace ShareHolderCategories=2 if (nShareholders==2)
replace ShareHolderCategories=3 if (nShareholders==3)
replace ShareHolderCategories=4 if (nShareholders==4)
replace ShareHolderCategories=5 if (nShareholders>=5)
replace ShareHolderCategories=6 if (nShareholders>10)
replace ShareHolderCategories=7 if (nShareholders>25)
replace ShareHolderCategories=8 if (nShareholders>50)
replace ShareHolderCategories=9 if (nShareholders>100)


gen SalesPerEmployee=Sales/max(nEmployees,1)

collapse (mean) nShareholders SalesPerEmployee (count) nFirms=nShareholders, by(ShareHolderCategories)


replace nFirms=nFirms/1000

twoway (bar nFirms ShareHolderCategories) , xtitle("Number of Shareholders") ytitle("Number of Firms")  graphregion(color(white)) xlabel( 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5-10" 6 "11-25" 7 "26-50" 8" 51-100" 9 "100+ ")
	 graph export Output/$CountryID/Distribution_NoShareHolders.pdf, replace  

	


	
twoway (scatter SalesPerEmployee ShareHolderCategories  [w=nFirms]) , xtitle("Number of Shareholders") ytitle("Average Sales Per Employee")  graphregion(color(white)) xlabel( 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5-10" 6 "11-25" 7 "26-50" 8" 51-100" 9 "100+ ")
	 graph export Output/$CountryID/Productivity-by-nShareholders.pdf, replace  


restore
