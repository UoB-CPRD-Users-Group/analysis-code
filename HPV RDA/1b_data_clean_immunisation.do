
********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"
	
	
********************************************************************************
***all hpv events, deduped, ranked and only earliest record the same stage******
********************************************************************************

	use "data_CPRD_Immunisation", clear


	/*
	tab medcode_desc if strpos(medcode_desc,"hpv")
	tab medcode_desc if strpos(medcode_desc,"human papillo")
	tab medcode_desc immstype if strpos(medcode_desc,"papil")
	tab medcode_desc immstype if immstype==58 | immstype==67 | immstype==93 | immstype==94
	*/


	keep if immstype==58 | immstype==67 | immstype==93 | immstype==94
	*190923
	*keep if strpos(medcode_desc,"papil")
	*sort patid stage

	label define immstype 58 "HPV" 67 "HPVCER" 93 "HPV2" 94 "HPVCER2" 
	label values immstype immstype

	label define status 0 "Data Not Entered" 1 "Given" 4 "Refusal to start or complete cours" 9 "Advised" 
	label values status status

	label define stage 2 "1st" 3 "2nd" 4 "3rd" 
	label values stage stage


	label define source 0 "Data Not Entered" 1 "In this Practice" 2 "Out of Practice" 3 "In another Practice" 4 "Source unknown" 
	label values source source


	gen event_date = date(eventdate, "DMY")
	format %d event_date

	gen sys_date = date(sysdate, "DMY")
	format %d sys_date


	*count if strpos(medcode_text2,"qrisk")
	*count if strpos(medcode_text2,"framingham")
	*keep if strpos(medcode_text2,"qrisk") | strpos(medcode_text2,"framingham")
	*save "d_Clinical_qrisk_framingham"
	*keep if strpos(medcode_text2,"qrisk") 
	*save "d_Clinical_qrisk"

	*save "data_CPRD_Immunisation_hpv", replace


	*use "data_CPRD_Immunisation_hpv", clear
	*190923

	*1 for datasets with vaccination records
	drop if medcode_desc=="consent status for immunisats."
	*190630

	/*
	*2 for dataset with refused consent
	drop if medcode_desc!="consent status for immunisats."
	*293
	*/


	*gen sys_date = date(sysdate, "DMY")
	*format %d sys_date
	keep patid event_date sys_date medcode stage status readcode medcode_desc 

	*drop duplicates with same stage and date
	duplicates tag patid stage event_date, gen(dup)
	sort dup patid stage event_date medcode 
	duplicates drop patid stage event_date, force
	drop dup
	*190260

	*drop if with no dates if same stage record exists with date 
	duplicates tag patid stage, gen(dup)
	sort dup patid stage event_date medcode 
	drop if event_date==. & dup!=0
	*drop not given but adviced
	drop if status == 9
	drop dup
	*190207

	*replace remaining missing event dates with system date
	replace event_date=sys_date if event_date==.
	drop sys_date

	*rank by stage and event date, leave only the earliest record for the same stage
	bysort patid stage: egen desired_rank=rank(event_date), unique 
	sort desired_rank 
	drop if desired_rank!=1
	*189749

	/*
	*2 for dataset with refused consent
	*use data_CPRD_Immunisation_hpv_refused, clear
	save "data_CPRD_Immunisation_hpv_refused", replace
	*/

	save "data_CPRD_Immunisation_hpv", replace

********************************************************************************
***all refused hpv events, deduped, ranked, earliest record the same stage******
********************************************************************************


	use "data_CPRD_Immunisation", clear

	keep if immstype==58 | immstype==67 | immstype==93 | immstype==94
	*190923
	*keep if strpos(medcode_desc,"papil")
	*sort patid stage

	label define immstype 58 "HPV" 67 "HPVCER" 93 "HPV2" 94 "HPVCER2" 
	label values immstype immstype

	label define status 0 "Data Not Entered" 1 "Given" 4 "Refusal to start or complete cours" 9 "Advised" 
	label values status status

	label define stage 2 "1st" 3 "2nd" 4 "3rd" 
	label values stage stage


	label define source 0 "Data Not Entered" 1 "In this Practice" 2 "Out of Practice" 3 "In another Practice" 4 "Source unknown" 
	label values source source


	gen event_date = date(eventdate, "DMY")
	format %d event_date

	gen sys_date = date(sysdate, "DMY")
	format %d sys_date

	drop if medcode_desc!="consent status for immunisats."
	*293

	*gen sys_date = date(sysdate, "DMY")
	*format %d sys_date
	keep patid event_date sys_date medcode stage status readcode medcode_desc 

	*drop duplicates with same stage and date
	duplicates tag patid stage event_date, gen(dup)
	sort dup patid stage event_date medcode 
	duplicates drop patid stage event_date, force
	drop dup
	*190260

	*drop if with no dates if same stage record exists with date 
	duplicates tag patid stage, gen(dup)
	sort dup patid stage event_date medcode 
	drop if event_date==. & dup!=0
	*drop not given but adviced
	drop if status == 9
	drop dup
	*190207

	*replace remaining missing event dates with system date
	replace event_date=sys_date if event_date==.
	drop sys_date

	*rank by stage and event date, leave only the earliest record for the same stage
	bysort patid stage: egen desired_rank=rank(event_date), unique 
	sort desired_rank 
	drop if desired_rank!=1
	*189749


	save "data_CPRD_Immunisation_hpv_refused", replace


