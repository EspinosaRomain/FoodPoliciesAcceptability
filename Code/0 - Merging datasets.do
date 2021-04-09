clear all 
set more off

//SET WORKING DIRECTORY:
*******//HERE//*******

//Append data into a single dataset
use "Data/dataBaselineSugar_anonymized.dta"
gen treatment="Sugar"

append using "Data/dataBaselinePalmOil_anonymized.dta"
replace treatment="PalmOil" if treatment==""

append using "Data/dataBaselineEggs_anonymized.dta"
replace treatment="Eggs" if treatment==""

//Replace BMI
replace bodymassindex="Missing" if bodymassindex=="CONSENT REVOKED" | bodymassindex=="N/A" | bodymassindex==""

// Save data
save "Data/mergedData.dta", replace
