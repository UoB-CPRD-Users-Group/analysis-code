
cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

*RD combined (YS primary 12)

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

*RD meta (YS primary)

	use logisticrd_primary_meta_new, clear
	

*OR combined (YS and Y primary 6 and 12)
	
	use logistic_primary_comb, clear
	
*OR meta (YS and Y, primary 6 and 12 + l 3d nh)

	use logistic_primary_meta_new, clear

*OR meta (YS and Y, sens1 and sens2 6 and 12)

	use logistic_sens_new, clear
	
	
	
	use logistic_results_all_new, clear
	
	
	use  analysis_YSprimary.dta ,clear
	
	tab mob exp if yob==2000
	
	use  analysis_YSsens1.dta ,clear
	
	use  analysis_YSsens2.dta ,clear
	
	tab mob s1fu12 if exp==1
	
	bys exp: tab yob s1fu12 if ch_s1==1
	
****************************************************************************
* sens c d e
	
use logistic_results_all_new, clear

drop if estmt=="HR"

drop if model!="adj"

drop if outcome=="---Neuromuscular symptoms---"

drop if  cohort=="sens1" 
drop if  cohort=="sens2" 

drop if analysis2=="combined"

drop if fu==6 
drop if codelevel=="Y" & cohort_type!="1a"
drop if fu==6 & codelevel=="Y" & cohort_type=="1a"

drop if cohort_type=="1a"

*sens figure
metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(outcome) nosubgroup  sortby (cohort_type outcome) ///
force xtick(0.75, 1.00, 1.25, 1.5, 1.75) effect(OR) lcols(cohort_type)    rcols(pvalue  Events_Exposed Events_Unexposed) astext(60) texts(190) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
nooverall 
 
****************************************************************************
*sens1 and sens2
	
use logistic_results_all_new, clear

drop if model!="adj"

drop if  dataset=="primary" 

drop if fu==6 

drop if codelevel=="Y"


*sens figure
 metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) ///
by(outcome) nosubgroup  
sortby (cohort_type outcome) ///
force xtick(0.75, 1.00, 1.25, 1.5, 1.75) effect(OR) lcols(cohort_type )    rcols(pvalue  Events_Exposed Events_Unexposed) astext(60) texts(190) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
 nooverall 

 
****************************************************************************

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
force xtick(0.75, 1.00, 1.25, 1.5, 1.75) effect(OR) lcols(cohort_type codelevel fu)    rcols(pvalue  Events_Exposed Events_Unexposed) astext(60) texts(140) ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
 nooverall 
 
 
  
****************************************************************************
*main analysis - meta YS 12 adj

use logistic_results_all_new, clear

drop if codelevel=="Y"
drop if model!="adj"
drop if fu==6
drop if cohort!="primary"
drop if analysis2=="combined"
drop if outcome=="---Neuromuscular symptoms---"

replace outcome="Gastrointestinal" if outcome=="---Gastrointestinal symptoms---"
replace outcome="Headache/migraine" if outcome=="---Headache/migraine symptoms---"
replace outcome="Pain" if outcome=="---Pain symptoms---"
replace outcome="Neuromuscular symptoms" if outcome=="---Neuromuscular symptoms---"

rename outcome Symptoms

replace cohort_type="----Cohort 1*" if cohort_type=="1a"

 metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.65, 0.75, 1.00, 1.25, 1.75)  by(cohort_type) nosubgroup sortby (Symptoms) ///
