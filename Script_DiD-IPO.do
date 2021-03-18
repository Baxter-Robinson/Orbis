preserve
	*------------------------------------------------------------------
	* This script loop over the DID graph of IPO for each variable of interest
	*------------------------------------------------------------------

	* Create DID graphs for each dependent variable
	global n = 2

	global v nEmployees
	do Graph_DID-IPO.do

	global v Sales
	do Graph_DID-IPO.do

	global v SalesPerEmployee
	do Graph_DID-IPO.do

	global v GrossProfits
	do Graph_DID-IPO.do

	global v Profitability
	do Graph_DID-IPO.do

	* Create graph for decomposition of DID
	global v nEmployees
	do Graph_DiD-IPO_Decomposition.do

	* Create graph for Haltwinger measure of growth rate
	global n = 1
	bysort IDNum: gen SalesGrowth_h = (Sales[_n]-Sales[_n-1])/((Sales[_n]+Sales[_n-1])/2)
	bysort IDNum: gen EmpGrowth_h = (nEmployees[_n]-nEmployees[_n-1])/((nEmployees[_n]+nEmployees[_n-1])/2)
	bysort IDNum: gen ProfitGrowth_h = (GrossProfits[_n]-GrossProfits[_n-1])/((GrossProfits[_n]+GrossProfits[_n-1])/2)

	global v SalesGrowth_h
	do Graph_DID-IPO.do

	global v EmpGrowth_h
	do Graph_DID-IPO.do

	global v ProfitGrowth_h
	do Graph_DID-IPO.do
restore