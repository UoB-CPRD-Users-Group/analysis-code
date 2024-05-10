
/*
********************************************************************************
*****************************import code lists**********************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\"


********************************************************************************
*contraindications*

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
*outcomes*

** fatigue (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_FTG") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="ftg"
	save "Data Analysis\workingdata\table_outcome_ftg_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_FTG") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	gen outcome_type="ftg"
	save "Data Analysis\workingdata\table_outcome_ftg_icd10", replace

** CRPS (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_CRPS") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="crps"
	save "Data Analysis\workingdata\table_outcome_crps_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_CRPS") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	gen outcome_type="crps"
	save "Data Analysis\workingdata\table_outcome_crps_icd10", replace

** POTS (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_POTS") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="pots"
	save "Data Analysis\workingdata\table_outcome_pots_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_POTS") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	duplicates drop
	gen outcome_type="pots"
	save "Data Analysis\workingdata\table_outcome_pots_icd10", replace

** ALL DIAGNOSES

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_OTHER") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 diagnosis_category decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type=diagnosis_category
	drop diagnosis_category
	save "Data Analysis\workingdata\table_outcome_all_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("DIAG_OTHER") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 diagnosis_category decision_s
	duplicates drop
	gen outcome_type=diagnosis_category
	drop diagnosis_category
	save "Data Analysis\workingdata\table_outcome_all_icd10", replace

** muscular weakness and paralysis (read icd)
		
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_MUSC") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	drop if readcode=="2832"
	gen outcome_type="muscular"
	save "Data Analysis\workingdata\table_outcome_muscular_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_MUSC") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	gen outcome_type="muscular"
	save "Data Analysis\workingdata\table_outcome_muscular_icd10", replace
	
** pain - musculoskeletal, neuropathic, idiopathic (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_PAIN") firstrow case(lower) clear
	keep if code_type=="READ" /*& (inclusion_type=="include"|inclusion_type=="unknown")*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="pain"
	save "Data Analysis\workingdata\table_outcome_pain_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_PAIN") firstrow case(lower) clear
	keep if code_type=="ICD10" /*& (inclusion_type=="include"|inclusion_type=="unknown")*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	duplicates drop
	gen outcome_type="pain"
	save "Data Analysis\workingdata\table_outcome_pain_icd10", replace
	
** headache and migraine (read icd)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_HEAD") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="headache"
	save "Data Analysis\workingdata\table_outcome_headache_read", replace

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_HEAD") firstrow case(lower) clear
	keep if code_type=="ICD10"/*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	duplicates drop
	gen outcome_type="headache"
	save "Data Analysis\workingdata\table_outcome_headache_icd10", replace

** gastrointestinal (read only)

	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_GASTRO") firstrow case(lower) clear
	keep if code_type=="READ" /*& inclusion_type=="include"*/
	rename code readcode
	keep readcode medcode term classification1 classification2 decision_s
	destring medcode, replace ignore(" ")
	format medcode %12.0g
	duplicates drop
	gen outcome_type="gastrointestinal"
	save "Data Analysis\workingdata\table_outcome_gastrointestinal_read", replace
	
	import excel "Data\lookups\outcome_codes.xlsx", sheet("SYMP_GASTRO") firstrow case(lower) clear
	keep if code_type=="ICD10"/*& inclusion_type=="include"*/
	rename code icd10
	keep icd10 medcode term classification1 classification2 decision_s
	duplicates drop
	gen outcome_type="gastrointestinal"
	save "Data Analysis\workingdata\table_outcome_gastrointestinal_icd10", replace
*/
	
********************************************************************************
*****************************merge code lists***********************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"

*without sensitive codes
/*	
global s ""Y""
global y ""Y""
global codetype "Y"
*/

