************************************************************
* SYNTHETIC CONTROL: PUNJAB WOMEN SHARE IN GOVT JOBS
************************************************************
* ssc install synth, replace
* ssc install synth_runner, replace
* ssc install estout, replace

use "$FINAL/fv_all_years_stacked_ready.dta", clear

************************************************************
* SAMPLE RESTRICTIONS
************************************************************
drop if year == 2017 | year == 2024
keep if age >= 21 & age <= 47
drop if inlist(state, "10","22","23","28","36")

************************************************************
* CONSTRUCT OUTCOME + CONTROLS
************************************************************

* Labour force indicator
gen in_lf = .
replace in_lf = 1 if inlist(principal_status,11,12,21,31,41,42,51,61,62,71,72,81,82)
replace in_lf = 0 if inlist(principal_status,91,92,93,94,95)

* Government job indicator: principal activity only
gen govt_job = inlist(principal_enterprise_type,5,6,7)

************************************************************
* DESCRIPTIVE GRAPH
************************************************************
preserve
keep if state == "03"
keep if govt_job == 1

gen female = (sex == 2)
gen male   = (sex == 1)

collapse (mean) female_share=female male_share=male ///
    [pw=final_weight_annual], by(year)

twoway ///
    (line female_share year, ///
        lcolor(black) ///
        lpattern(solid) ///
        lwidth(medthick)) ///
    (line male_share year, ///
        lcolor(black) ///
        lpattern(dash) ///
        lwidth(medthick)), ///
    ytitle("Share") ///
    xtitle("Year") ///
    legend(order(1 "Women" 2 "Men")) ///
    xline(2021, lpattern(dash) lcolor(black))

graph export "$GRAPHS/govt_jobs_men_vs_women.png", replace
restore

************************************************************
* FEMALE-SPECIFIC VARIABLES
************************************************************
gen female = (sex == 2)

* Female in labour force
gen female_in_lf = in_lf if sex == 2

* Female age
gen female_age = age if sex == 2

* Education categories for women
gen female_low_ed  = inlist(gen_ed,1,2,3,4) if sex == 2
gen female_mid_ed  = inlist(gen_ed,5,6,7,8) if sex == 2
gen female_high_ed = inlist(gen_ed,9,10,11,12) if sex == 2

* Rural female indicator
gen female_rural = (b1q3 == 1) if sex == 2

* Govt job female indicator
gen govt_job_female = (govt_job == 1 & sex == 2)

************************************************************
* COLLAPSE TO STATE-YEAR LEVEL
************************************************************
collapse ///
    (mean) govt_job_women = govt_job_female ///
           govt_job_total = govt_job ///
           female_age ///
           female_low_ed ///
           female_mid_ed ///
           female_high_ed ///
           female_rural ///
           female_lfpr = female_in_lf ///
    [pw=final_weight_annual], by(state year)

gen govt_job_women_share = govt_job_women / govt_job_total


************************************************************
* PUNJAB VS OTHER STATES: UNWEIGHTED TREND
************************************************************
preserve

* Keep non-missing outcome
keep if !missing(govt_job_women_share)

* Punjab indicator
gen punjab = (state == "03")
capture confirm numeric variable state
if _rc == 0 {
    replace punjab = (state == 3)
}

* Punjab outcome by year
gen punjab_share = govt_job_women_share if punjab == 1

* Mean of other states by year (simple unweighted average across states)
gen other_share = govt_job_women_share if punjab == 0

collapse ///
    (mean) punjab_share ///
    (mean) other_share, ///
    by(year)

twoway ///
    (line punjab_share year, ///
        lcolor(black) ///
        lpattern(solid) ///
        lwidth(medthick)) ///
    (line other_share year, ///
        lcolor(gs8) ///
        lpattern(dash) ///
        lwidth(medthick)), ///
    ytitle("Share of Women in Government Jobs") ///
    xtitle("Year") ///
legend(order(2 "Punjab" 1 "Control states") ///
       position(11) ring(0) ///
       col(1) ///
       region(lcolor(black) fcolor(white)))    xline(2021, lpattern(dash) lcolor(black))

graph export "$GRAPHS/punjab_vs_otherstates_unweighted.png", replace
restore

************************************************************
* CLEAN PANEL
************************************************************
drop if missing(govt_job_women_share)

destring state, replace
tsset state year

