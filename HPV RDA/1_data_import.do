
********************************************************************************
*****************************location*******************************************
********************************************************************************


*global data "\\rdsfcifs.acrc.bris.ac.uk\CPRD_Data_Distribution\16_294R_Kate\analysis\workingdata"
*cd "\\rdsfcifs.acrc.bris.ac.uk\CPRD_Data_Distribution\16_294R_Kate\analysis\workingdata"

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\"
*cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

*local anpath "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"
*local dapath "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data\DATA"


********************************************************************************
*************************************denominators*******************************
********************************************************************************


*1******
	import delimited "Data\DATA\16_294_patient_list_dedup.txt", clear
	save "Data Analysis\workingdata\raw_patient_list.dta", replace

*2******
	import delimited "Data\Denominators_2018_07\acceptable_pats_from_utspracts_JUL2018.txt", clear
	save "Data Analysis\workingdata\raw_denom_acceptable_pats_from_utspracts_JUL2018.dta", replace

*3******
	import delimited "Data\Denominators_2018_07\all_patients_JUL2018.txt", clear
	save "Data Analysis\workingdata\raw_denom_all_patients_JUL2018.txt", replace

*4******
	import delimited "Data\Denominators_2018_07\allpractices_JUL2018.txt",la clear
	save "Data Analysis\workingdata\raw_denom_allpractices_JUL2018.dta", replace


********************************************************************************
*************************************lookups************************************
********************************************************************************

*1******
	import delimited "Data\lookups\2018_08\medical.txt", clear
	drop if _n==1
	gen medcode_desc=lower(desc)
	save "Data Analysis\workingdata\raw_lookup_medical.dta", replace

*2******
	import delimited "Data\lookups\2018_08\product.txt", clear
	drop if _n<=2
	save "Data Analysis\workingdata\raw_lookup_product", replace
	*keep if bnfchapter=="Statins"
	*keep prodcode productname drugsubstance strength
	*sort prodcode
	*save "productcodes_statins", replace

*3******
	import delimited "Data\lookups\2018_08\Entity.txt", clear
	replace description=lower(description)
	replace category = lower(category)
	replace data1 = lower(data1)
	replace data2 = lower(data2)
	replace data3 = lower(data3)
	replace data4 = lower(data4)
	replace data5 = lower(data5)
	replace data6 = lower(data6)
	replace data7 = lower(data7)
	replace data8 = lower(data8)

	rename  description enttype_desc
	rename category enttype_category
	rename data1 data1_desc
	rename data2 data2_desc
	rename data3 data3_desc
	rename data4 data4_desc
	rename data5 data5_desc
	rename data6 data6_desc
	rename data7 data7_desc
	rename data8 data8_desc
	save "Data Analysis\workingdata\raw_lookup_enttype", replace


********************************************************************************
************************************contraindications***************************
********************************************************************************

*1******
	import excel "Data\lookups\outcome_codes.xlsx", sheet("CONTRA") firstrow case(lower) clear
	keep if code_type=="Read" /*& inclusion_type=="include"*/
	rename code readcode
	*keep readcode medcode term classification1 classification2 description_comment inclusion_type
	save "Data Analysis\workingdata\table_contra_all_read", replace

*2******
	import excel "Data\lookups\outcome_codes.xlsx", sheet("CONTRA") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	*keep readcode medcode term classification1 classification2 description_comment inclusion_type
	save "Data Analysis\workingdata\table_contra_all_icd10", replace

*3******
	import excel "Data\lookups\outcome_codes.xlsx", sheet("CONTRA") firstrow case(lower) clear
	keep if code_type=="BNF" /*& inclusion_type=="include"*/
	rename code bnf
	*keep readcode medcode term classification1 classification2 description_comment inclusion_type
	save "Data Analysis\workingdata\table_contra_all_bnf", replace


********************************************************************************
****************************outcomes********************************************
********************************************************************************

** fatigue (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_FTG") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_ftg_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_FTG") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	save "Data Analysis\workingdata\table_outcome_ftg_icd10", replace



