*----------------
* Initial Set Up
*----------------
cls
clear all
*version 13
*set maxvar 10000
set type double
set more off
set rmsg on

* Javier PATH
* Laptop
*cd "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
*global DATAPATH "/Volumes/EHDD1/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"

* HOME
cd "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis"
global DATAPATH "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw"



*---------------------
* Merge over countries
*---------------------

use "Data_Cleaned/IT_Unbalanced.dta",clear

gen Country="IT"

gen CountryID=.
replace CountryID=1 if Country=="IT"

global Countries  FR ES PT DE NL
*global Countries FR 

foreach C of global Countries {
	append using "Data_Cleaned/`C'_Unbalanced.dta"	
	replace Country="`C'" if missing(Country)
	

}

replace CountryID=2 if Country=="FR"
replace CountryID=3 if Country=="ES"
replace CountryID=4 if Country=="PT"
replace CountryID=5 if Country=="DE"
replace CountryID=6 if Country=="NL"

keep IDNum Year Country CountryID NACE_Rev_2_main_section NACE_Rev_2_Core_code_4_digits Industry_4digit NACE_Rev_2_Primary_code_s NACE_Rev_2_SEcondary_code_s US_SIC_Core_code_3_digits US_SIC_Primary_code_s US_SIC_Secondary_code_s


gen Activity_Code = .
replace Activity_Code= 1 if NACE_Rev_2_main_section=="A - Agriculture, forestry and fishing"
replace Activity_Code= 1 if NACE_Rev_2_main_section=="B - Mining and quarrying"
replace Activity_Code= 2 if NACE_Rev_2_main_section=="C - Manufacturing"
replace Activity_Code= 3 if NACE_Rev_2_main_section=="D - Electricity, gas, steam and air conditioning supply"
replace Activity_Code= 3 if NACE_Rev_2_main_section=="E - Water supply; sewerage, waste management and remediation activities"
replace Activity_Code= 3 if NACE_Rev_2_main_section=="F - Construction"
replace Activity_Code= 4 if NACE_Rev_2_main_section=="G - Wholesale and retail trade; repair of motor vehicles and motorcycles"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="H - Transportation and storage"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="I - Accommodation and food service activities"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="J - Information and communication"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="K - Financial and insurance activities"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="L - Real estate activities"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="M - Professional, scientific and technical activities"
replace Activity_Code= 5 if NACE_Rev_2_main_section=="N - Administrative and support service activities"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="O - Public administration and defence; compulsory social security"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="P - Education"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="Q - Human health and social work activities"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="R - Arts, entertainment and recreation"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="S - Other service activities"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="T - Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use"
replace Activity_Code= 6 if NACE_Rev_2_main_section=="U - Activities of extraterritorial organisations and bodies"
replace Activity_Code= 6 if missing(NACE_Rev_2_main_section)


bysort CountryID Activity_Code IDNum: gen nvals = _n == 1 

collapse (first) Country NACE_Rev_2_main_section (sum) Ind = nvals, by (CountryID Activity_Code)

bysort CountryID: egen Nfirms = total(Ind) 
gen pct = round(100*Ind/Nfirms,.01)

bysort CountryID: egen TotalPCT = total(pct) 

bysort CountryID: gen cumfreq = sum(pct)

* Midpoint calculation for labels in graphs

gen midpoint = .

levelsof Activity_Code, local(Act_Code)
levelsof CountryID, local(Countries)

foreach c of local Countries{
	foreach i of local Act_Code{
		sum pct if (CountryID==`c') & (Activity_Code==`i'), detail
		return list
		local `c'_pct_ActivityCode_`i' = r(mean)
	}
}


foreach c of local Countries{
		local `c'_midpoint_1 = (``c'_pct_ActivityCode_1')/2 
		local `c'_midpoint_2 = ( (``c'_pct_ActivityCode_1') + (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2') )/2
		local `c'_midpoint_3 = ( (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2') + (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2'+``c'_pct_ActivityCode_3') )/2
		local `c'_midpoint_4 = ( (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2' + ``c'_pct_ActivityCode_3' ) + (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2'+``c'_pct_ActivityCode_3' + ``c'_pct_ActivityCode_4') )/2
		local `c'_midpoint_5 = ( (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2' + ``c'_pct_ActivityCode_3'+ ``c'_pct_ActivityCode_4') + (``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2'+``c'_pct_ActivityCode_3' + ``c'_pct_ActivityCode_4'+``c'_pct_ActivityCode_5') )/2
		local `c'_midpoint_6 =  (100+(``c'_pct_ActivityCode_1'+``c'_pct_ActivityCode_2'+``c'_pct_ActivityCode_3' + ``c'_pct_ActivityCode_4'+``c'_pct_ActivityCode_5'))/2
}

