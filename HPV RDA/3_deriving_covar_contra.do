
********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"


********************************************************************************
*** BMI 
********************************************************************************

	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==13 	
	
	*281058
	destring data3, replace
	*184690 missing
	drop if data3==.
	*96368
	drop if data3>100 & data3!=.
	*96073
	
	/*
	merge m:1 patid using "data_patient_primary_cefu"
	keep if _merge==3
	gen temp=event_date-primary_ce_date
	bysort patid: egen closest=min(abs(temp))
	gen temp2=data3 if closest==temp | closest==-temp
	bysort patid: egen bmi=max(temp2)
	drop if temp2==.
	*/
	gen bmi=data3
	keep patid bmi event_date
	/*
	gen bmi_cat=1 if bmi<18.5
	replace bmi_cat=2 if bmi>=18.5 & bmi<25
	replace bmi_cat=3 if bmi>=25 & bmi<30
	replace bmi_cat=4 if bmi>=30 & bmi!=.
	label define bmi_cat 1 "Underweight" 2 "Healthy" 3 "Overweight" 4 "Obese"
	label values bmi_cat bmi_cat
	*/
	duplicates drop 
	*95605 (31557 patients)
	save "table_covariates_bmi", replace
	
	/*
	use "table_covariates_bmi", clear
	*/

	
*derive BMI
	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==13 | enttype==14

	keep patid consid enttype data1 data3 event_date
	duplicates drop
	drop if data1=="0" & data3==""
	drop if substr(data1,1,1)== "0" & data3==""
	
	destring data1, replace
	destring data3, replace
	
	capture drop alpharank1
	bysort patid consid event_date enttype: egen alpharank1=rank(data1), unique 
		
	reshape wide data1 data3, i(patid consid event_date alpharank1) j(enttype)
	drop data314
	rename data113 weight
	rename data313 bmi
	rename data114 height
	capture drop bmi2
	gen bmi2=round((weight/(height*height)),0.1) if weight!=. & height!=.
	replace bmi2=bmi if bmi2==.& bmi!=.
	recast double bmi2
	format bmi2 %10.0g
	replace bmi2=round(bmi2,0.1)
	
	sort bmi2
	drop if bmi2==.
	drop if bmi2>100
	drop if bmi2<1
	
	/*
	gen diffbmi = bmi2-bmi if bmi!=.
	sort diffbmi
	
	list if bmi2!=bmi &bmi!=.
	sort  alpharank1 
	sort patid consid event_date enttype alpharank1
	list if patid ==
	*/
	
	keep patid event_date bmi2
	rename bmi2 bmi
	duplicates drop
	*168868
	
	save "table_covariates_bmi_derived", replace

	
********************************************************************************
*** weight (in kg)
********************************************************************************

	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==13
	*281058
	destring data1, replace
	sort data1
	*11 missing
	drop if data1==.
	drop if data1<=0.096
	drop if data1>2000
	drop if data1>800
	*279663
	gen weight=data1
	keep patid weight event_date
	duplicates drop 
	*275691 (85905 patients)
	save "table_covariates_weight", replace

	/*
	use "table_covariates_weight", clear
	*/
	
********************************************************************************
*** *height(in meters)
********************************************************************************


	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==14
	*175505
	destring data1, replace
	sort data1
	*34 missing
	drop if data1==.
	drop if data1<0.4
	drop if data1>=3
	*173111
	gen height=data1
	keep patid height event_date
	duplicates drop 
	*170743 (75110 patients)
	save "table_covariates_height", replace

	/*
	use "table_covariates_weight", clear
	*/
	


********************************************************************************
*** *BP
********************************************************************************

	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==1
	*249663
	destring data1, replace
	destring data2, replace
	drop if data1==0 & data2==0
	
	sort data1
	replace data1=. if data1<=10
	sort data2
	replace data2=. if data2<=11
	replace data2=. if data2>300

	gen diastolicBP=data1
	gen systolicBP=data2
	keep patid diastolicBP systolicBP event_date
	duplicates drop 
	*248516 (61909 patients)
	save "table_covariates_BP", replace

	/*
	use "table_covariates_BP", clear
	*/
	
	*use "data_CPRD_Clinical_Additional", clear
	*postural drop
	*keep if enttype==411
	*no records!!


