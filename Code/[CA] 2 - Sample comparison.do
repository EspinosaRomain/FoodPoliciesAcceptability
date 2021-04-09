clear all 
set more off

//SET WORKING DIRECTORY:
*******//HERE//*******

//Load data
use "Data/workingConfirmatoryData.dta", clear

//Merge the two datasets
gen wave="Confirmatory Analysis"
append using "Data/workingData.dta", force
replace wave="First study"  if wave==""
gen firstStudy=cond(wave=="First study",1,0,.)

//Drop missing values
gen missingValue=0
foreach var in age female student job{
	replace missingValue=1 if `var'==.
}
drop if missingValue==1

//Table A6
mat TableA6=J(8,3,.)
mat rownames TableA6=age age female female student student job job
mat colnames TableA6=First CA Comparison
local k=1
foreach var in age{
	local j=`k'+1
	su `var' if firstStudy==1
	mat TableA6[`k',1]=round(`r(mean)',0.01)
	mat TableA6[`j',1]=round(`r(sd)',0.01)
	su `var' if firstStudy==0
	mat TableA6[`k',2]=round(`r(mean)',0.01)
	mat TableA6[`j',2]=round(`r(sd)',0.01)
	
	ttest `var', by(firstStudy)
	mat TableA6[`j',3]=round(`r(p)',0.001)
	
	esize twosample `var', by(firstStudy) all
	mat TableA6[`k',3]=round(abs(`r(d)'),0.001)
	
	local k=`k'+2
}
foreach var in female student job{
	local j=`k'+1
	su `var' if firstStudy==1
	mat TableA6[`k',1]=round(`r(mean)',0.01)
	mat TableA6[`j',1]=round(`r(sd)',0.01)
	su `var' if firstStudy==0
	mat TableA6[`k',2]=round(`r(mean)',0.01)
	mat TableA6[`j',2]=round(`r(sd)',0.01)

	prtest `var', by(firstStudy)
	local p = 2*(normprob(-abs(`r(z)')))
	mat TableA6[`j',3]=round(`p',0.001)
	
	esize twosample `var', by(firstStudy) all
	mat TableA6[`k',3]=round(abs(`r(d)'),0.001)
	
	local k=`k'+2
}	
mat list TableA6

tab bodymassindex firstStudy, chi2 col missing
