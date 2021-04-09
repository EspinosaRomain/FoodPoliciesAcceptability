clear all 
set more off

//SET WORKING DIRECTORY:
*******//HERE//*******

//Load data
use "Data/mergedData.dta"

//Generate treatment dummies
gen sugar=cond(treatment=="Sugar",1,0)
gen palmOil=cond(treatment=="PalmOil",1,0)
gen eggs=cond(treatment=="Eggs",1,0)

//Save data
save "Data/workingData.dta", replace

//Figure 2 - Graph for general acceptability
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
graph export "Graphs/figure1.eps", as(eps) preview(off) replace	


//Figure 3 - Graph for hypothetical votes
use "Data/workingData.dta", clear
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
graph export "Graphs/figure2.eps", as(eps) preview(off) replace	
	
//Tables 4 - Mean comparisons
use "Data/workingData.dta", clear
mat Table4=J(8,6,.)
mat rownames Table4=gen_legitimate gen_legitimate gen_externality gen_externality gen_injunctiveNorms gen_injunctiveNorms gen_descriptiveNorms gen_descriptiveNorms
mat colnames Table4=Sugar PalmOil Eggs SugarVSPalm SugarVSEggs EggsVSPalmOil
local k=1
foreach var in gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms{
	local j=`k'+1
	su `var' if sugar==1
	mat Table4[`k',1]=round(`r(mean)',0.001)
	mat Table4[`j',1]=round(`r(sd)',0.001)
	su `var' if palmOil==1
	mat Table4[`k',2]=round(`r(mean)',0.001)
	mat Table4[`j',2]=round(`r(sd)',0.001)
	su `var' if eggs==1
	mat Table4[`k',3]=round(`r(mean)',0.001)
	mat Table4[`j',3]=round(`r(sd)',0.001)
	ranksum `var' if sugar==1 | palmOil==1, by(sugar)
	mat Table4[`j',4]=round(2 * normprob(-abs(`r(z)')),0.001)
	ranksum `var' if sugar==1 | eggs==1, by(sugar)
	mat Table4[`j',5]=round(2 * normprob(-abs(`r(z)')),0.001)	
	ranksum `var' if eggs==1 | palmOil==1, by(eggs)
	mat Table4[`j',6]=round(2 * normprob(-abs(`r(z)')),0.001)
	esize twosample `var' if sugar==1 | palmOil==1, by(sugar) all
	mat Table4[`k',4]=round(abs(`r(d)'),0.001)
	esize twosample `var' if sugar==1 | eggs==1, by(sugar) all
	mat Table4[`k',5]=round(abs(`r(d)'),0.001)
	esize twosample `var' if eggs==1 | palmOil==1, by(eggs) all
	mat Table4[`k',6]=round(abs(`r(d)'),0.001)
	local k=`k'+2
}
mat list Table4

	
//Tables 5 - Mean comparisons
foreach var in effective appropriate coercive majority inequality{
	gen gen_`var'=(`var'_label+`var'_tax10+`var'_tax30+`var'_tax50+`var'_withdraw+`var'_infoCamp)/6
}
mat Table5=J(10,6,.)
mat rownames Table5=gen_effective gen_effective gen_appropriate gen_appropriate gen_coercive gen_coercive gen_majority gen_majority gen_inequality gen_inequality
mat colnames Table5=Sugar PalmOil Eggs SugarVSPalm SugarVSEggs EggsVSPalmOil
local k=1
foreach var in gen_effective gen_appropriate gen_coercive gen_majority gen_inequality{
	local j=`k'+1
	su `var' if sugar==1
	mat Table5[`k',1]=round(`r(mean)',0.001)
	mat Table5[`j',1]=round(`r(sd)',0.001)
	su `var' if palmOil==1
	mat Table5[`k',2]=round(`r(mean)',0.001)
	mat Table5[`j',2]=round(`r(sd)',0.001)
	su `var' if eggs==1
	mat Table5[`k',3]=round(`r(mean)',0.001)
	mat Table5[`j',3]=round(`r(sd)',0.001)
	
	ranksum `var' if sugar==1 | palmOil==1, by(sugar)
	mat Table5[`j',4]=round(2 * normprob(-abs(`r(z)')),0.001)
	ranksum `var' if sugar==1 | eggs==1, by(sugar)
	mat Table5[`j',5]=round(2 * normprob(-abs(`r(z)')),0.001)
	ranksum `var' if eggs==1 | palmOil==1, by(eggs)
	mat Table5[`j',6]=round(2 * normprob(-abs(`r(z)')),0.001)
	esize twosample `var' if sugar==1 | palmOil==1, by(sugar) all
	mat Table5[`k',4]=round(abs(`r(d)'),0.001)
	esize twosample `var' if sugar==1 | eggs==1, by(sugar) all
	mat Table5[`k',5]=round(abs(`r(d)'),0.001)
	esize twosample `var' if eggs==1 | palmOil==1, by(eggs) all
	mat Table5[`k',6]=round(abs(`r(d)'),0.001)
	local k=`k'+2
}
mat list Table5

//Table 3 - Table3

gen missingValue=0
foreach var in age female student job{
	replace missingValue=1 if `var'==.
}
drop if missingValue==1
tab treatment
mat Table3=J(8,7,.)
mat rownames Table3=age age female female student student job job
mat colnames Table3=All Sugar PalmOil Eggs SugarVSPalm SugarVSEggs EggsVSPalmOil
local k=1
foreach var in age{
	local j=`k'+1
	su `var'
	mat Table3[`k',1]=round(`r(mean)',0.01)
	mat Table3[`j',1]=round(`r(sd)',0.01)
	su `var' if sugar==1
	mat Table3[`k',2]=round(`r(mean)',0.001)
	mat Table3[`j',2]=round(`r(sd)',0.001)
	su `var' if palmOil==1
	mat Table3[`k',3]=round(`r(mean)',0.001)
	mat Table3[`j',3]=round(`r(sd)',0.001)
	su `var' if eggs==1
	mat Table3[`k',4]=round(`r(mean)',0.001)
	mat Table3[`j',4]=round(`r(sd)',0.001)
	
	ttest `var' if sugar==1 | palmOil==1, by(sugar)
	mat Table3[`j',5]=round(`r(p)',0.001)
	ttest `var' if sugar==1 | eggs==1, by(sugar)
	mat Table3[`j',6]=round(`r(p)',0.001)
	ttest `var' if eggs==1 | palmOil==1, by(eggs)
	mat Table3[`j',7]=round(`r(p)',0.001)
	
	esize twosample `var' if sugar==1 | palmOil==1, by(sugar) all
	mat Table3[`k',5]=round(abs(`r(d)'),0.001)
	esize twosample `var' if sugar==1 | eggs==1, by(sugar) all
	mat Table3[`k',6]=round(abs(`r(d)'),0.001)
	esize twosample `var' if eggs==1 | palmOil==1, by(eggs) all
	mat Table3[`k',7]=round(abs(`r(d)'),0.001)
	
	local k=`k'+2
}
foreach var in female student job{
	local j=`k'+1
	su `var'
	mat Table3[`k',1]=round(`r(mean)',0.01)
	mat Table3[`j',1]=round(`r(sd)',0.01)
	su `var' if sugar==1
	mat Table3[`k',2]=round(`r(mean)',0.001)
	mat Table3[`j',2]=round(`r(sd)',0.001)
	su `var' if palmOil==1
	mat Table3[`k',3]=round(`r(mean)',0.001)
	mat Table3[`j',3]=round(`r(sd)',0.001)
	su `var' if eggs==1
	mat Table3[`k',4]=round(`r(mean)',0.001)
	mat Table3[`j',4]=round(`r(sd)',0.001)
	
	prtest `var' if sugar==1 | palmOil==1, by(sugar)
	local p = 2*(normprob(-abs(`r(z)')))
	mat Table3[`j',5]=round(`p',0.001)
	prtest `var' if sugar==1 | eggs==1, by(sugar)
	local p = 2*(normprob(-abs(`r(z)')))
	mat Table3[`j',6]=round(`p',0.001)
	prtest `var' if eggs==1 | palmOil==1, by(eggs)
	local p = 2*(normprob(-abs(`r(z)')))
	mat Table3[`j',7]=round(`p',0.001)
	
	esize twosample `var' if sugar==1 | palmOil==1, by(sugar) all
	mat Table3[`k',5]=round(abs(`r(d)'),0.001)
	esize twosample `var' if sugar==1 | eggs==1, by(sugar) all
	mat Table3[`k',6]=round(abs(`r(d)'),0.001)
	esize twosample `var' if eggs==1 | palmOil==1, by(eggs) all
	mat Table3[`k',7]=round(abs(`r(d)'),0.001)
	
	local k=`k'+2
}	
mat list Table3
	
tab bodymassindex treat, chi2 col missing
tab bodymassindex, missing
	