*with sensitive codes
/*
global s ""S""
global y ""Y""
global codetype "YS"
*/
	
	*medcodes long
	use table_outcome_muscular_read, clear
	append using table_outcome_pain_read
	append using table_outcome_headache_read
	append using  table_outcome_gastrointestinal_read
	append using  table_outcome_all_read
	append using  table_outcome_crps_read
	append using  table_outcome_pots_read
	append using  table_outcome_ftg_read
	save table_outcome_read, replace
	*2183
	
	*icd10 long
	use table_outcome_muscular_icd10, clear
	append using  table_outcome_pain_icd10
	append using  table_outcome_headache_icd10
	append using  table_outcome_gastrointestinal_icd10
	append using  table_outcome_crps_icd10
	append using  table_outcome_pots_icd10
	append using  table_outcome_ftg_icd10
	append using  table_outcome_all_icd10
	save table_outcome_icd10, replace
	*669



********************************************************************************
*****************************check overlaps*************************************
********************************************************************************
*check for codes appearing in several categories
*exlude abdominal pain and headaches from pain
*exlude codes that are in pots, ftg,crps from symptom lists

	use table_outcome_read, clear
	*drop if decision_s=="N"
	sort medcode outcome_type
	capture drop dup2
	quietly by medcode:  gen dup2 = cond(_N==1,0,_n) 
	
	/*
	tab outcome_type decision_s
	tab outcome_type if dup2>0
	tab term if dup2>0 
	tab term outcome_type if dup2>0 & decision_s!="N"
	tab term if dup2>0 & decision_s!="N"
	tab term outcome_type if (outcome_type=="pain" | outcome_type=="gastrointestinal" ) & dup2>0 & decision_s!="N"
	tab medcode 
	*/

*fatigue
	*tab medcode outcome_type if outcome_type=="ftg" & dup2>0 & decision_s!="N"
	*sort medcode outcome_type
	*list if medcode==717 | medcode==1042 | medcode==4657 | medcode==12411
	
	replace decision_s="N" if medcode==717&outcome_type=="pain";
	replace decision_s="N" if medcode==4657&outcome_type=="pain";
	replace decision_s="N" if medcode==1042&outcome_type=="muscular";
	replace decision_s="N" if medcode==12411&outcome_type=="muscular";

*crps
	*tab medcode outcome_type if outcome_type=="crps" & dup2>0 & decision_s!="N"
	*sort medcode outcome_type
	*list if medcode==7915 | medcode==89917 | medcode==93531 | medcode==95878 ///| medcode==105200 | medcode==105257;
	
	replace decision_s="N" if medcode==7915 & outcome_type=="pain";
	replace decision_s="N" if medcode==89917&outcome_type=="pain";
	replace decision_s="N" if medcode==93531&outcome_type=="pain";
	replace decision_s="N" if medcode==95878&outcome_type=="pain";
	replace decision_s="N" if medcode==105200&outcome_type=="pain";
	replace decision_s="N" if medcode==105257&outcome_type=="pain";


*headache
	*tab medcode outcome_type if outcome_type=="headache" & dup2>0 & decision_s!="N"
	*sort medcode outcome_type
	*list if medcode==321 | medcode==1286 | medcode==3014 | medcode==3258 | medcode==5056 | medcode==6433 | medcode==6747 | ///
	*medcode==16481 | medcode==20800 | medcode==33362 | medcode==93398 | medcode==103577 
	
	replace decision_s="N" if medcode==321&outcome_type=="pain";
	replace decision_s="N" if medcode==1286&outcome_type=="pain";
	replace decision_s="N" if medcode==3014&outcome_type=="pain";
	replace decision_s="N" if medcode==3258&outcome_type=="pain";
	replace decision_s="N" if medcode==5056&outcome_type=="pain";
	replace decision_s="N" if medcode==6433&outcome_type=="headache";
	replace decision_s="N" if medcode==6747&outcome_type=="pain";
	replace decision_s="N" if medcode==16481&outcome_type=="pain";
	replace decision_s="N" if medcode==16481&outcome_type=="headache";
	replace decision_s="N" if medcode==20800&outcome_type=="pain";
	replace decision_s="N" if medcode==33362&outcome_type=="pain";
	replace decision_s="N" if medcode==93398&outcome_type=="pain";
	replace decision_s="N" if medcode==103577&outcome_type=="pain";

