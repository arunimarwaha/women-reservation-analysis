/********************************************************************
Project: Women's Reservation in Public-Sector Employment
Purpose: Run full PLFS data preparation and synthetic control analysis
Author: Arunima Marwaha

Notes:
- This master file preserves the original workflow and output logic.
- Set the global wd below to the root folder of this project before running.
- Expected folders: Data/Raw, Data/Prep, Data/Final, dofiles, Tables, Graphs
********************************************************************/

clear all
set more off

* -------------------------------------------------------------------
* 0. Set working directory
* -------------------------------------------------------------------
* CHANGE THIS PATH to the root folder where you store the project.
global wd "C:\Users\ama\OneDrive\OneDrive - ROCKWOOL FONDEN\Desktop\Women_Reservation_Analysis"


cap mkdir "$wd/Data/Raw/" 
cap mkdir "$wd/Data/Prep"
cap mkdir "$wd/dofiles/"
cap mkdir "$wd/Tables"
cap mkdir "$wd/Graphs/"
cap mkdir "$wd/Data/Final"

global RAW "${wd}/Data/Raw/" 
global PREP "${wd}/Data/Prep"
global FINAL "${wd}/Data/Final"
global DO "${wd}/dofiles"
global TABLES "${wd}/Tables"
global GRAPHS "${wd}/Graphs"

* -------------------------------------------------------------------
* 1. Data preparation: clean first-visit files year by year
* -------------------------------------------------------------------
* PLFS variable names differ across survey years, so each year is
* harmonised separately before appending. This preserves the original
* cleaning approach and therefore keeps outputs unchanged.
local years "2017-18 2018-19 2019-20 2020-21 2021-22 2022-23 2023-24"

foreach y of local years {
    do "$DO/clean_`y'"
}

* -------------------------------------------------------------------
* 2. Append all first-visit cleaned files
* -------------------------------------------------------------------
do "$DO/fv_append"

* -------------------------------------------------------------------
* 3. Construct final analysis dataset
* -------------------------------------------------------------------
do "$DO/final_prep_fv"

* -------------------------------------------------------------------
* 4. Run analysis and export figures/tables
* -------------------------------------------------------------------
do "$DO/analysis"

exit
