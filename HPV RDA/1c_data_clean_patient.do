
********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"
	
	
********************************************************************************
*** Patient dataset *** merge with practice and others**************************
********************************************************************************

	use "raw_CPRD_Patient_001.dta" , clear

	replace yob=yob+1800

	label define gender 1 "Male" 2 "Female"
	label values gender gender

	replace marital=6 if marital==0 
	label define marital 1 "Single" 2 "Married" 3 "Widowed" 4 "Divorced" 5 "Separated" 6 "Unknown" 7 "Engaged" 8 "Co-habiting" 9 "Remarried" 10 "Stable relationship" 11 "Civil partnership"
	label values marital marital

	label define transferoutreason 0 "Data Not Entered" 1 "Death" 2	"Removal to new TP/HB/CSA" 3	"Internal Transfer" 4	"Mental Hospital" 5	"Embarkation" 6	"New TP/HB/CSA/Same GP" 7	"Adopted Child" 8	"Services" 9	"Deduction at GP's Request" 10	"Registration Cancelled" 11	"Service Dependant" 12	"Deduction at Patient's Request" 13	"Other reason" 14	"Enlistment" 15	"Institution" 16	"Transfer within Practice" 17	"Linkage" 18	"Untraced - Miscellaneous" 19	"Untraced - Immig" 20	"Untraced - GP Resign" 21	"Untraced - College" 22	"Untraced - outwith Practice" 23	"Untraced - outwith HB" 24	"Multiple Transfer" 25	"Intra-consortium transfer" 26	"Returned Undelivered" 27	"Internal Transfer - Address Change" 28	"Internal Transfer within Partnership" 29	"Correspondence states 'gone away'" 30	"Practice advise outside their area" 31	"Practice advise patient no longer resident" 32	"Practice advise removal via screening system" 33	"Practice advise removal via vaccination data" 34	"Removal from Residential Institute"
	label values toreason transferoutreason 

	label variable frd "Date first registered with practice"
	label variable crd "Date currently registered with practice after transfer out"
	label variable gender "Gender"
	label variable marital "Marital Status"
	label variable yob "Year of birth"
	label variable mob "Month of birth"
	label variable regstat "Status of registration"
	label variable reggap "Number of days missing in the registration"
	label variable internal "Number of internal transfer out periods"
	label variable tod "Date the patient transferred out of the practice"
	label variable toreason "Reason the patient transferred out of the practice"
	label variable deathdate "Date of death of patient"

	*keep patid gender yob marital frd deathdate
	drop vmid accept famnum prescr capsup chsreg chsdate

****************

	gen pracid = mod(patid,1000)
	merge m:1 pracid using "raw_CPRD_Practice_001.dta", assert(master) keep(master) generate(_merge2)
	drop _merge2

	/*
	gen pracid = mod(patid,1000)
	cfvars "raw_allpractices_AUG2018"
	merge m:1 pracid using "raw_allpractices_AUG2018", assert(master) keep(master) generate(_merge)
	drop _merge
	*/

	label define region 0	"Missing" 1	"North East"		2	"North West"		3	"Yorkshire & The Humber"		4	"East Midlands"		5	"West Midlands"		6	"East of England"		7	"South West"		8	"South Central"		9	"London"		10	"South East Coast"		11	"Northern Ireland"		12	"Scotland"		13	"Wales"
	label values region region
	label variable region "Region of Practice"
	label variable lcd "Date of the last collection for the practice"
	label variable uts "Date at which the practice data is deemed to be of research quality"

		gen frd_date = date(frd, "DMY")
		gen crd_date = date(crd, "DMY")
		gen tod_date = date(tod, "DMY")
		gen death_date = date(deathdate, "DMY")
		gen uts_date = date(uts, "DMY")
		gen lcd_date = date(lcd, "DMY")
		format %d frd_date crd_date uts_date lcd_date tod_date death_date
		*egen start_date = rowmax(crd_date uts_date) 
		*egen exit_date = rowmin(tod_date /*death_date*/ lcd_date)
		*format %d start_date exit_date	
		
	label variable frd_date "Date first registered with practice"
	label variable crd_date "Date currently registered with practice after transfer out"
	label variable tod_date "Date the patient transferred out of the practice"
	label variable death_date "Date of death of patient"
	label variable lcd_date "Date of the last collection for the practice"
	label variable uts_date "Date at which the practice data is deemed to be of research quality"
		

	egen primary=anymatch(yob), v(2000/2005)
	replace primary=0 if inlist(mob,0,1,2,3,4,5,6,11,12)
	egen sens1=anymatch(yob), v(1994/1996)
	egen sens2=anymatch(yob), v(1998/2000)
	*table yob mob
	*table yob mob primary
	*table yob mob sens1
	*table yob mob sens2

	*drop string dates
	drop frd crd tod deathdate lcd uts 


