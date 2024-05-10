* primary YS - 6 and 12
* primary Y  - 6 and 12

* primary YS - 6 and 12  - pat with hes linkage only
* primary YS - 6 and 12  - pat born in 2000-2001 only (3 doses)
* primary YS - 6 and 12  - no hes outcomes 

*sens1 YS - 6 and 12
*sens1 Y  - 6 and 12

*sens2 YS - 6 and 12
*sens2 Y  - 6 and 12


*don*t forget metan by year

********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

********************************************************************************
********************************************************************************
********************************************************************************

/*
*fractures
use analysis_YSprimary, clear
logistic s5fu12 i.exp if ch_s5==1
logistic s5fu12 i.exp i.yob encoun if ch_s5==1

logistic s5fu12 i.exp if ch_s5==1
adjrr exp

logistic s5fu12 i.exp i.yob encoun if ch_s5==1
adjrr exp
*/


tab exp s2fu12
262 0 
217 1

logistic s2fu12 i.exp if ch_s2==1
 .9668864    .066338    -0.49   0.624     .8452294    1.106054
  .831817   .0771944    -1.98   0.047     .6934808    .9977485
 glm s2fu12 i.exp, fam(bin) nolog eform
 .9668864    .066338    -0.49   0.624     .8452294    1.106054
 glm s2fu12 i.exp, fam(bin) link(log) nolog eform
 .9682071   .0637364    -0.49   0.624     .8510093    1.101545
 .835171   .0758216    -1.98   0.047     .6990343    .9978204
 glm s2fu12 i.exp, fam(poisson) link(log) nolog vce(robust) eform
 .9682071   .0637378    -0.49   0.624     .8510068    1.101548
 .835171   .0758233    -1.98   0.047     .6990315    .9978244
 glm s2fu12 i.exp, fam(poisson) link(log) nolog eform
 .9682071   .0650685    -0.48   0.631     .8487174     1.10452
 .835171   .0766589    -1.96   0.050     .6976621     .999783
 stset s2fu12_tte, failure(s2fu12)
stcox i.exp 
.9668349   .0649763    -0.50   0.616     .8475146    1.102954
 .8339413    .076546    -1.98   0.048     .6966347    .9983109
 

 
 logistic s1fu12 i.exp i.yob encoun
.9684492   .0667645    -0.47   0.642     .8460487    1.108558
 glm s1fu12 i.exp i.yob encoun, fam(bin) nolog eform
.9684492   .0667645    -0.47   0.642     .8460487    1.108558
 glm s1fu12 i.exp encoun i.yob, fam(bin) link(log) nolog eform
.9667694   .0628677    -0.52   0.603       .85108    1.098185
 glm s1fu12 i.exp i.yob encoun, fam(poisson) link(log) nolog vce(robust) eform
.9700995   .0637933    -0.46   0.644     .8527891    1.103547
.968513    .0637299    -0.49   0.627     .8513239    1.101834
 glm s1fu12 i.exp i.yob encoun, fam(poisson) link(log) nolog eform
 .9682071   .0650685    -0.48   0.631     .8487174     1.10452
 .9700995    .065211    -0.45   0.652       .85035    1.106713
stset s1fu12_tte, failure(s1fu12)
stcox i.exp encoun, strata(yob) /*adjusted*/
.9673909   .0650261    -0.49   0.622     .8479807    1.103616
stcox i.exp encoun i.yob /*adjusted*/
.9672933   .0650195    -0.49   0.621     .8478951    1.103505



use  analysis_YSprimary.dta ,clear
use  analysis_Yprimary.dta ,clear

use  analysis_YSprimary_link.dta ,clear
use analysis_Yprimary_link.dta, clear

use  analysis_YSprimary_3d.dta ,clear
use analysis_Yprimary_3d.dta, clear

use analysis_nohesYSprimary.dta, clear
use analysis_nohesYprimary.dta, clear

use  analysis_YSsens1.dta ,clear
use  analysis_Ysens1.dta ,clear

use  analysis_YSsens2.dta ,clear
use  analysis_Ysens2.dta ,clear

tab mob s1fu12

*check covariates - categorical

*english patients
	count 
	bysort exp: count
	
*dates ce fu	
	bys exp: tab ce_date fu6_date
	bys exp: tab ce_date fu12_date
	
	
*region
	tab region 
	bysort exp: tab region
	tabulate region exp, row nofreq chi2
	tabulate region exp, all exact
	logistic exp i.region
	
	
*yob - dont include in sensitivity
	tab yob
	bysort exp: tab yob
	tabulate yob exp, row nofreq chi2
	tabulate yob exp, all exact
	logit exp i.yob 
	
	
*mob - not include in primary
	tab mob 
	tab mob exp
	bysort exp: tab mob
	tabulate mob exp, row nofreq chi2
	tabulate mob exp, nolabel all exact
	logit exp i.mob
	
	
*imd - has missing
	tab imd2015_5, missing
	tab imd2015_5 exp, missing
	bysort exp: tab imd2015_5, missing
	tabulate imd2015_5 exp, row nofreq chi2 missing
	tabulate imd2015_5 exp, all exact 
	logistic exp i.imd2015_5
	
	
*hes - has missing
	tab hes_e, missing
	bysort exp: tab hes_e, missing
	tabulate hes_e exp, row nofreq chi2 missing
	tabulate hes_e exp, all exact missing
	logistic exp i.hes_e
	
	
*lsoa_e - has missing
	tab lsoa_e, missing
	bysort exp: tab lsoa_e, missing
	tabulate lsoa_e exp, row nofreq chi2 missing
	tabulate lsoa_e exp, all exact missing
	
	
*immun - has missing
	tab stagemax_imm, missing
	bysort exp: tab stagemax_imm, missing
	tabulate stagemax_imm exp, row nofreq chi2 
	tabulate stagemax_imm exp, all exact 
	tabulate stagemax_imm exp if event_date_imm_firstdate > ce_date & event_date_imm_firstdate<fu12_date, all exact 
		tabulate event_count_imm_stage1 exp if event_date_imm_stage1 > ce_date & event_date_imm_stage1<fu12_date, all exact 
		tabulate event_count_imm_stage2 exp if event_date_imm_stage2 > ce_date & event_date_imm_stage2<fu12_date, all exact 
		tabulate event_count_imm_stage3 exp if event_date_imm_stage3 > ce_date & event_date_imm_stage3<fu12_date, all exact 
	logit exp i.stagemax_imm
	logit, or
	logistic exp i.stagemax_imm


*ethnicity	

	tab ethnicity, missing
	tab ethnicity exp, missing
	bysort exp: tab ethnicity, missing
	tabulate ethnicity exp, row nofreq chi2 
	tabulate ethnicity exp, all exact
	logistic exp i.ethnicity
	
	
*contraindications
	
	tab contra, missing
	bysort exp: tab contra , missing
	tab contra stagemax_imm, missing
	tabulate contra exp, row nofreq chi2 missing
	tabulate contra exp, all exact missing
	
	replace contra=0 if contra==.
	logistic exp contra
		
********************************************************************************
********************************************************************************
********************************************************************************
*check covariates - continuous 
	
	bysort exp: count if bmi!=.
	ttest bmi, by(exp) 
	ranksum bmi, by(exp)
	hist bmi
	ttest bmi_diff_ce_event, by(exp) 
	logistic exp bmi
	
	bysort exp: count if  weight!=.
	ttest weight, by(exp) 
	ranksum weight, by(exp)
	hist weight
	ttest weight_diff_ce_event, by(exp) 
	logistic exp weight
	
	bysort exp: count if height!=.
	ttest height, by(exp) 
	ranksum height, by(exp)
	hist height
	ttest height_diff_ce_event, by(exp) 
	
	bysort exp: count if BPdiastolic!=.
	ttest BPdiastolic, by(exp) 
	*ranksum BPdiastolic, by(exp)
	*hist BPdiastolic
	bysort exp: count if BPsystolic!=.
	ttest BPsystolic, by(exp)
	*ranksum BPsystolic, by(exp)
	*hist BPsystolic
	ttest BP_diff_ce_event, by(exp) 
	
	bysort exp: count if pulse!=.
	ttest pulse , by(exp) 
	*ranksum pulse, by(exp)
	*hist pulse
	ttest pulse_diff_ce_event, by(exp)
	
	
	bysort exp: count if hospcount_beforece!=.
	ttest hospcount_beforece, by(exp)
	ranksum hospcount_beforece, by(exp)
	*hist hospcount_beforece 
	*poisson hospcount_beforece i.exp
	*poisson hospcount_beforece i.exp, irr
	
	bysort exp: count if conscount_beforece!=.
	ttest conscount_beforece, by(exp) 
	ranksum conscount_beforece, by(exp)
	*hist conscount_beforece
	*poisson conscount_beforece i.exp
	*poisson conscount_beforece i.exp, irr
	
	bysort exp: count if encounters!=.
	*ttest conscount_beforece, by(exp) 
	ranksum encounters, by(exp)

	
********************************************************************************
********************************************************************************
********************************************************************************
*check outcomes

	bys d1_outcome_type: tab  exp  
	bys d2_outcome_type: tab d2fu12 exp 
	bys d3_outcome_type: tab d3fu12 exp  
	
	*1-crps
	tab d1_outcome_type exp
	tab d1fu12 exp
	tab d1fu6 exp
	tab d1_outcome_type exp if d1_event_date <ce_date 
	*7 to exclude
	tab d1_outcome_type exp if d1_event_date >= ce_date & d1_event_date <= fu12_date
	tab d1_outcome_type exp if d1_event_date >= ce_date & d1_event_date <= fu6_date
	
	*2-ftg
	tab d2_outcome_type exp
	tab d2fu12 exp
	tab d2fu6 exp
	tab d2_outcome_type exp if d2_event_date <ce_date 
	*10 to exclude
	tab d2_outcome_type exp if d2_event_date >= ce_date & d2_event_date <= fu12_date
	tab d2_outcome_type exp if d2_event_date >= ce_date & d2_event_date <= fu6_date
	
	*3-pots
	tab d3_outcome_type exp
	tab d3fu12 exp
	tab d3fu6 exp
	tab d3_outcome_type exp if d3_event_date <ce_date 
	*3 to exclude
	tab d3_outcome_type exp if d3_event_date >= ce_date & d3_event_date <= fu12_date
	tab d3_outcome_type exp if d3_event_date >= ce_date & d3_event_date <= fu6_date
	

	
