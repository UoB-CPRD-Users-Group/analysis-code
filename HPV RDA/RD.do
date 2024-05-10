
global maindata "analysis_YSprimary"
use  $maindata ,clear

*unadj

logistic s1fu12 i.exp if ch_s1==1
adjrr exp

logistic s2fu12 i.exp if ch_s2==1
adjrr exp

logistic s4fu12 i.exp if ch_s4==1
adjrr exp

*adj

logistic s1fu12 i.exp  encoun  i.yob if ch_s1==1
adjrr exp

logistic s2fu12 i.exp   encoun  i.yob if ch_s2==1
adjrr exp

logistic s4fu12 i.exp   encoun  i.yob if ch_s4==1
adjrr exp


**********************************************************************************

global maindata "analysis_YSprimary"

*foreach s of numlist 6 12 {
foreach k of numlist 1 2 4 5{
local j "s`k'fu12"
di "`j'"

forval i= 0/5{
*local j s1fu12
di "`j'"
di `i'
use  $maindata ,clear
drop if ch_s`k'==0
*logistic `j' i.exp if yob==200`i' /*unadjusted*/
*logistic s2fu12 i.exp 
logistic `j' i.exp encoun if yob==200`i' /*adjusted*/
*logistic `j' i.exp conscount if yob==200`i' /*adjusted for no hes*/
adjrr exp



display r(N)
display r(R0)               /*baseline risk*/
display r(R0_se)            /*baseline risk standard error*/
display r(R1)               /*exposed risk*/
display r(R1_se)            /*exposed risk standard error*/
display r(ARR)              /*ARR*/
display r(ARR_se)           /*ARR standard error*/
display r(ARD)              /*ARD*/
display r(ARD_se)           /*ARD standard error*/
display r(pvalue)           /*p-value for linear test R0 = R1*/
display  r(ARD)-1.959964* r(ARD_se)
display  r(ARD)+1.959964* r(ARD_se)

*odds ratio
display exp(_b[1.exp])
*ci at odds ratio scale
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])
*standard error at odds ration scale (delta method)
display exp(_b[1.exp])*_se[1.exp]
display  _b[1.exp]-1.959964*_se[1.exp]
display  _b[1.exp]+1.959964*_se[1.exp]


*capture drop counter
gen counter=1

gen RD=r(ARD) 
gen RDlo=r(ARD)-1.959964* r(ARD_se)
gen RDup=r(ARD)+1.959964* r(ARD_se)
gen RDp=r(pvalue) 


collapse (sum) counter, by (exp yob `j' RD RDlo RDup RDp)

reshape wide counter, i(yob exp) j(`j')
reshape wide counter0 counter1, i(yob) j(exp)
rename counter00 c0_unexp
rename counter01 c0_exp
rename counter10 c1_unexp
rename counter11 c1_exp

gen exp=c1_exp+c0_exp
gen unexp=c1_unexp+c0_unexp

keep if yob==200`i'

gen orval= exp(_b[1.exp])
gen orse=exp(_b[1.exp])*_se[1.exp]
gen ci95lo=exp(_b[1.exp]-1.959964*_se[1.exp])
gen ci95up=exp(_b[1.exp]+1.959964*_se[1.exp])

gen logor=_b[1.exp]
gen selogor=_se[1.exp]
gen ci95lologor=_b[1.exp]-1.959964*_se[1.exp]
gen ci95uplogor=_b[1.exp]+1.959964*_se[1.exp]

save logisticrd_YSprimary_200`i'`j'.dta, replace
}

*local j s1fu12
use logisticrd_YSprimary_2000`j', clear
forval i= 1/5{
append using logisticrd_YSprimary_200`i'`j'
}


*save logistic_Yprimary_`j', replace



metaeff effsize1 se1, ni(exp) nc(unexp) orval(orval) ci95lo(ci95lo)  ci95up(ci95up)
metaan effsize1 se1, dl label (yob) 

di r(eff)
di r(efflo)
di r(effup)
di r(Qpval)

gen effES = r(eff)
gen effloES = r(efflo)
gen effupES = r(effup)
gen effQpvalES = r(Qpval)

*metan logor selogor, randomi second(fixedi) eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
*force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=yob)

metan RD RDlo RDup, randomi second(fixedi)   ///
dp(4) effect(risk difference) label(namevar=yob)

metan c1_exp c0_exp c1_unexp c0_unexp, rd  dp(5) effect(risk difference) label(namevar=yob)


di r(ES)
di r(ES_2)
di r(selogES)
di r(ci_low)
di r(ci_upp)
di r(p_z)

gen ES=r(ES)
gen ES2=r(ES_2)
gen selogES = r(selogES)
gen ci_lowES=r(ci_low)
gen ci_uppES=r(ci_upp)
gen p_zES=r(p_z)

capture drop outc
gen outc="`j'"

save logisticrd_YSprimary_`j', replace
}




use logisticrd_YSprimary_s1fu12
append using logisticrd_YSprimary_s2fu12
append using logisticrd_YSprimary_s4fu12
append using logisticrd_YSprimary_s5fu12
save logisticrd_YSprimary_meta_unadj, replace

use logisticrd_YSprimary_s1fu12
append using logisticrd_YSprimary_s2fu12
append using logisticrd_YSprimary_s4fu12
append using logisticrd_YSprimary_s5fu12
save logisticrd_YSprimary_meta_adj, replace


use logisticrd_Yprimary_s1fu12
append using logisticrd_Yprimary_s2fu12
append using logisticrd_Yprimary_s4fu12
save logisticrd_Yprimary_meta_adj, replace

use logisticrd_Yprimary_s1fu12
append using logisticrd_Yprimary_s2fu12
append using logisticrd_Yprimary_s4fu12
save logisticrd_Yprimary_meta_unadj, replace


use logisticrd_YSprimary_meta_adj, clear
gen g1="adj"
append using logisticrd_YSprimary_meta_unadj
replace  g1="unadj" if g1==""
gen g2="YS"

append using logisticrd_Yprimary_meta_adj
replace  g1="adj" if g1==""
replace g2="Y" if g2==""
append using logisticrd_Yprimary_meta_unadj
replace  g1="unadj" if g1==""
replace g2="Y" if g2==""


keep effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc g1 g2 exp unexp c1_exp c1_unexp c0_exp c0_unexp 
collapse (sum) exp (sum) unexp (sum) c1_exp (sum) c1_unexp (sum) c0_exp (sum) c0_unexp, by (effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc g1 g2)

*sort outc g2 g1
*sort outc g1 g2
sort g2 g1 outc  
gen total=exp+unexp
*save logisticrd_primary_meta, replace
save logisticrd_primary_meta_new, replace

use logisticrd_primary_meta_new, clear

