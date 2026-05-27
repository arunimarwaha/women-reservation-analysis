
*****************2017-18*****************************
************************
*******FV**********
************************
use "$RAW/2017-18/fv.dta", clear

* 1. Remove suffixes
rename (*_per_fv) (*)

* 2. Harmonize Location Variables
* In FV, 'b1q4' is District. We rename it to match the RV file above.
rename b1q4 district_code
* (Note: FV usually has 'nss_region' named explicitly, so we keep that)

* 3. Keep Variables of Interest
keep ///
    FI b1q2 quarter visit b1q3 state district_code nss_region ///
    b1q5 b1q6 b1q11 b1q12 fsu b1q13 b1q14 b1q15 b4q1 /// IDs
    b4q4 b4q5 b4q6 b4q7 b4q8 b4q9 b4q10 b4q11 /// Demographics
     b5pt1q3 b5pt1q5 b5pt1q6 b5pt1q7 b5pt1q8 b5pt1q9 b5pt1q10 b5pt1q11 b5pt1q12 b5pt1q13 b5pt2q3 b5pt2q5 b5pt2q6 b5pt2q7 b5pt2q8 b5pt2q9 b5pt2q10 b5pt2q11 b5pt2q12 /// FV only vars
	 b6q4_3pt1_Act1 b6q5_3pt1_Act1 b6q6_3pt1_Act1 b6q9_3pt1_Act1 b6q4_3pt1__Act2 b6q5_3pt1_Act2 b6q6_3pt1_Act2 b6q9_3pt1_Act2 b6q7_3pt1 b6q8_3pt1 b6q4_3pt2_Act1 b6q5_3pt2_Act1 b6q6_3pt2_Act1 b6q9_3pt2_Act1 b6q4_3pt2_Act2 b6q5_3pt2_Act2 b6q6_3pt2_Act2 b6q9_3pt2_Act2 b6q7_3pt2 b6q8_3pt2 b6q4_3pt3_Act1 b6q5_3pt3_Act1 b6q6_3pt3_Act1 b6q9_3pt3_Act1 b6q4_3pt3_Act2 b6q5_3pt3_Act2 b6q6_3pt3_Act2 b6q9_3pt3_Act2 b6q7_3pt3 b6q8_3pt3 b6q4_3pt4_Act1 b6q5_3pt4_Act1 b6q6_3pt4_Act1 b6q9_3pt4_Act1 b6q4_3pt4_Act2 b6q5_3pt4_Act2 b6q6_3pt4_Act2 b6q9_3pt4_Act2 b6q7_3pt4 b6q8_3pt4 b6q4_3pt5_Act1 b6q5_3pt5_Act1 b6q6_3pt5_Act1 b6q9_3pt5_Act1 b6q4_3pt5_Act2 b6q5_3pt5_Act2 b6q6_3pt5_Act2 b6q9_3pt5_Act2 b6q7_3pt5 b6q8_3pt5 b6q4_3pt6_Act1 b6q5_3pt6_Act1 b6q6_3pt6_Act1 b6q9_3pt6_Act1 b6q4_3pt6_Act2 b6q5_3pt6_Act2 b6q6_3pt6_Act2 b6q9_Act2_3pt6 b6q7_3pt6 b6q8_3pt6 b6q4_3pt7_Act1 b6q5_3pt7_Act1 b6q6_3pt7_Act1 b6q9_Act1_3pt7 b6q4_3pt7_Act2 b6q5_3pt7_Act2 b6q6_3pt7_Act2 b6q9_Act2_3pt7 b6q7_3pt7 b6q8_3pt7 b6q5 b6q6 b6q7 b6q9 b6q10 /// Employment (CWS)
    MULT NSS NSC No_qtr

* 4. Standardize Variable Types
destring b6q9 b6q10 MULT NSS, replace ignore(" ") force

****************************************************
* PRINCIPAL ACTIVITY
****************************************************
rename b5pt1q3    principal_status
rename b5pt1q5    principal_industry
rename b5pt1q6    principal_occupation
rename b5pt1q7    principal_sub_work
rename b5pt1q8    principal_workplace_loc
rename b5pt1q9    principal_enterprise_type
rename b5pt1q10   principal_enterprise_size
rename b5pt1q11   principal_job_contract
rename b5pt1q12   principal_paid_leave
rename b5pt1q13   principal_social_security


****************************************************
* SUBSIDIARY ACTIVITY
****************************************************
rename b5pt2q3    subsidiary_status
rename b5pt2q5    subsidiary_industry
rename b5pt2q6    subsidiary_occupation
rename b5pt2q7    subsidiary_workplace_loc
rename b5pt2q8    subsidiary_enterprise_type
rename b5pt2q9    subsidiary_enterprise_size
rename b5pt2q10   subsidiary_job_contract
rename b5pt2q11   subsidiary_paid_leave
rename b5pt2q12   subsidiary_social_security

