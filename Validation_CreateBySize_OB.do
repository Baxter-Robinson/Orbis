
** Orbis
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear

keep IDNum Year nEmployees 

sum nEmployees, detail
local max= r(max)

egen SizeCategory = cut(nEmployees), at(0 10 20 50 250 `max')

sort IDNum Year SizeCategory


collapse (sum) nEmployees (count) nFirms=nEmployees, by (SizeCategory Year)

gen DataSet="OB"

save "Data_Cleaned/${CountryID}_Validation_bySize_OB.dta", replace
