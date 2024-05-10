
****************************************
*set location ruta
****************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\17_263\Data\Ruta\workingdata"


****************************************
*set location hannah
****************************************

cd "\\ads.bris.ac.uk\filestore\HealthSci SafeHaven\CPRD Projects UOB\Projects\17_263\Data\Hannah working data"



use cohort1_entryexitdates, clear
*1663 db
use cohort2_entryexitdates, clear
*1268 ht
use cohort3_entryexitdates, clear
*1668 hc
use cohort4_entryexitdates, clear
*1144 all


use all_cohorts_description, clear
*1833

use cohort1_diabetesoutcome, clear
use cohort2_hypertensionoutcome, clear
use cohort3_hypercholoutcome, clear
use cohort4_anyoutcome, clear


use exposure_polypharmacy_cohort1, clear
use exposure_polypharmacy_cohort2, clear
use exposure_polypharmacy_cohort3, clear
use exposure_polypharmacy_cohort4, clear


codebook patid
*1663
codebook patid if poly==2
*440
codebook patid if poly==2 & episode_dur>=180
*68
drop if poly==1
drop if poly==0
tab episode
sum episode
*605 episodes for 440 patients from 1 to 28

collapse (sum) episode_dur, by(patid)
codebook patid if episode_dur>=180
*107 cummulative


use exposure_drug_changes_cohort1, clear
use exposure_drug_changes_cohort2, clear
use exposure_drug_changes_cohort3, clear
use exposure_drug_changes_cohort4, clear