*gastro 
	/*tab medcode outcome_type if outcome_type=="gastrointestinal" & dup2>0 & decision_s!="N"
	list medcode if dup2>0 & decision_s!="N" & outcome_type=="pain", noobs clean
	sort medcode outcome_type
	list if medcode==177 | 	medcode==290 | 	medcode==421 | 	medcode==542 | 	medcode==701 | 	medcode==1181 | 	///
	medcode==1763 | 	medcode==1976 | 	medcode==2234 | 	medcode==2982 | 	medcode==3086 | 	medcode==3338 | 	///
	medcode==3978 | 	medcode==4617 | 	medcode==4771 | 	medcode==5691 | 	medcode==5960 | 	medcode==6357 | 	///
	medcode==6395 | 	medcode==7300 | 	medcode==7490 | 	medcode==7726 | 	medcode==7812 | 	medcode==8362 | 	///
	medcode==8436 | 	medcode==8541 | 	medcode==9061 | 	medcode==9695 | 	medcode==9811 | 	medcode==9920 | 	///
	medcode==11070 | 	medcode==11647 | 	medcode==11718 | 	medcode==12639 | 	medcode==13018 | 	medcode==14807 | 	///
	medcode==14916 | 	medcode==14989 | 	medcode==15180 | 	medcode==17223 | 	medcode==17636 | 	medcode==19020 | 	///
	medcode==19223 | 	medcode==19283 | 	medcode==19360 | 	medcode==20640 | 	medcode==21583 | 	medcode==21618 | 	///
	medcode==22608 | 	medcode==23872 | 	medcode==24627 | 	medcode==24661 | 	medcode==24821 | 	medcode==25118 | 	///
	medcode==25630 | 	medcode==28285 | 	medcode==29922 | 	medcode==31062 | 	medcode==36558 | 	medcode==37101 | 	///
	medcode==41564 | 	medcode==42211 | 	medcode==44484 | 	medcode==50662 | 	medcode==51337 | 	medcode==52402 | 	///
	medcode==103540 */
	replace decision_s="N" if medcode==177&outcome_type=="pain"
	replace decision_s="N" if medcode==290&outcome_type=="pain"
	replace decision_s="N" if medcode==421&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==542&outcome_type=="pain" 
	replace decision_s="N" if medcode==701&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==1181&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==1763&outcome_type=="pain"
	replace decision_s="N" if medcode==1976&outcome_type=="pain"
	replace decision_s="N" if medcode==2234&outcome_type=="pain"
	replace decision_s="N" if medcode==2982&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==3086&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==3338&outcome_type=="pain"
	replace decision_s="N" if medcode==3978&outcome_type=="pain"
	replace decision_s="N" if medcode==4617&outcome_type=="pain"
	replace decision_s="N" if medcode==4771&outcome_type=="pain"
	replace decision_s="N" if medcode==5691&outcome_type=="pain"
	replace decision_s="N" if medcode==5960&outcome_type=="pain"
	replace decision_s="N" if medcode==6357&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==6395&outcome_type=="pain"
	replace decision_s="N" if medcode==7300&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==7490&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==7726&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==7812&outcome_type=="pain"
	replace decision_s="N" if medcode==8362&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==8436&outcome_type=="pain"
	replace decision_s="N" if medcode==8541&outcome_type=="pain"
	replace decision_s="N" if medcode==9061&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==9695&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==9811&outcome_type=="pain"
	replace decision_s="N" if medcode==9920&outcome_type=="pain"
	replace decision_s="N" if medcode==11070&outcome_type=="pain"
	replace decision_s="N" if medcode==11647&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==11718&outcome_type=="pain"
	replace decision_s="N" if medcode==12639&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==13018&outcome_type=="pain"
	replace decision_s="N" if medcode==14807&outcome_type=="pain"
	replace decision_s="N" if medcode==14916&outcome_type=="pain"
	replace decision_s="N" if medcode==14989&outcome_type=="pain"
	replace decision_s="N" if medcode==15180&outcome_type=="pain"
	replace decision_s="N" if medcode==17223&outcome_type=="pain"/*??*/
	replace decision_s="N" if medcode==17636&outcome_type=="pain"
	replace decision_s="N" if medcode==19020&outcome_type=="gastrointestinal" /*??*/
	replace decision_s="N" if medcode==19223&outcome_type=="pain"
	replace decision_s="N" if medcode==19283&outcome_type=="pain"
	replace decision_s="N" if medcode==19360&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==20640&outcome_type=="pain"
	replace decision_s="N" if medcode==21583&outcome_type=="pain"
	replace decision_s="N" if medcode==21618&outcome_type=="pain"
	replace decision_s="N" if medcode==22608&outcome_type=="pain"
	replace decision_s="N" if medcode==23872&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==24627&outcome_type=="pain"
	replace decision_s="N" if medcode==24661&outcome_type=="pain"
	replace decision_s="N" if medcode==24821&outcome_type=="pain" /*??*/
	replace decision_s="N" if medcode==25118&outcome_type=="pain"
	replace decision_s="N" if medcode==25630&outcome_type=="pain"
	replace decision_s="N" if medcode==28285&outcome_type=="pain"
	replace decision_s="N" if medcode==29922&outcome_type=="pain"
	replace decision_s="N" if medcode==31062&outcome_type=="pain"
	replace decision_s="N" if medcode==36558&outcome_type=="pain"
	replace decision_s="N" if medcode==37101&outcome_type=="pain"
	replace decision_s="N" if medcode==41564&outcome_type=="pain"
	replace decision_s="N" if medcode==42211&outcome_type=="pain"
	replace decision_s="N" if medcode==44484&outcome_type=="pain"
	replace decision_s="N" if medcode==50662&outcome_type=="pain"
	replace decision_s="N" if medcode==51337&outcome_type=="pain"
	replace decision_s="N" if medcode==52402&outcome_type=="pain"
	replace decision_s="N" if medcode==103540&outcome_type=="pain"


