cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

use analysis_primary.dta, clear

*****A1
capture drop temp
gen temp=1

capture drop temp1
capture drop temp2
gen temp1=1 if event_date_imm_firstdate >=ce_date & event_date_imm_firstdate<=fu6_date
gen temp2=1 if event_date_imm_firstdate >=ce_date & event_date_imm_firstdate<=fu12_date
tab mob temp1
tab mob temp2

capture drop temp3
capture drop temp4
bysort mob: egen temp3=total(temp2)
bysort mob: egen temp4=total(temp)

capture drop stat_prob2
gen stat_prob2=temp3/temp4

scatter stat_prob2 mob, yscale(range(0 0.8)) ylabel(0(0.1)0.8) ytitle("Probability of receiving hpv vaccine within follow up") xtitle("birth month")
*scatter stat_prob primary_exp, yscale(range(0 0.4)) ylabel(0(0.1)0.4) ytitle("Probability of receiving hpv vaccine within follow up period") xtitle("exposure group")
* There is a clear discontinuity between months. Jump from approx 0.2 to 0.3)

tab stat_prob2 mob

*****A2

****A3
tab mob, sum (weight)
tab mob, sum (height)
tab mob, sum (weight_diff_ce_event)
tab mob, sum (height_diff_ce_event)



****A4
graph bar (sum) pain_outcome12, over(mob) 
asyvars stack per ytitle("%")
graph bar (sum) temp,  over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(pain_outcome12) over(mob) asyvars stack per ytitle("%")
graph bar (sum) temp, over(pain_post1cem) over(mob) asyvars stack per ytitle("%")

tab muscular_outcome12

tab mob muscular_outcome12 
tab mob, sum (height)
tab pain_outcome12 mob
tab headache_outcome12 mob
tab gastro_outcome12 mob

scatter gastro_outcome12 mob

******************************************************
*power

power twoproportions 0.00024,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.0003,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.0004,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.0005,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.001,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.005,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.01,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.05,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.1,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.15,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.20,  n1(10972) n2(10881) power (0.8)

power twoproportions (0.0003(0.0001)0.2) ,  n1(10972) n2(10881) power (0.8) saving(powertwo)

power twoproportions 0.0001 (0.00011(0.00001)0.005) ,  n1(10972) n2(10881) saving(powertwo2)
use powertwo2, replace

scatter power delta

power twoproportions 0.0002 (0.00021(0.00001)0.005) ,  n1(10972) n2(10881) 

use powertwo, replace
scatter p1 delta

power logrank 0.999, n(21853) hratio(0.0001(0.00001)0.001) 



saving(mypower3)




	foreach v in "0001" 0005 001 005 01 1 15 20 { 
	power twoproportions 0.`v'0,  n1(10972) n2(10881) power (0.8)
	} 
	

power twoproportions p1 , n(numlist) power(numlist)

power twoproportions 0.01, n(21853) power (0.8)

*n1 control
*n2 case
power twoproportions 0.01,  n1(10972) n2(10881) power (0.8)
power twoproportions 0.01,  n1(10972) n2(10881) power (0.8), effect(oratio)





cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\codes"
set seed 1234

run poispow 1000 10 .2 .5 1.0 0.0
