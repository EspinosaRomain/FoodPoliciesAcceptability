clear all 
set more off

//SET WORKING DIRECTORY:
*******//HERE//*******

//Load data
use "Data/dataConfirmatoryAnalysis_anonymized.dta", clear

//Destring variables
foreach var in gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms{
	replace `var'="1" if `var'=="1 - Completely disagree"
	replace `var'="4" if `var'=="4 - Indifferent"
	replace `var'="5" if `var'=="7 - Completely agree"
	destring `var', replace
}

//Generate treatment dummies
gen sugar=cond(treatment=="Sugar",1,0)
gen palmOil=cond(treatment=="PalmOil",1,0)
gen eggs=cond(treatment=="Eggs",1,0)

save "Data/workingConfirmatoryData.dta", replace


//Figure A1
mat dataGraph=J(18,3,.)
mat colnames dataGraph=Moyenne LowerBound UpperBound
local k=1
foreach var in sugar palm eggs{
	foreach var2 in label tax10 tax30 tax50 withdraw infoCamp{
		qui ci means acceptableMe_`var2' if `var'==1
		mat dataGraph[`k',1]=`r(mean)'
		mat dataGraph[`k',2]=`r(lb)'
		mat dataGraph[`k',3]=`r(ub)'
		local k=`k'+1
	}
}
mat list dataGraph
clear
svmat dataGraph
ren dataGraph1 Moyenne 
ren dataGraph2 LowerBound 
ren dataGraph3 UpperBound 
gen id=_n
gen topic="eggs"
replace topic="palm" if id<=12
replace topic="sugar" if id<=6
gen measure="label"
replace measure="tax10" if id==2 | id==8 | id==14
replace measure="tax30" if id==3 | id==9 | id==15
replace measure="tax50" if id==4 | id==10 | id==16
replace measure="withdraw" if id==5 | id==11 | id==17
replace measure="infoCamp" if id==6 | id==12 | id==18

gen orderID=1 if measure=="label"
replace orderID=5 if measure=="tax10"
replace orderID=9 if measure=="tax30"
replace orderID=13 if measure=="tax50"
replace orderID=17 if measure=="withdraw"
replace orderID=-3 if measure=="infoCamp"
replace orderID=orderID+1 if topic=="palm"
replace orderID=orderID+2 if topic=="eggs"
replace orderID=orderID+4

twoway (bar Moyenne orderID if topic=="sugar", fcolor("57 106 177") barwidth(0.9))/*
	*/ (bar Moyenne orderID if topic=="palm", fcolor("62 150 81") barwidth(0.9))/*
	*/ (bar Moyenne orderID if topic=="eggs", fcolor("218 124 48") barwidth(0.9))/*
	*/(rcap LowerBound UpperBound orderID, lcolor(gs3))/*
	*/, legend(row(1) order(1 "Sugar" 2 "Palm Oil" 3 "Cage Eggs") region(col(white)))/*
	*/xlabel(2 `" "Information" "campaign" "' 6 "Label" 10 "Tax10" 14 "Tax30" 18 "Tax50" 22 "Withdrawal" , noticks)/*
     */xtitle("Policies") ytitle("Policy acceptability", height(6)) graphregion(color(white)) bgcolor(white)  ylab(1(1)7)
graph export "Graphs/figureA1.eps", as(eps) preview(off) replace	


//Graph for general acceptability
use "Data/workingConfirmatoryData.dta", clear
mat dataGraph=J(18,3,.)
mat colnames dataGraph=Moyenne LowerBound UpperBound
local k=1
foreach var in sugar palm eggs{
	foreach var2 in label tax10 tax30 tax50 withdraw infoCamp{
		qui ci prop vote_`var2' if `var'==1
		mat dataGraph[`k',1]=`r(mean)'
		mat dataGraph[`k',2]=`r(lb)'
		mat dataGraph[`k',3]=`r(ub)'
		local k=`k'+1
	}
}
mat list dataGraph
clear
svmat dataGraph
ren dataGraph1 Moyenne 
ren dataGraph2 LowerBound 
ren dataGraph3 UpperBound 
gen id=_n
gen topic="eggs"
replace topic="palm" if id<=12
replace topic="sugar" if id<=6
gen measure="label"
replace measure="tax10" if id==2 | id==8 | id==14
replace measure="tax30" if id==3 | id==9 | id==15
replace measure="tax50" if id==4 | id==10 | id==16
replace measure="withdraw" if id==5 | id==11 | id==17
replace measure="infoCamp" if id==6 | id==12 | id==18

gen orderID=1 if measure=="label"
replace orderID=5 if measure=="tax10"
replace orderID=9 if measure=="tax30"
replace orderID=13 if measure=="tax50"
replace orderID=17 if measure=="withdraw"
replace orderID=-3 if measure=="infoCamp"
replace orderID=orderID+1 if topic=="palm"
replace orderID=orderID+2 if topic=="eggs"
replace orderID=orderID+4

twoway (bar Moyenne orderID if topic=="sugar", fcolor("57 106 177") barwidth(0.9))/*
	*/ (bar Moyenne orderID if topic=="palm", fcolor("62 150 81") barwidth(0.9))/*
	*/ (bar Moyenne orderID if topic=="eggs", fcolor("218 124 48") barwidth(0.9))/*
	*/(rcap LowerBound UpperBound orderID, lcolor(gs3))/*
	*/, legend(row(1) order(1 "Sugar" 2 "Palm Oil" 3 "Cage Eggs") region(col(white)))/*
	*/xlabel(2 `" "Information" "campaign" "' 6 "Label" 10 "Tax10" 14 "Tax30" 18 "Tax50" 22 "Withdrawal" , noticks)/*
     */xtitle("Policies") ytitle("Hypothetical Vote", height(6)) graphregion(color(white)) bgcolor(white)  ylab(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%", angle(0))
graph export "Graphs/figureA2.eps", as(eps) preview(off) replace	