****************

	merge m:1 patid using "raw_lookup_linkage_eligibility"
	drop  death_e cr_e mh_e _merge
	*tab hes_e /*79734*/
	*tab lsoa_e /*79734*/
	gen link_date = date(linkdate, "DMY")
	format %d link_date
	drop linkdate

****************

	merge m:1 patid using "raw_HES_patient"
	drop _merge
	*52455

	*encoude strinf variables
	*tab gen_ethnicity
	encode gen_ethnicity, gen(ethnicity2)
	*describe
	*tab gen_ethnicity ethnicity, nolab
	replace ethnicity=0 if ethnicity==11
	replace ethnicity=11 if ethnicity==12
	drop gen_ethnicity


****************

	merge m:1 patid using "raw_IMD2015_patient"
	drop _merge
	*79734

	*drop hes_apc_start hes_apc_end
	gen hes_apc_start = date("01/04/1997", "DMY") if hes_e == 1
	gen hes_apc_end = date("31/12/2017", "DMY") if hes_e == 1
	format %d hes_apc_start hes_apc_end

****************
*primary

	gen primary_ce="01/09/2012" if primary == 1
	replace primary_ce="01/09/2013" if yob==2001
	replace primary_ce="01/09/2014" if yob==2002
	replace primary_ce="01/09/2015" if yob==2003
	replace primary_ce="01/09/2016" if yob==2004
	replace primary_ce="01/09/2017" if yob==2005
	tab  primary_ce yob

	gen primary_ce_date = date(primary_ce, "DMY")
	format %d primary_ce_date
	drop primary_ce

	gen primary_fu="01/03/2013" if primary == 1
	replace primary_fu="01/03/2014" if yob==2001
	replace primary_fu="01/03/2015" if yob==2002
	replace primary_fu="01/03/2016" if yob==2003
	replace primary_fu="01/03/2017" if yob==2004
	replace primary_fu="01/03/2018" if yob==2005
	tab  primary_fu yob

	gen primary_fu6_date = date(primary_fu, "DMY")
	format %d primary_fu6_date
	drop primary_fu
	
	gen primary_fu="01/09/2013" if primary == 1
	replace primary_fu="01/09/2014" if yob==2001
	replace primary_fu="01/09/2015" if yob==2002
	replace primary_fu="01/09/2016" if yob==2003
	replace primary_fu="01/09/2017" if yob==2004
	replace primary_fu="01/09/2018" if yob==2005
	tab  primary_fu yob

	gen primary_fu12_date = date(primary_fu, "DMY")
	format %d primary_fu12_date
	drop primary_fu

	gen primary_exp=1 if primary == 1
	replace primary_exp=0 if mob==9 & primary==1
	replace primary_exp=0 if mob==10 & primary==1