*muscular
	*tab medcode outcome_type if outcome_type=="muscular" & dup2>0 & decision_s!="N"

*pain
	*tab medcode outcome_type if outcome_type=="pain" & dup2>0 & decision_s!="N"
	
	/*
	sort  medcode outcome_type
	capture drop dup2
	quietly by medcode:  gen dup2 = cond(_N==1,0,_n)
	tab medcode outcome_type if dup2>0 & decision_s!="N"
	*/
	capture drop dup2
	save table_outcome_read, replace
	
	
	/* icd10 codes overlapping */
	use table_outcome_icd10, clear

	*list if icd10=="F45.3" | 	icd10=="F45.4" | 	icd10=="F48.0" | 	icd10=="G50.0" | 	icd10=="G50.1" | 	icd10=="K59.2" | icd10=="R10" | icd10=="R10.0"  | icd10=="R10.2" ///
	*| icd10=="R10.1" | icd10=="R10.3" | icd10=="R10.4" | icd10=="R14" | icd10=="R51" | icd10=="R52" | icd10=="R52.1" | icd10=="R52.2" | icd10=="R52.9" 
	
	replace decision_s="N" if icd10=="F45.3" &outcome_type=="pain"
	replace decision_s="N" if icd10=="F45.4" &outcome_type=="crps"
	replace decision_s="N" if icd10=="F48.0" &outcome_type=="muscular"
	replace decision_s="N" if icd10=="G50.0"&outcome_type=="pain"
	replace decision_s="N" if icd10=="G50.1"&outcome_type=="pain"
	replace decision_s="N" if icd10=="K59.2"&outcome_type=="neurogenic bladder"
	replace decision_s="N" if icd10=="R10"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R10.0"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R10.1"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R10.2"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R10.3"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R10.4"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R14"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R51"&outcome_type=="pain"
	replace decision_s="N" if icd10=="R52"&outcome_type=="crps"
	replace decision_s="N" if icd10=="R52.1"&outcome_type=="crps"
	replace decision_s="N" if icd10=="R52.2"&outcome_type=="crps"
	replace decision_s="N" if icd10=="R52.9"&outcome_type=="crps"

	save  table_outcome_icd10, replace
	
