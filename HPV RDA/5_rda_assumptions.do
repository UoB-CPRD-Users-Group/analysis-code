
cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

use "data_analysis_primary", clear


/*
*scotland 3423
drop if region==12
*wales 3787
drop if region==13
*northern ireland 1079
drop if region==11
*/


/*
keep if region==12 | region==13

keep if region==12 
*scotland 3423

keep if region==13
*wales 3787

*/

/*
*11411 exposed (7 and 8)
tab yob mob if primary_exp==1
*111521 unexposed (9 and 10)
tab yob mob if primary_exp==0
*/

********************************************************************************
* Assumption 1: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

*gen vaccinehpv1=1 if event_date_imm_firstdate>=primary_ce_date & event_date_imm_firstdate<primary_fu_date 
*& stage_imm_firstdate=2
*replace vaccinehpv1=0 if  (event_date_imm_firstdate<primary_ce_date | event_date_imm_firstdate>=primary_fu_date) & event_date_imm_firstdate!=.

*bysort patid: egen temp=total(vaccinehpv1)
*sort patid primary_ce_date
*tab vaccinehpv1
*replace vaccinehpv1=. if vaccinehpv1==1 & patid==patid[_n+1] & temp>1 /*Im not sure about this bit. Am dropping people who have statins more than once within 60 days but what about people who have more than one qrisk but no statins? Might have to go back to just first qrisk for this assumptions bit*/
*

/*
tostring yob, gen(yob1)
tostring mob, gen(mob1)
gen birthdate = "01/"+mob1+"/"+yob1
gen birth_date = date(birthdate, "DMY")
format %d birth_date
drop yob1 mob1
drop birthdate
*/
/*
tab primary_exp
bysort primary_exp: egen temp3=total(vaccinehpv1)
bysort primary_exp: egen temp4=total(temp)
capture drop stat_prob1
gen stat_prob1=temp3/temp4
drop temp3 temp4
hist stat_prob1
tab vaccinehpv1 temp
*/


capture drop temp
*all patients
gen temp=1
*only those with vaccination record
*gen temp=1 if event_date_imm_firstdate!=.

tab mob
bysort mob: egen temp3=total(vaccinehpv12)
bysort mob: egen temp4=total(temp)
capture drop stat_prob2
gen stat_prob2=temp3/temp4
drop temp3 temp4
*hist stat_prob2

scatter stat_prob2 mob, yscale(range(0 0.8)) ylabel(0(0.1)0.8) ytitle("Probability of receiving hpv vaccine within follow up") xtitle("birth month")
*scatter stat_prob primary_exp, yscale(range(0 0.4)) ylabel(0(0.1)0.4) ytitle("Probability of receiving hpv vaccine within follow up period") xtitle("exposure group")
* There is a clear discontinuity between months. Jump from approx 0.2 to 0.3)

tab mob stat_prob2

tab stagecount_imm if vaccinehpv6==1
tab stagemax_imm if vaccinehpv6==1
tab stage_imm_firstdate 
*if vaccinehpv12==1

tab stage_imm_firststage 
*if vaccinehpv12==1

********************************************************************************
* Assumption 1 by birth year category: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)
capture drop temp
gen temp=1
*gen temp=1 if event_date_imm_firstdate!=.

bysort yob mob: egen temp3=total(vaccinehpv1)
bysort yob mob: egen temp4=total(temp)
capture drop stat_prob_yob
gen stat_prob_yob=temp3/temp4
drop temp3 temp4
hist stat_prob_yob
scatter stat_prob_yob mob, by(yob) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months and years. Jump from approx 0.1 to 0.3)

********************************************************************************
* Assumption 1 by region category: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)
capture drop temp
gen temp=1
*gen temp=1 if event_date_imm_firstdate!=.

bysort region mob: egen temp3=total(vaccinehpv1)
bysort region mob: egen temp4=total(temp)
capture drop stat_prob_region
gen stat_prob_region=temp3/temp4
capture drop temp3 temp4
hist stat_prob_region
scatter stat_prob_region mob, by(region) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
*NI, Scotland does not show discontinuity, however Wales does and all English regions

********************************************************************************
* Assumption 1 by birth year and region category: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1
*gen temp=1 if event_date_imm_firstdate!=.

bysort yob region mob: egen temp3=total(vaccinehpv1)
bysort yob region mob: egen temp4=total(temp)
capture drop stat_prob_yobregion
gen stat_prob_yobregion=temp3/temp4
capture drop temp3 temp4
hist stat_prob_yobregion
scatter stat_prob_yobregion mob, by(region yob) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is discontinuity between some regions and years. Jump from approx 0.01 to 0.3)

*some areas have very small or no discontinuity in years 2003-2004-2005: North East, West Midlands, East of England,
*other areas have no discontinuity in year 2005: Yorkshire and the Humber, South Central, London
*no discontinuity at any year: Scotland and Norther Ireland.
*the remaining areas have discontinuity in all years: North West, East Midlands, South West, South East Coast, Wales
*not all areas have all years: East midlands 2000-2001 only
*looking at actual count of vaccination records aailable there is a large drop in year 2005, perhaps record are not being fed through yet to Vision from external sources (school?)