****************
*sens1 unsure about follow up date for sens analysis!!

	gen sens1_ce="01/09/2006" if sens1 == 1
	replace sens1_ce="01/09/2008" if yob==1996
	tab  sens1_ce yob
	gen sens1_ce_date = date(sens1_ce, "DMY")
	format %d sens1_ce_date
	drop sens1_ce

	gen sens1_fu="01/09/2008" if sens1 == 1
	replace sens1_fu="01/09/2010" if yob==1996
	tab  sens1_fu yob
	gen sens1_fu12_date = date(sens1_fu, "DMY")
	format %d sens1_fu12_date
	drop sens1_fu

	gen sens1_exp=1 if sens1==1
	replace sens1_exp=0 if yob==1994

****************
*sens2 unsure about follow up date for sens analysis!!

	gen sens2_ce="01/09/2010" if sens2 == 1
	replace sens2_ce="01/09/2012" if yob==2000
	tab  sens2_ce yob
	gen sens2_ce_date = date(sens2_ce, "DMY")
	format %d sens2_ce_date
	drop sens2_ce

	gen sens2_fu="01/09/2012" if sens2 == 1
	replace sens2_fu="01/09/2014" if yob==2000
	tab  sens2_fu yob
	gen sens2_fu12_date = date(sens2_fu, "DMY")
	format %d sens2_fu12_date
	drop sens2_fu

	gen sens2_exp=1 if sens2==1
	replace sens2_exp=0 if yob==1998


	/*
	tab yob sens1_exp
	tab sens1_exp sens1_fu
	tab sens1_exp sens1_ce

	tab yob sens2_exp
	tab sens2_exp sens2_fu
	tab sens2_exp sens2_ce

	tab yob primary
	drop counter
	gen counter=1
	tab yob counter
	tab yob primary_exp
	tab mob primary_exp
	tab yob mob if primary==1
	*/

	*save "data_CPRD_Patient_Practice", replace


****************
***add immunisation data

	*use "data_CPRD_Patient_Practice", replace
	
	*add first immunisation record
	cfvars "data_CPRD_Immunisation_hpv_firstdate"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_firstdate" 
	drop if _merge==2
	drop _merge

	cfvars "data_CPRD_Immunisation_hpv_firststage"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_firststage" 
	drop if _merge==2
	drop _merge

	cfvars "data_CPRD_Immunisation_hpv_stagecount"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_stagecount" 
	drop if _merge==2
	drop _merge

	cfvars "data_CPRD_Immunisation_hpv_stagemax"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_stagemax" 
	drop if _merge==2
	drop _merge


	cfvars "data_CPRD_Immunisation_hpv_refused_firstdate"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_refused_firstdate" 
	drop if _merge==2
	drop _merge
	*no need for refused stage max becayse same as first date


	rename stagecount stagecount_imm
	rename stagemax stagemax_imm

	/*
	tab stagecount_imm stagemax_imm, missing
	tab  stage_imm_refused_firstdate stagecount_imm, missing
	list if   event_date_imm_refused_firstdate<  event_date_imm_firstdate
	sort event_date_imm_refused_firstdate
	*/

	*save "data_CPRD_Patient_Practice", replace
	*use "data_CPRD_Patient_Practice", clear

	*add date of first stage1 record
	cfvars "data_CPRD_Immunisation_hpv_stage1"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_stage1" 
	drop if _merge==2
	drop _merge

	*add date of first stage2 record
	cfvars "data_CPRD_Immunisation_hpv_stage2"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_stage2" 
	drop if _merge==2
	drop _merge

	*add date of first stage3 record
	cfvars "data_CPRD_Immunisation_hpv_stage3"
	merge m:1 patid using "data_CPRD_Immunisation_hpv_stage3" 
	drop if _merge==2
	drop _merge
	
	
	gen event_count_imm_stage1=0 if event_date_imm_stage1==.
	replace event_count_imm_stage1=1 if event_count_imm_stage1==.

	gen event_count_imm_stage2=0 if event_date_imm_stage2==.
	replace event_count_imm_stage2=1 if event_count_imm_stage2==.

	gen event_count_imm_stage3=0 if event_date_imm_stage3==.
	replace event_count_imm_stage3=1 if event_count_imm_stage3==.