********************************************************************************
*only first stage earliest date*************************************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	tab stage, missing
	keep if stage==2
	*69246
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank1!=1
	keep patid event_date
	duplicates drop
	rename event_date event_date_imm_stage1
	save "data_CPRD_Immunisation_hpv_stage1", replace

********************************************************************************
*only second stage earliest date************************************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	tab stage, missing
	keep if stage==3
	*64192
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank1!=1
	keep patid event_date
	duplicates drop
	rename event_date event_date_imm_stage2
	save "data_CPRD_Immunisation_hpv_stage2", replace

********************************************************************************
*only third stage earliest date*************************************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	tab stage, missing
	keep if stage==4
	*56311
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank1!=1
	keep patid event_date
	duplicates drop
	rename event_date event_date_imm_stage3
	save "data_CPRD_Immunisation_hpv_stage3", replace

********************************************************************************
*date of the earliest recorded stage (could be any stage)***********************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank2!=1
	keep patid event_date stage
	duplicates drop
	rename event_date event_date_imm_firststage
	rename stage stage_imm_firststage
	save "data_CPRD_Immunisation_hpv_firststage", replace
	*save "data_CPRD_Immunisation_hpv_refused_firststage", replace
	*73989

********************************************************************************
*earliest date of vaccination (could be any stage)******************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank1!=1
	keep patid event_date stage
	duplicates drop
	rename event_date event_date_imm_firstdate
	rename stage stage_imm_firstdate
	save "data_CPRD_Immunisation_hpv_firstdate", replace
	*73989

	/*
	*2 for dataset with refused consent
	use data_CPRD_Immunisation_hpv_refused, clear
	sort patid event_date stage
	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	drop if alpharank1!=1
	keep patid event_date stage
	rename event_date event_date_imm_refused_firstdate
	rename stage stage_imm_refused_firstdate
	save "data_CPRD_Immunisation_hpv_refused_firstdate", replace
	*/

********************************************************************************
*number of different stages*****************************************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	by patid stage, sort: gen nvals = _n == 1 
	by patid: replace nvals = sum(nvals)
	by patid: replace nvals = nvals[_N] 
	collapse (max) stagecount=nvals, by(patid) 
	save "data_CPRD_Immunisation_hpv_stagecount", replace

********************************************************************************
*max available stage************************************************************
********************************************************************************

	use "data_CPRD_Immunisation_hpv", clear
	collapse (max) stagemax=stage, by(patid) 
	label define stagemax 2 "1st" 3 "2nd" 4 "3rd" 
	label values stagemax stagemax
	save "data_CPRD_Immunisation_hpv_stagemax", replace

	
********************************************************************************
********************************************************************************
********************************************************************************

	**distinct patids
	*by patid, sort: gen nvals = _n == 1 
	*count if nvals
	*replace nvals = sum(nvals)
	*replace nvals = nvals[_N] 

	/*

	*use "data_CPRD_Consultation", clear

	cfvars "data_CPRD_Consultation"
	rename event_date event_date_imm
	merge m:1 patid consid using "data_CPRD_Consultation"
	drop if _merge==2
	drop _merge
	sort eventdate

	sort patid event_date stage

	bysort patid: egen alpharank1=rank(event_date), unique 
	bysort patid: egen alpharank2=rank(stage), unique 
	*egen alpharank1=rank(stage), by(patid) unique
	*egen alpharank2=rank(event_date), by(patid) unique
	drop alpharank1
	drop alpharank2


	count if alpharank1!=alpharank2

*/