********************************************************************************
*** *heartrate - pulse 
********************************************************************************

	use "data_CPRD_Clinical_Additional", clear
	keep if enttype==131
	*31127
	destring data1, replace
	sort data1
	*413 missing
	drop if data1==.
	drop if data1<=0
	*30690
	gen pulse=data1
	keep patid pulse event_date
	duplicates drop 
	*30613 (18108 patients)
	save "table_covariates_pulse", replace

	/*
	use "table_covariates_pulse", clear
	*/
	
	
********************************************************************************
*** *region
********************************************************************************

	*use "data_CPRD_Patient_Practice", clear
	*tab region, missing


********************************************************************************
*** *number hosp
********************************************************************************


	use "data_HES_diagnosis_hosp_patient", clear
	*390323

	keep patid spno discharged_date
	duplicates drop
	*171863
	gen counter_id=1
	
	rename discharged_date event_date
	
	collapse (sum) counter_id, by (patid event_date)
	*171556
	
	save "table_covariates_hosp_eventid", replace

********************************************************************************
*** *number gp cons
********************************************************************************

	use "data_CPRD_Consultation", clear
	*14,510,909
	*tab constype
	gen counter_id=1
	*gen pracid = mod(patid,1000)
	*sort patid event_date consid
	collapse (sum) counter_id, by (patid event_date)
	save "table_covariates_cons_eventid", replace
	*12,368,350

	
	*gen counter_event=1
	*collapse (sum) counter_event (sum) counter_id, by (patid)
	*135096 patients
	
********************************************************************************
*** *ethnicity
********************************************************************************
	
	*derived from HES, need to check read codes?
	*use "data_CPRD_Patient_Practice", clear
	*tab ethnicity, missing

********************************************************************************
*** contraindications - clean code tables
********************************************************************************

*read
		
		use table_contra_all_read, clear
		duplicates drop
		replace readcode="1453.00" if readcode=="1453"
		replace readcode="1454.00" if readcode=="1454"
		replace readcode="1458.00" if readcode=="1458"
		replace readcode="6827.00" if readcode=="6827"
		
		merge m:1 readcode using raw_lookup_medical
		drop if _merge==2
		tostring (medcode), replace
		rename codedescription code_description
		rename type code_comment
		replace medcode=medcodeprodcode if medcode=="." 
		replace medcodeprodcode=medcode if medcodeprodcode=="-" 
		
		rename medcode_desc code_desc
		destring(medcode), replace
		*rename medcode code
		*rename code medcode

		keep code_type medcode code_desc decision_s code_comment
		
		order medcode, last
		order code_type, last
		order code_desc, last
		order code_comment, last
		order decision_s, last
		drop if medcode==33943 & code_comment=="HIV positive" /*duplicate with conflicting inclusion"*/
		save table_contra_all_read, replace
		*573

		*create short version for merging
		use table_contra_all_read, clear
		keep medcode decision_s
		duplicates drop
		save table_contra_all_read_short, replace
		*tab decision_s
		*559
		

*icd10
		
		use table_contra_all_icd10, clear
		duplicates drop 
		drop if codedescription=="other contraindications??"
		rename codedescription code_description
		rename type code_comment
		keep code_type icd10 code_desc decision_s code_comment 
		order icd10, last
		order code_type, last
		order code_desc, last
		order code_comment, last
		order decision_s, last
		save table_contra_all_icd10, replace
		*30

