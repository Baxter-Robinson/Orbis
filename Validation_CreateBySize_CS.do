
** Orbis
use "Data_Cleaned/${CountryID}_CompustatUnbalanced.dta",clear

keep IDNum Year nEmployees 
drop if missing(nEmployees)

sum nEmployees, detail
local max= r(max)+1

local Categories 0 100 1000 10000 100000
egen SizeCategory  = cut(nEmployees), at ( `Categories', `max')


local iCategory=0
foreach Num of local Categories {
	local iCategory=`iCategory'+1
	replace SizeCategory=`iCategory' if (SizeCategory==`Num')

}

sort IDNum Year SizeCategory

collapse (sum) nEmployees (count) nFirms=nEmployees, by (SizeCategory Year)

gen DataSet="CS"

save "Data_Cleaned/${CountryID}_Validation_bySize_CS.dta", replace