****************

	label variable hes_e "hes eligibility"
	label variable lsoa_e "imd2015 eligibility"
	label variable link_date "linkage date"
	label variable gen_hesid "patient identifier hes"
	label variable n_patid_hes "number of practices for hes patient id"
	label variable imd2015_5 "imd2015 5-score "
	label variable hes_apc_start "hes linkage coverage start"
	label variable hes_apc_end "hes linkage coverage end"
	label variable primary_ce_date "cohort entry date - primary"
	label variable primary_fu6_date "follow up date 6months - primary"
	label variable primary_fu12_date "follow up date 12months - primary"
	label variable primary_exp "exposure groups - primary"
	label variable sens1_exp "exposure groups - sens1"
	label variable sens2_exp "exposure groups - sens2"
	label variable sens1_ce_date "cohort entry date - sens1"
	label variable sens2_ce_date "cohort entry date - sens2"
	label variable sens1_fu12_date "follow up date 12 months - sens1"
	label variable sens2_fu12_date "follow up date 12 months - sens2"
	label variable stage_imm_firstdate "immunisation stage of the earliest record"
	label variable event_date_imm_firstdate "immunisation date of the earliest record"
	label variable stage_imm_firststage "first available immunisation stage"
	label variable event_date_imm_firststage "immunisation date of the first available immunisation stage"
	label variable stagemax_imm "highest immunisation stage patient received(max) stage"
	label variable stagecount_imm "number of immunisation stages patient received -  (max) nvals"
	label variable ethnicity "patient ethnicity - hes"
	label variable match_rank "hes matching quality indicator"
	label variable patid "patient identifier cprd"
	label variable pracid "practice identifier cprd"
	label variable event_date_imm_refused_firstdate "immunisation refusal date of the earliest record"
	label variable stage_imm_refused_firstdate "immunisation stage of the earliest refusal record"
	label variable event_date_imm_stage1 "first immunisation date"
	label variable event_date_imm_stage2 "second immunisation date"
	label variable event_date_imm_stage3 "third  immunisation date"
	label variable event_count_imm_stage1 "first immunisation date flag"
	label variable event_count_imm_stage2 "second immunisation date flag"
	label variable event_count_imm_stage3 "third  immunisation date flag"

	
	save "data_CPRD_Patient_Practice", replace
	*136631

********************************************************************************
***primary analyses*************************************************************
********************************************************************************


	use "data_CPRD_Patient_Practice", clear
	*136631

	*save patient dataset for primary analyses
	drop if primary==0
	drop sens1_ce_date sens1_fu12_date sens2_ce_date sens2_fu12_date sens2_exp sens1_exp sens1 sens2 primary

	gen uts_ce = primary_ce_date-uts_date
	sort uts_ce
	drop if uts_ce<365
	drop uts_ce

	rename primary_ce_date ce_date
	rename primary_exp exp
	rename primary_fu6_date fu6_date 
	rename primary_fu12_date fu12_date

	save "data_CPRD_Patient_Practice_primary", replace
	*30142
	
