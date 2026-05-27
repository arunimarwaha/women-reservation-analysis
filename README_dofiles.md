# Do-file workflow

This folder contains the Stata do-files for the project **Women’s Reservation in Public-Sector Employment: Policy Impact Analysis**.

The scripts preserve the original data preparation and analysis logic. The main outputs should remain unchanged, provided the raw PLFS files are stored in the same folder structure expected by `Masterfile.do`.

## Run order

Run only:

```stata
do Masterfile.do
```

The master file calls the remaining scripts in this order:

1. `clean_2017-18.do`
2. `clean_2018-19.do`
3. `clean_2019-20.do`
4. `clean_2020-21.do`
5. `clean_2021-22.do`
6. `clean_2022-23.do`
7. `clean_2023-24.do`
8. `fv_append.do`
9. `final_prep_fv.do`
10. `analysis.do`

## Why each year is cleaned separately

PLFS variable names and suffixes change across survey years. Each annual file is therefore cleaned separately and harmonised into a common structure before appending. This is intentional and helps preserve transparency in the data preparation process.

## Folder structure expected

```text
├── Masterfile.do
├── dofiles/
│   ├── clean_2017-18.do
│   ├── clean_2018-19.do
│   ├── clean_2019-20.do
│   ├── clean_2020-21.do
│   ├── clean_2021-22.do
│   ├── clean_2022-23.do
│   ├── clean_2023-24.do
│   ├── fv_append.do
│   ├── final_prep_fv.do
│   └── analysis.do
├── Data/
│   ├── Raw/
│   ├── Prep/
│   └── Final/
├── Tables/
└── Graphs/
```

## Notes for reproducibility

- Edit the `global wd` path in `Masterfile.do` before running.
- Raw PLFS files are not included due to file size and access restrictions.
- The scripts assume the raw files follow the same naming and folder structure used in the original analysis.
