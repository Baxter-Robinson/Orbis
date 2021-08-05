preserve
	*------------------------------------------------------------------
	* This script loop over the DID graph of IPO for each variable of interest
	*------------------------------------------------------------------

	* Create DID graphs for each dependent variable
	global n = 2

	global v nEmployees
	do OB_Graph_DID-IPO.do

	global v Sales
	do OB_Graph_DID-IPO.do

	global v SalesPerEmployee
	do OB_Graph_DID-IPO.do

	global v GrossProfits
	do OB_Graph_DID-IPO.do

	global v Profitability
	do OB_Graph_DID-IPO.do

	* Create graph for decomposition of DID
	*global v nEmployees
	*do Graph_DiD-IPO_Decomposition.do

	* Create graph for Haltwinger measure of growth rate
	global n = 1

	global v SalesGrowth_h
	do OB_Graph_DID-IPO.do

	global v EmpGrowth_h
	do OB_Graph_DID-IPO.do

	global v ProfitGrowth_h
	do OB_Graph_DID-IPO.do
restore