********************************************************************************
***primary analysis cefu lookup table ******************************************
********************************************************************************

	use "data_CPRD_Patient_Practice_primary", clear

	/*
	*scotland 3423
	drop if region==12
	*wales 3787
	drop if region==13

	*11411 exposed (7 and 8)
	tab yob mob if primary_exp==1
	*111521 unexposed (9 and 10)
	tab yob mob if primary_exp==0
	*/

	keep patid ce_date fu6_date fu12_date exp uts_date mob death_date lcd_date tod_date hes_apc_start hes_apc_end frd_date crd_date

	
	gen  fu6_date_dropall= fu6_date
	format %d fu6_date_dropall
	replace fu6_date_dropall=lcd_date if lcd_date<fu6_date_dropall & lcd_date>=ce_date
	*2404
	replace fu6_date_dropall=death_date if death_date<fu6_date_dropall & death_date>=ce_date
	*2
	replace fu6_date_dropall= tod_date if tod_date<fu6_date_dropall & tod_date>=ce_date
	*648
	
	gen  fu12_date_dropall= fu12_date
	format %d fu12_date_dropall
	replace fu12_date_dropall=lcd_date if lcd_date<fu12_date_dropall & lcd_date>=ce_date
	*9864
	replace fu12_date_dropall=death_date if death_date<fu12_date_dropall & death_date>=ce_date
	*3
	replace fu12_date_dropall= tod_date if tod_date<fu12_date_dropall & tod_date>=ce_date
	*1073
	
	/*
	* last birth year not covered by apc - end befroe cohort entry, others are covered fully
	
	gen  primary_fu6_date_drophes= primary_fu6_date
	format %d primary_fu6_date_drophes
	replace primary_fu6_date_drophes=lcd_date if lcd_date<primary_fu6_date_drophes & lcd_date>=primary_ce_date
	*2404
	replace primary_fu6_date_drophes=death_date if death_date<primary_fu6_date_drophes & death_date>=primary_ce_date
	*2
	replace primary_fu6_date_drophes= tod_date if tod_date<primary_fu6_date_drophes & tod_date>=primary_ce_date
	*648
	replace primary_fu6_date_drophes=  hes_apc_end if hes_apc_end<primary_fu6_date_drophes & hes_apc_end>=primary_ce_date
	*1850
	replace primary_fu6_date_drophes=  hes_apc_end if hes_apc_end<primary_fu6_date_drophes & hes_apc_end>=primary_ce_date
	*1850
	*/
	
	keep patid ce_date fu6_date fu12_date exp uts_date mob fu6_date_dropall fu12_date_dropall frd_date crd_date

	save "data_patient_primary_cefu", replace
	*30142
	
********************************************************************************
***sens1 analyses*************************************************************
********************************************************************************


	use "data_CPRD_Patient_Practice", clear

	*save patient dataset for primary analyses
	drop if sens1==0
	drop  primary_ce_date primary_fu6_date primary_fu12_date primary_exp sens2_ce_date sens2_fu12_date sens2_exp sens2 primary 
	drop sens1

	gen uts_ce = sens1_ce_date-uts_date
	sort uts_ce
	drop if uts_ce<365
	drop uts_ce
	
	rename sens1_exp exp
	rename sens1_fu12_date fu12_date
	rename sens1_ce_date ce_date
	
	capture drop fu6_date
	gen fu6_date=fu12_date-184
	format %d fu6_date
	order fu6_date, before (fu12_date)
	
	save "data_CPRD_Patient_Practice_sens1", replace
	*55687
	
********************************************************************************
***sens1 analysis cefu lookup table ******************************************
********************************************************************************

	use "data_CPRD_Patient_Practice_sens1", clear

	keep patid ce_date fu6_date fu12_date exp uts_date mob death_date lcd_date tod_date hes_apc_start hes_apc_end frd_date crd_date
	
	gen  fu6_date_dropall= fu6_date
	format %d fu6_date_dropall
	replace fu6_date_dropall=lcd_date if lcd_date<fu6_date_dropall & lcd_date>=ce_date /*exit date = last collection*/
	replace fu6_date_dropall=death_date if death_date<fu6_date_dropall & death_date>=ce_date /*exit date = death*/
	replace fu6_date_dropall= tod_date if tod_date<fu6_date_dropall & tod_date>=ce_date /*exit date = transfer out*/

	gen  fu12_date_dropall= fu12_date
	format %d fu12_date_dropall
	replace fu12_date_dropall=lcd_date if lcd_date<fu12_date_dropall & lcd_date>=ce_date
	replace fu12_date_dropall=death_date if death_date<fu12_date_dropall & death_date>=ce_date
	replace fu12_date_dropall= tod_date if tod_date<fu12_date_dropall & tod_date>=ce_date

	keep patid ce_date fu6_date fu12_date exp uts_date mob fu6_date_dropall fu12_date_dropall frd_date crd_date
	
	/*
	capture drop len6
	gen len6=fu6_date_dropall-ce_date
	hist len6
	capture drop len12
	gen len12=fu12_date_dropall-ce_date
	hist len12 if len12<1
	sum len12
	list patid if len12<1, noobs clean
	list if patid==5071071
	*/
	
	save "data_patient_sens1_cefu", replace
	*55687

