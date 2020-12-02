preserve


gen MultiShareholder=0
replace MultiShareholder=1 if ((nShareholders>1) & ~(Listed))



xtreg EmpGrowth MultiShareholder Listed i.Year i.Industry_2digit


restore