***********************************************
	*1-gastro
	
	tab s1fu6_outcome_type exp if ch_s1==1, missing
	tab s1fu6 exp if ch_s1==1, missing
	tabulate s1fu6 exp, all exact 
	tab s1fu6_count exp
	hist s1fu6_count, freq
	hist s1fu6_count if s1fu6==1, freq
	*tab s1fu6_event_date
	bys exp: sum s1fu6_tte
	tab exp,  sum(s1fu6_tte)
	
	tab s1fu12_outcome_type exp if ch_s1==1, missing
	tab s1fu12 exp if ch_s1==1, missing
	tabulate s1fu12 exp, all exact 
	tab s1fu12_count exp
	hist s1fu12_count, freq
	hist s1fu12_count if s1fu12==1, freq
	*tab s1fu12_event_date
	bys exp: sum s1fu12_tte
	tab exp,  sum(s1fu12_tte)

***********************************************
	*2-headache
	
	tab s2fu6_outcome_type exp if ch_s2==1, missing
	tab s2fu6 exp if ch_s2==1, missing
	tab s2fu6_count exp
	hist s2fu6_count, freq
	hist s2fu6_count if s2fu6==1, freq
	*tab s1fu6_event_date
	bys exp: sum s2fu6_tte
	tab exp,  sum(s2fu6_tte)
	
	tab s2fu12_outcome_type exp if ch_s2==1, missing
	tab s2fu12 exp if ch_s2==1, missing
	tab s2fu12_count exp
	hist s2fu12_count, freq
	hist s2fu12_count if s2fu12==1, freq
	*tab s1fu12_event_date
	bys exp: sum s2fu12_tte
	tab exp,  sum(s2fu12_tte)
	
***********************************************
	*3-muscular
	
	tab s3fu6_outcome_type exp if ch_s3==1, missing
	tab s3fu6 exp if ch_s3==1, missing
	tab s3fu6_count exp
	hist s3fu6_count, freq
	hist s3fu6_count if s3fu6==1, freq
	*tab s1fu6_event_date
	bys exp: sum s3fu6_tte
	tab exp,  sum(s3fu6_tte)
	
	tab s3fu12_outcome_type exp if ch_s3==1, missing
	tab s3fu12 exp if ch_s3==1, missing
	tab s3fu12_count exp
	hist s3fu12_count, freq
	hist s3fu12_count if s3fu12==1, freq
	*tab s1fu12_event_date
	bys exp: sum s3fu12_tte
	tab exp,  sum(s3fu12_tte)
	
***********************************************
	*4-pain
	
	tab s4fu6_outcome_type exp if ch_s4==1, missing
	tab s4fu6 exp if ch_s4==1, missing
	tab s4fu6_count exp
	hist s4fu6_count, freq
	hist s4fu6_count if s4fu6==1, freq
	*tab s1fu6_event_date
	bys exp: sum s4fu6_tte
	tab exp,  sum(s4fu6_tte)
	
	tab s4fu12_outcome_type exp if ch_s4==1, missing
	tab s4fu12 exp if ch_s4==1, missing
	tab s4fu12_count exp
	hist s4fu12_count, freq
	hist s4fu12_count if s4fu12==1, freq
	*tab s1fu12_event_date
	bys exp: sum s4fu12_tte
	tab exp,  sum(s4fu12_tte)

********************************************************************************
********************************************************************************

*time toevent
		
		stset muscular_tte6, failure(muscular_outcome6)
	    stset muscular_tte12, failure(muscular_outcome12)
		
		stset pain_tte6, failure(pain_outcome6)
		stset pain_tte12, failure(pain_outcome12)
		
		stset headache_tte6, failure(headache_outcome6)
		stset headache_tte12, failure(headache_outcome12)
		
		stset gastro_tte6, failure(gastro_outcome6)
		stset gastro_tte12, failure(gastro_outcome12)
		
		sts graph, na
		
		sts test exp, logrank
		
		sts graph, by(exp) 
		

***********************************************
*logistic - diagnoses and symptoms

		
		logistic s1fu12 i.region
		logistic s2fu12 i.region
		logistic s3fu12 i.region
		logistic s4fu12 i.region
		
		logistic s1fu12 i.yob
		logistic s2fu12 i.yob
		logistic s3fu12 i.yob
		logistic s4fu12 i.yob
		
		logistic s1fu12 i.imd2015_5
		logistic s2fu12 i.imd2015_5
		logistic s3fu12 i.imd2015_5
		logistic s4fu12 i.imd2015_5
		
		logistic s1fu12 i.exp i.imd2015_5
		logistic s2fu12 i.exp i.imd2015_5
		logistic s3fu12 i.exp i.imd2015_5
		logistic s4fu12 i.exp i.imd2015_5
	
	

		logistic d1fu6 i.exp
		logistic d2fu6 i.exp
		logistic d3fu6 i.exp
		
		logistic d1fu12 i.exp
		logistic d2fu12 i.exp
		logistic d3fu12 i.exp
		
		logistic s1fu6 i.exp
		logistic s2fu6 i.exp
		logistic s3fu6 i.exp
		logistic s4fu6 i.exp
		
		logistic s1fu12 i.exp
		logistic s2fu12 i.exp
		logistic s3fu12 i.exp
		logistic s4fu12 i.exp
		

		
		******
		
		logistic s1fu6 i.exp encoun
		logistic s2fu6 i.exp encoun
		logistic s3fu6 i.exp encoun
		logistic s4fu6 i.exp encoun
		
		logistic s1fu12 i.exp encoun
		logistic s2fu12 i.exp encoun
		logistic s3fu12 i.exp encoun
		logistic s4fu12 i.exp encoun
		
		*****
		
		logistic s1fu6 i.exp  i.yob 
		logistic s2fu6 i.exp  i.yob 
		logistic s3fu6 i.exp  i.yob 
		logistic s4fu6 i.exp  i.yob 
		
		logistic s1fu12 i.exp  i.yob 
		logistic s2fu12 i.exp  i.yob 
		logistic s3fu12 i.exp  i.yob 
		logistic s4fu12 i.exp  i.yob 
		
			*****
		
		logistic s1fu6 i.exp encoun  i.yob 
		logistic s2fu6 i.exp encoun  i.yob 
		logistic s3fu6 i.exp encoun  i.yob 
		logistic s4fu6 i.exp encoun  i.yob 
		
		logistic s1fu12 i.exp encoun  i.yob 
		logistic s2fu12 i.exp encoun  i.yob 
		logistic s3fu12 i.exp encoun  i.yob 
		logistic s4fu12 i.exp encoun  i.yob 
		
		/*
		logistic s2fu12 i.exp encoun  i.yob i.region
		logistic s2fu12  i.exp##i.yob encoun 
		logistic s2fu12  i.exp i.region##i.yob encoun 
		
		margins yob
		margins region
		margins yob region
		margins yob region, at(exp=(0)) vsquish
		margins yob region, at(exp=(1)) vsquish
		margins yob, at(exp=(0) region=7) vsquish
		margins yob, at(exp=(1) region=7) vsquish
		
				
		margins region, at(exp=(0)) vsquish
		margins region, at(exp=(1)) vsquish
		margins region, at(exp=(0) yob=2005) vsquish
		margins region, at(exp=(1) yob=2000) vsquish
		
		marginsplot, legend(row(1))
		*/
		
		*****
		
		logistic s1fu6 i.exp encoun i.mob 
		logistic s2fu6 i.exp encoun i.mob 
		logistic s3fu6 i.exp encoun i.mob 
		logistic s4fu6 i.exp encoun i.mob 
		
		logistic s1fu12 i.exp encoun i.mob if mob!=0
		logistic s2fu12 i.exp encoun i.mob if mob!=0
		logistic s3fu12 i.exp encoun i.mob if mob!=0
		logistic s4fu12 i.exp encoun i.mob if mob!=0
		
		
		*****
		
		logistic s1fu6 i.exp encoun i.region 
		logistic s2fu6 i.exp encoun i.region 
		logistic s3fu6 i.exp encoun i.region 
		logistic s4fu6 i.exp encoun i.region 
		
		logistic s1fu12 i.exp encoun i.region 
		logistic s2fu12 i.exp encoun i.region 
		logistic s3fu12 i.exp encoun i.region 
		logistic s4fu12 i.exp encoun i.region 
		
				
		*****
		
		logistic s1fu6 i.exp encoun i.ethnicity 
		logistic s2fu6 i.exp encoun i.ethnicity 
		logistic s3fu6 i.exp encoun i.ethnicity 
		logistic s4fu6 i.exp encoun i.ethnicity 
		
		logistic s1fu12 i.exp if hes_e==1
		logistic s2fu12 i.exp  if hes_e==1
		logistic s3fu12 i.exp  if hes_e==1
		logistic s4fu12 i.exp  if hes_e==1
		
		*****
		
		logistic s1fu6 i.exp encoun mob
		logistic s2fu6 i.exp encoun mob 
		logistic s3fu6 i.exp encoun mob 
		logistic s4fu6 i.exp encoun mob 
		
		logistic s1fu12 i.exp mob encoun
		logistic s2fu12 i.exp mob encoun
		logistic s3fu12 i.exp mob encoun
		logistic s4fu12 i.exp mob encoun
		
		tab mob exp
		
		
		*****
		
		logistic s1fu6 i.exp encoun i.imd2015_5 
		logistic s2fu6 i.exp encoun i.imd2015_5 
		logistic s3fu6 i.exp encoun i.imd2015_5 
		logistic s4fu6 i.exp encoun i.imd2015_5 
		
		logistic s1fu12 i.exp encoun i.imd2015_5 
		logistic s2fu12 i.exp encoun i.imd2015_5 
		logistic s3fu12 i.exp encoun i.imd2015_5 
		logistic s4fu12 i.exp encoun i.imd2015_5 
		
		
		 

***********************************************
		
use  analysis_YSprimary.dta ,clear
use  analysis_Yprimary.dta ,clear
use analysis_nohes_YSprimary.dta, clear
use  analysis_YSprimary_link.dta ,clear
use  analysis_YSprimary_3d.dta ,clear

use analysis_Yprimary_link.dta, clear
use analysis_Yprimary_3d.dta, clear
use analysis_nohesYprimary.dta, clear

use  analysis_YSsens1.dta ,clear
use  analysis_Ysens1.dta ,clear

use  analysis_YSsens2.dta ,clear
use  analysis_Ysens2.dta ,clear

***********************************************
net set ado "O:\CURRENT WORK\statainst"
net install metaan
net install metaeff
adopath ++ "O:\CURRENT WORK\statainst"

ssc install metaan
ssc install metaeff
ssc install metan
ssc install meta

***********************************************
*unadj and adjusted to encoun - primary