********************************************************************************
***sens2 analyses*************************************************************
********************************************************************************

	use "data_CPRD_Patient_Practice", clear

	drop if sens2==0
	drop  primary_ce_date primary_fu6_date primary_fu12_date primary_exp sens1_ce_date sens1_fu12_date sens1_exp sens1 primary

	gen uts_ce = sens2_ce_date-uts_date
	sort uts_ce
	drop if uts_ce<365
	drop uts_ce
	
	rename sens2_exp exp
	rename sens2_fu12_date fu12_date
	rename sens2_ce_date ce_date
	
	capture drop fu6_date
	gen fu6_date=fu12_date-184
	format %d fu6_date
	order fu6_date, before (fu12_date)

	save "data_CPRD_Patient_Practice_sens2", replace
	*54447
	
********************************************************************************
***sens2 analysis cefu lookup table ******************************************
********************************************************************************

	use "data_CPRD_Patient_Practice_sens2", clear

	keep patid ce_date fu6_date fu12_date exp uts_date mob death_date lcd_date tod_date hes_apc_start hes_apc_end frd_date crd_date
	
	gen  fu6_date_dropall= fu6_date
	format %d fu6_date_dropall
	replace fu6_date_dropall=lcd_date if lcd_date<fu6_date_dropall & lcd_date>=ce_date
	replace fu6_date_dropall=death_date if death_date<fu6_date_dropall & death_date>=ce_date
	replace fu6_date_dropall= tod_date if tod_date<fu6_date_dropall & tod_date>=ce_date
	
	gen  fu12_date_dropall= fu12_date
	format %d fu12_date_dropall
	replace fu12_date_dropall=lcd_date if lcd_date<fu12_date_dropall & lcd_date>=ce_date
	replace fu12_date_dropall=death_date if death_date<fu12_date_dropall & death_date>=ce_date
	replace fu12_date_dropall= tod_date if tod_date<fu12_date_dropall & tod_date>=ce_date

	keep patid ce_date fu6_date fu12_date exp uts_date mob fu6_date_dropall fu12_date_dropall frd_date crd_date
	
	save "data_patient_sens2_cefu", replace
	*54447

********************************************************************************
*primarylink - subset of patients with hes linkage only ************************
********************************************************************************

use "data_CPRD_Patient_Practice", clear
	*136631

	*save patient dataset for primary analyses
	drop if primary==0
	drop sens1_ce_date sens1_fu12_date sens2_ce_date sens2_fu12_date sens2_exp sens1_exp sens1 sens2 primary

	gen uts_ce = primary_ce_date-uts_date
	sort uts_ce
	drop if uts_ce<365
	drop uts_ce

	rename primary_ce_date ce_date
	rename primary_exp exp
	rename primary_fu6_date fu6_date 
	rename primary_fu12_date fu12_date
	
	*tab hes_e, missing
	drop if hes_e==.

	save "data_CPRD_Patient_Practice_primary_link", replace
	*17126

