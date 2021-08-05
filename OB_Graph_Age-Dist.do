
histogram Age if (Age<25), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_Firm-Age.pdf, replace  

histogram Year if (Year>1950), width(1)  graphregion(color(white)) frequency
         graph export Output/$CountryID/Distribution_Firm-Year.pdf, replace  