foreach c of local Countries{
	foreach i of local Act_Code{
		replace midpoint=``c'_midpoint_`i''  if (CountryID==`c') & (Activity_Code==`i')
	}
}


drop NACE_Rev_2_main_section Ind TotalPCT
reshape wide pct cumfreq midpoint, i(CountryID)  j(Activity_Code)   
gen TotalPCT = cumfreq5+pct6

gen floor = 0

label define CountryID 1 "Italy" 2 "France"  3 "Spain" 4 "Portugal" 5 "Germany" 6 "Netherlands" 

local Labels  1 "Italy" 2 "France"  3 "Spain" 4 "Portugal" 5 "Germany" 6 "Netherlands" 
graph twoway (rbar floor pct1 CountryID, color(maroon) barwidth(.75) )  ///
(rbar pct1 cumfreq2 CountryID, color(navy) barwidth(.75))  ///
(rbar cumfreq2 cumfreq3 CountryID, color(dkgreen) barwidth(.75))  ///
(rbar cumfreq3 cumfreq4 CountryID, color(orange) barwidth(.75))  ///
(rbar cumfreq4 cumfreq5 CountryID, color(purple) barwidth(.75))  ///
(rbar cumfreq5 cumfreq6 CountryID, color(edkblue) barwidth(.75)), ///
legend(label(1 "Agriculture, mining") label( 2 "Manufacturing" ) label( 3 "Construction" ) label( 4 "Wholesale and Retail Trade" ) label( 5 "Services" ) label( 6 "Other" )    ) ///
ytitle("Percentage") ///
ylabel(, format(%9.0fc)) ///
xtitle("Country") ///
xlabel(`Labels')  ///
graphregion(color(white)) ///
text(`1_midpoint_1' 1 "`1_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`1_midpoint_2' 1 "`1_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`1_midpoint_3' 1 "`1_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`1_midpoint_4' 1 "`1_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`1_midpoint_5' 1 "`1_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`1_midpoint_6' 1 "`1_pct_ActivityCode_6'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_1' 2 "`2_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_2' 2 "`2_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_3' 2 "`2_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_4' 2 "`2_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_5' 2 "`2_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`2_midpoint_6' 2 "`2_pct_ActivityCode_6'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_1' 3 "`3_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_2' 3 "`3_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_3' 3 "`3_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_4' 3 "`3_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_5' 3 "`3_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`3_midpoint_6' 3 "`3_pct_ActivityCode_6'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_1' 4 "`4_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_2' 4 "`4_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_3' 4 "`4_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_4' 4 "`4_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_5' 4 "`4_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`4_midpoint_6' 4 "`4_pct_ActivityCode_6'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_1' 5 "`5_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_2' 5 "`5_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_3' 5 "`5_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_4' 5 "`5_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_5' 5 "`5_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`5_midpoint_6' 5 "`5_pct_ActivityCode_6'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_1' 6 "`6_pct_ActivityCode_1'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_2' 6 "`6_pct_ActivityCode_2'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_3' 6 "`6_pct_ActivityCode_3'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_4' 6 "`6_pct_ActivityCode_4'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_5' 6 "`6_pct_ActivityCode_5'", color(white) size(small)) /// Begin labels for private firms (first number is y second is x)
text(`6_midpoint_6' 6 "`6_pct_ActivityCode_6'", color(white) size(small)) 
graph export "Output/Cross-Country/OB_CrossCountry_Industry_Comparison.png",  replace  


