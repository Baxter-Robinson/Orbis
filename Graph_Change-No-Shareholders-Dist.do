replace DiffShareHolders=DiffShareHolders-0.5

histogram DiffShareHolders, width(1)  graphregion(color(white)) ///
			xscale( range(-10(2)10)) xlabel(-10(2)10)
         graph export Output/$CountryID/Distribution_Change-No-Shareholders.pdf, replace  
