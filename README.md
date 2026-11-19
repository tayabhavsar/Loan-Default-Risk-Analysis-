# Loan Default Risk Analysis

SQL and Python analysis of what drives loan defaults, with specific underwriting threshold recommendations.

**Headline result:** Declining borrowers with a credit score below 700 *and* a DTI of 40% or higher would remove 31% of applications and cut the portfolio default rate from **24.3% to 13.8%**.

---

## Business Question

The loan book defaults at **24.3% (146 of 601 loans)**, twice the company's **12% target**. Which borrower and loan characteristics best predict default, and what approval thresholds should the underwriting team adopt?

## Data

Two tables joined on `borrower_id` (one borrower can have multiple loans):

| Table | Rows | Key fields |
|---|---|---|
| `borrower_profiles` | 500 | credit score, income, employment status, years employed, existing monthly debt |
| `loan_applications` | 601 | loan purpose, amount, term, interest rate, DTI ratio, loan status, days delinquent, defaulted flag |

**Data quality checks:** no nulls, no sentinel values (0, -1, 999), unique IDs, and no orphaned loans. The `defaulted` flag matches `loan_status` one-to-one (defaulted = 31+ days delinquent).

> **Source:** [add dataset source and link here]

## Key Findings

### 1. Credit score is the strongest predictor (correlation: -0.286)

Default rates fall at every step as credit score rises. Borrowers scoring 520-599 are 19% of the loan book but account for 39% of all defaults.

![Default rate by credit score bucket](images/default_rate_by_credit_score.png)

| Credit score | Loans | Default rate |
|---|---|---|
| 520-599 | 116 | 49.1% |
| 600-649 | 93 | 29.0% |
| 650-699 | 75 | 28.0% |
| 700-749 | 86 | 16.3% |
| 750+ | 231 | 11.7% |

Only the 750+ bucket meets the 12% target on its own.

### 2. Debt-to-income (DTI) ratio is the second strongest (correlation: +0.192)

Default risk is flat and relatively low below a DTI of 40%, then rises sharply. Loans under 40% DTI default at **12.9%**, versus **31.5%** at 40% or higher. Borrowers with a DTI of 60% or more are 28% of the book but 42% of all defaults.

![DTI ratio by default status](images/dti_by_default_status.png)

| DTI | Default rate |
|---|---|
| < 20 | 16.7% |
| 20-30 | 12.8% |
| 30-40 | 11.7% |
| 40-50 | 23.4% |
| 50-60 | 32.3% |
| 60+ | 35.7% |

### 3. Short employment tenure is a useful but weaker flag

Borrowers with under 2 years of employment default at **34.5%**, versus **22.6%** for those with 2 or more years. Finer tenure buckets are not monotonic and rely on small samples, so tenure works best as a review flag rather than a standalone cutoff.

### Factors with little to no signal

- **Loan amount:** defaulters and non-defaulters borrow nearly the same (mean $22.6K vs $22.0K, identical medians; Welch t-test p = 0.66).
- **Employment status:** default rates range only from 22.7% to 27.7% (chi-square p = 0.97).
- **Loan purpose:** a modest spread (20.6% to 32.1%), too small to drive approval decisions.

## Recommendations

| Rule | Threshold | Action |
|---|---|---|
| Minimum credit score | 600 | Automatic decline below |
| Target credit score | 700+ | Standard approval |
| Maximum DTI | 40% | Decline or escalate above |
| Employment tenure | Under 2 years | Manual review (not an automatic decline) |

### Combined rule

| Segment | Loans | Default rate |
|---|---|---|
| Score ≥ 700, DTI < 40 | 138 | 10.1% |
| Score ≥ 700, DTI ≥ 40 | 179 | 15.1% |
| Score < 700, DTI < 40 | 95 | 16.8% |
| **Score < 700, DTI ≥ 40** | **189** | **47.1%** |

Declining only the last segment removes 31% of applications and reduces the default rate from 24.3% to **13.8%**, close to but not yet at the 12% target. Approving only the first segment would reach about 10%, but would keep just 23% of volume. Segments B and C can be paired with the tenure flag and tighter pricing or terms.

### Summary for underwriting

Our loan book defaults at 24.3% (146 out of 601 loans), twice the 12% target. Credit score, DTI, and short employment tenure are the three risk factors that most clearly separate defaulters from non-defaulters. We recommend an automatic decline below a 600 credit score, a standard-approval target of 700 or higher, a maximum DTI of 40%, and manual review for borrowers with under 2 years of employment. Applying score and DTI together would reduce the portfolio default rate to 13.8%.

## Limitations

- **Small sample (601 loans):** thresholds should be validated on additional data or a holdout set before becoming policy.
- **DTI outliers:** some DTI values are extreme (max 177.4%), which may be real edge cases or data entry errors worth confirming with the data owner.
- **Descriptive, not predictive:** the findings come from single-factor and two-factor breakdowns. A logistic regression would test whether tenure still matters after controlling for score and DTI.

## Tools Used

- **SQL (MySQL):** data validation, segmentation, threshold testing, and correlation analysis
- **Python:** pandas, SQLite, matplotlib, seaborn, SciPy (Welch t-test, chi-square)

## Repository Structure

```
├── README.md
├── sql/
│   └── Loan_Default_Risk_Analysis.sql   # Cleaning, segmentation, and threshold queries
├── notebooks/
│   └── Loan_Risk_Visualization.ipynb    # Charts, cut-off analysis, and statistical tests
└── images/
```

## How to Run

1. Download the dataset (see Data above) and place `borrower_profiles.csv` and `loan_applications.csv` in a `data/` folder.
2. Open the notebook and run the cells in order. It builds a local SQLite database (`loans.db`) from the CSVs.
3. The `.sql` file contains the full query workflow, written for MySQL.

> The notebook loads the borrower table into SQLite as `borrowers`, while the SQL file uses `borrower_profiles`.

---

*Author: Taya | [LinkedIn](#) | [Portfolio](#)*
