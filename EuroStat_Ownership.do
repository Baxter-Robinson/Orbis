
cls
clear all
import delimited "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Ownership_RAW.csv", encoding(ISO-8859-2) clear

drop dataflow lastupdate freq obs_flag
rename geo Country
rename time_period Year
label var leg_form "Type of enterprise"
label var enterpr "Type of firm (High growth, young high growth, etc.)"
label var unit "Unit: Percentage"

save "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Cleaned/EuroStat_Ownership.dta", replace

