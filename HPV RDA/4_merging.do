********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"


********************************************************************************
********************************************************************************
********************************************************************************

*prim main/prim no hes
	global codetype "YS"
	global maindata "data_CPRD_Patient_Practice_primary"
	global cefu "data_patient_primary_cefu"
	global i "primary"

	global codetype "Y"
	global maindata "data_CPRD_Patient_Practice_primary"
	global cefu "data_patient_primary_cefu"
	global i "primary"

*prim link
	global codetype "YS"
	global maindata "data_CPRD_Patient_Practice_primary_link"
	global cefu "data_patient_primary_link_cefu"
	global i "primary_link"

	global codetype "Y"
	global maindata "data_CPRD_Patient_Practice_primary_link"
	global cefu "data_patient_primary_link_cefu"
	global i "primary_link"


*prim 3d
	global codetype "YS"
	global maindata "data_CPRD_Patient_Practice_primary_3d"
	global cefu "data_patient_primary_3d_cefu"
	global i "primary_3d"

	global codetype "Y"
	global maindata "data_CPRD_Patient_Practice_primary_3d"
	global cefu "data_patient_primary_3d_cefu"
	global i "primary_3d"

*sens1
	global codetype "YS"
	global maindata "data_CPRD_Patient_Practice_sens1"
	global cefu "data_patient_sens1_cefu3"
	global i "sens1"

	global codetype "Y"
	global maindata "data_CPRD_Patient_Practice_sens1"
	global cefu "data_patient_sens1_cefu3"
	global i "sens1"

*sens2
	global codetype "YS"
	global maindata "data_CPRD_Patient_Practice_sens2"
	global cefu "data_patient_sens2_cefu3"
	global i "sens2"

	global codetype "Y"
	global maindata "data_CPRD_Patient_Practice_sens2"
	global cefu "data_patient_sens2_cefu3"
	global i "sens2"
	
	/*
	use data_patient_sens2_cefu, clear
	replace fu12_date=fu12_date-365 if exp==1
	replace fu12_date=fu12_date-366 if exp==0
	replace fu6_date=fu6_date-365 if exp==1
	replace fu6_date=fu6_date-366 if exp==0
	save data_patient_sens2_cefu1
	*/
	
	/*
	use data_patient_sens2_cefu, clear
	replace ce_date=ce_date+365
	save data_patient_sens2_cefu2
	*/
	
	/*
	use data_patient_sens2_cefu, clear
	replace ce_date=ce_date+122 if exp==1
	replace ce_date=ce_date+122 if exp==0
	replace fu12_date=ce_date+365 
	replace fu6_date=ce_date+181
	save data_patient_sens2_cefu3
	*/
	
	/*
	use data_patient_sens1_cefu, clear
	replace ce_date=ce_date+122 if exp==1
	replace ce_date=ce_date+122 if exp==0
	replace fu12_date=ce_date+365 
	replace fu6_date=ce_date+181
	save data_patient_sens1_cefu3
	*/

	

/*
global codetype "YS"
*global codetype "Y"
global maindata "data_CPRD_Patient_Practice_primary"
global cefu "data_patient_primary_cefu"
global i "primary_nohes"
*/



use $maindata, clear


********************************************************************************
********************************************************************************
********************************************************************************
* derive covariates

* bmi derived
	use "table_covariates_bmi_derived", clear
	*95605
	merge m:1 patid using $cefu
	keep if _merge==3
	drop if event_date>ce_date
	drop if event_date<uts_date
	
	drop if event_date < ce_date - 730
	sort bmi
	drop if bmi < 10
	*https://www.cdc.gov/growthcharts/data/set1clinical/cj41l024.pdf
	
	
	bysort patid -event_date: egen rank=rank(-bmi), unique 
	sort patid rank 
	drop if rank!=1
	*145 (select higher value if measured on the same date)
	capture drop rank
	bysort patid: egen rank=rank(-event_date), unique 
	drop if rank!=1
	*99 *12657
	
	gen diff_ce_event=ce_date-event_date
	
	keep patid event_date bmi diff_ce_event exp
	rename event_date bmi_event_date
	rename diff_ce_event bmi_diff_ce_event

	*tabulate primary_exp, summarize(bmi)
	*tabulate primary_exp, summarize(bmi_diff_ce_event)
	
	keep patid bmi_event_date bmi_diff_ce_event bmi
	
	save table_covariates_bmi_$i, replace

