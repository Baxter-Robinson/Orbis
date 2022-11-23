
** Orbis
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear

keep IDNum Year nEmployees 

sum nEmployees, detail
local max= r(max)
egen groups  = cut(nEmployees), at (0, 9, 10, 19, 20, 49, 50, 249, 250, `max')

gen SizeCategory = . 
replace SizeCategory = 1 if (groups==0) | (groups==9)
replace SizeCategory = 2 if (groups==10) | (groups==19)
replace SizeCategory = 3 if (groups==20) | (groups==49)
replace SizeCategory = 4 if (groups==50) | (groups==249)
replace SizeCategory = 5 if (groups==250) | (groups==`max')
drop groups 
drop if SizeCategory==.

sort IDNum Year SizeCategory


collapse (sum) nEmployees (count) nFirms=nEmployees, by (SizeCategory Year)

gen DataSet="OB"

save "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", replace