** CRPS (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_CRPS") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_crps_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_CRPS") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	save "Data Analysis\workingdata\table_outcome_crps_icd10", replace

** POTS (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_POTS") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_pots_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_POTS") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_pots_icd10", replace

** ALL DIAGNOSES

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_OTHER") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 diagnosis_category decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_all_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_OTHER") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 diagnosis_category decision_s
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_all_icd10", replace

** muscular weakness and paralysis (read icd)
		
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_MUSC") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	*drop if inclusion_type=="exclude"
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_muscular_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_MUSC") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	*drop if inclusion_type=="exclude"
	save "Data Analysis\workingdata\table_outcome_muscular_icd10", replace
	
** pain - musculoskeletal, neuropathic, idiopathic (read icd)

	*import excel "Data\lookups\outcome_codes.xlsx", sheet("13.PAIN") firstrow case(lower) clear
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_PAIN") firstrow case(lower) clear
	keep if code_type=="READ" /*& (inclusion_type=="include"|inclusion_type=="unknown")*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_pain_read", replace

	*import excel "Data\lookups\outcome_codes.xlsx", sheet("13.PAIN") firstrow case(lower) clear
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_PAIN") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& (inclusion_type=="include"|inclusion_type=="unknown")*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_pain_icd10", replace
	
** headache and migraine (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_HEAD") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_headache_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_HEAD") firstrow case(lower) clear
	keep if code_type=="ICD10"/*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_headache_icd10", replace

** gastrointestinal (read only)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_GASTRO") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_gastrointestinal_read", replace
	**no icd10 codes
	
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_GASTRO") firstrow case(lower) clear
	keep if code_type=="ICD10"/*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	*drop if inclusion_type=="exclude"
	duplicates drop
	save "Data Analysis\workingdata\table_outcome_gastrointestinal_icd10", replace

		
********************************************************************************
*************************************HES and IMD********************************
********************************************************************************

*1******
	import delimited "Data\DATA_LINKED\16_294R\GOLD_linked\16_294R_linkage_eligibility.txt", clear
	save "Data Analysis\workingdata\raw_lookup_linkage_eligibility.dta", replace

*2******
	import delimited "Data\DATA_LINKED\16_294R\Documentation\Set16\linkage_coverage.txt", clear
	drop if _n==1
	rename v1 data_source
	rename v2 start
	rename v3 end
	save "Data Analysis\workingdata\raw_lookup_linkage_coverage.dta", replace
	
*2******
	import delimited "Data\DATA_LINKED\16_294R\GOLD_linked\hes_diagnosis_hosp_16_294R.txt", clear
	save "Data Analysis\workingdata\raw_HES_diagnosis_hosp.dta", replace

*3******
	import delimited "Data\DATA_LINKED\16_294R\GOLD_linked\hes_patient_16_294R.txt", clear
	save "Data Analysis\workingdata\raw_HES_patient.dta", replace
	
*4******
	import delimited "Data\DATA_LINKED\16_294R\GOLD_linked\patient_imd2015_16_294R.txt", clear
	save "Data Analysis\workingdata\raw_IMD2015_patient.dta", replace


********************************************************************************
************************************cprd data***********************************
********************************************************************************

	capture program drop import_cprd
	program import_cprd
		import delimited "Data\DATA\16_294_July_Extract_`1'.txt", clear
		save "Data Analysis\workingdata\raw_CPRD_`1'.dta", replace
	end

	import_cprd Additional_001
	import_cprd Clinical_001
	import_cprd Clinical_002
	import_cprd Consultation_001
	import_cprd Consultation_002
	import_cprd Immunisation_001
	import_cprd Patient_001
	import_cprd Practice_001
	import_cprd Referral_001
	import_cprd Staff_001
	import_cprd Staff_002
	import_cprd Test_001
	import_cprd Therapy_001
	import_cprd Therapy_002
	import_cprd Therapy_003

	
********************************************************************************
********************************************************************************
********************************************************************************