/*
tab region yob if vaccinehpv1!=.
tab region yob if vaccinehpv1==1
tab region yob if vaccinehpv1==1 & mob==10
tab region yob if vaccinehpv1==1 & mob==9
tab region yob if vaccinehpv1==1 & mob==8
tab region yob if vaccinehpv1==1 & mob==7
tab region yob if vaccinehpv1==0
tab region yob if vaccinehpv1==0 & mob==10
tab region yob if vaccinehpv1==0 & mob==9
tab region yob if vaccinehpv1==0 & mob==8
tab region yob if vaccinehpv1==0 & mob==7
tab region yob 
*/

********************************************************************************
* Assumption 1 by imd: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1

bysort imd2015_5 mob: egen temp3=total(vaccinehpv1)
bysort imd2015_5 mob: egen temp4=total(temp)
capture drop stat_prob_imd
gen stat_prob_imd=temp3/temp4
drop temp3 temp4
hist stat_prob_imd
scatter stat_prob_imd mob, by(imd2015_5) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months by imd (jump from approx 0.2 to 0.3)


********************************************************************************
* Assumption 1 by ethnicity: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1

bysort ethnicity mob: egen temp3=total(vaccinehpv1)
bysort ethnicity mob: egen temp4=total(temp)
capture drop stat_prob_eth
gen stat_prob_eth=temp3/temp4
drop temp3 temp4
hist stat_prob_eth
scatter stat_prob_eth mob, by(ethnicity) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months by ethinicty (jump from approx 0.2 to 0.4)

********************************************************************************
* Assumption 1 by linkage eligibility: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1

bysort hes_e mob: egen temp3=total(vaccinehpv1)
bysort hes_e mob: egen temp4=total(temp)
capture drop stat_prob_hese
gen stat_prob_hese=temp3/temp4
drop temp3 temp4
hist stat_prob_hese
scatter stat_prob_hese mob if region!=12&region!=12, by(hes_e) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months by ethinicty (jump from approx 0.2 to 0.4)

********************************************************************************
* Assumption 1 by linkage eligibility region: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1

bysort hes_e region mob: egen temp3=total(vaccinehpv1)
bysort hes_e region mob: egen temp4=total(temp)
capture drop stat_prob_hesereg
gen stat_prob_hesereg=temp3/temp4
drop temp3 temp4
hist stat_prob_hesereg
scatter stat_prob_hesereg mob if region!=12&region!=12, by(hes_e region) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months by ethinicty (jump from approx 0.2 to 0.4)

********************************************************************************
* Assumption 1 by linkage eligibility year: there is a discontinuity in the probability of exposure at the cut-off
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

capture drop temp
gen temp=1

bysort hes_e yob mob: egen temp3=total(vaccinehpv1)
bysort hes_e yob mob: egen temp4=total(temp)
capture drop stat_prob_heseyob
gen stat_prob_heseyob=temp3/temp4
drop temp3 temp4
*hist stat_prob_heseyob
scatter stat_prob_heseyob mob if region!=12&region!=12, by(hes_e yob) yscale(range(0 0.9)) ylabel(0(0.1)0.9) ytitle("Probability of receiving hpv vaccine within FU period") xtitle("birth_month") xline(19.5,lpattern(dash))
* There is a clear discontinuity between months by ethinicty (jump from approx 0.2 to 0.4)




********************************************************************************
* Assumption 1 by ????????: 
* plotting probability of receiving vaccine hpv (within 6 months from cohort entry in September) against birth month(Jul-Oct)

**** *BMI
*** *weight
*** *height
*** *BP
*** *heartrate
*** *number hosp
*** *number gp cons
*** *contraindications


********************************************************************************
* Assumption 2: individuals’ value of the forcing variable was not manipulated
* It is impossible for patients to manipulate their birth month
hist mob
*similar size group by month

********************************************************************************
* Assumption 3: exposure groups are exchangeable around the cut-off
graph bar (sum) temp, over(yob) over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(region) over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(imd2015_5) over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(ethnicity) over(mob) asyvars stack per ytitle("%")
*graph bar (sum) temp, over(vaccinehpv1) over(mob) asyvars stack per ytitle("%")

graph bar (mean) weight, over(exp) over(mob) asyvars stack per ytitle("%")


********************************************************************************
* Assumption 4: the outcome probability is continuous at the cut-off in the absence of the intervention
* Very difficult to test as we don't have an equivelent population...
* Will look at the outcomes once I have that data, however if there is a dicontinuation this will suggest an effect of the intervention rather than rejecting the assumption...


gen pain_pre1cem=pain_pre1ce
replace pain_pre1cem=0 if pain_pre1cem==.
gen pain_post1cem=pain_post1ce
replace pain_post1cem=0 if pain_post1cem==.
*very similar can't spot any differences


graph bar (sum) temp, over(pain_pre1cem) over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(pain_post1cem) over(mob) asyvars stack per ytitle("%")


