clear all 
set more off

//SET WORKING DIRECTORY:
*******//HERE//*******

//Load data
use "Data/workingData.dta", clear

//Prepare data
gen id=_n
keep id effective_* appropriate_* coercive_* acceptableMe_* majority_* inequality_* vote_* gen_* treatment sugar palm eggs student female job age bodymassindex
reshape long effective_ appropriate_ coercive_ acceptableMe_ majority_ inequality_ vote_, i(id) j(measure) string

encode measure, gen(measure_num) 
encode treatment, gen(treatment_num)
encode bodymassindex, gen(bmi)


//Table 6 - Regression of acceptability scores
mixed acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi ib4.measure_num i.treatment_num || id:, mle
outreg2  using "Tables/table6",  tex stats(coef se)  replace

mixed acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if sugar==1, mle
outreg2  using "Tables/table6",  tex stats(coef se)  append

mixed acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if palm==1, mle
outreg2  using "Tables/table6",  tex stats(coef se)  append

mixed acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if eggs==1, mle
outreg2  using "Tables/table6",  tex stats(coef se)  append

//Table 7 - Regression of votes
mixed vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num i.treatment_num  || id:, mle
outreg2  using "Tables/table7",  tex stats(coef se)  replace

mixed vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if sugar==1, mle
outreg2  using "Tables/table7",  tex stats(coef se)  append

mixed vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if palm==1, mle
outreg2  using "Tables/table7",  tex stats(coef se)  append

mixed vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num || id: if eggs==1, mle
outreg2  using "Tables/table7",  tex stats(coef se)  append


//Table A3 - Robustness check
mixed acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi ib4.measure_num i.treatment_num || id:, mle
outreg2  using "Tables/tableA3",  tex stats(coef se)  replace

meoprobit acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi ib4.measure_num i.treatment_num || id:
outreg2  using "Tables/tableA3",  tex stats(coef se)  append

mixed vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num i.treatment_num  || id:, mle
outreg2  using "Tables/tableA3",  tex stats(coef se)  append

meprobit vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.measure_num i.treatment_num  || id:
outreg2  using "Tables/tableA3",  tex stats(coef se)  append


//Table A4 - Acceptability by policy
reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num if measure=="label"
outreg2  using "Tables/tableA4",  tex stats(coef se)  replace

reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num if measure=="infoCamp"
outreg2  using "Tables/tableA4",  tex stats(coef se)  append

reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num  if measure=="tax10"
outreg2  using "Tables/tableA4",  tex stats(coef se)  append

reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi  i.treatment_num  if measure=="tax30"
outreg2  using "Tables/tableA4",  tex stats(coef se)  append

reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi  i.treatment_num  if measure=="tax50"
outreg2  using "Tables/tableA4",  tex stats(coef se)  append

reg acceptableMe_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi  i.treatment_num  if measure=="withdraw"
outreg2  using "Tables/tableA4",  tex stats(coef se)  append


//Table A5 - Acceptability by policy
reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num if measure=="label"
outreg2  using "Tables/tableA5",  tex stats(coef se)  replace

reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num if measure=="infoCamp"
outreg2  using "Tables/tableA5",  tex stats(coef se)  append

reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num  if measure=="tax10"
outreg2  using "Tables/tableA5",  tex stats(coef se)  append

reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi  i.treatment_num  if measure=="tax30"
outreg2  using "Tables/tableA5",  tex stats(coef se)  append

reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi  i.treatment_num  if measure=="tax50"
outreg2  using "Tables/tableA5",  tex stats(coef se)  append

reg vote_ gen_legitimate gen_externality gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_ coercive_ majority_ inequality_ student female job age i.bmi i.treatment_num  if measure=="withdraw"
outreg2  using "Tables/tableA5",  tex stats(coef se)  append


//Figure 4 - Interaction effect
gen interaction=coercive_*gen_externality
mixed acceptableMe_ gen_legitimate gen_externality coercive_ interaction gen_injunctiveNorms gen_descriptiveNorms effective_ appropriate_  majority_ inequality_ student female job age  i.bmi i.measure_num i.treatment_num || id:, mle

//Compute the conditional effects
nlcom (_b[coercive]+_b[interaction]*1)/*
	*/(_b[coercive]+_b[interaction]*2)/*
	*/(_b[coercive]+_b[interaction]*3)/*
	*/(_b[coercive]+_b[interaction]*4)/*
	*/(_b[coercive]+_b[interaction]*5)/*
	*/(_b[coercive]+_b[interaction]*6)/*
	*/ (_b[coercive]+_b[interaction]*7)/*
	*/(_b[gen_externality]+_b[interaction]*1)/*
	*/(_b[gen_externality]+_b[interaction]*2)/*
	*/(_b[gen_externality]+_b[interaction]*3)/*
	*/(_b[gen_externality]+_b[interaction]*4)/*
	*/(_b[gen_externality]+_b[interaction]*5)/*
	*/(_b[gen_externality]+_b[interaction]*6)/*
	*/ (_b[gen_externality]+_b[interaction]*7) 

mat b=r(b)
mat V=r(V)

//Prepare matrix to plot the estimated effects
mat estimatedEffects=J(14,3,.)
forvalues k=1(1)14{
	mat estimatedEffects[`k',1]=b[1,`k']
	mat estimatedEffects[`k',2]=b[1,`k']-1.96*sqrt(V[`k',`k'])
	mat estimatedEffects[`k',3]=b[1,`k']+1.96*sqrt(V[`k',`k'])
}
mat list estimatedEffects

//Matrix into data
clear
svmat estimatedEffects

gen id=_n
ren estimatedEffects1 coef
ren estimatedEffects2 lb
ren estimatedEffects3 ub
gen effectVariable="Coerciveness"
replace effectVariable="Awareness" if id>7
sort effectVariable id
bys effectVariable: gen interactionValue=_n
sort id


twoway  (rcap ub lb interactionValue, lcolor(navy)) (scatter coef interactionValue, color(navy))  if effectVariable=="Awareness",/*
	*/ xtitle("Coerciveness score") title("Conditional effect of Awareness") /*
	*/ graphregion(color(white)) bgcolor(white) /*
	*/ xlabel(1 2 3 4 5 6 7) /*
	*/ xscale(range(0.7 7.3)) /*
	*/  ylab(-0.3 "-0.3" -0.2 "-0.2" -0.1 "-0.1" 0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3", angle(0)) /*
	*/yscale(range(-0.35 0.35)) /*
	*/ legend(off) /*
	*/ yline(0, lcol(black))
	
	
graph export "Graphs/figure4.eps", as(eps) preview(off) replace	

