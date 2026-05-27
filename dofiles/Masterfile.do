****MASTERFILE****

global wd "C:\Users\ama\OneDrive\OneDrive - ROCKWOOL FONDEN\Desktop\Applied Econometrics Term Paper"

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

*****************************
****DATA PREP****************
*****************************

*we first clean (keep relevant variables, rename them) for each raw file of FVs and RVs for each year
local years "2017-18 2018-19 2019-20 2020-21 2021-22 2022-23 2023-24"

foreach y of local years {
	do "$DO/clean_`y'" 
}


* now I append all FVs for all years
do "$DO/fv_append"


*here i prepare the data (calculate total earnings/participation rates by reshaping) only for appended FVs ONLY all years 
do "$DO/final_prep_fv"

*analysis
do "$DO/analysis"


exit



