*------------------------------------------------------------------
* This script loop over the DID graph of IPO for each variable of interest
*------------------------------------------------------------------

* Create DID graphs for each dependent variable
global v Revenue
do Graph_DID-IPO.do

global v RevenuePerEmployee
do Graph_DID-IPO.do

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