*meta by year
*use  analysis_YSprimary.dta ,clear
*use  analysis_Yprimary.dta ,clear
/*
global j s1fu12
global j s2fu12
global j s3fu12
global j s4fu12

global j s1fu6
global j s2fu6
global j s3fu6
global j s4fu6

bys exp: tab s3fu6 yob
bys exp: tab s3fu12 yob
*/
********************************************************************************
*global maindata analysis_YSprimary_3d
*global maindata analysis_Yprimary_3d

*global maindata analysis_YSprimary_link
*global maindata analysis_Yprimary_link

*global maindata "analysis_nohesYSprimary"
*global maindata "analysis_nohesYprimary"

global maindata "analysis_YSprimary"
*global maindata "analysis_Yprimary"

foreach s of numlist 12 {
foreach k of numlist 1 2 4 5{
local j "s`k'fu`s'"
di "`j'"

forval i= 0/5{

di `i'
use  $maindata ,clear
drop if ch_s`k'==0
*logistic `j' i.exp if yob==200`i' & ch_s`k'==1/*unadjusted*/
logistic `j' i.exp encoun if yob==200`i' & ch_s`k'==1/*adjusted*/
*logistic `j' i.exp conscount if yob==200`i' /*adjusted for no hes*/

*odds ratio
display exp(_b[1.exp])
*ci at odds ratio scale
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])
*standard error at odds ration scale (delta method)
display exp(_b[1.exp])*_se[1.exp]
display  _b[1.exp]-1.959964*_se[1.exp]
display  _b[1.exp]+1.959964*_se[1.exp]


capture drop counter
gen counter=1
collapse (sum) counter, by (exp yob `j')
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

save logistic_Yprimary_200`i'`j'.dta, replace
}

use logistic_Yprimary_2000`j'.dta, clear
forval i= 1/5{
append using logistic_Yprimary_200`i'`j'.dta
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

metan logor selogor, randomi second(fixedi) eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=yob) nograph


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

save logistic_YSprimary_`j', replace
}
}

/*
metan logor selogor,  fixed eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=yob)

metan logor selogor,  random eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=yob)
*/

*metan logor ci95lologor ci95uplogor, fixed eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
*force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=yob)

/*
capture drop ES 
capture drop ES2 
capture drop selogES 
capture drop ci_lowES 
capture drop ci_uppES 
capture drop p_zES
*/
********************************************************************************
*run twice for adjusted and unadjusted models

*primary

		use logistic_YSprimary_s1fu12
		append using logistic_YSprimary_s2fu12
		*append using logistic_YSprimary_s3fu12
		append using logistic_YSprimary_s4fu12
		append using logistic_YSprimary_s5fu12
		append using logistic_YSprimary_s1fu6
		append using logistic_YSprimary_s2fu6
		*append using logistic_YSprimary_s3fu6
		append using logistic_YSprimary_s4fu6
		*save logistic_YSprimary_meta_unadj, replace
		save logistic_YSprimary_meta_adj, replace
		/*
		use logistic_YSprimary_meta_adj, clear
		use logistic_YSprimary_meta_unadj, clear
		*/
		use logistic_Yprimary_s1fu12
		append using logistic_Yprimary_s2fu12
		*append using logistic_Yprimary_s3fu12
		append using logistic_Yprimary_s4fu12
		append using logistic_Yprimary_s1fu6
		append using logistic_Yprimary_s2fu6
		*append using logistic_Yprimary_s3fu6
		append using logistic_Yprimary_s4fu6
		*save logistic_Yprimary_meta_unadj, replace
		save logistic_Yprimary_meta_adj, replace

		/*
		use logistic_YSprimary_meta_adj, clear
		use logistic_YSprimary_meta_unadj, clear
	*/

*no linked HES

		use logistic_YSprimaryl_s1fu12
		append using logistic_YSprimaryl_s2fu12
		append using logistic_YSprimaryl_s4fu12
		append using logistic_YSprimaryl_s1fu6
		append using logistic_YSprimaryl_s2fu6
		append using logistic_YSprimaryl_s4fu6
		*save logistic_YSprimaryl_meta_unadj, replace
		save logistic_YSprimaryl_meta_adj, replace
		/*
		use logistic_YSprimaryl_meta_adj, clear
		use logistic_YSprimaryl_meta_unadj, clear
		*/
		use logistic_Yprimaryl_s1fu12
		append using logistic_Yprimaryl_s2fu12
		append using logistic_Yprimaryl_s4fu12
		append using logistic_Yprimaryl_s1fu6
		append using logistic_Yprimaryl_s2fu6
		append using logistic_Yprimaryl_s4fu6
		*save logistic_Yprimaryl_meta_unadj, replace
		save logistic_Yprimaryl_meta_adj, replace
		/*
		use logistic_Yprimaryl_meta_adj, clear
		use logistic_Yprimaryl_meta_unadj, clear
		*/

*3 dose sched - 2000-2001
		use logistic_YSprimary3d_s1fu12
		append using logistic_YSprimary3d_s2fu12
		append using logistic_YSprimary3d_s4fu12
		append using logistic_YSprimary3d_s1fu6
		append using logistic_YSprimary3d_s2fu6
		append using logistic_YSprimary3d_s4fu6
		*save logistic_YSprimary3d_meta_unadj, replace
		save logistic_YSprimary3d_meta_adj, replace
		/*
		use logistic_YSprimary3d_meta_adj, clear
		use logistic_YSprimary3d_meta_unadj, clear
		*/
		use logistic_Yprimary3d_s1fu12
		append using logistic_Yprimary3d_s2fu12
		append using logistic_Yprimary3d_s4fu12
		append using logistic_Yprimary3d_s1fu6
		append using logistic_Yprimary3d_s2fu6
		append using logistic_Yprimary3d_s4fu6
		*save logistic_Yprimary3d_meta_unadj, replace
		save logistic_Yprimary3d_meta_adj, replace
		/*
		use logistic_Yprimary3d_meta_adj, clear
		use logistic_Yprimary3d_meta_unadj, clear
		*/

*no hes outcomes

		use logistic_YSprimarynh_s1fu12
		append using logistic_YSprimarynh_s2fu12
		append using logistic_YSprimarynh_s4fu12
		append using logistic_YSprimarynh_s1fu6
		append using logistic_YSprimarynh_s2fu6
		append using logistic_YSprimarynh_s4fu6
		*save logistic_YSprimarynh_meta_unadj, replace
		save logistic_YSprimarynh_meta_adj, replace
		/*
		use logistic_YSprimarynh_meta_adj, clear
		use logistic_YSprimarynh_meta_unadj, clear
		*/
		use logistic_Yprimarynh_s1fu12
		append using logistic_Yprimarynh_s2fu12
		append using logistic_Yprimarynh_s4fu12
		append using logistic_Yprimarynh_s1fu6
		append using logistic_Yprimarynh_s2fu6
		append using logistic_Yprimarynh_s4fu6
		*save logistic_Yprimarynh_meta_unadj, replace
		save logistic_Yprimarynh_meta_adj, replace
		/*
		use logistic_Yprimarynh_meta_adj, clear
		use logistic_Yprimarynh_meta_unadj, clear
		*/

********************************************************************************

use logistic_YSprimary_meta_adj, clear
gen g1="adj"
append using logistic_YSprimary_meta_unadj
replace  g1="unadj" if g1==""
gen g2="YS"
append using logistic_Yprimary_meta_adj
replace  g1="adj" if g1==""
replace g2="Y" if g2==""
append using logistic_Yprimary_meta_unadj
replace  g1="unadj" if g1==""
replace g2="Y" if g2==""
append using logistic_YSprimaryl_meta_unadj
replace  g1="unadj" if g1==""
replace g2="YSl" if g2==""
append using logistic_YSprimaryl_meta_adj
replace  g1="adj" if g1==""
replace g2="YSl" if g2==""
append using logistic_YSprimary3d_meta_adj
replace  g1="adj" if g1==""
replace g2="YS3d" if g2==""
append using logistic_YSprimary3d_meta_unadj
replace  g1="unadj" if g1==""
replace g2="YS3d" if g2==""
append using logistic_YSprimarynh_meta_adj
replace  g1="adj" if g1==""
replace g2="YSnh" if g2==""
append using logistic_YSprimarynh_meta_unadj
replace  g1="unadj" if g1==""
replace g2="YSnh" if g2==""

append using logistic_Yprimaryl_meta_unadj
replace  g1="unadj" if g1==""
replace g2="Yl" if g2==""
append using logistic_Yprimaryl_meta_adj
replace  g1="adj" if g1==""
replace g2="Yl" if g2==""
append using logistic_Yprimary3d_meta_adj
replace  g1="adj" if g1==""
replace g2="Y3d" if g2==""
append using logistic_Yprimary3d_meta_unadj
replace  g1="unadj" if g1==""
replace g2="Y3d" if g2==""
append using logistic_Yprimarynh_meta_adj
replace  g1="adj" if g1==""
replace g2="Ynh" if g2==""
append using logistic_Yprimarynh_meta_unadj
replace  g1="unadj" if g1==""
replace g2="Ynh" if g2==""

*keep effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc g1 g2
*duplicates drop

keep effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc g1 g2 exp unexp c1_exp c1_unexp c0_exp c0_unexp
collapse (sum) exp (sum) unexp (sum) c1_exp (sum) c1_unexp (sum) c0_exp (sum) c0_unexp, by (effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc g1 g2)

*sort outc g2 g1
*sort outc g1 g2
sort g2 g1 outc  
gen total=exp+unexp
*save logistic_primary_meta, replace
save logistic_primary_meta_new, replace
*save logistic_primary_meta_new_fractures, replace

use logistic_primary_meta_new, clear


********************************************************************************
sens1 and 2 

/*
global maindata "analysis_YSsens2"
global maindata "analysis_YSsens1"
use  $maindata ,clear
		logistic s1fu6 i.exp
		logistic s2fu6 i.exp
		logistic s3fu6 i.exp
		logistic s4fu6 i.exp
		
		logistic s1fu12 i.exp
		logistic s2fu12 i.exp
		logistic s3fu12 i.exp
		logistic s4fu12 i.exp
		
		******
		
		logistic s1fu6 i.exp encoun
		logistic s2fu6 i.exp encoun
		logistic s3fu6 i.exp encoun
		logistic s4fu6 i.exp encoun
		
		logistic s1fu12 i.exp encoun
		logistic s2fu12 i.exp encoun
		logistic s3fu12 i.exp encoun
		logistic s4fu12 i.exp encoun
*/


global maindata "analysis_YSsens2"
*global maindata "analysis_Ysens2"

*global maindata "analysis_YSsens1"
*global maindata "analysis_Ysens1"

foreach s of numlist 6 12 {
foreach k of numlist 1 2 3 4 {
local j "s`k'fu`s'"
di "`j'"

