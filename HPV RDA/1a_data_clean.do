
********************************************************************************
*****************************location*******************************************
********************************************************************************


	cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"


	
********************************************************************************
*** HES data *** merge diagnosis and patient ***********************************
********************************************************************************

	use "Data Analysis\workingdata\raw_HES_diagnosis_hosp", clear

	gen discharged_date = date(discharged, "DMY")
	format %d discharged_date

	merge m:1 patid using "Data Analysis\workingdata\raw_HES_patient"
	tab patid if _merge==2
	drop if _merge==2

	save "Data Analysis\workingdata\data_HES_diagnosis_hosp_patient", replace



********************************************************************************
*** clinical data and merging additional data **********************************
********************************************************************************

	use "raw_CPRD_Additional_001", clear
	rename enttype enttype_add
	save "raw_CPRD_Additional_001", replace

	use "raw_CPRD_Clinical_001", clear
	append using "raw_CPRD_Clinical_002"

	*ssc install cfvars
	cfvars "raw_lookup_medical"
	merge m:1 medcode using "raw_lookup_medical"
	tab medcode if _merge==1 /*medcode of zero. This is not a valid medcode*/
	drop if _merge==2 /*dropping unused medcodes*/
	drop _merge
	drop desc

	/*
	tab medcode_desc if strpos(medcode_desc,"hpv")
	tab medcode_desc if strpos(medcode_desc,"human papillo")
	*/

	cfvars "raw_CPRD_Additional_001"
	*rename enttype enttype_clin
	*** cannot merge 1:1 because many entries have no additional information (adid=0) and therefore there are duplicates in terms of patid and adid
	*duplicates tag patid adid, gen(dup)
	*tab adid if dup!=0 /*all duplicates in patid and adid are due to adid=0. i.e. no additional information. And there are no adid=0 in the additional dataset. Therefore can safely merge m:1.*/

	merge m:1 patid adid using "raw_CPRD_Additional_001"
	*** none from additional that didn't match in- yay!
	*tab adid if _merge==1 /*all those which didn't merge have adid=0- yay!*/
	*drop dup
	drop _merge 

	/*
	*too large to merge!!!
	cfvars "raw_lookup_enttype"
	merge m:1 enttype using "raw_lookup_enttype"
	drop _merge
	*/

	gen event_date = date(eventdate, "DMY")
	format %d event_date

	gen sys_date = date(sysdate, "DMY")
	format %d sys_date


	label define constype 0 "Data Not Entered" 1 "Clinic" 2 "Night visit, Deputising service" 3 "Follow-up/routine visit" 4 "Night visit, Local rota" 5 "Mail from patient" 6 "Night visit , practice" 7 "Out of hours, Practice" 15 "Other"
	label values constype constype

	label define episode 0 "Data Not Entered" 1 "First Ever" 2 "New event" 3 "Continuing" 4 "Other"
	label values episode episode

	drop  eventdate sysdate


	*use "data_Clinical", clear
	save "data_CPRD_Clinical_Additional", replace
	*use "data_CPRD_Clinical_Additional", clear

	*count if strpos(medcode_text2,"qrisk")
	*count if strpos(medcode_text2,"framingham")
	*keep if strpos(medcode_text2,"qrisk") | strpos(medcode_text2,"framingham")
	*save "d_Clinical_qrisk_framingham"
	*keep if strpos(medcode_text2,"qrisk") 
	*save "d_Clinical_qrisk"


********************************************************************************
*** Appending consultation data ************************************************
********************************************************************************

	use "raw_CPRD_Consultation_001", clear
	append using "raw_CPRD_Consultation_002"

	gen event_date = date(eventdate, "DMY")
	gen sys_date = date(sysdate, "DMY")
	format %d event_date sys_date
	drop eventdate sysdate

	save "data_CPRD_Consultation", replace
	
********************************************************************************
*** Appending Immunisation data ***********************************************
********************************************************************************

	use "raw_CPRD_Immunisation_001", clear
	*3,735,359
	merge m:1 medcode using "raw_lookup_medical"
	drop if _merge==2
	drop _merge
	drop desc
	save "data_CPRD_Immunisation", replace
	*use "data_CPRD_Immunisation", clear


********************************************************************************
*** Merging referal data with medcodes******************************************
********************************************************************************

	use "raw_CPRD_Referral_001.dta", clear

	cfvars "raw_lookup_medical"
	merge m:1 medcode using "raw_lookup_medical"
	tab medcode if _merge==1
	drop if _merge==2
	drop _merge
	drop desc

	label define source 0 "No data/missing" 1 "GP referral" 2 "Self" 3 "3rd party" 3 "PHCT"
	label values source source
	label define inpatient 0 "No data/missing" 1 "In patient" 2 "Day case" 3 "Out patient" 4 "Domiciliary" 5 "Direct access" 6 "PHCT" 7 "Other" 
	label values inpatient inpatient
	label define urgency 0 "No data/missing" 1 "2 week wait" 2 "Routine" 3 "Stat (immediately)" 4 "Urgent" 5 "Emergency" 6 "Red flag"
	label values urgency urgency
	label define attendance 0 "No data/missing" 1 "First visit" 2 "Subsiquent visit" 3 "Last visit" 4 "First follow-up" 5 "Subsiquent follow-up"
	label values attendance attendance
	label define constype 0 "Data Not Entered" 1 "Clinic" 2 "Night visit, Deputising service" 3 "Follow-up/routine visit" 4 "Night visit, Local rota" 5 "Mail from patient" 6 "Night visit , practice" 7 "Out of hours, Practice" 15 "Other"
	label values constype constype

	foreach x in medcode source inpatient urgency attendance nhsspec fhsaspec {
		replace `x'=. if `x'==0
	}

	gen event_date = date(eventdate, "DMY")
	format %d event_date

	gen sys_date = date(sysdate, "DMY")
	format %d sys_date

	drop  eventdate sysdate

	tab constype, missing
	tab source, missing
	tab nhsspec, missing
	tab fhsaspec, missing
	tab inpatient, missing
	tab attendance, missing
	tab urgency, missing

	save "data_CPRD_Referral", replace

********************************************************************************
*** Appending staff data *******************************************************
********************************************************************************

	use "raw_CPRD_Staff_001", clear
	append using "raw_CPRD_Staff_002"
	save "data_CPRD_Staff", replace


********************************************************************************
*** Appending Test data ********************************************************
********************************************************************************

	use "raw_CPRD_Test_001", clear

	cfvars "raw_lookup_medical"
	merge m:1 medcode using "raw_lookup_medical"
	tab medcode if _merge==1
	drop if _merge==2
	drop _merge
	drop desc
	save "data_CPRD_Test", replace

********************************************************************************
*** Appending therapy data *****************************************************
********************************************************************************

	use "raw_CPRD_Therapy_001", clear
	append using "raw_CPRD_Therapy_002"
	append using "raw_CPRD_Therapy_003"
	save "data_CPRD_Therapy", replace

********************************************************************************
********************************************************************************
********************************************************************************

