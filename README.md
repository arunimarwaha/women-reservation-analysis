# Women’s Reservation in Public-Sector Employment  
### Policy Impact Analysis using Synthetic Control Method

This project estimates the causal impact of Punjab’s 2020 policy reserving 33% of direct recruitment positions in state government jobs for women. Using Indian labour force survey data and the Synthetic Control Method, I compare Punjab’s post-policy trajectory with a weighted synthetic control group constructed from other Indian states.

## Why this project matters

Reservation policies are widely used in India to improve representation of historically disadvantaged groups, but their labour market effects remain an empirical question. This project examines whether Punjab’s women’s reservation policy increased women’s representation in government employment.

## Research Question

Did Punjab’s 33% reservation policy for women in state government jobs increase the share of women in public-sector employment?

## Data

**Source:** Periodic Labour Force Survey (PLFS), India  
**Level:** Individual-level labour market survey data  
**Period used:** 2018–2023  
**Outcome:** Share of women in government jobs  

Raw PLFS files are not included in this repository due to size. The data can be accessed here:  
[PLFS Microdata Portal](https://microdata.gov.in/NADA/index.php/catalog/PLFS/?page=1&sort_order=desc&ps=15&repo=PLFS)

### Data preparation

- Aggregated quarterly PLFS data to the annual level to smooth seasonal labour market variation
- Excluded 2017 and 2024 because both years are only partially observed
- Restricted the sample to individuals aged 21–47, matching the eligibility age range for direct recruitment
- Applied PLFS sampling weights throughout the analysis
- Identified government jobs using enterprise type of principal activity

## Methodology

The project uses the **Synthetic Control Method (SCM)** to estimate the counterfactual share of women in government jobs in Punjab in the absence of the policy.

### Treatment

- **Policy:** 33% reservation for women in direct recruitment to Punjab Civil Services
- **Announcement:** October 2020
- **First treatment year:** 2021
- **Treated unit:** Punjab
- **Donor pool:** Indian states without comparable women’s reservation policies during the relevant period

### Empirical strategy

To estimate the causal impact of Punjab’s 33% reservation policy for women in public-sector jobs, this project uses the **Synthetic Control Method (SCM)**. States with comparable reservation policies introduced before or during the study period are excluded from the donor pool to avoid contamination.

Let $Y_{it}$ denote the outcome of interest for state $i$ in year $t$. The policy was announced in October 2020, so 2021 is treated as the first post-treatment year. Let $T_0 = 2020$ denote the final pre-treatment year.

The treatment indicator is defined as:

$$
D_{it} =
\begin{cases}
1, & \text{if } i = \text{Punjab and } t \geq 2021 \\
0, & \text{otherwise}
\end{cases}
$$

The treatment effect is estimated as the difference between Punjab’s observed outcome and the weighted average outcome of the donor states:

$$
\hat{\tau}_t = Y_{Punjab,t} - \sum_{j=1}^{J} w_j Y_{j,t}, \quad t > T_0
$$

where $w_j$ represents the synthetic-control weight assigned to donor state $j$.


## Key Findings
- Before treatment, Punjab and synthetic Punjab closely track each other, suggesting a reasonable counterfactual fit.
- After the policy implementation, Punjab’s trajectory begins to diverge from the synthetic control.
- By 2023, the share of women in government jobs in Punjab reaches approximately 0.46, compared with around 0.36–0.37 for synthetic Punjab.
- Placebo tests suggest that Punjab’s post-treatment gap is larger than most placebo gaps.
- Results suggest that the policy is associated with a substantial increase in women’s representation in government employment.


## Robustness Checks
- Conducted placebo tests by applying SCM to donor states
- Excluded placebo units with poor pre-treatment fit
- Compared post-treatment gaps against the placebo distribution

## Limitations

The results should be interpreted with caution because the available PLFS period provides a short pre-treatment window. Future work could extend the analysis using longer time horizons and additional outcomes such as female labour force participation, sectoral employment patterns, education, and private-sector spillovers.

## Skills Demonstrated
- Causal inference and policy evaluation
- Synthetic Control Method
- Labour market data analysis
- Survey data cleaning and preprocessing
- Panel data construction
- Placebo testing and robustness checks
- Data visualization and interpretation
- Policy-focused analytical writing

## Tools Used
- STATA
- PLFS microdata
- Synthetic Control Method
- Econometric analysis
- Data visualization

### Author
Arunima Marwaha