* ===============================
* DAILY ACTIVITY VARIABLES
* ===============================

* --- Day 7 (3pt1) ---
rename b6q4_3pt1_Act1 status_day7_act1
rename b6q5_3pt1_Act1 industry_day7_act1
rename b6q6_3pt1_Act1 hours_day7_act1
rename b6q9_3pt1_Act1 wage_day7_act1

rename b6q4_3pt1__Act2 status_day7_act2
rename b6q5_3pt1_Act2 industry_day7_act2
rename b6q6_3pt1_Act2 hours_day7_act2
rename b6q9_3pt1_Act2 wage_day7_act2

rename b6q7_3pt1 total_hours_day7
rename b6q8_3pt1 availability_day7


* --- Day 6 (3pt2) ---
rename b6q4_3pt2_Act1 status_day6_act1
rename b6q5_3pt2_Act1 industry_day6_act1
rename b6q6_3pt2_Act1 hours_day6_act1
rename b6q9_3pt2_Act1 wage_day6_act1

rename b6q4_3pt2_Act2 status_day6_act2
rename b6q5_3pt2_Act2 industry_day6_act2
rename b6q6_3pt2_Act2 hours_day6_act2
rename b6q9_3pt2_Act2 wage_day6_act2

rename b6q7_3pt2 total_hours_day6
rename b6q8_3pt2 availability_day6


* --- Day 5 (3pt3) ---
rename b6q4_3pt3_Act1 status_day5_act1
rename b6q5_3pt3_Act1 industry_day5_act1
rename b6q6_3pt3_Act1 hours_day5_act1
rename b6q9_3pt3_Act1 wage_day5_act1

rename b6q4_3pt3_Act2 status_day5_act2
rename b6q5_3pt3_Act2 industry_day5_act2
rename b6q6_3pt3_Act2 hours_day5_act2
rename b6q9_3pt3_Act2 wage_day5_act2

rename b6q7_3pt3 total_hours_day5
rename b6q8_3pt3 availability_day5


* --- Day 4 (3pt4) ---
rename b6q4_3pt4_Act1 status_day4_act1
rename b6q5_3pt4_Act1 industry_day4_act1
rename b6q6_3pt4_Act1 hours_day4_act1
rename b6q9_3pt4_Act1 wage_day4_act1

rename b6q4_3pt4_Act2 status_day4_act2
rename b6q5_3pt4_Act2 industry_day4_act2
rename b6q6_3pt4_Act2 hours_day4_act2
rename b6q9_3pt4_Act2 wage_day4_act2

rename b6q7_3pt4 total_hours_day4
rename b6q8_3pt4 availability_day4


* --- Day 3 (3pt5) ---
rename b6q4_3pt5_Act1 status_day3_act1
rename b6q5_3pt5_Act1 industry_day3_act1
rename b6q6_3pt5_Act1 hours_day3_act1
rename b6q9_3pt5_Act1 wage_day3_act1

rename b6q4_3pt5_Act2 status_day3_act2
rename b6q5_3pt5_Act2 industry_day3_act2
rename b6q6_3pt5_Act2 hours_day3_act2
rename b6q9_3pt5_Act2 wage_day3_act2

rename b6q7_3pt5 total_hours_day3
rename b6q8_3pt5 availability_day3


* --- Day 2 (3pt6) ---
rename b6q4_3pt6_Act1 status_day2_act1
rename b6q5_3pt6_Act1 industry_day2_act1
rename b6q6_3pt6_Act1 hours_day2_act1
rename b6q9_3pt6_Act1 wage_day2_act1

rename b6q4_3pt6_Act2 status_day2_act2
rename b6q5_3pt6_Act2 industry_day2_act2
rename b6q6_3pt6_Act2 hours_day2_act2
rename b6q9_Act2_3pt6 wage_day2_act2

rename b6q7_3pt6 total_hours_day2
rename b6q8_3pt6 availability_day2


* --- Day 1 (3pt7) ---
rename b6q4_3pt7_Act1 status_day1_act1
rename b6q5_3pt7_Act1 industry_day1_act1
rename b6q6_3pt7_Act1 hours_day1_act1
rename b6q9_Act1_3pt7 wage_day1_act1

rename b6q4_3pt7_Act2 status_day1_act2
rename b6q5_3pt7_Act2 industry_day1_act2
rename b6q6_3pt7_Act2 hours_day1_act2
rename b6q9_Act2_3pt7 wage_day1_act2