********************************************************************************
***primary link cefu lookup table **********************************************
********************************************************************************

	use "data_CPRD_Patient_Practice_primary_link", clear

	keep patid ce_date fu6_date fu12_date exp uts_date mob death_date lcd_date tod_date hes_apc_start hes_apc_end frd_date crd_date

	
	gen  fu6_date_dropall= fu6_date
	format %d fu6_date_dropall
	replace fu6_date_dropall=lcd_date if lcd_date<fu6_date_dropall & lcd_date>=ce_date
	*2404
	replace fu6_date_dropall=death_date if death_date<fu6_date_dropall & death_date>=ce_date
	*2
	replace fu6_date_dropall= tod_date if tod_date<fu6_date_dropall & tod_date>=ce_date
	*648
	
	gen  fu12_date_dropall= fu12_date
	format %d fu12_date_dropall
	replace fu12_date_dropall=lcd_date if lcd_date<fu12_date_dropall & lcd_date>=ce_date
	*9864
	replace fu12_date_dropall=death_date if death_date<fu12_date_dropall & death_date>=ce_date
	*3
	replace fu12_date_dropall= tod_date if tod_date<fu12_date_dropall & tod_date>=ce_date
	*1073
	
	keep patid ce_date fu6_date fu12_date exp uts_date mob fu6_date_dropall fu12_date_dropall frd_date crd_date

	save "data_patient_primary_link_cefu", replace
	*17126
	
********************************************************************************
*primary_3d - subset of patients born in 2000 - 2001 - 3 doses******************
********************************************************************************

use "data_CPRD_Patient_Practice", clear
	*136631

	*save patient dataset for primary analyses
	drop if primary==0
	drop sens1_ce_date sens1_fu12_date sens2_ce_date sens2_fu12_date sens2_exp sens1_exp sens1 sens2 primary

	gen uts_ce = primary_ce_date-uts_date
	sort uts_ce
	drop if uts_ce<365
	drop uts_ce

	rename primary_ce_date ce_date
	rename primary_exp exp
	rename primary_fu6_date fu6_date 
	rename primary_fu12_date fu12_date
	
	/*
	global yob "2000"
	global exp "1"
	twoway histogram event_date_imm_stage1 if event_date_imm_stage1>=ce_date & event_date_imm_stage1<fu12_date & exp==1, by(yob) frequency
	twoway histogram event_date_imm_stage2 if event_date_imm_stage2>=ce_date & event_date_imm_stage2<fu12_date & exp==1, by(yob) frequency
	twoway histogram event_date_imm_stage3 if event_date_imm_stage3>=ce_date & event_date_imm_stage3<fu12_date & exp==1, by(yob) frequency
	
	global yob "2005"
	global exp "1"
	twoway histogram event_date_imm_stage1 if event_date_imm_stage1>=ce_date & event_date_imm_stage1!=. & yob==$yob & exp==$exp, frequency
	twoway histogram event_date_imm_stage2 if event_date_imm_stage2>=ce_date & event_date_imm_stage1!=.& yob==$yob & exp==$exp, frequency
	twoway histogram event_date_imm_stage3 if event_date_imm_stage3>=ce_date & event_date_imm_stage1!=. & yob==$yob & exp==$exp, frequency
	
	gen  event_year_imm_stage1=year(event_date_imm_stage1)
	gen  event_year_imm_stage2= year(event_date_imm_stage2)
	gen  event_year_imm_stage3= year(event_date_imm_stage3)
	
	gen  event_gap_imm_stage1=event_year_imm_stage1-yob-12
	gen  event_gap_imm_stage2=event_year_imm_stage2-yob-12
	gen  event_gap_imm_stage3=event_year_imm_stage3-yob-12
	
	gen  event_days_imm_stage1=event_date_imm_stage1-ce_date
	gen  event_days_imm_stage2=event_date_imm_stage2-ce_date
	gen  event_days_imm_stage3=event_date_imm_stage3-ce_date
	
	tab event_days_imm_stage1 if yob==2000 & exp==1 & event_days_imm_stage1>=0
	
	hist event_days_imm_stage1 if exp==1 & event_days_imm_stage1>=0 & event_days_imm_stage1<=365, bin(50) by (yob) kdensity 
	hist event_days_imm_stage2 if exp==1 & event_days_imm_stage2>=0 & event_days_imm_stage2<=730, bin(50) by (yob) kdensity
	hist event_days_imm_stage3 if exp==1 & event_days_imm_stage3>=0 & event_days_imm_stage3<=365, bin(50) by (yob) kdensity
	
	hist event_days_imm_stage1 if exp==1 & event_days_imm_stage1>=0 & event_days_imm_stage1<=730, bin(50) by (yob) frequency 
	hist event_days_imm_stage2 if exp==1 & event_days_imm_stage2>=0 & event_days_imm_stage2<=730, bin(50) by (yob) frequency
	hist event_days_imm_stage3 if exp==1 & event_days_imm_stage3>=0 & event_days_imm_stage3<=730, bin(50) by (yob) frequency
	
	graph box event_days_imm_stage1 if exp==1 & event_days_imm_stage1>=0 & event_days_imm_stage1<=365, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal
	graph box event_days_imm_stage2 if exp==1 & event_days_imm_stage2>=0 & event_days_imm_stage2<=365, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal
	graph box event_days_imm_stage3 if exp==1 & event_days_imm_stage3>=0 & event_days_imm_stage3<=365, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal

	graph box event_days_imm_stage1 if exp==1 & event_days_imm_stage1>=366 & event_days_imm_stage1<=730, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal
	graph box event_days_imm_stage2 if exp==1 & event_days_imm_stage2>=366 & event_days_imm_stage2<=730, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal
	graph box event_days_imm_stage3 if exp==1 & event_days_imm_stage3>=366 & event_days_imm_stage3<=730, over(yob) medtype(marker) medmarker(msymbol(diamond)) horizontal

	tab yob event_gap_imm_stage1 if exp==1 & event_year_imm_stage1>=yob+12
	tab yob event_gap_imm_stage2 if exp==1 & event_year_imm_stage2>=yob+12
	tab yob event_gap_imm_stage3 if exp==1 & event_year_imm_stage3>=yob+12
	
	tab yob event_gap_imm_stage1 if exp==0 & event_year_imm_stage1>=yob+12
	tab yob event_gap_imm_stage2 if exp==0 & event_year_imm_stage2>=yob+12
	tab yob event_gap_imm_stage3 if exp==0 & event_year_imm_stage3>=yob+12
	
	tab  yob exp if event_date_imm_stage1>=ce_date & event_date_imm_stage1<fu12_date, sum(event_count_imm_stage1)
	tab  yob exp if event_date_imm_stage2>=ce_date & event_date_imm_stage2>=fu12_date & event_count_imm_stage2!=0, sum(event_count_imm_stage2)
	*/

	drop if yob!=2000 & yob!=2001
	save "data_CPRD_Patient_Practice_primary_3d", replace
	*7801