force xtick(0.75, 1.00, 1.25) effect(OR) lcols(Symptoms) rcols(pvalue  Events_Exposed Events_Unexposed)  astext(60) texts(210)  ///
xsize(10) ysize(6) favours (Exposure decreases odds of outcome   #   Exposure increases odds of outcome) classic ///
note ("* estimates from random effects meta-analyses across birth years for main study population," ///
"  born Jul/Aug 2000-2005 (exposed to quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (unexposed)") ///
 nooverall 
 
  
****************************************************************************
*sens1 and sens2
	
use logistic_results_all_new, clear

label variable Events_Exposed "Events/Eligible"
label variable Events_Unexposed "Events/Ineligible"


drop if model!="adj"
drop if fu==6 
drop if codelevel=="Y"

keep if  cohort=="sens1"|cohort=="sens2"|cohort=="primary"
drop if cohort=="primary" & analysis2=="combined"

*drop if outcome=="---Neuromuscular symptoms---"

replace outcome="Gastrointestinal" if outcome=="---Gastrointestinal symptoms---"
replace outcome="Headache/migraine" if outcome=="---Headache/migraine symptoms---"
replace outcome="Pain" if outcome=="---Pain symptoms---"
replace outcome="Neuromuscular" if outcome=="---Neuromuscular symptoms---"

rename outcome Symptoms


replace cohort_type="----Cohort 1*" if cohort_type=="1a"
replace cohort_type="----Cohort 2**" if cohort_type=="2"
replace cohort_type="----Cohort 3***" if cohort_type=="3"

*sens figure
 metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25, 1.5, 1.75) by(cohort_type) nosubgroup  sortby (Symptoms) ///
force xtick(0.75, 1.00, 1.25, 1.5, 1.75) effect(OR) lcols(Symptoms)    rcols(pvalue  Events_Exposed Events_Unexposed) astext(60) texts(180) ///
xsize(10) ysize(6) favours (Eligibility decreases odds of outcome   #   Eligibility increases odds of outcome) classic ///
note ("*    born Jul/Aug 2000-2005 (eligible for quadrivalent HPV vaccination programme) vs Sep/Oct 2000-2005 (ineligible)" ///
"**  born in 1996 (eligible to bivalent HPV vaccination programme) vs 1994 (ineligible)" ///
"*** born in 2000 (eligible to quadrivalent HPV vaccination programme) vs 1998 (eligible to bivalent HPV vaccination programme)" ) ///
 nooverall 

 
  
****************************************************************************
*main analysis - meta YS 12 adj

use logistic_results_all_new, clear

label variable Events_Exposed "Events/Eligible"
label variable Events_Unexposed "Events/Ineligible"


drop if codelevel=="Y"
drop if model!="adj"
drop if fu==6
drop if cohort=="primary"
drop if cohort=="sens1"
drop if cohort=="sens2"
drop if analysis2=="combined"
drop if outcome=="---Neuromuscular symptoms---"

replace outcome="Gastrointestinal" if outcome=="---Gastrointestinal symptoms---"
replace outcome="Headache/migraine" if outcome=="---Headache/migraine symptoms---"
replace outcome="Pain" if outcome=="---Pain symptoms---"
replace outcome="Neuromuscular symptoms" if outcome=="---Neuromuscular symptoms---"

rename outcome Symptoms

replace cohort_type="----Cohort 1a*" if cohort_type=="1c"
*no hes

replace cohort_type="----Cohort 1b**" if cohort_type=="1d"
*linked only

replace cohort_type="----Cohort 1c***" if cohort_type=="1e"
* 3 doses

sort cohort_type Symptoms

 metan logES logci_lowES logci_uppES , ///
fixedi eform xlabel(0.5, 0.75, 1.00, 1.25)  by(cohort_type) nosubgroup sortby (cohort_type Symptoms) ///
force xtick(0.5, 0.75, 1.00, 1.25) effect(OR) lcols(Symptoms) rcols(pvalue  Events_Exposed Events_Unexposed)  astext(60) texts(190)  ///
xsize(10) ysize(6) favours (Eligibility decreases odds of outcome # Eligibility increases odds of outcome) classic ///
note ("*   main study population with no outcomes from HES, born Jul/Aug 2000-2005 (eligible) vs Sep/Oct 2000-2005 (ineligible)" ///
"**  subgroup of main study population with linkage to HES, born Jul/Aug 2000-2005 (eligible) vs Sep/Oct 2000-2005 (ineligible)" ///
"*** subgroup of main study population eligible to 3-dose vaccination schedule, born Jul/Aug 2000-2001 (eligible) vs Sep/Oct 2000-2001 (ineligible)" ) ///
 nooverall 
 