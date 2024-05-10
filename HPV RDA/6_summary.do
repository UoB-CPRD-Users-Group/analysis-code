

********************************************************************************
*****************************location*******************************************
********************************************************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\16_294\Data Analysis\workingdata"


********************************************************************************
****time to vaccines***


	use "data_analysis_primary", clear

	/*
	tabulate yob primary_exp, col missing
	tabulate mob primary_exp, col missing
	tabulate region primary_exp, col missing
	tab vaccinehpv1 primary_exp, missing
	tabulate vaccinehpv1 primary_exp, row missing
	*/

	*tab event_date_imm_stage1

	/*
	gen event_month_imm_stage1=month(event_date_imm_stage1)
	gen event_month_imm_stage2=month(event_date_imm_stage2)
	gen event_month_imm_stage3=month(event_date_imm_stage3)

	gen event_year_imm_stage1=year(event_date_imm_stage1)
	gen event_year_imm_stage2=year(event_date_imm_stage2)
	gen event_year_imm_stage3=year(event_date_imm_stage3)
	*/

	gen timetovaccine1=event_date_imm_stage1-primary_ce_date if event_date_imm_stage1>=primary_ce_date
	gen timetovaccine2=event_date_imm_stage2-primary_ce_date if event_date_imm_stage2>=primary_ce_date
	gen timetovaccine3=event_date_imm_stage3-primary_ce_date if event_date_imm_stage3>=primary_ce_date
	*gen timetovaccineanyfirst=event_date_imm_firstdate-primary_ce_date if event_date_imm_firstdate>=primary_ce_date

	hist timetovaccine1 if primary_exp==1 & timetovaccine1<=730, by (yob) width(30)
	hist timetovaccine1 if primary_exp==0 & timetovaccine1<=730, by (yob) width(30)

	hist timetovaccine2 if primary_exp==1 & timetovaccine1<=730, by (yob) width(30)
	hist timetovaccine2 if primary_exp==0 & timetovaccine1<=730, by (yob) width(30)

	hist timetovaccine3 if primary_exp==1 & timetovaccine1<=730, by (yob) width(30)
	hist timetovaccine3 if primary_exp==0 & timetovaccine1<=730, by (yob) width(30)



	capture drop timetovaccinea1to2
	gen timetovaccinea1to2=event_date_imm_stage2-event_date_imm_stage1 if event_date_imm_stage1>=primary_ce_date & event_date_imm_stage2>=event_date_imm_stage1
	hist timetovaccinea1to2 if primary_exp==1, by (yob) width(30)
	hist timetovaccinea1to2 if primary_exp==0, by (yob) width(30)


	bysort yob primary_exp:sum timetovaccinea1to2
	bysort yob primary_exp:sum timetovaccine1

	*graph bar (count) if primary_exp==1 & yob==2003 & event_date_imm_stage1<= primary_ce_date+365 & event_date_imm_stage1>= primary_ce_date-360, over(event_month_imm_stage1) over(event_year_imm_stage1) by(yob) blabel(total) 


	/*
	tab yob primary_ce_date
	tab event_count_imm_stage1 birth_date
	tab event_date_imm_stage1 event_month_imm_stage1
	tab event_month_imm_stage1 event_count_imm_stage1, missing

	graph bar (count) if primary_exp==1 & yob==2005 , over(event_month_imm_stage1) over(event_year_imm_stage1) by(yob) blabel(total) 
	graph bar (count) if primary_exp==1 & yob==2005 & event_date_imm_stage1<= primary_ce_date+730 & event_date_imm_stage1>= primary_ce_date-365, over(event_month_imm_stage1) over(event_year_imm_stage1) by(yob) blabel(total) 
	graph bar (count) if primary_exp==1 & yob==2003 & event_date_imm_stage1<= primary_ce_date+365 & event_date_imm_stage1>= primary_ce_date-360, over(event_month_imm_stage1) over(event_year_imm_stage1) by(yob) blabel(total) 


	graph bar (count), over(event_year_imm_stage1) over (yob) blabel(total)
	graph bar (count), over (event_month_imm_stage2) blabel(total) 
	graph bar (count), over (event_month_imm_stage3) blabel(total) 

	bysort primary_ce_date: tab  event_month_imm_stage2 event_year_imm_stage1 if primary_exp==1
	*/

************************************************************************************
*plot bars for categorical variables


	graph bar (count), over (yob) missing blabel(total) 
	graph bar (count), over (mob) missing blabel(total) 
	graph bar (count), over (region) missing blabel(total) 
	graph bar (count), over (vaccinehpv6) over (primary_exp) missing blabel(total) 
	graph bar (count), over (vaccinehpv12) over (primary_exp) missing blabel(total)