********************************************************************************
*derive short tables for merging - without overlap

	*medcodes short for merging
	use table_outcome_read, clear
	sort medcode
	keep medcode decision_s outcome_type
	keep if decision_s==$y | decision_s==$s
	drop if outcome_type=="asthenia" | outcome_type=="myasthenia" | outcome_type=="neuropathy" 
	duplicates drop
	save table_outcome_read_short_$codetype, replace
	*2183
	*1425 without n
	*1372 without overlapping codes and n
	*903 without overlapping codes and n and s
	
	*icd10 short for merging
	use table_outcome_icd10, clear
	sort icd10
	keep icd10 decision_s outcome_type term
	keep if decision_s==$y | decision_s==$s
	drop if outcome_type=="asthenia" | outcome_type=="myasthenia" | outcome_type=="neuropathy" 
	duplicates drop
	save table_outcome_icd10_short_$codetype, replace
	*669 all
	*568 with Y and S without overlapping 
	
	

	
	/*
	sort medcode outcome_type
	capture drop dup2
	quietly by medcode:  gen dup2 = cond(_N==1,0,_n) 
	tab medcode outcome_type if dup2>0 & decision_s!="N"
	list if medcode==7915 
	
	keep medcode
	duplicates drop
	*/
	
	/*
	drop if outcome_type=="asthenia" | outcome_type=="myasthenia" | outcome_type=="neuropathy" 
	sort icd10 outcome_type
	capture drop dup2
	quietly by icd10:  gen dup2 = cond(_N==1,0,_n)
	tab icd10 outcome_type if dup2>0 & decision_s!="N"
	*/
	

	

	
	
********************************************************************************
*medcodes***********************************************************************
********************************************************************************


		use "data_CPRD_Clinical_Additional", clear
		*12.585.994
		keep patid medcode episode medcode_desc event_date sys_date 
		
		/*
		merge m:1 medcode using "fracture_codes_gold.dta"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		sort patid
		keep patid medcode episode medcode_desc event_date sys_date 
		duplicates drop
		*29810 --> 22138 patients
		*codebook patid
		gen source="cprd_clinical"
		gen code_type="medcode"
		rename medcode code
		decode episode, gen(additional_info)
		drop episode
		order additional_info, last
		save "data_outcome_clinical_fractures", replace
		*/

		merge m:1 medcode using "table_outcome_read_short_$codetype" 
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		sort patid
		keep patid medcode episode medcode_desc event_date sys_date decision_s outcome_type
		
		duplicates drop

		gen source="cprd_clinical"
		gen code_type="medcode"
		rename medcode code
		decode episode, gen(additional_info)
		drop episode
		order additional_info, last

		save "data_outcome_clinical", replace
		*567661 
		*551125
		
		*use data_outcome_clinical, clear
		
		*list if patid==16144578
	
		
		
		**********************************************
		use "data_CPRD_Referral", clear
		*297986
		
		/*
		merge m:1 medcode using "fracture_codes_gold.dta"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		sort patid
		keep patid medcode attendance medcode_desc event_date sys_date 
		duplicates drop
		gen source="cprd_referral"
		gen code_type="medcode"
		rename medcode code
		decode attendance, gen(additional_info)
		drop attendance
		order additional_info, last
		save "data_outcome_referral_fractures", replace
		*/
		
		
		merge m:1 medcode using "table_outcome_read_short_$codetype"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		sort patid
		keep patid medcode attendance medcode_desc event_date sys_date decision_s outcome_type
		
		duplicates drop

		gen source="cprd_referral"
		gen code_type="medcode"
		rename medcode code
		decode attendance, gen(additional_info)
		drop attendance
		order additional_info, last

		save "data_outcome_referral", replace
		*20945
		*19744
		
		**********************************************
		use "data_CPRD_Test", clear
		*4.720.037
		merge m:1 medcode using "table_outcome_read_short_$codetype"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		sort patid
		gen event_date = date(eventdate, "DMY")
		format %d event_date
		gen sys_date = date(sysdate, "DMY")
		format %d sys_date
		keep patid medcode enttype medcode_desc event_date sys_date decision_s outcome_type
		
		duplicates drop

		gen source="cprd_test"
		gen code_type="medcode"
		rename medcode code
		rename enttype additional_info
		tostring additional_info, replace
		order additional_info, last

		save "data_outcome_test", replace
		*74
		*50
		
		/*
		*no matches for immunisation
		use "data_CPRD_Immunisation", clear
		keep patid medcode medcode_desc eventdate sysdate
		*3.735.359
		merge m:m medcode using "table_outcome_read_short"
		*/
		