*weight
	use "table_covariates_weight", clear
	*275691
	merge m:1 patid using $cefu
	keep if _merge==3
	*40285
	drop if event_date>ce_date
	*34895
	drop if event_date<uts_date
	*33340
	
	drop if event_date < ce_date - 730
	sort weight
	drop if weight < 15
	**https://www.rcpch.ac.uk/sites/default/files/Girls_2-18_years_growth_chart.pdf
	
	bysort patid -event_date: egen rank=rank(-weight), unique 
	sort patid rank 
	drop if rank!=1
	*33191 (select higher weight if measured on the same date)
	capture drop rank
	bysort patid: egen rank=rank(-event_date), unique 
	drop if rank!=1
	*14349
	
	gen diff_ce_event=ce_date-event_date
	
	keep patid event_date weight diff_ce_event exp
	rename event_date weight_event_date
	rename diff_ce_event weight_diff_ce_event
	
	keep patid weight_event_date weight_diff_ce_event weight
	
	save "table_covariates_weight_$i", replace
	
*height
	use "table_covariates_height", clear
	*170743
	merge m:1 patid using $cefu
	keep if _merge==3
	*27527
	drop if event_date>ce_date
	*23484
	drop if event_date<uts_date
	*22659
	
	drop if event_date < ce_date - 730
	sort height
	drop if height < 1
	*https://www.rcpch.ac.uk/sites/default/files/Girls_2-18_years_growth_chart.pdf
	
	bysort patid -event_date: egen rank=rank(-height), unique 
	sort patid rank 
	drop if rank!=1
	*22636(select higher value if measured on the same date)
	capture drop rank
	bysort patid: egen rank=rank(-event_date), unique 
	drop if rank!=1
	*11548
	
	gen diff_ce_event=ce_date-event_date
	
	keep patid event_date height diff_ce_event exp
	rename event_date height_event_date
	rename diff_ce_event height_diff_ce_event
	
	keep patid height_event_date height_diff_ce_event height
	
	save "table_covariates_height_$i", replace

*BP sys dias
	*local cefu "data_patient_sens1_cefu"
	use "table_covariates_BP", clear
	*248516
	*merge m:1 patid using "data_patient_sens1_cefu"
	merge m:1 patid using $cefu
	keep if _merge==3
	*7987
	drop if event_date>ce_date
	*3552
	drop if event_date<uts_date
	*3501
	
	drop if event_date < ce_date - 730
	sort diastolic
	sort systolic
	
	
	bysort patid -event_date: egen rank=rank(-diastolicBP), unique 
	sort patid rank 
	drop if rank!=1
	*3417(select higher value if measured on the same date)
	capture drop rank
	bysort patid: egen rank=rank(-event_date), unique 
	drop if rank!=1
	*2183
	
	gen diff_ce_event=ce_date-event_date
	
	keep patid event_date  diastolicBP systolicBP diff_ce_event exp
	rename event_date BP_event_date
	rename diff_ce_event BP_diff_ce_event
	rename systolicBP BPsystolic
	rename diastolicBP BPdiastolic
	
	keep patid BP_event_date BP_diff_ce_event BPsystolic BPdiastolic
	
	save "table_covariates_BP_$i", replace
	
*heart rate
	use "table_covariates_pulse", clear
	*30613
	merge m:1 patid using $cefu
	keep if _merge==3
	*4161
	drop if event_date>ce_date
	*2562
	drop if event_date<uts_date
	*2520
	
	drop if event_date < ce_date - 730
	sort pulse
	
	bysort patid -event_date: egen rank=rank(-pulse), unique 
	sort patid rank 
	drop if rank!=1
	*2508(select higher value if measured on the same date)
	capture drop rank
	bysort patid: egen rank=rank(-event_date), unique 
	drop if rank!=1
	*1746
	
	gen diff_ce_event=ce_date-event_date
	
	keep patid event_date  pulse  diff_ce_event exp
	rename event_date pulse_event_date
	rename diff_ce_event pulse_diff_ce_event

	
	keep patid pulse_event_date pulse_diff_ce_event pulse
	
	save "table_covariates_pulse_$i", replace
	