use  $maindata ,clear
drop if ch_s`k'==0
logistic `j' i.exp /*unadjusted*/
*logistic `j' i.exp encoun  /*adjusted*/

*odds ratio
display exp(_b[1.exp])
*ci at odds ratio scale
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])
*standard error at odds ration scale (delta method)
display exp(_b[1.exp])*_se[1.exp]
*p value
matrix a=r(table)
display a[4,2]

capture drop counter
gen counter=1
collapse (sum) counter, by (exp `j')
reshape wide counter, i(exp) j(`j')
gen outc="`j'"
reshape wide counter0 counter1, i(outc) j(exp)
rename counter00 c0_unexp
rename counter01 c0_exp
rename counter10 c1_unexp
rename counter11 c1_exp
gen exp=c1_exp+c0_exp
gen unexp=c1_unexp+c0_unexp

gen ES= exp(_b[1.exp])
gen ES2= exp(_b[1.exp])
gen selogES=exp(_b[1.exp])*_se[1.exp]
gen ci_lowES=exp(_b[1.exp]-1.959964*_se[1.exp])
gen ci_uppES=exp(_b[1.exp]+1.959964*_se[1.exp])
gen p_zES=a[4,2]
capture drop outc
gen outc="`j'"

save logistic_YSsens2unadj`j'.dta, replace
}
}

use logistic_YSsens1unadjs1fu12.dta, clear
append using logistic_YSsens1unadjs2fu12
append using logistic_YSsens1unadjs3fu12
append using logistic_YSsens1unadjs4fu12
append using logistic_YSsens1unadjs1fu6
append using logistic_YSsens1unadjs2fu6
append using logistic_YSsens1unadjs3fu6
append using logistic_YSsens1unadjs4fu6
gen g2="sens1YS"
gen g1="unadj"

append using logistic_YSsens1adjs1fu12
append using logistic_YSsens1adjs2fu12
append using logistic_YSsens1adjs3fu12
append using logistic_YSsens1adjs4fu12
append using logistic_YSsens1adjs1fu6
append using logistic_YSsens1adjs2fu6
append using logistic_YSsens1adjs3fu6
append using logistic_YSsens1adjs4fu6
replace g2="sens1YS" if g2==""
replace g1="adj" if g1==""

append using logistic_Ysens1unadjs1fu12
append using logistic_Ysens1unadjs2fu12
append using logistic_Ysens1unadjs3fu12
append using logistic_Ysens1unadjs4fu12
append using logistic_Ysens1unadjs1fu6
append using logistic_Ysens1unadjs2fu6
append using logistic_Ysens1unadjs3fu6
append using logistic_Ysens1unadjs4fu6
replace g2="sens1Y" if g2==""
replace g1="unadj" if g1==""

append using logistic_Ysens1adjs1fu12
append using logistic_Ysens1adjs2fu12
append using logistic_Ysens1adjs3fu12
append using logistic_Ysens1adjs4fu12
append using logistic_Ysens1adjs1fu6
append using logistic_Ysens1adjs2fu6
append using logistic_Ysens1adjs3fu6
append using logistic_Ysens1adjs4fu6
replace g2="sens1Y" if g2==""
replace g1="adj" if g1==""


append using logistic_YSsens2unadjs1fu12
append using logistic_YSsens2unadjs2fu12
append using logistic_YSsens2unadjs3fu12
append using logistic_YSsens2unadjs4fu12
append using logistic_YSsens2unadjs1fu6
append using logistic_YSsens2unadjs2fu6
append using logistic_YSsens2unadjs3fu6
append using logistic_YSsens2unadjs4fu6
replace g2="sens2YS" if g2==""
replace g1="unadj" if g1==""

append using logistic_YSsens2adjs1fu12
append using logistic_YSsens2adjs2fu12
append using logistic_YSsens2adjs3fu12
append using logistic_YSsens2adjs4fu12
append using logistic_YSsens2adjs1fu6
append using logistic_YSsens2adjs2fu6
append using logistic_YSsens2adjs3fu6
append using logistic_YSsens2adjs4fu6
replace g2="sens2YS" if g2==""
replace g1="adj" if g1==""

append using logistic_Ysens2unadjs1fu12
append using logistic_Ysens2unadjs2fu12
append using logistic_Ysens2unadjs3fu12
append using logistic_Ysens2unadjs4fu12
append using logistic_Ysens2unadjs1fu6
append using logistic_Ysens2unadjs2fu6
append using logistic_Ysens2unadjs3fu6
append using logistic_Ysens2unadjs4fu6
replace g2="sens2Y" if g2==""
replace g1="unadj" if g1==""

append using logistic_Ysens2adjs1fu12
append using logistic_Ysens2adjs2fu12
append using logistic_Ysens2adjs3fu12
append using logistic_Ysens2adjs4fu12
append using logistic_Ysens2adjs1fu6
append using logistic_Ysens2adjs2fu6
append using logistic_Ysens2adjs3fu6
append using logistic_Ysens2adjs4fu6
replace g2="sens2Y" if g2==""
replace g1="adj" if g1==""

*save logistic_sens, replace

save logistic_sens_new, replace

**********************************************************
*main combined logistic

global maindata "analysis_Yprimary"

foreach s of numlist 6 12 {
foreach k of numlist 1 2 3 4 {
local j "s`k'fu`s'"
di "`j'"

use  $maindata ,clear
drop if ch_s`k'==0
logistic `j' i.exp /*unadjusted*/
*logistic `j' i.exp encoun i.yob /*adjusted*/

*odds ratio
display exp(_b[1.exp])
*ci at odds ratio scale
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])
*standard error at odds ration scale (delta method)
display exp(_b[1.exp])*_se[1.exp]
*p value
matrix a=r(table)
display a[4,2]

capture drop counter
gen counter=1
collapse (sum) counter, by (exp `j')
reshape wide counter, i(exp) j(`j')
gen outc="`j'"
reshape wide counter0 counter1, i(outc) j(exp)
rename counter00 c0_unexp
rename counter01 c0_exp
rename counter10 c1_unexp
rename counter11 c1_exp
gen exp=c1_exp+c0_exp
gen unexp=c1_unexp+c0_unexp

gen ES= exp(_b[1.exp])
gen ES2= exp(_b[1.exp])
gen selogES=exp(_b[1.exp])*_se[1.exp]
gen ci_lowES=exp(_b[1.exp]-1.959964*_se[1.exp])
gen ci_uppES=exp(_b[1.exp]+1.959964*_se[1.exp])
gen p_zES=a[4,2]
capture drop outc
gen outc="`j'"

save logistic_Yprimary_comb_unadj_`j'.dta, replace
}
}

use logistic_YSprimary_comb_unadj_s1fu12.dta, clear
append using logistic_YSprimary_comb_unadj_s2fu12
append using logistic_YSprimary_comb_unadj_s3fu12
append using logistic_YSprimary_comb_unadj_s4fu12
append using logistic_YSprimary_comb_unadj_s1fu6
append using logistic_YSprimary_comb_unadj_s2fu6
append using logistic_YSprimary_comb_unadj_s3fu6
append using logistic_YSprimary_comb_unadj_s4fu6
gen g2="YScomb"
gen g1="unadj"

append using logistic_YSprimary_comb_adj_s1fu12
append using logistic_YSprimary_comb_adj_s2fu12
append using logistic_YSprimary_comb_adj_s3fu12
append using logistic_YSprimary_comb_adj_s4fu12
append using logistic_YSprimary_comb_adj_s1fu6
append using logistic_YSprimary_comb_adj_s2fu6
append using logistic_YSprimary_comb_adj_s3fu6
append using logistic_YSprimary_comb_adj_s4fu6
replace g2="YScomb" if g2==""
replace g1="adj" if g1==""

append using logistic_Yprimary_comb_adj_s1fu12
append using logistic_Yprimary_comb_adj_s2fu12
append using logistic_Yprimary_comb_adj_s3fu12
append using logistic_Yprimary_comb_adj_s4fu12
append using logistic_Yprimary_comb_adj_s1fu6
append using logistic_Yprimary_comb_adj_s2fu6
append using logistic_Yprimary_comb_adj_s3fu6
append using logistic_Yprimary_comb_adj_s4fu6
replace g2="Ycomb" if g2==""
replace g1="adj" if g1==""

append using logistic_Yprimary_comb_unadj_s1fu12
append using logistic_Yprimary_comb_unadj_s2fu12
append using logistic_Yprimary_comb_unadj_s3fu12
append using logistic_Yprimary_comb_unadj_s4fu12
append using logistic_Yprimary_comb_unadj_s1fu6
append using logistic_Yprimary_comb_unadj_s2fu6
append using logistic_Yprimary_comb_unadj_s3fu6
append using logistic_Yprimary_comb_unadj_s4fu6
replace g2="Ycomb" if g2==""
replace g1="unadj" if g1==""


save logistic_primary_comb, replace

use logistic_primary_comb, clear

drop if g2=="Ycomb"
drop if outc=="s3fu12"

********************************************************************************
*main combined cox

global maindata "analysis_YSprimary"

foreach k of numlist 1 2 3 4 {
local j "s`k'fu6"
di "`j'"

use  $maindata ,clear
stset `j'_tte, failure(`j')
*stcox i.exp /*unadjusted*/
stcox i.exp encoun, strata(yob) /*adjusted*/

/*
		stset s1fu12_tte, failure(s1fu12)
		stcox i.exp encoun
		stcox i.exp encoun, strata(yob)
		stcox i.exp encoun i.yob
		stcox i.exp
		stcox i.exp, strata(yob)
		stcox i.exp i.yob
*/


*odds ratio
display exp(_b[1.exp])
*ci at odds ratio scale
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])
*standard error at odds ration scale (delta method)
display exp(_b[1.exp])*_se[1.exp]
*p value
matrix a=r(table)
display a[4,2]

