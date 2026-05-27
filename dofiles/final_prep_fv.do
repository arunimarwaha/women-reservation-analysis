****ANALYSIS*****
use "$FINAL/fv_all_years_stacked.dta", clear

///keping only labour force
keep if age >= 15

* ----------------------------------------------------------------------
* 1. Create Common ID
* ----------------------------------------------------------------------
* Using egen concat is safer for mixed variable types (string/numeric)
egen uid = concat(year quarter fsu b1q3 b1q12 b1q13 b1q14 b1q15 b4q1 b1q2 visit)
order uid, first

* ----------------------------------------------------------------------
* 2. Rename Variables for Reshape
* ----------------------------------------------------------------------
* We need to standardize names to [variable]_[day]_[activity] for the first reshape.
* Current format: status_day7_act1, wage_day1_act2, etc.

* Rename Activity variables (act1 -> 1, act2 -> 2)
foreach var in status industry hours wage {
    forval d = 1/7 {
        capture rename `var'_day`d'_act1 `var'_day`d'_1
        capture rename `var'_day`d'_act2 `var'_day`d'_2
    }
}

* Rename Day-level variables (remove 'day' to match pattern later)
* Current format: total_hours_day7 -> total_hours_7
foreach var in total_hours availability {
    forval d = 1/7 {
        capture rename `var'_day`d' `var'_`d'
    }
}

foreach v of varlist industry_day*_1 industry_day*_2 {
    tostring `v', replace force
}

foreach v of varlist industry_day*_1 industry_day*_2 {
    replace `v' = "0" + `v' if strlen(`v') == 1
}

* ----------------------------------------------------------------------
* 3. First Reshape: Activity Wide -> Long
* ----------------------------------------------------------------------
* This collapses the 2 activities per day into separate rows.
* Variables like total_hours_1, total_hours_2... are kept wide (constant for the day)
reshape long status_day1_ status_day2_ status_day3_ status_day4_ status_day5_ status_day6_ status_day7_ ///
             industry_day1_ industry_day2_ industry_day3_ industry_day4_ industry_day5_ industry_day6_ industry_day7_ ///
             hours_day1_ hours_day2_ hours_day3_ hours_day4_ hours_day5_ hours_day6_ hours_day7_ ///
             wage_day1_ wage_day2_ wage_day3_ wage_day4_ wage_day5_ wage_day6_ wage_day7_ ///
             , i(uid) j(activity_srl_no)

* ----------------------------------------------------------------------
* 4. Rename for Second Reshape
* ----------------------------------------------------------------------
* Now we standardize names to [variable]_[day] for the second reshape.
* Example: status_day1_ -> status_1
foreach var in status industry hours wage {
    forval d = 1/7 {
        rename `var'_day`d'_ `var'_`d'
    }
}

* ----------------------------------------------------------------------
* 5. Second Reshape: Day Wide -> Long
* ----------------------------------------------------------------------
* This collapses the 7 days into separate rows.
reshape long status_ industry_ hours_ wage_ total_hours_ availability_ , i(uid activity_srl_no) j(day) string

* Sort for clean viewing
sort uid day activity_srl_no day



* ----------------------------------------------------------------------
* 6. Calculate Intensity (hrs_day)
* ----------------------------------------------------------------------
* Define "Day" weight based on hours worked (CDS criteria)
* 1-4 hours = Half day (0.5); >4 hours = Full day (1.0)
* we cannot just add wages for all days and call it weekly
gen hrs_day = 0
replace hrs_day = 0.5 if hours_ >= 1 & hours_ <= 4
replace hrs_day = 1 if hours_ > 4 & hours_ != .

* ----------------------------------------------------------------------
* 7. Classify Activities (Daily Level)
* ----------------------------------------------------------------------

* --- Labor Force (LF) ---
* Includes Employed (11-72) and Unemployed (81-82)
gen is_lf = (status_ >= 11 & status_ <= 82)
gen lf_days_val = hrs_day * is_lf 

* --- Work Force (WF) ---
* Includes only Employed (11-72)
gen is_worker = (status_ >= 11 & status_ <= 72)
gen wf_days_val = hrs_day * is_worker 

* --- Casual Labor ---
* Codes: 41 (Public Works), 42 (MGNREGA), 51 (Other Casual)
gen is_casual = (status_ == 41 | status_ == 42 | status_ == 51)
gen casual_days_val = hrs_day * is_casual 
* Casual Earnings: Capture wage only for casual days to sum later
gen casual_wage_val = wage_ if is_casual == 1 

* --- Regular Salaried ---
* Codes: 31 (Regular), 71/72 (Regular but absent)
gen is_regular = (status_ == 31 | status_ == 71 | status_ == 72)
gen regular_days_val = hrs_day * is_regular

* --- Self Employed ---
* Codes: 11, 12, 21 (Self-Emp), 61/62 (Self-Emp but absent)
gen is_selfemp = (status_ >= 11 & status_ <= 21) | (status_ >= 61 & status_ <= 62)
gen selfemp_days_val = hrs_day * is_selfemp

* ----------------------------------------------------------------------
* 8. Aggregate to Weekly Totals (Person Level)
* ----------------------------------------------------------------------
* Sum the daily values for each person (uid) to get weekly totals.

* Weekly Days Indicators
bysort uid: egen weekly_lf_days = sum(lf_days_val) 
bysort uid: egen weekly_wf_days = sum(wf_days_val) 

* Weekly Employment Type Days
bysort uid: egen weekly_casual_days = sum(casual_days_val)
bysort uid: egen weekly_regular_days = sum(regular_days_val)
bysort uid: egen weekly_selfemp_days = sum(selfemp_days_val)

* Weekly Earnings Calculation
* 1. Casual: Sum of daily wages over 7 days
bysort uid: egen weekly_casual_earnings = sum(casual_wage_val)

* 2. Regular Salaried: Monthly earnings (from CWS block) converted to weekly
* Note: taking max() because the value is constant for the person across all days
bysort uid: egen monthly_regular_wage = max(cws_earnings_primary)
gen weekly_regular_earnings = monthly_regular_wage / 4.3 

* 3. Self-employed
bysort uid: egen monthly_selfemp_wage = max(cws_earnings_secondary)
gen weekly_selfemp_earnings = monthly_selfemp_wage / 4.3 

gen total_weekly_earnings = weekly_casual_earnings + weekly_regular_earnings + weekly_selfemp_earnings

* ----------------------------------------------------------------------
* 9. Drop Duplicates (Return to Person Level)
* ----------------------------------------------------------------------
* Now that we have the totals in every row for a person, we keep one row per person.
duplicates drop uid, force

*dropping all variables that were created at daily level
drop status_ industry_ hours_ wage_ total_hours_ availability_ is_lf is_worker is_casual is_regular is_selfemp lf_days_val wf_days_val casual_days_val casual_wage_val regular_days_val selfemp_days_val

destring b4q7 gen_ed tech_ed, replace

drop year
gen year = yofd(qdate)
gen actual_year = year(dofq(qdate))
drop year
rename actual_year year

replace final_weight_annual = 2*final_weight_annual if year == 2017 | year == 2024


save "$FINAL/fv_all_years_stacked_ready.dta", replace

keep if sex == 2

save "$FINAL/fv_all_years_stacked_ready_women.dta", replace

exit