*hospitalisations
	use "data_HES_diagnosis_hosp_patient", clear
	*390323
	gen hospcount_beforece=1

	collapse (mean) hospcount, by (patid spno discharged_date)
	*171863
	
	capture drop _merge
	merge m:1 patid using $cefu
	keep if _merge==3
	*33828
	
	*only hopsitalisations before cohort entry?
	drop if  discharged_date>=ce_date
	*29067
	codebook patid
	drop if discharged_date<ce_date-365 /*leave 1 years prior 365 730*/
	codebook patid
	*721
	collapse (sum) hospcount_beforece, by (patid  ce_date uts_date frd_date crd_date)
	*10798
	*721
	keep patid  hospcount_beforece
	save "table_covariates_hosprate_$i", replace


*consultations
	use  "data_CPRD_Consultation", clear
	
	capture drop _merge
	merge m:1 patid using $cefu
	keep if _merge==3
	*2614375
	
	
	drop if  event_date>=ce_date
	*2217590
	codebook patid
	*29512
	drop if event_date<ce_date-365 /*leave 1 years prior 365 730*/
	codebook patid
	*24599
	
	/* *one year before and one year after ce
		drop if event_date>=ce_date+365 /*leave 1 years prior 365 730*/
		drop if event_date<ce_date-365 /*leave 1 years prior 365 730*/
	*/
	
	gen conscount_beforece=1

	collapse (mean) conscount_beforece, by (patid consid event_date ce_date exp)
	*2,641,258
	*109307
	
	collapse (sum) conscount_beforece, by (patid  event_date ce_date exp)
	*2,465,040
	*155721
	*if the same date then one consultation
	
	/*
	capture drop diff
	gen diff=event_date-ce_date
	
	*save consult, replace
	
	use consult, clear
		
		drop if diff>=0
		
		drop if diff<0
		
		drop if diff<0
		drop if diff>=90
		
		drop if diff<0
		drop if diff>=180
		
		drop if diff<90
		
		drop if diff<180
		
		drop if diff<90
		drop if diff>=180
		
				
		capture drop conscount_beforece
		gen conscount_beforece=1
		collapse (sum) conscount_beforece, by (patid exp ce_date)
		
		

	hist   event_date, by (exp) kdensity bin(24)
	hist   event_date if ce_date==d(01sep2015), by (exp) kdensity bin(24)
	hist   event_date, by (ce_date) kdensity bin(24)
	
	hist   diff, by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2012), by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2013), by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2014), by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2015), by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2016), by (exp) kdensity  bin(24)
	hist   diff if ce_date==d(01sep2017), by (exp) kdensity  bin(24)
	hist   diff, by (ce_date exp) kdensity bin(24)
	
	ttest diff if diff<0 & diff>-90 ,by(exp)
	ttest diff if diff>=0 & diff < 90 ,by(exp)
	
	collapse (sum) conscount_beforece, by (ce_date exp)
	
	logistic exp conscount_beforece
	
	logistic exp conscount_beforece if diff<90 & diff>-90 & ce_date==d(01sep2015)
	logistic exp conscount_beforece if diff<0
	logistic exp conscount_beforece if diff>=0
	
	logistic exp conscount_beforece if ce_date==d(01sep2012)
	logistic exp conscount_beforece if ce_date==d(01sep2013)
	logistic exp conscount_beforece if ce_date==d(01sep2014)
	logistic exp conscount_beforece if ce_date==d(01sep2015)
	logistic exp conscount_beforece if ce_date==d(01sep2016)
	logistic exp conscount_beforece if ce_date==d(01sep2017)
	
	ttest conscount_beforece  , by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2012), by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2013), by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2014), by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2015), by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2016), by(exp)
	ttest conscount_beforece  if ce_date==d(01sep2017), by(exp)
	
	ranksum conscount_beforece, by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2012), by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2013), by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2014), by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2015), by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2016), by(exp)
	ranksum conscount_beforece  if ce_date==d(01sep2017), by(exp)
	
	tabulate  ce_date exp, sum (conscount_beforece) 
	hist   diff, by (ce_date exp) kdensity bin(8)
	hist   diff, by (ce_date exp) kdensity bin(4)
	hist   diff, by (ce_date exp) kdensity bin(2)

	logistic exp conscount_beforece if ce_date==d(01sep2012) & diff<0
	logistic exp conscount_beforece if ce_date==d(01sep2013) & diff<0
	logistic exp conscount_beforece if ce_date==d(01sep2014) & diff<0
	logistic exp conscount_beforece if ce_date==d(01sep2015) & diff<0
    logistic exp conscount_beforece if ce_date==d(01sep2016) & diff<0
	logistic exp conscount_beforece if ce_date==d(01sep2017) & diff<0
	
	logistic exp conscount_beforece if ce_date==d(01sep2012) & diff>=0
	logistic exp conscount_beforece if ce_date==d(01sep2013) & diff>=0
	logistic exp conscount_beforece if ce_date==d(01sep2014) & diff>=0
	logistic exp conscount_beforece if ce_date==d(01sep2015) & diff>=0
    logistic exp conscount_beforece if ce_date==d(01sep2016) & diff>=0
	logistic exp conscount_beforece if ce_date==d(01sep2017) & diff>=0
	
    logistic exp conscount_beforece if ce_date==d(01sep2012) & diff>=0 & diff<90
	logistic exp conscount_beforece if ce_date==d(01sep2013) & diff>=0 & diff<90
	logistic exp conscount_beforece if ce_date==d(01sep2014) & diff>=0 & diff<90
	logistic exp conscount_beforece if ce_date==d(01sep2015) & diff>=0 & diff<90
    logistic exp conscount_beforece if ce_date==d(01sep2016) & diff>=0 & diff<90
	logistic exp conscount_beforece if ce_date==d(01sep2017) & diff>=0 & diff<90
 

	
    */

	
	capture drop conscount_beforece
	gen conscount_beforece=1
	collapse (sum) conscount_beforece, by (patid exp ce_date)
	*55250
	*24599
	
	
	
	save "table_covariates_consrate_$i", replace
	

