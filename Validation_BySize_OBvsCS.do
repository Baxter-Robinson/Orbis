
use "Data_Cleaned/${CountryID}_Validation_bySize_OB_Public.dta", clear
append using "Data_Cleaned/${CountryID}_Validation_bySize_CS.dta"



** Print out table of nFirms by Size Category for each dataset
local DataSets OB CS
local Set="CS"
foreach Set of local DataSets{
    local t=${FirstYear}
    forval t=$FirstYear/$LastYear{

        file close _all
        file open nFirmsFile using Output/${CountryID}/Validation_`Set'_BySizePub_nFirms_`t'.tex, write replace
        file open nEmpFile using Output/${CountryID}/Validation_`Set'_BySizePub_nEmp_`t'.tex, write replace
        file write nFirmsFile " ${CountryID} `Set' (`t') & "
        file write nEmpFile " ${CountryID} `Set' (`t') & "
        local i=1
        forval i=1/5{
            sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="`Set'")
            local Moment: di %12.0fc r(mean)
            file write  nFirmsFile " `Moment' & "   
            sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="`Set'")    
            local Moment: di %12.0fc r(mean)
            file write  nEmpFile " `Moment' & "     
        }
            sum nFirms if ( Year==`t' & DataSet=="`Set'")
            local Moment: di %12.0fc r(sum)
            file write  nFirmsFile " `Moment'  "    
            sum nEmployees if ( Year==`t' & DataSet=="`Set'")
            local Moment: di %12.0fc r(sum)
            file write  nEmpFile " `Moment'  "      
        
        file close _all
    }

}

** Print out table of (nFirms in Orbis)/(nFirms in CompuStat) by Size Category for each dataset
local t=${FirstYear}
forval t=$FirstYear/$LastYear{

    file close _all
    file open nFirmsFile using Output/${CountryID}/Validation_OBvsCS_BySizePub_nFirms_`t'.tex, write replace
    file open nEmpFile using Output/${CountryID}/Validation_OBvsCS_BySizePub_nEmp_`t'.tex, write replace
    file write nFirmsFile " ${CountryID} OB/CS (`t') & "
    file write nEmpFile " ${CountryID}  OB/CS  (`t') & "

    local i=1
    forval i=1/5{
        sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="OB")
        local OBMoment=r(mean)
        sum nFirms if (SizeCategory==`i' & Year==`t' & DataSet=="CS")
        local CSMoment=r(mean)
        local Moment : di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nFirmsFile " `Moment' & "       

        sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="OB")
        local OBMoment=r(mean)
        sum nEmployees if (SizeCategory==`i' & Year==`t' & DataSet=="CS")
        local CSMoment=r(mean)
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nEmpFile " `Moment' & "         
    }
        sum nFirms if (Year==`t' & DataSet=="OB")
        local OBMoment=r(sum)
        sum nFirms if (Year==`t' & DataSet=="CS")
        local CSMoment=r(sum)
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nFirmsFile " `Moment'  "
        
        sum nEmployees if (Year==`t' & DataSet=="OB")
        local OBMoment=r(sum)
        disp(`OBMoment')
        sum nEmployees if (Year==`t' & DataSet=="CS")
        local CSMoment=r(sum)
        disp(`CSMoment')
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        disp(`Moment')
        file write  nEmpFile " `Moment' "           
    
    file close _all
}



******************************************************************
** Average Across Years
******************************************************************
drop if (Year<${FirstYear} | Year> ${LastYear})

collapse (mean) nFirms nEmployees, by(SizeCategory DataSet)


** Print out table of nFirms by Size Category for each dataset
local DataSets OB CS
local Set="CS"
foreach Set of local DataSets{

    file close _all
    file open nFirmsFile using Output/${CountryID}/Validation_`Set'_BySizePub_nFirms_AvgOverYears.tex, write replace
    file open nEmpFile using Output/${CountryID}/Validation_`Set'_BySizePub_nEmp_AvgOverYears.tex, write replace
    file write nFirmsFile " ${CountryID} `Set' (Average) & "
    file write nEmpFile " ${CountryID} `Set' (Average) & "
    local i=1
    forval i=1/5{
        sum nFirms if (SizeCategory==`i' & DataSet=="`Set'")
        local Moment: di %12.0fc r(mean)
        file write  nFirmsFile " `Moment' & "   
        sum nEmployees if (SizeCategory==`i' & DataSet=="`Set'")    
        local Moment: di %12.0fc r(mean)
        file write  nEmpFile " `Moment' & "     
    }
        sum nFirms if ( DataSet=="`Set'")
        local Moment: di %12.0fc r(sum)
        file write  nFirmsFile " `Moment'  "    
        sum nEmployees if ( DataSet=="`Set'")
        local Moment: di %12.0fc r(sum)
        file write  nEmpFile " `Moment'  "      
    
    file close _all

}


** Print out table of (nFirms in Orbis)/(nFirms in CompuStat) by Size Category for each dataset

    file close _all
    file open nFirmsFile using Output/${CountryID}/Validation_OBvsCS_BySizePub_nFirms_AvgOverYears.tex, write replace
    file open nEmpFile using Output/${CountryID}/Validation_OBvsCS_BySizePub_nEmp_AvgOverYears.tex, write replace
    file write nFirmsFile " ${CountryID} OB/CS (Average) & "
    file write nEmpFile " ${CountryID}  OB/CS  (Average) & "

    local i=1
    forval i=1/5{
        sum nFirms if (SizeCategory==`i' & DataSet=="OB")
        local OBMoment=r(mean)
        sum nFirms if (SizeCategory==`i'  & DataSet=="CS")
        local CSMoment=r(mean)
        local Moment : di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nFirmsFile " `Moment' & "       

        sum nEmployees if (SizeCategory==`i'  & DataSet=="OB")
        local OBMoment=r(mean)
        sum nEmployees if (SizeCategory==`i' & DataSet=="CS")
        local CSMoment=r(mean)
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nEmpFile " `Moment' & "         
    }
        sum nFirms if (DataSet=="OB")
        local OBMoment=r(sum)
        sum nFirms if ( DataSet=="CS")
        local CSMoment=r(sum)
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nFirmsFile " `Moment'  "
        
        sum nEmployees if (DataSet=="OB")
        local OBMoment=r(sum)
        sum nEmployees if (DataSet=="CS")
        local CSMoment=r(sum)
        local Moment: di %12.0fc `OBMoment'/`CSMoment'*100
        file write  nEmpFile " `Moment' "           
    
    file close _all