*product
		
		use table_contra_all_bnf, clear
		duplicates drop 
		rename medcodeprodcode prodcode
		destring(prodcode), replace
		merge m:1 prodcode using raw_lookup_product
		drop if _merge==2
		
		*rename prodcode code
		rename codedescription code_description
		rename drugsubstance code_comment
		keep code_type prodcode code_desc decision_s code_comment
		
		order prodcode, last
		order code_type, last
		order code_desc, last
		order code_comment, last
		order decision_s, last

		save table_contra_all_bnf, replace
		*244
		
		*create short version for merging
		use table_contra_all_bnf, clear
		keep prodcode decision_s
		duplicates drop
		save table_contra_all_bnf_short, replace
		*244
		
********************************************************************************
*** contraindications - events and codes
********************************************************************************

*therapy - prodcodes

		use "data_CPRD_Therapy", clear
		merge m:1 prodcode using table_contra_all_bnf_short
		keep if _merge==3
		gen event_date = date(eventdate, "DMY")
		format %d event_date
		*45743

		keep patid event_date prodcode decision_s
		gen source="therapy"
		order event_date, last
		order prodcode, last
		order source, last
		order decision_s, last
		duplicates drop
		
		save data_contra_therapy_code, replace
		*45365

		keep patid event_date decision_s
		duplicates drop
		save data_contra_therapy_event, replace
		*41458
		

*hes - icd10

		use "data_HES_diagnosis_hosp_patient", clear
		rename icd icd10
		capture drop _merge
		cfvars "table_contra_all_icd10"
		merge m:1 icd10 using "table_contra_all_icd10"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		duplicates drop
		*8

		keep patid icd10 discharged_date decision_s
		rename discharged_date event_date
		gen source="hes"
		order event_date, last
		order icd10, last
		order source, last
		order decision_s, last
		duplicates drop
		*8

		save data_contra_hes_code, replace
		
		keep patid event_date decision_s
		duplicates drop
		save data_contra_hes_event, replace
		*7
		
*clinical - medcode

		use "data_CPRD_Clinical_Additional", clear
		merge m:1 medcode using table_contra_all_read_short
		keep if _merge==3
		*2577

		keep patid event_date medcode decision_s
		gen source="clinical"
		order event_date, last
		order medcode, last
		order source, last
		order decision_s, last
		duplicates drop
		
		save data_contra_clinical_code, replace
		*2453
		
		use data_contra_clinical_code, clear
		keep patid event_date decision_s
		duplicates drop
		save data_contra_clinical_event, replace
		*2521

*referral - medcode

		use "data_CPRD_Referral", clear
		merge m:1 medcode using table_contra_all_read_short
		keep if _merge==3
		*101

		keep patid event_date medcode decision_s
		gen source="referral"
		order event_date, last
		order medcode, last
		order source, last
		order decision_s, last
		duplicates drop
		
		save data_contra_referral_code, replace
		*101
		
		keep patid event_date decision_s
		duplicates drop
		save data_contra_referral_event, replace
		*101

*test - medcode

		use "data_CPRD_Test", clear
		merge m:1 medcode using table_contra_all_read_short
		keep if _merge==3
		*1816
		gen event_date = date(eventdate, "DMY")
		format %d event_date
		keep patid event_date medcode decision_s
		gen source="test"
		order event_date, last
		order medcode, last
		order source, last
		order decision_s, last
		duplicates drop
		
		save data_contra_test_code, replace
		*1684
		
		keep patid event_date decision_s
		duplicates drop
		save data_contra_test_event, replace
		*1507


*immunisation - medcode - none

********************************************************************************
**merge event level
********************************************************************************


	*use data_contra_therapy_event, clear
	*append using data_contra_hes_event
	use data_contra_hes_event, clear
	append using data_contra_clinical_event
	append using data_contra_referral_event
	append using data_contra_test_event
	*append using data_contra_therapy_event
	save data_contra_all_event, replace
	*45594 (15197 patients)
	*4136 without therapy
	*tab decision_s, missing
	
	*use using data_contra_clinical_event
	*append using data_contra_referral_event
	*append using data_contra_test_event
	*append using data_contra_therapy_event
	*save data_contra_all_event_nohes, replace
	*4129 nohes

********************************************************************************
********************************************************************************
********************************************************************************