************************************************************
* STATE LABELS
************************************************************
label define statelabel ///
1  "Jammu & Kashmir" ///
2  "Himachal Pradesh" ///
3  "Punjab" ///
4  "Chandigarh" ///
5  "Uttrakhand" ///
6  "Haryana" ///
7  "Delhi" ///
8  "Rajasthan" ///
9  "Uttar Pradesh" ///
10 "Bihar" ///
11 "Sikkim" ///
12 "Arunachal Pradesh" ///
13 "Nagaland" ///
14 "Manipur" ///
15 "Mizoram" ///
16 "Tripura" ///
17 "Meghalaya" ///
18 "Assam" ///
19 "West Bengal" ///
20 "Jharkhand" ///
21 "Odisha" ///
22 "Chhattisgarh" ///
23 "Madhya Pradesh" ///
24 "Gujarat" ///
25 "Daman & Diu" ///
26 "D & N Haveli" ///
27 "Maharashtra" ///
28 "Andhra Pradesh" ///
29 "Karnataka" ///
30 "Goa" ///
31 "Lakshadweep" ///
32 "Kerala" ///
33 "Tamil Nadu" ///
34 "Puducherry" ///
35 "A & N Island" ///
36 "Telangana"

label values state statelabel

* Keep balanced states only
bysort state: gen n = _N
drop if n < 6
drop n

************************************************************
* SYNTHETIC CONTROL
************************************************************
label variable govt_job_women_share "Share of women in government jobs"

synth govt_job_women_share ///
    govt_job_women_share(2018) ///
    govt_job_women_share(2019) ///
    govt_job_women_share(2020) ///
    female_age female_low_ed female_mid_ed female_high_ed female_rural female_lfpr, ///
    trunit(3) trperiod(2021) figure ///
    ytitle("Share of Women in Government Jobs") ///
    ylabel(0(.1).5) ///
    xline(2021, lpattern(dash) lcolor(black))

graph export "$GRAPHS/Women_govt_job_share_Punjab.png", replace

************************************************************
* SAVE WEIGHTS / BALANCE TABLES
************************************************************
esttab e(W_weights) using "$TABLES/weights.tex", replace

* Save balance stats with average of control states
matrix A = e(X_balance)

gen share2018 = govt_job_women_share if year == 2018
gen share2019 = govt_job_women_share if year == 2019
gen share2020 = govt_job_women_share if year == 2020

estpost sum share2018 share2019 share2020 ///
    female_age female_low_ed female_mid_ed female_high_ed female_rural female_lfpr if state != 3
matrix B = e(mean)
matrix C = A , B'

matrix rownames C = ///
    "Govt Job Share 2018" ///
    "Govt Job Share 2019" ///
    "Govt Job Share 2020" ///
    "Age" ///
    "Low Education" ///
    "Medium Education" ///
    "High Education" ///
    "Rural" ///
    "LFPR"

matrix colnames C = "Treated" "Synthetic" "Average"

esttab matrix(C, fmt(%9.2f)) using "$TABLES/balancing_with_control.tex", ///
    replace ///
    nomtitles

************************************************************
* PLACEBO / INFERENCE
************************************************************

* Rename outcome for synth_runner
rename govt_job_women_share outcome

synth_runner outcome ///
    female_age female_low_ed female_mid_ed female_high_ed female_rural female_lfpr ///
    outcome(2018) outcome(2019) outcome(2020), ///
    trunit(3) trperiod(2021) gen_vars


preserve

* Treated unit (Punjab)
keep if state == 3

twoway ///
    (line outcome year, ///
        lcolor(black) ///
        lpattern(solid) ///
        lwidth(medthick)) ///
    (line outcome_synth year, ///
        lcolor(black) ///
        lpattern(dash) ///
        lwidth(medthick)), ///
    xline(2021, lpattern(dash) lcolor(black)) ///
    xtitle("Year") ///
    ytitle("Share of Women in Government Jobs") ///
    legend(order(1 "Punjab" 2 "Synthetic Punjab")) ///
    scheme(s1mono) ///
    graphregion(color(white)) ///
    name(tc, replace)

graph export "$GRAPHS/tc.png", name(tc) replace

restore

preserve
keep if state == 3
twoway ///
    (line effect year, lcolor(black) lwidth(medthick)), ///
    xline(2021, lpattern(dash) lcolor(black)) ///
    yline(0, lcolor(gs10)) ///
    ytitle("Gap in Share of Women in Government Jobs") ///
    xtitle("Year") ///
    xlabel(2018(1)2023) ///
    scheme(s1mono) ///
    graphregion(color(white)) ///
    name(effect, replace)
graph export "$GRAPHS/effect.png", name(effect) replace
restore

************************************************************
* SPAGHETTI PLACEBO PLOT
************************************************************
****single_treatment_graphs, effects_ylabels(-30(10)30) effects_ymax(35) effects_ymin(-35) effects_options(scheme(s1mono) yline(0)) do_color(gs15) //author drops the states that have badly matched synthetic controls 
///this code above is taken from the class but did not work and always gave the error - 'outcome var not found'



* Decide outcome name automatically
capture confirm variable outcome
if _rc == 0 {
    local y outcome
}
else {
    local y govt_job_women_share
}

* Save current analysis dataset
tempfile master gaps
save `master', replace

* Create empty file to collect placebo gaps
clear
set obs 0
gen state = .
gen year  = .
gen gap   = .
save `gaps', replace

