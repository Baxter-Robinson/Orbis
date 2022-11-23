
** Orbis
use "Data_Cleaned/${CountryID}_Unbalanced.dta",clear
drop if (Private==1)

keep IDNum Year nEmployees 

sum nEmployees, detail
local max= r(max)

local Categories 100 1000 10000 100000
egen SizeCategory  = cut(nEmployees), at ( `Categories', `max')

local iCategory=0
foreach Num of local Categories {
	local iCategory=`iCategory'+1
	replace SizeCategory=`iCategory' if (SizeCategory==`Num')
	
}

sort IDNum Year SizeCategory

collapse (sum) nEmployees (count) nFirms=nEmployees, by (SizeCategory Year)

gen DataSet="OB"

save "Data_Cleaned/${CountryID}_Validation_bySize_OB_Public.dta", replace
