


preserve


/*

- Look into leverage ratios, capital-output ratios in this data
   - What does it look like?
   - Many missing observations?
   - Many zeros?
   - What does this look like Public vs. Private

*/

keep Assets EBITDA EverPublic GrossProfits IDNum Market_capitalisation_mil No_of_recorded_shareholders Private Stock nShareholders Revenue


gen Assets_EBITDA = Assets/EBITDA
gen Assets_Revenue = Assets/Revenue
gen Assets_Profits = Assets/GrossProfits
gen MktCap_Assets = Market_capitalisation_mil/Assets















