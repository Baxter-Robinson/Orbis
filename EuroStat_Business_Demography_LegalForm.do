clear all
cls
import delimited "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Business_Demography_LegalForm.csv", encoding(ISO-8859-2) clear


label var v11910 "Population of active enterprises in t - number "
label var v11920 "Births of enterprises in t - number "
label var v11930 "Deaths of enterprises in t - number "
label var v16910 "Persons employed in the population of active enterprises in t - number "
label var v16911 "Employees in the population of active enterprises in t - number "
label var v16920 "Persons employed in the population of births in t - number "
label var v16921 "Employees in the population of births in t - number "
label var v16930 "Persons employed in the population of deaths in t - number "
label var v16931 "Employees in the population of deaths in t - number "
label var v97010 "Net business population growth - percentage "
label var v97015 "Business churn: birth rate + death rate - percentage "
label var v97020 "Birth rate: number of enterprise births in the reference period (t) divided by the number of enterprises active in t - percentage "
label var v97022 "Density of birth rate: number of enterprise births in the reference period (t) divided by the population (in 10,000) in t - percentage "
label var v97023 "Density of birth rate (narrow version): number of enterprise births in the reference period (t) divided by the population aged 20-59 (in 10,000) in t - percentage "
label var v97030 "Death rate: number of enterprise deaths in the reference period (t) divided by the number of enterprises active in t - percentage "
label var v97031 "Proportion of enterprise deaths in the reference period (t) by size class - percentage "
label var v97120 "Employment share of enterprise births: number of persons employed in the reference period (t) among enterprises newly born in t divided by the number of persons employed in t among the stock of enterprises active in t - percentage "
label var v97121 "Average size of newly born enterprises: number of persons employed in the reference period (t) among enterprises newly born in t divided by the number of enterprises newly born in t - number "
label var v97122 "New enterprise paid employment rate: number of employees in the reference period (t) among enterprises newly born in t divided by the number of persons employed in t among enterprises newly born in t - percentage "
label var v97130 "Employment share of enterprise deaths: number of persons employed in the reference period (t) among enterprise deaths divided by the number of persons employed in t among the stock of active enterprises in t - percentage "
label var v97131 "Average employment in enterprise deaths: number of persons employed in the reference period (t) among enterprise deaths in t divided by the number of enterprise deaths in t - number "



save "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Cleaned/EuroStat_Business_Demography_LegalForm.dta", replace
