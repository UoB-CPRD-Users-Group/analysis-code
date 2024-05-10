tab pain_pre1ce, missing
tab pain_post1ce if pain_pre1ce==., missing

pain_pre_date1ce 
pain_post_date1ce

*crps
*pots


****************************************************************************
*crps* 

tab crps_pre1ce, missing  
*crps_pre_date1ce 
tab crps_post1ce , missing  
*crps_post_date1ce 
tab crps_post1ce if crps_pre1ce==., missing  

*no crps observations (new cases within followup period)
capture drop crps_cefu
gen crps_cefu=1 if crps_post_date1ce<primary_fu_date & crps_pre1ce==.
tab crps_cefu, missing

****************************************************************************
*pots+orthostatic intolerance* 

tab pots_pre1ce , missing  
*pots_pre_date1ce 
tab pots_post1ce , missing  
*pots_post_date1ce
tab pots_post1ce if pots_pre1ce==., missing  

*no pots observations (new cases within followup period)
capture drop pots_cefu
gen pots_cefu=1 if pots_post_date1ce<primary_fu_date & pots_pre1ce==.
tab pots_cefu, missing





****************************************************************************
capture drop fup_dur
gen fup_dur=primary_fu_date-primary_ce_date+184
gen fup_dur=365
tab pots_post_date1ce primary_fu_date if pots_post1ce!=.

*no pots observations (new case

primary_ce_date primary_fu_date

* generating time to event variables
capture drop ttcrps
foreach x in crps {
	gen tt`x'=`x'_post_date1ce - primary_ce_date
	count if tt`x'<=0
	replace tt`x'=fup_dur if `x'_post1ce==.
	replace tt`x'=1 if tt`x'==0
	replace `x'_post1ce=0 if `x'_post1ce==.
	replace `x'_pre1ce=0 if `x'_pre1ce==.	
}

capture drop ttcrps
gen ttcrps=crps_post_date1ce- primary_ce_date
capture drop ttpots
gen ttpots=pots_post_date1ce- primary_ce_date

tab ttcrps crps_post_date1ce, missing
tab ttcrps crps_post_date1ce if primary_exp==0, missing
tab ttcrps crps_post_date1ce if primary_exp==1, missing
tab primary_fu_date crps_post_date1ce if primary_exp==0, missing
tab primary_fu_date crps_post_date1ce if primary_exp==1, missing

tab ttpots pots_post_date1ce, missing
tab ttpots pots_post_date1ce if primary_exp==0, missing
tab ttpots pots_post_date1ce if primary_exp==1, missing
tab primary_fu_date pots_post_date1ce if primary_exp==0, missing
tab primary_fu_date pots_post_date1ce if primary_exp==1, missing

**********************************************************************************


capture drop temp
gen temp=1 if cvd_post==1
replace temp=0 if cvd_post==0 & cvd_pre==0

gen temp2=1

gen score_floor=floor(score_first)
tab score_floor
bysort score_floor: egen temp3=total(temp)
bysort score_floor: egen temp4=total(temp2)
gen cvd_prob=temp3/temp4
drop temp3 temp4
hist cvd_prob
scatter cvd_prob score_floor, ytitle("Probability of CVD") xtitle("QRISK score")
scatter cvd_prob score_floor if score_first<40, yscale(range(0 0.3)) ylabel(0(0.1)0.3) ytitle("Probability of CVD") xtitle("QRISK score")