********************************************************************************
*icd10**************************************************************************
********************************************************************************

		use "data_HES_diagnosis_hosp_patient", clear
		rename icd icd10
		capture drop _merge
	
		merge m:1 icd10 using "table_outcome_icd10_short_$codetype"
		drop if _merge==1 /*dropping unmatched*/
		drop if _merge==2 /*dropping unused medcodes*/
		drop _merge
		duplicates drop

		keep patid icd10 gen_hesid term discharged_date decision_s outcome_type
		duplicates drop
		gen source="hes"
		gen code_type="icd10"

		rename icd10 code
		rename discharged_date event_date
		rename gen_hesid additional_info
		rename term medcode_desc
		order additional_info, last
		tostring additional_info, replace

		duplicates drop

		save "data_outcome_hes", replace
		*42679
		
********************************************************************************
*merge outcomes codes***********************************************************
********************************************************************************

	use data_outcome_clinical, clear
	append using data_outcome_referral
	append using data_outcome_test
	tostring code, replace
	append using data_outcome_hes
	save  data_outcome_$codetype, replace 
	*save  data_outcome_nohes_$codetype, replace 
	*612598 YS
	*572342 Y
	*570919 YS no hes
	*tab outcome_type source
	*tab outcome_type decision_s 
	
	/*
	use data_outcome_clinical_fractures, clear
	append using data_outcome_referral_fractures
	duplicates drop
	save  data_outcome_fractures, replace 
	*/
					
********************************************************************************
*derive outcomes event level****************************************************
********************************************************************************


	use data_outcome_$codetype, clear
	keep if event_date<=ce_date-365
	keep patid outcome_type code
	duplicates drop
	tab outcome_type
	save data_outcome_event_exclude, replace
	
	/*
	*use data_patient_primary_cefu, clear
	use  data_outcome_fractures, clear 
	merge m:1 patid using "data_patient_primary_cefu"
	keep if _merge==3
	keep if event_date>=ce_date
	keep if event_date<=fu12_date
	keep patid code event_date exp 
	duplicates drop
	keep patid event_date exp 
	keep patid exp
	duplicates drop
	merge m:1 patid using data_outcome_fractures_event_exclude
	keep if _merge==1
	tab  exp
	gen s5fu12=1
	drop _merge
	save data_outcome_fractures_primary, replace
	
	
	use data_outcome_fractures, clear
	merge m:1 patid using "data_patient_primary_cefu"
	keep if _merge==3
	keep if event_date>=ce_date-365
	keep if event_date<ce_date
	keep patid code exp
	duplicates drop
	keep patid exp
	duplicates drop
	tab exp
	gen ch_s5=0
	save data_outcome_fractures_event_exclude, replace
	*/

	
	*use data_outcome_YS, clear
	*save "data_outcome_event_nohes_$codetype", replace
	*583167 YS
	*544760 Y
	*547693 YS no hes
	
	/*
	use data_outcome_event_nohes_YS, clear
	*547693
	
	use data_outcome_event_nohes_YS, clear
	use data_outcome_event_YS, clear
	tab decision_s
	use data_outcome_event_Y, clear
	*583167
	
	drop if decision_s=="S"
	save data_outcome_event_nohes_Y, replace
	*/
	
	/*
	use data_outcome_Y, clear
	tab source
	drop if source=="hes"
	keep patid event_date outcome_type decision_s
	sort patid event_date outcome_type decision_s
	duplicates drop
	*519635
	save data_outcome_event_nohes_Y, replace
	
	use data_outcome_event_nohes_Y, clear
	use data_outcome_event_Y, clear
	*544760
	*/
	
	/*
	use data_outcome_YS, clear
	tab source
	drop if source=="hes"
	keep patid event_date outcome_type decision_s
	sort patid event_date outcome_type decision_s
	duplicates drop
	*547693
	save data_outcome_event_nohes_YS, replace
	
	use data_outcome_event_nohes_YS, clear
	use data_outcome_event_YS, clear
	*583167
	*/

	
********************************************************************************