rename b6q7_3pt7 total_hours_day1
rename b6q8_3pt7 availability_day1


* ===============================
* WEEKLY (CWS) VARIABLES
* ===============================

rename b6q5  cws_status
rename b6q6  cws_industry
rename b6q7  cws_occupation
rename b6q9  cws_earnings_primary
rename b6q10 cws_earnings_secondary

gen year = 2017

destring b1q3 b1q11 fsu b1q13 b1q14 b4q4 b4q5 b4q6 b4q7  b4q10 principal_status principal_occupation principal_sub_work principal_workplace_loc principal_enterprise_size principal_enterprise_type  principal_job_contract principal_paid_leave principal_social_security subsidiary_status subsidiary_occupation status_* hours_* wage_* cws_status cws_occupation total_* availability_*, replace 

save "$PREP/2017-18_fv_clean.dta", replace

*******************
*******RV**********
*******************

use "$RAW/2017-18/rv.dta", clear

* 1. Remove suffixes
rename (*_per_rv) (*)

* 2. Harmonize Location Variables (Crucial Step)
* In RV, 'district' is the district code, but 'b1q4' is NSS-Region.
* In FV, 'b1q4' is District. We must fix this collision.
rename district district_code
rename b1q4 nss_region 

* 3. Keep Variables of Interest
keep ///
    FI b1q2 quarter visit b1q3 state district_code nss_region ///
    b1q5 b1q6 b1q11 b1q12 fsu b1q13 b1q14 b1q15 b4q1 /// IDs
    b4q4 b4q5 b4q6 b4q7 b4q8 b4q9 b4q10 b4q11 /// Demographics
    b6q4_3pt1_Act1 b6q5_3pt1 b6q6_Act1_3pt1 b6q9_3pt1_Act1 b6q4_3pt1_Act2 b6q5_3pt1_Act2 b6q6_3pt1_Act2 b6q9_3pt1_Act2 b6q7_3pt1 b6q8_3pt1 b6q4_3pt2_Act1 b6q5_3pt2_Act1 b6q6_3pt2_Act1 b6q9_3pt2_Act1 b6q4_3pt2_Act2 b6q5_3pt2_Act2 b6q6_3pt2_Act2 b6q9_3pt2_Act2 b6q7_3pt2 b6q8_3pt2 b6q4_3pt3_Act1 b6q5_3pt3_Act1 b6q6_3pt3_Act1 b6q9_3pt3_Act1 b6q4_3pt3_Act2 b6q5_3pt3_Act2 b6q6_3pt3_Act2 b6q9_3pt3_Act2 b6q7_3pt3 b6q8_3pt3 b6q4_3pt4_Act1 b6q5_3pt4_Act1 b6q6_3pt4_Act1 b6q9_3pt4 b6q4_3pt4_Act2 b6q5_3pt4_Act2 b6q6_3pt4_Act2 b6q9_3pt4_Act2 b6q7_3pt4 b6q8_3pt4 b6q4_3pt5_Act1 b6q5_3pt5_Act1 b6q6_3pt5_Act1 b6q9_3pt5_Act1 b6q4_3pt5_Act2 b6q5_3pt5_Act2 b6q6_3pt5_Act2 b6q9_3pt5_Act2 b6q7_3pt5 b6q8_3pt5 b6q4_3pt6_Act1 b6q5_3pt6_Act1 b6q6_3pt6_Act1 b6q9_3pt6 b6q4_3pt6_Act2 b6q5_3pt6_Act2 b6q6_3pt6_Act2 b6q9_3pt6_Act2 b6q7_3pt6_Act1 b6q8_3pt6 b6q4_3pt7_Act1 b6q5_3pt7_Act1 b6q6_3pt7_Act1 b6q9_3pt7_Act1 b6q4_3pt7_Act2 b6q5_3pt7_Act2 b6q6_3pt7_Act2 b6q9_3pt7_Act2 b6q7_3pt7 b6q8_3pt7 b6q5 b6q6 b6q7 b6q9 b6q10 /// Employment (CWS)
    MULT NSS NSC No_qtr

* 4. Standardize Variable Types
* Weights and Earnings are often imported as strings in PLFS
destring b6q9 b6q10 MULT NSS, replace ignore(" ") force

* ===============================
* DAILY ACTIVITY VARIABLES
* ===============================

* --- Day 7 (3pt1) ---
rename b6q4_3pt1_Act1 status_day7_act1
rename b6q5_3pt1 industry_day7_act1
rename b6q6_Act1_3pt1 hours_day7_act1
rename b6q9_3pt1_Act1 wage_day7_act1

