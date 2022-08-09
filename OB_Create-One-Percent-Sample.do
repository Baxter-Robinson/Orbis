*---------------------------
* Create One Percent sample
*---------------------------
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear

* Characteristics: 
* One sample = one firm with all its years
preserve
tempfile tmps_public
keep if FirmType == 6 & IPO_year !=.
duplicates drop IDNum, force
sort FirmType
sample 50
save `tmps_public'
restore
preserve 
tempfile tmps
duplicates drop IDNum, force
sort FirmType
by FirmType: sample 1 // Always keep at least one public firm
sort IDNum
save `tmps'
restore
merge m:1 IDNum using `tmps_public'
rename _merge _merge0
merge m:1 IDNum using `tmps'
gen _merge_final = 0 
replace _merge_final = 1 if _merge == 3 | _merge0 == 3
keep if _merge_final == 1
drop _merge _merge_final _merge0
save Data_Cleaned/${CountryID}_OnePercent.dta, replace