************************************************************************************
*check outcome counts within folow up periods

	use data_outcome_pain_all, clear
	use data_outcome_crps_all, clear
	*keep patid event_date 
	*sort patid event_date 
	*duplicates drop
	*2695

	merge m:1 patid using "data_patient_primary_cefu"
	keep if _merge==3 
	drop _merge
	sort patid event_date 
	keep patid event_date primary_ce_date primary_fu_date primary_fu12_date primary_exp
	duplicates drop
	*414
	sort patid

	/*
	by patid, sort: gen nvals = _n == 1 
	by patid: replace nvals = sum(nvals)
	by patid: replace nvals = nvals[_N] 
	*/

	bysort primary_exp: count if event_date<primary_ce_date
	bysort primary_exp: count if event_date>=primary_ce_date


	bysort primary_exp: count if event_date>=primary_ce_date & event_date<primary_fu_date
	bysort primary_exp: count if event_date>=primary_ce_date & event_date<primary_fu12_date



	*drop if event_date<primary_ce_date
	*drop if event_date>=primary_fu_date
	*20 (11 patients)
	*sort patid event_date 

	*save  "data_outcome_datesall_muscular_all", replace

	gen primary_fu_flag=1 if event_date>=primary_ce_date & event_date<primary_fu_date
	gen primary_fu12_flag=1 if event_date>=primary_ce_date & event_date<primary_fu12_date

	*use data_outcome_datesall_muscular_all, clear
	by patid, sort: gen nvals = _n == 1 
	by patid: replace nvals = sum(nvals)
	by patid: replace nvals = nvals[_N] 
	collapse (sum) eventcount=nvals, by(patid primary_exp primary_fu_flag primary_fu12_flag) 

	*save "data_outcome_datesall_muscular_all_count", replace
	 
	bysort primary_exp: count if primary_fu_flag==1
	bysort primary_exp: count if primary_fu12_flag==1



********************************************************************************
*counts stages received vaccinations in follow up periods

	use "data_analysis_primary", clear


	keep patid primary_ce_date primary_fu_date primary_fu12_date primary_exp stage_imm_firstdate stagecount_imm stagemax_imm event_date_imm_stage1 event_date_imm_stage2 event_date_imm_stage3 

	gen primary_fu_flag_v1=1 if event_date_imm_stage1>=primary_ce_date & event_date_imm_stage1<primary_fu_date
	gen primary_fu12_flag_v1=1 if event_date_imm_stage1>=primary_ce_date & event_date_imm_stage1<primary_fu12_date

	gen primary_fu_flag_v2=1 if event_date_imm_stage2>=primary_ce_date & event_date_imm_stage2<primary_fu_date
	gen primary_fu12_flag_v2=1 if event_date_imm_stage2>=primary_ce_date & event_date_imm_stage2<primary_fu12_date

	gen primary_fu_flag_v3=1 if event_date_imm_stage3>=primary_ce_date & event_date_imm_stage3<primary_fu_date
	gen primary_fu12_flag_v3=1 if event_date_imm_stage3>=primary_ce_date & event_date_imm_stage3<primary_fu12_date



	gen primary_ce_flag_v1=1 if event_date_imm_stage1>=primary_ce_date & event_date_imm_stage1!=.
	replace primary_ce_flag_v1=0 if primary_ce_flag_v1==. & event_date_imm_stage1<primary_ce_date & event_date_imm_stage1!=.
	bysort primary_exp: tab primary_ce_flag_v1 stagecount_imm


	bysort primary_exp: count if primary_fu_flag_v3==1 
	bysort primary_exp: count if primary_fu12_flag_v3==1 
	 
	bysort primary_exp: count if primary_fu_flag_v3==. & primary_fu_flag_v2==1
	bysort primary_exp: count if primary_fu12_flag_v3==. & primary_fu12_flag_v2==1

	bysort primary_exp: count if primary_fu_flag_v3==. & primary_fu_flag_v2==. & primary_fu_flag_v1==1
	bysort primary_exp: count if primary_fu12_flag_v3==. & primary_fu12_flag_v2==. & primary_fu12_flag_v1==1

	gen vaccineall=1 if stagecount_imm!=.
	tab vaccineall stagecount_imm
	tab primary_exp stagecount_imm 
	tab primary_exp stagecount_imm if primary_ce_flag_v1!=.

	tab primary_fu_flag_v2 primary_fu12_flag_v2, missing

	bysort primary_exp: tab primary_fu_flag_v1 stagecount_imm
	bysort primary_exp: tab primary_fu_flag_v2 stagecount_imm
	bysort primary_exp: tab primary_fu_flag_v3 stagecount_imm
	
********************************************************************************
********************************************************************************
********************************************************************************