rename b6q4_3pt1_Act2 status_day7_act2
rename b6q5_3pt1_Act2 industry_day7_act2
rename b6q6_3pt1_Act2 hours_day7_act2
rename b6q9_3pt1_Act2 wage_day7_act2

rename b6q7_3pt1 total_hours_day7
rename b6q8_3pt1 availability_day7


* --- Day 6 (3pt2) ---
rename b6q4_3pt2_Act1 status_day6_act1
rename b6q5_3pt2_Act1 industry_day6_act1
rename b6q6_3pt2_Act1 hours_day6_act1
rename b6q9_3pt2_Act1 wage_day6_act1

rename b6q4_3pt2_Act2 status_day6_act2
rename b6q5_3pt2_Act2 industry_day6_act2
rename b6q6_3pt2_Act2 hours_day6_act2
rename b6q9_3pt2_Act2 wage_day6_act2

rename b6q7_3pt2 total_hours_day6
rename b6q8_3pt2 availability_day6


* --- Day 5 (3pt3) ---
rename b6q4_3pt3_Act1 status_day5_act1
rename b6q5_3pt3_Act1 industry_day5_act1
rename b6q6_3pt3_Act1 hours_day5_act1
rename b6q9_3pt3_Act1 wage_day5_act1

rename b6q4_3pt3_Act2 status_day5_act2
rename b6q5_3pt3_Act2 industry_day5_act2
rename b6q6_3pt3_Act2 hours_day5_act2
rename b6q9_3pt3_Act2 wage_day5_act2

rename b6q7_3pt3 total_hours_day5
rename b6q8_3pt3 availability_day5


* --- Day 4 (3pt4) ---
rename b6q4_3pt4_Act1 status_day4_act1
rename b6q5_3pt4_Act1 industry_day4_act1
rename b6q6_3pt4_Act1 hours_day4_act1
rename b6q9_3pt4 wage_day4_act1

rename b6q4_3pt4_Act2 status_day4_act2
rename b6q5_3pt4_Act2 industry_day4_act2
rename b6q6_3pt4_Act2 hours_day4_act2
rename b6q9_3pt4_Act2 wage_day4_act2

rename b6q7_3pt4 total_hours_day4
rename b6q8_3pt4 availability_day4


* --- Day 3 (3pt5) ---
rename b6q4_3pt5_Act1 status_day3_act1
rename b6q5_3pt5_Act1 industry_day3_act1
rename b6q6_3pt5_Act1 hours_day3_act1
rename b6q9_3pt5_Act1 wage_day3_act1

rename b6q4_3pt5_Act2 status_day3_act2
rename b6q5_3pt5_Act2 industry_day3_act2
rename b6q6_3pt5_Act2 hours_day3_act2
rename b6q9_3pt5_Act2 wage_day3_act2

rename b6q7_3pt5 total_hours_day3
rename b6q8_3pt5 availability_day3


* --- Day 2 (3pt6) ---
rename b6q4_3pt6_Act1 status_day2_act1
rename b6q5_3pt6_Act1 industry_day2_act1
rename b6q6_3pt6_Act1 hours_day2_act1
rename b6q9_3pt6 wage_day2_act1

rename b6q4_3pt6_Act2 status_day2_act2
rename b6q5_3pt6_Act2 industry_day2_act2
rename b6q6_3pt6_Act2 hours_day2_act2
rename b6q9_3pt6_Act2 wage_day2_act2

rename b6q7_3pt6_Act1 total_hours_day2
rename b6q8_3pt6 availability_day2


* --- Day 1 (3pt7) ---
rename b6q4_3pt7_Act1 status_day1_act1
rename b6q5_3pt7_Act1 industry_day1_act1
rename b6q6_3pt7_Act1 hours_day1_act1
rename b6q9_3pt7_Act1 wage_day1_act1

rename b6q4_3pt7_Act2 status_day1_act2
rename b6q5_3pt7_Act2 industry_day1_act2
rename b6q6_3pt7_Act2 hours_day1_act2
rename b6q9_3pt7_Act2 wage_day1_act2

rename b6q7_3pt7 total_hours_day1
rename b6q8_3pt7 availability_day1


* ===============================
* WEEKLY (CWS) VARIABLES
* ===============================

rename b6q5  cws_status
rename b6q6  cws_industry
rename b6q7  cws_occupation
rename b6q9  cws_earnings_primary
rename b6q10 cws_earnings_secondary

gen year = 2017

destring b1q3 b1q11 fsu b1q13 b1q14 b4q4 b4q5 b4q6 b4q7  b4q10 status_* hours_* wage_* cws_status cws_occupation total_* availability_*, replace 
save "$PREP/2017-18_rv_clean.dta", replace

exit