capture drop counter
gen counter=1
collapse (sum) counter, by (exp `j')
reshape wide counter, i(exp) j(`j')
gen outc="`j'"
reshape wide counter0 counter1, i(outc) j(exp)
rename counter00 c0_unexp
rename counter01 c0_exp
rename counter10 c1_unexp
rename counter11 c1_exp
gen exp=c1_exp+c0_exp
gen unexp=c1_unexp+c0_unexp

gen ES= exp(_b[1.exp])
gen ES2= exp(_b[1.exp])
gen selogES=exp(_b[1.exp])*_se[1.exp]
gen ci_lowES=exp(_b[1.exp]-1.959964*_se[1.exp])
gen ci_uppES=exp(_b[1.exp]+1.959964*_se[1.exp])
gen p_zES=a[4,2]
capture drop outc
gen outc="`j'"

save cox_YSprimary_comb_adj_`j'.dta, replace
}

use cox_YSprimary_comb_unadj_s1fu12.dta, clear
append using cox_YSprimary_comb_unadj_s2fu12
append using cox_YSprimary_comb_unadj_s3fu12
append using cox_YSprimary_comb_unadj_s4fu12
append using cox_YSprimary_comb_unadj_s1fu6
append using cox_YSprimary_comb_unadj_s2fu6
append using cox_YSprimary_comb_unadj_s3fu6
append using cox_YSprimary_comb_unadj_s4fu6
gen g2="YScombcox"
gen g1="unadj"

append using cox_YSprimary_comb_adj_s1fu12
append using cox_YSprimary_comb_adj_s2fu12
append using cox_YSprimary_comb_adj_s3fu12
append using cox_YSprimary_comb_adj_s4fu12
append using cox_YSprimary_comb_adj_s1fu6
append using cox_YSprimary_comb_adj_s2fu6
append using cox_YSprimary_comb_adj_s3fu6
append using cox_YSprimary_comb_adj_s4fu6
replace g2="YScombcox" if g2==""
replace g1="adj" if g1==""

append using cox_Yprimary_comb_adj_s1fu12
append using cox_Yprimary_comb_adj_s2fu12
append using cox_Yprimary_comb_adj_s3fu12
append using cox_Yprimary_comb_adj_s4fu12
append using cox_Yprimary_comb_adj_s1fu6
append using cox_Yprimary_comb_adj_s2fu6
append using cox_Yprimary_comb_adj_s3fu6
append using cox_Yprimary_comb_adj_s4fu6
replace g2="Ycombcox" if g2==""
replace g1="adj" if g1==""

append using cox_Yprimary_comb_unadj_s1fu12
append using cox_Yprimary_comb_unadj_s2fu12
append using cox_Yprimary_comb_unadj_s3fu12
append using cox_Yprimary_comb_unadj_s4fu12
append using cox_Yprimary_comb_unadj_s1fu6
append using cox_Yprimary_comb_unadj_s2fu6
append using cox_Yprimary_comb_unadj_s3fu6
append using cox_Yprimary_comb_unadj_s4fu6
replace g2="Ycombcox" if g2==""
replace g1="unadj" if g1==""


save cox_primary_comb, replace


********************************************************************************
*final dataset of results

use logistic_primary_meta_new, clear
append using logistic_sens_new
append using logistic_primary_comb
*append using cox_primary_comb

replace total = exp+unexp if total==.
label variable total "Total"

capture drop Events_Exposed
capture drop Events_Exposed1
capture drop Events_Exposed2
tostring(c1_exp), gen (Events_Exposed1)
tostring(exp), gen (Events_Exposed2)
gen Events_Exposed=Events_Exposed1+"/"+Events_Exposed2
capture drop Events_Exposed1
capture drop Events_Exposed2

capture drop Events_Unexposed
capture drop Events_Unexposed1
capture drop Events_Unexposed2
tostring(c1_unexp), gen (Events_Unexposed1)
tostring(unexp), gen (Events_Unexposed2)
gen Events_Unexposed=Events_Unexposed1+"/"+Events_Unexposed2
capture drop Events_Unexposed1
capture drop Events_Unexposed2

capture drop pvalue
gen pvalue = p_zES
format %9.3f pvalue
label variable pvalue "p-value"

label variable Events_Exposed "Events/Exposed"
label variable Events_Unexposed "Events/Unexposed"

capture drop fu
gen fu=6 if outc=="s1fu6"|outc=="s2fu6"|outc=="s3fu6"|outc=="s4fu6"
replace fu=12 if fu==.

capture drop codelevel
gen codelevel="Y" if g2=="Y"|g2=="Y3d"|g2=="Y"|g2=="Ycomb"|g2=="Ycombcox"|g2=="Yl"|g2=="Ynh"|g2=="sens1Y"|g2=="sens2Y"
replace codelevel="YS" if codelevel==""

capture drop outcome
generate outcome="---Gastrointestinal symptoms---" if outc=="s1fu12"|outc=="s1fu6"
replace outcome="---Headache/migraine symptoms---" if outc=="s2fu12"|outc=="s2fu6"
replace outcome="---Neuromuscular symptoms---" if outc=="s3fu12"|outc=="s3fu6"
replace outcome="---Pain symptoms---" if outc=="s4fu12"|outc=="s4fu6"

capture drop dataset
gen dataset="sens1" if g2=="sens1Y"|g2=="sens1YS"
replace dataset="sens2" if g2=="sens2Y"|g2=="sens2YS"
replace dataset="primary" if dataset==""

capture drop estmt
gen estmt="HR" if g2=="Ycombcox"|g2=="YScombcox"
replace estmt="OR" if estmt==""

capture drop analysis
gen analysis="cox" if g2=="Ycombcox"|g2=="YScombcox"
replace analysis="logistic" if g2=="Ycomb"|g2=="YScomb"|g2=="sens1Y"|g2=="sens2Y"|g2=="sens1YS"|g2=="sens2YS"
replace analysis="logistic_meta" if analysis==""

capture drop analysis2
gen analysis2="combined" if g2=="Ycombcox"|g2=="YScombcox"
replace analysis2="combined" if g2=="Ycomb"|g2=="YScomb"|g2=="sens1Y"|g2=="sens2Y"|g2=="sens1YS"|g2=="sens2YS"
replace analysis2="meta" if analysis2==""

rename g1 model
order model, last

capture drop cohort
gen cohort=dataset
replace cohort="primary_3doses" if g2=="YS3d"|g2=="Y3d"
replace cohort="primary_linked" if g2=="YSl"|g2=="Yl"
replace cohort="primary_nohes" if g2=="YSnh"|g2=="Ynh"

capture drop analysis_type
*gen analysis_type = codelevel+" "+cohort+" "+analysis+" "+model + " " + outcome + " 6" if fu==6
*replace analysis_type = codelevel+" "+cohort+" "+analysis+" "+model + " " + outcome + " 12" if fu==12
*gen analysis_type = codelevel+" "+cohort+" "+analysis2+" "+model + " 12" if fu==12
*replace analysis_type = codelevel+" "+cohort+" "+analysis2+" "+model + " 6" if fu==6
*gen analysis_type="Primary 1" if cohort=="primary"&analysis2=="meta"
*replace analysis_type="Primary 2" if cohort=="primary"&analysis2=="combined"
*replace analysis_type="Sensitivity 2" if cohort=="primary_linked"&analysis2=="meta"
*replace analysis_type="Sensitivity 1" if cohort=="primary_nohes"&analysis2=="meta"
*replace analysis_type="Sensitivity 3" if cohort=="primary_3doses"&analysis2=="meta"
*replace analysis_type="Sensitivity 4" if cohort=="sens1"&analysis2=="combined"
*replace analysis_type="Sensitivity 5" if cohort=="sens2"&analysis2=="combined"

gen analysis_type="1" if cohort=="primary"&analysis2=="meta"
replace analysis_type="2" if cohort=="primary"&analysis2=="combined"
replace analysis_type="1" if cohort=="primary_linked"&analysis2=="meta"
replace analysis_type="1" if cohort=="primary_nohes"&analysis2=="meta"
replace analysis_type="1" if cohort=="primary_3doses"&analysis2=="meta"
replace analysis_type="2" if cohort=="sens1"&analysis2=="combined"
replace analysis_type="2" if cohort=="sens2"&analysis2=="combined"
label variable analysis_type "AnalysisType**"
tab analysis_type, missing

capture drop cohort_type
gen cohort_type="1a" if cohort=="primary"&analysis2=="meta"
replace cohort_type="1b" if cohort=="primary"&analysis2=="combined"
replace cohort_type="1d" if cohort=="primary_linked"&analysis2=="meta"
replace cohort_type="1c" if cohort=="primary_nohes"&analysis2=="meta"
replace cohort_type="1e" if cohort=="primary_3doses"&analysis2=="meta"
replace cohort_type="2" if cohort=="sens1"&analysis2=="combined"
replace cohort_type="3" if cohort=="sens2"&analysis2=="combined"
label variable cohort_type "CohortType*"
tab cohort_type, missing

gen logES=log(ES)
gen logci_lowES=log(ci_lowES)
gen logci_uppES=log(ci_uppES)



sort codelevel fu cohort model outcome
save logistic_results_all_new, replace


********************************************************************************

use logistic_results_all_new, clear

drop if estmt=="HR"

*primary narrow 12 
drop if codelevel=="Y" & cohort!="primary" 
drop if codelevel=="Y" & analysis2!="meta" 
drop if codelevel=="Y" & fu!=12
drop if codelevel=="Y" & model!="adj"

*primary unadj
drop if model =="unadj" & cohort!="primary"
drop if model =="unadj" & analysis2!="meta" 
drop if  model =="unadj"  & fu!=12

*primary 6
drop if fu==6 & cohort!="primary"
drop if fu==6  & analysis2!="meta" 

drop if outcome=="---Neuromuscular symptoms---"  & cohort=="primary"
drop if cohort=="primary" & analysis2=="combined"

replace codelevel="Yes" if codelevel=="YS"
replace codelevel="No" if codelevel=="Y"

replace model="adjusted" if model=="adj"
replace model="unadjusted" if model=="unadj"

replace cohort_type = "1a" if cohort_type=="1a" & codelevel=="Y" & model=="adj" & fu==12
replace cohort_type = "1a" if cohort_type=="1a" & codelevel=="YS" & model=="unadj" & fu==12
replace cohort_type = "1a" if cohort_type=="1a" & codelevel=="YS" & model=="adj" & fu==6
replace cohort_type = "1a" if cohort_type=="1a" & codelevel=="YS" & model=="adj" & fu==12 & analysis2=="meta"
replace cohort_type = "1a" if cohort_type=="1a" & codelevel=="YS" & model=="adj" & fu==12 & analysis2=="combined"


sort outcome cohort_type fu analysis_type

label variable cohort_type "Cohort*"
label variable codelevel "Uncertain Codes"
label variable fu "FollowUp Months"
label variable model "Estimates**"

*sens figure
 metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cohort_type outcome) ///
force xtick(0.75, 1.00, 1.25, 1.5, 1.75) effect(OR) lcols(cohort_type   model codelevel fu)    rcols(pvalue  Events_Exposed Events_Unexposed) astext(60) texts(140) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
 nooverall 
 
********************************************************************************
 
 use logistic_results_all, clear

/*
gen g3=g1+g2
replace g3=g3+"6" if fu==6
replace g3=g3+"12" if fu==12
*/

sort outcome cohort_type analysis_type


*unadjusted estimates 
 metan logES logci_lowES logci_uppES  if fu==12 & model=="unadj" & codelevel=="YS"  ///
& analysis!="cox"  & (outcome!="---Neuromuscular symptoms---"|cohort!="primary"&fu==12 & model=="unadj" & codelevel=="YS") , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cohort_type analysis_type outcome) ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(OR) lcols( cohort_type analysis_type)    rcols(pvalue Events_Exposed Events_Unexposed) astext(58) texts(130) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
title("Unadjusted odds ratios with 95% CI for developing an outcome (symptom) in exposed vs unexposed" "within 12 months follow up period using broad outcome defintion", size(small)) ///
caption ("* 1a - study population, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1b - study population without outcomes from secondary care, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1c - subgroup of the study population with linkage to secondary care, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1d - subgroup of thestudy population eligible for 3 dose vaccination schedule, born Jul/Aug 2000-2001(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2001 (unexposed)"  ///
"  2   - born in 1996(exposed to bivalent HPV vaccination programme) vs born in 1994 (unexposed)"  ///
"  3   - born in 2000(exposed to quadrivalent HPV vaccination programme) vs born in 1998 (exposed to bivalent HPV vaccination programme)" ///
" " ///
"**1 - weighted average estimate across birth years from random effects meta-analysis model"  ///
"   2 - estimate from logistic regression analysis model, adjusted to number of consultations" ///
, size(*0.52)) ///
 nooverall 



*Adjusted estimates 
 metan logES logci_lowES logci_uppES  if fu==12 & model=="adj" & codelevel=="YS"  ///
& analysis!="cox"  & (outcome!="---Neuromuscular symptoms---"|cohort!="primary"&fu==12 & model=="adj" & codelevel=="YS") , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cohort_type analysis_type outcome) ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(OR) lcols(cohort_type analysis_type)    rcols(pvalue  Events_Exposed Events_Unexposed) astext(58) texts(130) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
caption ("* 1a - study population, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1b - study population without outcomes from secondary care, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1c - subgroup of the study population with linkage to secondary care, born Jul/Aug 2000-2005(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)"  ///
"  1d - subgroup of thestudy population eligible for 3 dose vaccination schedule, born Jul/Aug 2000-2001(exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2001 (unexposed)"  ///
"  2   - born in 1996(exposed to bivalent HPV vaccination programme) vs born in 1994 (unexposed)"  ///
"  3   - born in 2000(exposed to quadrivalent HPV vaccination programme) vs born in 1998 (exposed to bivalent HPV vaccination programme)" ///
" " ///
"**1 - weighted average estimate across birth years from random effects meta-analysis model, adjusted to number of consultations/hospitalizations before cohort entry"  ///
"   2 - estimate from logistic regression analysis model, adjusted to number of consultations/hospitalizations before cohort entry (and birth year where appropriate)" ///
, size(*0.52)) ///
 nooverall 
 
 *title("Adjusted odds ratios with 95% CI for developing an outcome(symptom) in exposed vs unexposed" "within 12 months follow up period using broad outcome defintion", size(small)) ///

 capture drop cox_type
 gen cox_type=""
 replace cox_type="12 months follow up, adjusted" if fu==12 & model=="adj" & analysis=="cox"
 replace cox_type="12 months follow up, unadjusted" if fu==12 & model=="unadj" & analysis=="cox"
 replace cox_type="6 months follow up, adjusted" if fu==6 & model=="adj" & analysis=="cox"
 replace cox_type="6 months follow up, unadjusted" if fu==6 & model=="unadj" & analysis=="cox"
 label variable cox_type "AnalysisType*" 
 
  *estimates cox YS or Y
 metan logES logci_lowES logci_uppES  if codelevel=="Y" ///
& analysis=="cox"  & (outcome!="---Neuromuscular symptoms---"|cohort!="primary"&codelevel=="Y") , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cox_type cohort_type analysis_type outcome) ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(HR) lcols(cox_type) rcols(pvalue  Events_Exposed Events_Unexposed) astext(65) texts(130) ///
xsize(10) ysize(6) favours (Exposure decreases risk of outcome   #   Exposure increases risk of outcome) classic ///
title("Hazard ratios with 95% CI for developing an outcome(symptom) in exposed vs unexposed" "within 6 and 12 months follow up periods using narrow outcome definition", size(small)) ///
caption (" " ///
"* Main study population, born July/August in 2000-2005 (exposed to quadrivalent HPV vaccination programme) vs September/October in 2000-2005 (unexposed) with"  ///
"  estimates from cox regression model, unadjusted or adjusted to number of consultations/hospitalizations before cohort entry" ///
, size(*0.45)) ///
 nooverall 


  /*
  capture drop cox_type
 gen cox_type=""
 replace cox_type="narrow outcome definition, adjusted" if codelevel=="Y" & model=="adj" & analysis=="cox"
 replace cox_type="narrow outcome definition, unadjusted" if codelevel=="Y" & model=="unadj" & analysis=="cox"
 replace cox_type="broad outcome definition, adjusted" if codelevel=="YS" & model=="adj" & analysis=="cox"
 replace cox_type="broad outcome definition, unadjusted" if codelevel=="YS" & model=="unadj" & analysis=="cox"
 label variable cox_type "AnalysisType*" 


 
 *estimates cox 12 months
 metan logES logci_lowES logci_uppES  if fu==6 ///
& analysis=="cox"  & (outcome!="---Neuromuscular symptoms---"|cohort!="primary"&fu==6) , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cox_type cohort_type analysis_type outcome) ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(OR) lcols(cox_type) rcols(pvalue  Events_Exposed Events_Unexposed) astext(75) texts(130) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
title("Hazard ratios with 95% CI for developing an outcome(symptom) in exposed vs unexposed" "within 6 months follow up period for broad and narrow outcome definitions", size(small)) ///
caption ("*" ///
"Main study population, born July/August in 2000-2005 (exposed to quadrivalent HPV vaccination programme) vs September/October in 2000-2005 (unexposed) with"  ///
"estimates from cox regression model, unadjusted or adjusted to number of consultations/hospitalizations before cohort entry" ///
, size(*0.45)) ///
 nooverall 
  */
  

*Forest plot displaying adjusted** odds ratios with 95% CI for developing an outcome (symptom) in exposed 
*versus unexposed to HPV vaccination programme group within 12 months follow up period using broad outcome defintion

*classic
*(analysis!="logistic"|cohort!="primary")
*firststats(exp)


*prim only
metan logES logci_lowES logci_uppES if fu==12 & model=="unadj" & codelevel=="YS" ///
& analysis!="cox" & (analysis!="logistic"|cohort!="primary") & (outcome!="Neuromuscular symptoms"|cohort!="primary"&fu==12 & model=="unadj" & codelevel=="YS"), ///
fixedi eform  xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup /// 
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(Odds ratio) lcols(cohort model fu) astext(50) ///
xsize(10) ysize(6) nooverall 


*unadjusted counts
metan c1_exp c0_exp c1_unexp c0_unexp if fu==12 & model=="unadj" & codelevel=="YS"  ///
& analysis!="cox" & (analysis!="logistic"|cohort!="primary") & (outcome!="---Neuromuscular symptoms---"|cohort!="primary"&fu==12 & model=="unadj" & codelevel=="YS"), ///
rd  dp(5) fixedi xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup counts group1(Exposed) group2(Unexposed) sortby (outcome cohort analysis2) ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75)  lcols(cohort)  rcols(total) astext(50) ///
 xsize(10) ysize(6) favours (Vaccine programme exposure decreases risk # Vaccine programme exposure increases risk) classic ///
 title("Unadjusted estimates within 12 months follow up using broad outcome definition", size(small)) ///
caption("this is caption" "another" , size(tiny)) nooverall 
*efficacy

metan logES logci_lowES logci_uppES if fu==12 & model=="unadj" & codelevel=="YS" &(cohort=="primary"|cohort=="sens1"|cohort=="sens2")& analysis!="cox"  ///
& (analysis!="logistic"|cohort!="primary"), /// 
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  ///
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(Odds ratio) lcols(cohort analysis2 model fu) astext(50) ///
 xsize(10) ysize(6)  nooverall 




metan logES logci_lowES logci_uppES if outcome=="headache/migraine" & fu==12 & model=="unadj" & analysis!="cox" , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(codelevel) nosubgroup /// 
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(Odds ratio) lcols(cohort analysis2 model fu) astext(50) ///
xsize(10) ysize(6)  nooverall 

metan logES logci_lowES logci_uppES if outcome=="headache/migraine" & fu==12 & model=="unadj" & analysis!="cox" , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(codelevel) nosubgroup /// 
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(Odds ratio) lcols(cohort analysis2 model fu) astext(50) ///
xsize(10) ysize(6)  nooverall 


metan logES logci_lowES logci_uppES if outcome=="pain" & fu==12 & model=="adj" & analysis!="cox" , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(codelevel) nosubgroup /// 
force xtick(0.5, 0.75, 1.00, 1.25, 1.75) effect(Odds ratio) lcols(cohort analysis2 model fu) astext(50) ///
xsize(10) ysize(6)  nooverall 




metan logES logci_lowES logci_uppES if (outc=="s2fu12"|outc=="s2fu6")& g2!="sens2Y" & g2!="sens2YS" & g2!="sens1YS" & g2!="sens1Y", ///
fixedi eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=analysis_type) nooverall nowt nobox

metan logES logci_lowES logci_uppES if (outc=="s4fu12"|outc=="s2fu6")& g2!="sens2Y" & g2!="sens2YS" & g2!="sens1YS" & g2!="sens1Y", ///
fixedi eform xlabel(0.5, 1, 1.5, 2, 2.5) ///
force xtick(0.75, 1.25, 1.75, 2.25) effect(Odds ratio) label(namevar=g3) nooverall nowt nobox




********************************************************************************




*metaan effsize1 se1, ml label (yob) forest
drop if orval==1


use logistic_Yprimary_meta, replace
keep effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc
duplicates drop

use logistic_Yprimary_meta_unadj,replace
keep effES effloES effupES effQpvalES ES ES2 selogES ci_lowES ci_uppES p_zES outc
duplicates drop


********************************************************************************


logistic s1fu12 i.exp encoun if yob==2000
logit s1fu12 i.exp encoun if yob==2000
estimates save log_2000_primYS

estimates use log_2000_primYS
estimates describe using log_2000_primYS

estimates store log_2000_primYS
estimates describe
estimates replay
estimates table
estimates stats

display e(N)
matrix list e(b)
matrix list e(V)

display _b[1.exp]
display _se[1.exp]

*1.95996 39845 40054 23552

display exp(_b[1.exp])
display exp(_b[1.exp]+1.959964*_se[1.exp])
display exp(_b[1.exp]-1.959964*_se[1.exp])


logistic s1fu12 i.exp encoun if yob==2001
logistic s1fu12 i.exp encoun if yob==2002
logistic s1fu12 i.exp encoun if yob==2003
logistic s1fu12 i.exp encoun if yob==2004
logistic s1fu12 i.exp encoun if yob==2005

logistic s1fu12 i.exp encoun

 1.028807   .1429833  .7834909    1.350932
 1.13395    .1569666  .8645034    1.487377
 1.089046   .1395918  .8471124    1.400076
 1.229874   .1867943 .9132288    1.656311
 0.8749061   .1478077 .6282875    1.218329
 0.9816773   .1861309  .6769813    1.423511

tab s1fu12_count
tab s1fu12

meglm s1fu12 i.exp encoun|| yob:, family(binomial) link(logit) or
meglm s2fu12 i.exp encoun|| yob:, family(binomial) link(logit) or
meglm s3fu12 i.exp encoun|| yob:, family(binomial) link(logit) or
meglm s4fu12 i.exp encoun|| yob:, family(binomial) link(logit) or


meglm s1fu6 i.exp encoun|| yob:, family(binomial) link(logit)
meglm s2fu6 i.exp encoun|| yob:, family(binomial) link(logit)
meglm s3fu6 i.exp encoun|| yob:, family(binomial) link(logit)
meglm s4fu6 i.exp encoun|| yob:, family(binomial) link(logit)

logistic s1fu12 i.exp i.yob encoun
logistic s1fu12 i.exp i.yob 
logistic s1fu12 i.exp 

meglm s1fu12_count i.exp || yob:, family(poisson) link(log) irr
meglm s1fu12_count exp encoun || yob:, family(poisson) link(log) irr

poisson s1fu12_count i.exp i.yob encoun, vce(robust) irr
poisson s1fu12_count i.exp i.yob, vce(robust) irr
poisson s1fu12_count i.exp, vce(robust) irr


meglm s2fu12_count i.exp || yob:, family(poisson) link(log) irr
meglm s2fu12_count exp encoun || yob:, family(poisson) link(log) irr

poisson s2fu12_count i.exp i.yob encoun, vce(robust) irr
poisson s2fu12_count i.exp i.yob, vce(robust) irr
poisson s2fu12_count i.exp, vce(robust) irr


meglm s1fu6_count exp encoun || yob:, family(poisson) link(log) irr
meglm s2fu6_count exp encoun || yob:, family(poisson) link(log) irr
meglm s3fu6_count exp encoun || yob:, family(poisson) link(log) irr
meglm s4fu6_count exp encoun || yob:, family(poisson) link(log) irr

meglm s1fu12_count exp encoun || yob:, family(poisson) link(log) irr 
meglm s2fu12_count exp encoun || yob:, family(poisson) link(log) irr
meglm s3fu12_count exp encoun || yob:, family(poisson) link(log) irr
meglm s4fu12_count exp encoun || yob:, family(poisson) link(log) irr

predict re_yob, remeans reses(se_yob)
generate lower = re_yob - 1.96*se_yob
generate upper = re_yob + 1.96*se_yob
capture drop tag
egen tag = tag(yob)
gsort +re_yob -tag
capture drop rank
generate rank = sum(-tag)
generate labpos = re_yob + 1.96*se_yob + .1
twoway (rcap lower upper rank) (scatter re_yob rank)(scatter labpos rank, ///
mlabel(yob) msymbol(none) mlabpos(0)), xtitle(rank) ytitle(predicted posterior mean) legend(off) ///
xscale(range(0 7)) xlabel(1/7) ysize(2)

di e(cmd)
di e(depvar)
matrix list e(b)

/*
***********************************************
*unadjusted

use  analysis_YSprimary.dta ,clear 
/*
global j s1fu12
global j s2fu12
global j s3fu12
global j s4fu12



*/
capture drop counter
gen counter=1
collapse (sum) counter, by (exp yob $j)
reshape wide counter, i(yob exp) j($j)

reshape wide counter0 counter1, i(yob) j(exp)

rename counter00 c0_unexp
rename counter01 c0_exp
rename counter10 c1_unexp
rename counter11 c1_exp

gen exp=c1_exp+c0_exp
gen unexp=c1_unexp+c0_unexp

metaeff effsize1 se1, ni(exp) nc(unexp) i(c1_exp) c(c1_unexp)
metaan effsize1 se1, pl label (yob) forest

metan c1_exp c0_exp c1_unexp c0_unexp, rr xlab(.1,1,10) label(namevar=yob)
*/


***********************************************
*poisson robust - symptoms - crude

		poisson s1fu12_count i.exp, vce(robust) irr
		poisson s2fu12_count i.exp, vce(robust) irr
		poisson s3fu12_count i.exp, vce(robust) irr
		poisson s4fu12_count i.exp, vce(robust) irr
		
		poisson s1fu6_count i.exp, vce(robust) irr
		poisson s2fu6_count i.exp, vce(robust) irr
		poisson s3fu6_count i.exp, vce(robust) irr
		poisson s4fu6_count i.exp, vce(robust) irr
		
***********************************************
*poisson robust - symptoms - adjusted

	*for primary
		poisson s1fu12_count i.exp i.yob encoun, vce(robust) irr
		poisson s2fu12_count i.exp i.yob encoun, vce(robust) irr
		poisson s3fu12_count i.exp yob encoun, vce(robust) irr
		poisson s4fu12_count i.exp i.yob encoun, vce(robust) irr
		
		poisson s1fu6_count i.exp i.yob encoun, vce(robust) irr
		poisson s2fu6_count i.exp i.yob encoun, vce(robust) irr
		poisson s3fu6_count i.exp yob encoun, vce(robust) irr
		poisson s4fu6_count i.exp i.yob encoun, vce(robust) irr
	
	*for sens
	tab mob, missing
		
		poisson s1fu12_count i.exp encoun , vce(robust) irr
		poisson s2fu12_count i.exp encoun , vce(robust) irr
		poisson s3fu12_count i.exp encoun , vce(robust) irr
		poisson s4fu12_count i.exp encoun , vce(robust) irr	
		
		poisson s1fu12_count i.exp encoun i.mob, vce(robust) irr
		poisson s2fu12_count i.exp encoun i.mob, vce(robust) irr
		poisson s3fu12_count i.exp encoun i.mob, vce(robust) irr
		poisson s4fu12_count i.exp encoun i.mob, vce(robust) irr	
		
		poisson s1fu12_count i.exp encoun mob, vce(robust) irr
		poisson s2fu12_count i.exp encoun mob, vce(robust) irr
		poisson s3fu12_count i.exp encoun mob, vce(robust) irr
		poisson s4fu12_count i.exp encoun mob, vce(robust) irr	
		
		/*

		
		poisson s1fu12_count i.exp encoun i.region , vce(robust) irr
		poisson s2fu12_count i.exp encoun i.region , vce(robust) irr
		poisson s3fu12_count i.exp encoun i.region , vce(robust) irr
		poisson s4fu12_count i.exp encoun i.region , vce(robust) irr	
	
		
		poisson s1fu12_count i.exp encoun i.mob i.region , vce(robust) irr
		poisson s2fu12_count i.exp encoun i.mob i.region , vce(robust) irr
		poisson s3fu12_count i.exp encoun i.mob i.region , vce(robust) irr
		poisson s4fu12_count i.exp encoun i.mob i.region , vce(robust) irr	
		

		
		poisson s1fu12_count i.exp encoun i.stagemax_imm , vce(robust) irr
		poisson s2fu12_count i.exp encoun i.stagemax_imm , vce(robust) irr
		poisson s3fu12_count i.exp encoun i.stagemax_imm , vce(robust) irr
		poisson s4fu12_count i.exp encoun i.stagemax_imm , vce(robust) irr	
		*/
		

		poisson s1fu6_count i.exp encoun, vce(robust) irr
		poisson s2fu6_count i.exp encoun, vce(robust) irr
		poisson s3fu6_count i.exp encoun, vce(robust) irr
		poisson s4fu6_count i.exp encoun, vce(robust) irr
		
		poisson s1fu6_count i.exp encoun i.mob, vce(robust) irr
		poisson s2fu6_count i.exp encoun i.mob, vce(robust) irr
		poisson s3fu6_count i.exp encoun i.mob, vce(robust) irr
		poisson s4fu6_count i.exp encoun i.mob, vce(robust) irr
		
		poisson s1fu6_count i.exp encoun mob, vce(robust) irr
		poisson s2fu6_count i.exp encoun mob, vce(robust) irr
		poisson s3fu6_count i.exp encoun mob, vce(robust) irr
		poisson s4fu6_count i.exp encoun mob, vce(robust) irr

***********************************************
*cox - symptoms - adjusted

	*for primary
		stset s1fu12_tte, failure(s1fu12)
		stcox i.exp encoun, strata(yob)
		stcox i.exp encoun i.yob
		stset s1fu6_tte, failure(s1fu6)
		stcox i.exp encoun, strata(yob)	
		
		stset s2fu12_tte, failure(s2fu12)
		stcox i.exp encoun, strata(yob)
		stcox i.exp encoun i.yob
		stset s2fu6_tte, failure(s2fu6)
		stcox i.exp encoun, strata(yob)	
		
		stset s3fu12_tte, failure(s3fu12)
		stcox i.exp encoun, strata(yob)
		stcox i.exp encoun i.yob
		stset s3fu6_tte, failure(s3fu6)
		stcox i.exp encoun, strata(yob)	
		
		stset s4fu12_tte, failure(s4fu12)
		stcox i.exp encoun, strata(yob)
		stcox i.exp encoun i.yob
		stset s4fu6_tte, failure(s4fu6)
		stcox i.exp encoun, strata(yob)	
		
	*for sens	
		stset s1fu12_tte, failure(s1fu12)
		stcox i.exp encoun
		stset s1fu6_tte, failure(s1fu6)
		stcox i.exp encoun

		stset s2fu12_tte, failure(s2fu12)
		stcox i.exp encoun
		stset s2fu6_tte, failure(s2fu6)
		stcox i.exp encoun	
		
		stset s3fu12_tte, failure(s3fu12)
		stcox i.exp encoun
		stset s3fu6_tte, failure(s3fu6)
		stcox i.exp encoun
		
		stset s4fu12_tte, failure(s4fu12)
		stcox i.exp encoun
		stset s4fu6_tte, failure(s4fu6)
		stcox i.exp encoun

	
********************************************************************************		
		
				*replace pain_tte6 = pain_tte6+1
				stset pain_tte6, failure(pain_outcome6)
				stset pain_tte12, failure(pain_outcome12)
				*stset pain_tte6
				sts graph, na
				
				sts test exp, logrank
				sts graph, by(exp) 
				
				sts test yob, logrank
				sts graph, by(yob)
				
				sts test region, logrank
				sts graph, by(region)
				
				sts test mob, logrank
				sts graph, by(mob)
				
				sts test imd2015_5, logrank
				sts graph, by(imd2015_5)
				
				sts test contra, logrank
				sts graph, by(contra)
				
				sts test ethnicity, logrank
				sts graph, by(ethnicity)
				
			
				stcox bmi, nohr
				stcox weight, nohr
				stcox height, nohr
				stcox BPdiastolic, nohr
				stcox BPsystolic, nohr
				stcox pulse, nohr
				stcox hospcount_beforece
				stcox conscount_beforece
				stcox encounters
				
				stcox i.exp encounters, strata(yob)
				

				
				stcox i.exp encounters
				stcox i.exp encounters i.yob
				
				quietly stcox conscount_beforece i.exp i.contra, nohr strata(yob) mgale(mg)
				predict cs, csnell
				
				stset cs, failure(pain_outcome12)
				sts generate H = na
				line H cs cs, sort xlab(0 1 to 4) ylab(0 1 to 4)
				drop mg
				
		*poisson/nbreg/logit	
		
				sampsi .000637988 0.000183807, n1(10972) n2(10881) onesided
			
				sampsi .001002552 0.000735227, n1(10972) n2(10881) onesided

				
				hist pain_count12
				summarize  pain_count12, detail
				tab pain_count12 exp
				tab pain_outcome12 exp
				
				
				poisson pain_count12 i.exp, vce(robust)
				poisson pain_count12 i.exp
				poisson pain_count12 i.exp i.yob region, vce(robust)
				estat gof
				poisson, irr
				margins exp, atmeans
				nbreg pain_count12 i.exp
				zinb pain_count12 i.exp , inflate(patid) robust

				logit pain_outcome12 i.exp 
				logistic pain_outcome12 i.exp 
				tabulate pain_outcome12 exp , row nofreq chi2
				tabulate pain_outcome12 exp  if region!=11 & region!=12 & region!=13, all exact

				*glm poisson model!!!!
				glm pain_count12 i.exp , nolog family(poisson) link(log) vce(robust) 
				glm pain_count12 i.exp , nolog family(poisson) link(log) 
				glm pain_count12 i.exp , nolog family(poisson) link(log) scale(x2)
				*glm pain_count12 i.exp , nolog family(poisson) link(log) vce(cluster patid)
				glm pain_count12 i.exp , nolog family(poisson) link(log) vce(cluster yob) 
				glm pain_count12 i.exp , nolog family(poisson) link(log) vce(cluster mob)

				glm pain_count12 i.exp ib7.mob, nolog family(poisson) link(log) vce(robust) vsquish
				glm pain_count12 i.exp ib8.mob, nolog family(poisson) link(log) vce(robust) vsquish
				glm pain_count12 i.yob, nolog family(poisson) link(log) vce(cluster patid) vsquish
				margins yob, atmeans
				glm pain_count12 i.mob, nolog family(poisson) link(log) vce(cluster patid) vsquish
				glm pain_count12 i.exp i.region, nolog family(poisson) link(log) vce(cluster patid) vsquish

				* glm nbinom model!!!

				glm pain_eventall_count12 i.primary_exp if region!=11 & region!=12 & region!=13, nolog family(nbinom) link(log) vce(robust) 

				tab pain_eventall_count12 yob if region!=11 & region!=12 & region!=13
				tab pain_eventall_count12 mob if region!=11 & region!=12 & region!=13, sum(pain_eventall_count12)

				logit pain_flag12 i.primary_exp if region!=11 & region!=12 & region!=13
				logistic pain_flag12 i.primary_exp if region!=11 & region!=12 & region!=13
				tabulate pain_flag12 primary_exp  if region!=11 & region!=12 & region!=13, row nofreq chi2
				tabulate pain_flag12 primary_exp  if region!=11 & region!=12 & region!=13, all exact

				tabulate pain_flag12 primary_exp  if region!=11 & region!=12 & region!=13, col nofreq chi2

				power twoproportions 0.064 0.055, n(21853)
********************************************************************************

/*
				stset muscular_tte6, failure(muscular_outcome6)
				stcox i.exp encounters, strata(yob)
				stset muscular_tte12, failure(muscular_outcome12)
				stcox i.exp encounters, strata(yob)
				
				stset pain_tte6, failure(pain_outcome6)
				stcox i.exp encounters, strata(yob)
				stset pain_tte12, failure(pain_outcome12)
				stcox i.exp encounters, strata(yob)
				
				stset headache_tte6, failure(headache_outcome6)
				stcox i.exp encounters, strata(yob)
				stset headache_tte12, failure(headache_outcome12)
				stcox i.exp encounters, strata(yob)
				
				stset gastro_tte6, failure(gastro_outcome6)
				stcox i.exp encounters, strata(yob)
				stset gastro_tte12, failure(gastro_outcome12)
				stcox i.exp encounters, strata(yob)
				
*/


/*
		
		poisson muscular_count6 i.exp yob encoun, vce(robust) irr
		poisson muscular_count12 i.exp i.yob encoun, vce(robust) irr
		poisson pain_count6 i.exp i.yob encoun, vce(robust) irr
		poisson pain_count12 i.exp i.yob encoun, vce(robust) irr
		poisson headache_count6 i.exp i.yob encoun, vce(robust) irr
		poisson headache_count12 i.exp i.yob encoun, vce(robust) irr
		poisson gastro_count6 i.exp i.yob encoun, vce(robust) irr
		poisson gastro_count12 i.exp i.yob encoun, vce(robust) irr
	
*/


/*
		
		

		poisson muscular_count6 i.exp, vce(robust) irr
		poisson muscular_count12 i.exp, vce(robust) irr
		poisson pain_count6 i.exp, vce(robust) irr
		poisson pain_count12 i.exp, vce(robust) irr
		poisson headache_count6 i.exp, vce(robust) irr
		poisson headache_count12 i.exp, vce(robust) irr
		poisson gastro_count6 i.exp, vce(robust) irr
		poisson gastro_count12 i.exp, vce(robust) irr
*/



/*

		logistic pots_outcome6 i.exp 
		logistic pots_outcome12 i.exp 
		logistic crps_outcome6 i.exp
		logistic crps_outcome12 i.exp
		logistic ftg_outcome6 i.exp
		logistic ftg_outcome12 i.exp
				
		logistic muscular_outcome6 i.exp 
		logistic muscular_outcome12 i.exp
		logistic pain_outcome6 i.exp 
		logistic pain_outcome12 i.exp 
		logistic headache_outcome6 i.exp 
		logistic headache_outcome12 i.exp 
		logistic gastro_outcome6 i.exp 
		logistic gastro_outcome12 i.exp 

*/



	/*
	
	tab pots_outcome exp if pots_event_date >= ce_date
	tab pots_outcome exp if  pots_event_date >= ce_date & pots_event_date <= fu12_date
	tab pots_outcome exp if  pots_event_date >= ce_date & pots_event_date <= fu6_date

	tab crps_outcome exp
	tab crps_outcome exp if crps_event_date >= ce_date
	tab crps_outcome exp if  crps_event_date >= ce_date & crps_event_date <= fu12_date
	tab crps_outcome exp if  crps_event_date >= ce_date & crps_event_date <= fu6_date
	
	tab ftg_outcome exp
	tab ftg_outcome exp if ftg_event_date >= ce_date
	tab ftg_outcome exp if ftg_event_date >= ce_date & ftg_event_date <= fu12_date
	tab ftg_outcome exp if ftg_event_date >= ce_date & ftg_event_date <= fu6_date
	
	
	tab pain_outcome exp
	tab pain_outcome exp if pain_event_date >= ce_date
	tab pain_outcome exp if pain_event_date >= ce_date & pain_event_date <= fu12_date
	tab pain_outcome exp if pain_event_date >= ce_date & pain_event_date <= fu6_date
	
	tab gastro_outcome exp
	tab gastro_outcome exp if gastro_event_date >= ce_date
	tab gastro_outcome exp if gastro_event_date >= ce_date & gastro_event_date <= fu12_date
	tab gastro_outcome exp if gastro_event_date >= ce_date & gastro_event_date <= fu6_date
	*/



/*

***********************************************
*muscular

	tab muscular_outcome6 exp
	tab muscular_count6 exp
	hist muscular_count6
	
	tab muscular_outcome12 exp
	tab muscular_count12 exp
	hist muscular_count12
	
	bys exp: sum muscular_tte6 
	tab exp,  sum(muscular_tte6)
	tab muscular_tte6 exp
	
	bys exp: sum muscular_tte12 
	tab exp,  sum(muscular_tte12)
	tab muscular_tte12 exp

***********************************************
	*pain
	tab pain_outcome6 exp
	tab pain_count6 exp
	hist pain_count6
	
	tab pain_outcome12 exp
	tab pain_count12 exp
	hist pain_count12
	
	bys exp: sum pain_tte6 
	tab exp,  sum(pain_tte6)
	tab pain_tte6 exp
	
	bys exp: sum pain_tte12 
	tab exp,  sum(pain_tte12)
	tab pain_tte12 exp
	
		
	/*
	tab painn_outcome12 exp
	tab painn_count12 exp
	*/
	
***********************************************
	*headache
	tab headache_outcome6 exp
	tab headache_count6 exp
	hist headache_count6
	
	tab headache_outcome12 exp
	tab headache_count12 exp
	hist headache_count12
	
	bys exp: sum headache_tte6 
	tab exp,  sum(headache_tte6)
	tab headache_tte6 exp
	
	bys exp: sum headache_tte12 
	tab exp,  sum(headache_tte12)
	tab headache_tte12 exp
	
***********************************************
	*gastro
	tab gastro_outcome6 exp
	tab gastro_count6 exp
	hist gastro_count6
	
	tab gastro_outcome12 exp
	tab gastro_count12 exp
	hist gastro_count12
	
	bys exp: sum gastro_tte6 
	tab exp,  sum(gastro_tte6)
	tab gastro_tte6 exp
	
	bys exp: sum gastro_tte12 
	tab exp,  sum(gastro_tte12)
	tab gastro_tte12 exp
	

*/