* Recover state list
use `master', clear
levelsof state, local(states)

************************************************************
* LOOP OVER STATES AND RUN PLACEBO SYNTH
************************************************************
foreach s of local states {

    di "Running placebo SCM for state `s'"

    use `master', clear

    tempfile synthout

    capture noisily synth `y' ///
        `y'(2018) `y'(2019) `y'(2020) ///
        female_age female_low_ed female_mid_ed female_high_ed female_rural female_lfpr, ///
        trunit(`s') trperiod(2021) keep(`synthout') replace

    if _rc != 0 {
        di "synth failed for state `s'"
        continue
    }

    capture use `synthout', clear
    if _rc != 0 {
        di "keep file missing for state `s'"
        continue
    }

    * synth output variables
    gen year  = _time
    gen gap   = _Y_treated - _Y_synthetic
    gen state = `s'

    keep state year gap

    append using `gaps'
    save `gaps', replace
}

************************************************************
* PREPARE DATA FOR SPAGHETTI PLOT
************************************************************
use `gaps', clear

duplicates drop state year, force
sort state year

count
if r(N) == 0 {
    di as error "No placebo gaps were created."
    exit 2000
}

************************************************************
* OPTIONAL: FILTER OUT BADLY FITTING PLACEBOS
* This usually makes the spaghetti plot look like published SCM figures
************************************************************
gen pre_gap2 = gap^2 if year < 2021
bysort state: egen pre_mse = mean(pre_gap2)
gen pre_rmspe = sqrt(pre_mse)

summ pre_rmspe if state == 3, meanonly
local punjab_rmspe = r(mean)

************************************************************
* BUILD PLOT COMMAND
************************************************************
levelsof state if state != 3, local(placebo_states)

local placebo_lines
foreach s of local placebo_states {
    local placebo_lines `placebo_lines' ///
        (line gap year if state == `s', sort ///
            lcolor(gs12) lwidth(vthin))
}

local nplacebos : word count `placebo_states'
local punjab_order = `nplacebos' + 1

************************************************************
* SPAGHETTI PLOT
************************************************************
twoway ///
    `placebo_lines' ///
    (line gap year if state == 3, sort ///
        lcolor(black) lwidth(medthick)), ///
    xline(2021, lpattern(dash) lcolor(black)) ///
    yline(0, lcolor(gs10)) ///
    legend(order(`punjab_order' "Punjab" 1 "Placebo states") ///
           cols(1) ring(0) pos(11)) ///
    xtitle("Year") ///
    ytitle("Gap in Share of Women in Government Jobs") ///
    xlabel(2018(1)2023) ///
    scheme(s1mono) ///
    graphregion(color(white))

graph export "$GRAPHS/placebo_spaghetti.png", replace


************************************************************
* PREPARE DATA FOR SPAGHETTI PLOT
************************************************************
use `gaps', clear

duplicates drop state year, force
sort state year

count
if r(N) == 0 {
    di as error "No placebo gaps were created."
    exit 2000
}

************************************************************
* OPTIONAL: FILTER OUT BADLY FITTING PLACEBOS
* This usually makes the spaghetti plot look like published SCM figures
************************************************************
gen pre_gap2 = gap^2 if year < 2021
bysort state: egen pre_mse = mean(pre_gap2)
gen pre_rmspe = sqrt(pre_mse)

summ pre_rmspe if state == 3, meanonly
local punjab_rmspe = r(mean)

* Keep Punjab and reasonably well-fit placebo states
* You can tighten or loosen this cutoff:
* 2 = strict, 3 = moderate, 5 = loose
keep if state == 3 | pre_rmspe <= 20 * `punjab_rmspe'

************************************************************
* BUILD PLOT COMMAND
************************************************************
levelsof state if state != 3, local(placebo_states)

local placebo_lines
foreach s of local placebo_states {
    local placebo_lines `placebo_lines' ///
        (line gap year if state == `s', sort ///
            lcolor(gs12) lwidth(vthin))
}

local nplacebos : word count `placebo_states'
local punjab_order = `nplacebos' + 1

************************************************************
* SPAGHETTI PLOT
************************************************************
twoway ///
    `placebo_lines' ///
    (line gap year if state == 3, sort ///
        lcolor(black) lwidth(medthick)), ///
    xline(2021, lpattern(dash) lcolor(black)) ///
    yline(0, lcolor(gs10)) ///
    legend(order(`punjab_order' "Punjab" 1 "Placebo states") ///
           cols(1) ring(0) pos(11)) ///
    xtitle("Year") ///
    ytitle("Gap in Share of Women in Government Jobs") ///
    xlabel(2018(1)2023) ///
    scheme(s1mono) ///
    graphregion(color(white))

graph export "$GRAPHS/placebo_spaghetti_restricted.png", replace