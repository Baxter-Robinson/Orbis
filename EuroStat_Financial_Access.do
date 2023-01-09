


cls
clear all
import delimited "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Financial_Access_RAW.csv", encoding(ISO-8859-2) clear
drop dataflow lastupdate freq enterpr unit obs_flag
gen f_a = fin_source+"_"+decision
* drop fin_source decision
rename time_period Year
rename geo Country
label var f_a "Financial access decision"
egen id_f_a = group(f_a)
label var id_f_a "Numeric id for Financial Access Decision"

/*
Financial access meaning
 FS02_ACC "Other employees of the business Accepted"
 FS02_PART "Other employees of the business Partial"
 FS02_REF "Other employees of the business Refused"
 FS04_ACC "Other businesses Accepted"
 FS04_PART "Other businesses Partial"
 FS04_REF "Other businesses Refused"
 FS05_ACC "Banks Accepted"
 FS05_PART "Banks Partial"
 FS05_REF "Banks Refused"
 FS07_ACC "Existing shareholders Accepted"
 FS07_PART "Existing shareholders Partial"
 FS07_REF "Existing shareholders Refused"
 FS09_ACC "Directors not previously shareholders Accepted"
 FS09_PART "Directors not previously shareholders Partial"
 FS09_REF "Directors not previously shareholders Refused"
 FS10_ACC "Venture capital funds Accepted"
 FS10_PART "Venture capital funds Partial"
 FS10_REF "Venture capital funds Refused"
 FS11_ACC "Business angels Accepted"
 FS11_PART "Business angels Partial"
 FS11_REF "Business angels Refused"
 FS12_ACC "Family, friends or other individuals, not any of the above Accepted"
 FS12_PART "Family, friends or other individuals, not any of the above Partial"
 FS12_REF "Family, friends or other individuals, not any of the above Refused"
 FS13_ACC "Initial public offering or other stock market offerings Accepted"
 FS13_PART "Initial public offering or other stock market offerings Partial"
 FS13_REF "Initial public offering or other stock market offerings Refused"
 FS14_ACC "Other financial institutions Accepted"
 FS14_PART "Other financial institutions Partial"
 FS14_REF "Other financial institutions Refused"
 FS15_ACC "Government/other equity finance Accepted"
 FS15_PART "Government/other equity finance Partial"
 FS15_REF "Government/other equity finance Refused"
*/


save "/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Cleaned/EuroStat_Financial_Access.dta", replace