*contraindications
	use data_contra_all_event, clear
	drop if decision_s=="N"
	merge m:1 patid using $cefu
	keep if _merge==3
	drop if event_date>ce_date
	
	bysort patid: egen rank=rank(-event_date), unique 
	sort patid rank 
	drop if rank!=1
	gen prece_event_date = ce_date -  event_date
	
	*keep if prece_event_date <= 365
	*348
	
	keep patid event_date
	duplicates drop
	*141  without therapy *2406 with therapy
	save data_contra_all_event_$i, replace
	
********************************************************************************
********************************************************************************
********************************************************************************
*derive outcomes - diagnoses

	*ssc install savesome 
	use data_outcome_event_$codetype, clear
	*drop if decision_s==$n| decision_s==$s
	keep if outcome_type=="crps" | outcome_type=="pots" | outcome_type=="ftg" 
	*merge m:1 patid using $cefu
	*keep if _merge==3
	egen ot = group(outcome_type), label 
	sort outcome_type patid

	preserve 
	*levelsof outcome_type, local(levels) 
	*foreach l of local levels {
	forval i= 1/3 {
			di `i'
			keep if ot==`i'
			levelsof outcome_type, local(lvl) 
			display `lvl'
			keep event_date patid outcome_type 
			duplicates drop
			collapse (min) event_date, by (patid outcome_type)
			display `lvl'
			save data_outcome_d_event_min_`i'_$i, replace
			restore, preserve 
	 }

	/*
	use data_outcome_d_event_min_1_primary, clear
	use data_outcome_d_event_min_2_primary, clear
	use data_outcome_d_event_min_3_primary, clear
	62
	495
	250
	
	78
	546
	290
	*/
	
	
	
********************************************************************************
********************************************************************************
********************************************************************************
*derive outcomes - symptoms
	
	/*
	use data_outcome_$codetype, clear
	keep if outcome_type=="gastrointestinal" | outcome_type=="muscular" | outcome_type=="headache" | outcome_type=="pain" 
	merge m:1 patid using $cefu
	keep if _merge==3
	egen ot = group(outcome_type), label 
	sort outcome_type patid
	
	keep if event_date<ce_date & event_date>=ce_date-365
	keep patid outcome_type code
	duplicates drop
	tab outcome_type
	save data_outcome_event_exclude, replace
	*58085
	

	use data_outcome_$codetype, clear
	keep if outcome_type=="gastrointestinal" | outcome_type=="muscular" | outcome_type=="headache" | outcome_type=="pain" 
	merge m:1 patid using $cefu
	keep if _merge==3
	egen ot = group(outcome_type), label 
	sort outcome_type patid
	keep if event_date>=ce_date & event_date<=fu12_date
	
	
	capture drop _merge
	merge m:1 patid outcome_type code using data_outcome_event_exclude
	keep if _merge==3
	
	/*
	*if exlude by specific diagnostic code (had thiscode 12 month prior and within follow up)
	 gastrointestinal |         177       40.60       40.60
     headache |         		69       15.83       56.42
     muscular |          		1        0.23       56.65
     pain |        				189       43.35      100.00

	*if exlude any code (had any diagnostic code 12 months prior)
      gastrointestinal |      1,977       33.39       33.39
              headache |        676       11.42       44.81
              muscular |         34        0.57       45.38
                  pain |      3,234       54.62      100.00

	*/
	*/

	
	
	***********************************************
	*use data_outcome_event_nohes_$codetype, clear
	use data_outcome_event_$codetype, clear
	*drop if decision_s==$n| decision_s==$s
	keep if outcome_type=="gastrointestinal" | outcome_type=="muscular" | outcome_type=="headache" | outcome_type=="pain" 
	merge m:1 patid using $cefu
	keep if _merge==3
	egen ot = group(outcome_type), label 
	sort outcome_type patid
	*codebook patid *22964
	*99451
	
	keep if event_date<ce_date & event_date>=ce_date-365
	keep patid outcome_type 
	duplicates drop
	tab outcome_type
	save data_outcome_event_exclude, replace
	*5921
	
	*use data_outcome_event_nohes_$codetype, clear
	use data_outcome_event_$codetype, clear
	*drop if decision_s==$n| decision_s==$s
	keep if outcome_type=="gastrointestinal" | outcome_type=="muscular" | outcome_type=="headache" | outcome_type=="pain" 
	merge m:1 patid using $cefu
	keep if _merge==3
	egen ot = group(outcome_type), label 
	sort outcome_type patid
	*99451
	
	capture drop _merge
	merge m:1 patid outcome_type using data_outcome_event_exclude
	drop if _merge==3
	
	*this is to only select new onset symptoms - this is my stupid mistake, what a dumbass i am !!! 
	*actually, not so stupid afterall, since I drop anyone more than 12 months before ce, then I select min date and if min not between follow up, then it is 12 months prior, so exclude those!
	*this means I am not couting outcomes for those excluded, which is great, but I left excluded in the total cohort (as zeros), so that's definitely stupid!!! don't do that again you muppet.
	drop if event_date<=ce_date-365
	gen  counter=1
	collapse (sum) counter (min) event_date, by (patid outcome_type ot ce_date fu6_date fu12_date)
	*13716
	
	
	*6 months follow up
	preserve 
	foreach i of numlist 1 2 3 4 {
			di `i'
			keep if ot==`i'
			levelsof outcome_type, local(lvl) 
			display `lvl'
			keep if event_date>=ce_date & event_date<=fu6_date 
			keep patid outcome_type event_date counter
			duplicates drop
			*gen counter=1
			collapse (sum) counter (min)event_date, by (patid outcome_type)
			display `lvl'
			save "data_outcome_s_event_min_fu6_`i'_$i", replace
			restore, preserve 
	 }
	 
	
	*12 months follow up
	*preserve 
	forval i= 1/4 {
			di `i'
			keep if ot==`i'
			levelsof outcome_type, local(lvl) 
			display `lvl'
			keep if event_date>=ce_date & event_date<=fu12_date 
			keep patid outcome_type event_date counter
			duplicates drop
			*gen counter=1
			collapse (sum) counter (min)event_date, by (patid outcome_type)
			display `lvl'
			save "data_outcome_s_event_min_fu12_`i'_$i", replace
			restore, preserve 
	 }
	 
	 *list if event_date==ce_date
	
	/*
	use data_outcome_s_event_min_fu6_1_primary, clear
	*692
	*723
	use data_outcome_s_event_min_fu12_1_primary, clear
	*1219
	codebook patid 1219
	*1158
	*1219
	*/
	
	
	
********************************************************************************
********************************************************************************
********************************************************************************
*build dataset

	use data_outcome_event_exclude, clear
	keep if outcome_type=="gastrointestinal"
	duplicates drop
	keep patid
	gen ch_s1=0
	save data_outcome_event_exclude_gastrointestinal, replace
	
	use data_outcome_event_exclude, clear
	keep if outcome_type=="headache"
	duplicates drop
	keep patid
	gen ch_s2=0
	save data_outcome_event_exclude_headache, replace
	
	use data_outcome_event_exclude, clear
	keep if outcome_type=="muscular"
	duplicates drop
	keep patid
	gen ch_s3=0
	save data_outcome_event_exclude_muscular, replace
	
	use data_outcome_event_exclude, clear
	keep if outcome_type=="pain"
	duplicates drop
	keep patid
	gen ch_s4=0
	save data_outcome_event_exclude_pain, replace
	

	use $maindata, clear
	
	capture drop _merge
	merge m:1 patid using data_outcome_event_exclude_gastrointestinal
		replace ch_s1=1 if ch_s1==.
		capture drop _merge
	merge  m:1 patid using data_outcome_event_exclude_headache
		replace ch_s2=1 if ch_s2==.
		capture drop _merge
	merge  m:1 patid using data_outcome_event_exclude_muscular
		replace ch_s3=1 if ch_s3==.
		capture drop _merge
	merge  m:1 patid using data_outcome_event_exclude_pain
		replace ch_s4=1 if ch_s4==.
		capture drop _merge

	
	/*
	tab ch_s1 exp
	tab ch_s2 exp
	tab ch_s3 exp
	tab ch_s4 exp
	*/

	*add covariates	

		merge 1:1 patid using table_covariates_bmi_$i
		drop _merge 
		merge 1:1 patid using table_covariates_weight_$i
		drop _merge 
		merge 1:1 patid using table_covariates_height_$i
		drop _merge 
		merge 1:1 patid using table_covariates_BP_$i
		drop _merge 
		merge 1:1 patid using table_covariates_pulse_$i
		drop _merge 
		
		merge 1:1 patid using table_covariates_hosprate_$i
		drop _merge 
		*tab hospcount_beforece
		*count if hes_e==1 & hospcount_beforece==.
		replace hospcount_beforece=0 if hes_e==1 & hospcount_beforece==.
		
		merge 1:1 patid using table_covariates_consrate_$i
		drop _merge
		*tab conscount_beforece
		*count if conscount_beforece==.
		replace conscount_beforece=0 if conscount_beforece==.
		
		merge m:1 patid using "raw_HES_patient"
		drop if _merge==2
		drop _merge
		encode gen_ethnicity, gen(ethnicity2)
		drop ethnicity gen_ethnicity
		rename ethnicity2 ethnicity
		
		merge m:1 patid using "data_contra_all_event_$i"
		drop _merge
		rename event_date contra_event_date
		gen contra=1 if contra_event_date!=.
		replace contra=0 if contra==.
	
	

	*add outcomes
	
	*diagnoses
		forval i= 1/3 {
			merge m:1 patid using "data_outcome_d_event_min_`i'_$i"
			drop if _merge==2
			drop _merge
			rename outcome_type d`i'_outcome_type
			rename event_date d`i'_event_date
			}
			
	*symptoms fu6 & fu12
		forval i= 1/4 {
			merge m:1 patid using "data_outcome_s_event_min_fu6_`i'_$i"
			drop if _merge==2
			drop _merge
			rename outcome_type s`i'fu6_outcome_type
			rename counter s`i'fu6_count
			rename event_date s`i'fu6_event_date
			
			merge m:1 patid using "data_outcome_s_event_min_fu12_`i'_$i"
			drop if _merge==2
			drop _merge
			rename outcome_type s`i'fu12_outcome_type
			rename counter s`i'fu12_count
			rename event_date s`i'fu12_event_date
			}

	
	
********************************************************************************
********************************************************************************
********************************************************************************
*tidyup/derive dataset
	
	*use $maindata
	
	*all patients
	*count
	*bysort exp:count if region!=11 & region!=12 & region!=13

	drop if region==11
	drop if region==12
	drop if region==13
	*42793 for sens1
	
	*symptoms
	forval i= 1/4{
		replace s`i'fu6_count=0 if s`i'fu6_count==.
		replace s`i'fu12_count=0 if s`i'fu12_count==.
		replace s`i'fu6_event_date=fu6_date   if s`i'fu6_event_date==.
		replace s`i'fu12_event_date=fu12_date if s`i'fu12_event_date==.
		
		capture drop s`i'fu6_tte
		gen s`i'fu6_tte = s`i'fu6_event_date-ce_date
		capture drop s`i'fu12_tte
		gen s`i'fu12_tte = s`i'fu12_event_date-ce_date
		replace s`i'fu6_tte=181 if s`i'fu6_tte==182
		replace s`i'fu12_tte=365 if s`i'fu12_tte==366
		replace s`i'fu6_tte=s`i'fu6_tte+1
		replace s`i'fu12_tte=s`i'fu12_tte+1
		
		capture drop  s`i'fu6
		gen s`i'fu6=1 if s`i'fu6_outcome_type!=""
		replace s`i'fu6=0 if s`i'fu6==.
		
		capture drop  s`i'fu12
		gen s`i'fu12=1 if s`i'fu12_outcome_type!=""
		replace s`i'fu12=0 if s`i'fu12==.
		}

	
	*diagnoses
	forval i= 1/3{
		capture drop d`i'fu6
		gen d`i'fu6=1 if d`i'_event_date >= ce_date & d`i'_event_date <= fu6_date
		replace d`i'fu6=0 if d`i'fu6==.
		
		capture drop d`i'fu12
		gen d`i'fu12=1 if d`i'_event_date >= ce_date & d`i'_event_date <= fu12_date
		replace d`i'fu12=0 if d`i'fu12==.
		}
		
		tab d1fu6 d1_outcome_type
		tab d1fu12 d1_outcome_type
		
		tab d2fu6 d2_outcome_type
		tab d2fu12 d2_outcome_type
		
		tab d3fu6 d3_outcome_type
		tab d3fu12 d3_outcome_type
		
	
	capture drop encounters
	gen encounters=conscount_beforece
	replace encounters=conscount_beforece+hospcount_beforece if hospcount_beforece!=.
	
	*tab encounters, missing
	*hist encounters 
	save analysis_$codetype$i, replace
	*save analysis_nohes$codetype$i, replace
	
	/*
	use analysis_YSprimary, clear
	use analysis_nohesYSprimary, clear
	use analysis_YSprimary, clear
	tab s1fu6 exp if ch_s1==1
	tab s1fu12 exp
	tab s2fu6 exp if ch_s2==1
	tab s2fu12 exp
	tab s3fu6 exp if ch_s3==1, missing
	tab s3fu12 exp
	tab s4fu6 exp if ch_s4==1, missing
	tab s4fu12 exp
	
	tab ch_s1 exp
	
	tab d1fu6 exp
	tab d1fu12 exp
	tab d2fu6 exp
	tab d2fu12 exp
	tab d3fu6 exp
	tab d3fu12 exp
	
	*/
	
	/*
	use analysis_YSprimary, clear
	merge m:1 patid using data_outcome_fractures_primary
	drop if _merge==2
	drop _merge
	replace s5fu12=0 if s5fu12==.
	tab exp s5fu12
	tab exp s4fu12
	merge m:1 patid using data_outcome_fractures_event_exclude
	drop if _merge==2
	drop _merge
	replace ch_s5=1 if ch_s5==.
	tab exp ch_s5
	tab exp ch_s4
	save analysis_YSprimary, replace
	*/
	
	