********************************************************************************
***primary 3d cefu lookup table ************************************************
********************************************************************************

	use "data_CPRD_Patient_Practice_primary_3d", clear

	keep patid ce_date fu6_date fu12_date exp uts_date mob death_date lcd_date tod_date hes_apc_start hes_apc_end frd_date crd_date

	
	gen  fu6_date_dropall= fu6_date
	format %d fu6_date_dropall
	replace fu6_date_dropall=lcd_date if lcd_date<fu6_date_dropall & lcd_date>=ce_date
	*2404
	replace fu6_date_dropall=death_date if death_date<fu6_date_dropall & death_date>=ce_date
	*2
	replace fu6_date_dropall= tod_date if tod_date<fu6_date_dropall & tod_date>=ce_date
	*648
	
	gen  fu12_date_dropall= fu12_date
	format %d fu12_date_dropall
	replace fu12_date_dropall=lcd_date if lcd_date<fu12_date_dropall & lcd_date>=ce_date
	*9864
	replace fu12_date_dropall=death_date if death_date<fu12_date_dropall & death_date>=ce_date
	*3
	replace fu12_date_dropall= tod_date if tod_date<fu12_date_dropall & tod_date>=ce_date
	*1073
	
	keep patid ce_date fu6_date fu12_date exp uts_date mob fu6_date_dropall fu12_date_dropall frd_date crd_date

	save "data_patient_primary_3d_cefu", replace
	*7801

********************************************************************************

