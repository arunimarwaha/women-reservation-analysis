local years "2017-18 2018-19 2019-20 2020-21 2021-22 2022-23 2023-24"

gettoken first rest : years

use "$PREP/`first'_fv_clean.dta", clear

* 2. Loop through the remaining years
foreach y of local rest {
    append using "$PREP/`y'_fv_clean.dta", force
}

*Rename vars
rename (b4q5 b4q6 b4q8 b4q9 b4q10 b4q11) (sex age gen_ed tech_ed formal_ed current_att) 

gen q_idx = real(substr(quarter, 2, 1))


* Apply Rule
* (We use 'weight' which is the raw Multiplier)
rename MULT weight
gen final_weight = .
replace final_weight = weight / 100 if NSS == NSC
replace final_weight = weight / 200 if NSS != NSC

* Fail-safe for missing NSC/SS data (Standard assumption)
replace final_weight = weight / 100 if final_weight == . & weight != .
///0 real changes made

gen final_weight_annual = .
replace final_weight_annual = final_weight/4

* Labeling
label variable final_weight "Quarterly Survey Weight"
label variable final_weight_annual "Annual Survey Weight"

gen qdate = .
* Visits Q1-Q4 (Survey Year 2017, 2019, 2021, 2023)
replace qdate = yq(year, 3)     if q_idx == 1
replace qdate = yq(year, 4)     if q_idx == 2
replace qdate = yq(year + 1, 1) if q_idx == 3
replace qdate = yq(year + 1, 2) if q_idx == 4

* Re-visits Q5-Q8 (Survey Year 2017, 2018, 2020, 2022)
* Note: In your table, Q5 starts in the same 'year' as Q1 for 2017, 
* but for the others, Q5 starts in the 'even' year.
replace qdate = yq(year, 3)     if q_idx == 5
replace qdate = yq(year, 4)     if q_idx == 6
replace qdate = yq(year + 1, 1) if q_idx == 7
replace qdate = yq(year + 1, 2) if q_idx == 8

format qdate %tq

* 3. Final Save
save "$FINAL/fv_all_years_stacked.dta", replace

exit