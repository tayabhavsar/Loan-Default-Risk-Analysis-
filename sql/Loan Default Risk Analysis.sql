#---Loan Default Risk Analysis - SQL 

#-- Questions to Answer 
#--1. What is the overall default rate, and how does it break down by credit score range (e.g., 520–599, 600–649, 650–699, 700–749, 750+)? Which credit score bucket has the highest default rate?
#--2. Is there a relationship between a borrower’s debt-to-income (DTI) ratio and the likelihood of defaulting? What DTI threshold would you recommend as a cutoff for loan approval?
#--3. Which loan purposes have the highest default rates, and does the average loan amount differ significantly between defaulted and non-defaulted loans?
#--4. Are borrowers with less than 2 years of employment significantly more likely to default?
#--5. How do employment status and years employed affect default risk? 


SELECT *
FROM borrower_profiles; 


SELECT *
FROM loan_applications; 

#---1. Check for nulls, data types, and basic stats

#--- Data types
DESCRIBE borrower_profiles; 
DESCRIBE loan_applications; 

SHOW COLUMNS FROM borrower_profiles;
SHOW COLUMNS FROM loan_applications;

#--Checking for Nulls for Borrowers
SELECT 
SUM(borrower_id IS NULL) AS null_borrower_id,
SUM(credit_score IS NULL) AS null_credit_score, 
SUM(annual_income IS NULL) AS null_annual_income, 
SUM(employment_status IS NULL) as null_employment_status,
SUM(home_ownership IS NULL) AS null_home_ownership,
SUM(dependents IS NULL) AS null_dependents,
SUM(age IS NULL) AS null_age,
SUM(state IS NULL) AS null_state,
SUM(education_level IS NULL) AS null_education_level,
SUM(years_employed IS NULL) AS null_years_employed,
SUM(existing_monthly_debt IS NULL) AS null_emd
FROM borrower_profiles; 

#-- There are no nulls in the borrowers table 


#-- Check nulls for Loan Applications 
SELECT 
SUM(loan_id IS NULL) AS null_loan_id,
SUM(borrower_id IS NULL) AS null_borrower_id, 
SUM(application_date IS NULL) AS null_application_date,
SUM(loan_purpose IS NULL) AS null_loan_purpose, 
SUM(loan_amount IS NULL) As null_loan_amount, 
SUM(term_months IS NULL) AS null_term_months, 
SUM(interest_rate IS NULL) AS null_interest_rate, 
SUM(monthly_payment IS NULL) AS null_monthly_payment, 
SUM(dti_ratio IS NULL) AS null_dti_ratio, 
SUM(loan_status IS NULL) AS null_loan_status, 
SUM(days_delinquent IS NULL) AS null_days_delinquent, 
SUM(defaulted IS NULL) AS null_defaulted
FROM loan_applications; 

#-- There are no nulls in loan applications table


#--Basic Stats: Borrowers 
SELECT
  COUNT(*)                    AS n_rows,
  MIN(credit_score)           AS min_cs,
  MAX(credit_score)           AS max_cs,
  AVG(credit_score)           AS avg_cs,
  STDDEV(credit_score)        AS sd_cs,
  MIN(annual_income)          AS min_income,
  MAX(annual_income)          AS max_income,
  AVG(annual_income)          AS avg_income,
  MIN(age)                    AS min_age,
  MAX(age)                    AS max_age,
  AVG(age)                    AS avg_age,
  MIN(years_employed)         AS min_yrs,
  MAX(years_employed)         AS max_yrs,
  AVG(years_employed)         AS avg_yrs,
  MIN(existing_monthly_debt)  AS min_emd,
  MAX(existing_monthly_debt)  AS max_emd,
  AVG(existing_monthly_debt)  AS avg_emd
FROM borrower_profiles;

#--Results: 
# n_rows, min_cs, max_cs, avg_cs, sd_cs, min_income, max_income, avg_income, min_age, max_age, avg_age, min_yrs, max_yrs, avg_yrs, min_emd, max_emd, avg_emd
'500', '528', '850', '704.9520', '97.24176929694362', '12549', '157047', '64471.4840', '22', '68', '44.9860', '0', '35', '10.8540', '124', '6130', '1585.1660'

#--Basic Stats: Loan Applications 
SELECT
  COUNT(*)                     AS n_rows,
  MIN(loan_amount)             AS min_amt,   MAX(loan_amount)             AS max_amt,
  AVG(loan_amount)             AS avg_amt,   STDDEV(loan_amount)          AS sd_amt,
  MIN(term_months)             AS min_term,  MAX(term_months)             AS max_term,
  MIN(interest_rate)           AS min_rate,  MAX(interest_rate)           AS max_rate,
  AVG(interest_rate)           AS avg_rate,
  MIN(monthly_payment)         AS min_pay,   MAX(monthly_payment)         AS max_pay,
  MIN(dti_ratio)               AS min_dti,   MAX(dti_ratio)               AS max_dti,
  AVG(dti_ratio)               AS avg_dti,
  MIN(days_delinquent)         AS min_delinq, MAX(days_delinquent)        AS max_delinq,
  MIN(defaulted)               AS min_def,   MAX(defaulted)               AS max_def
FROM loan_applications;

#--Results: 
# n_rows, min_amt, max_amt, avg_amt, sd_amt, min_term, max_term, min_rate, max_rate, avg_rate, min_pay, max_pay, min_dti, max_dti, avg_dti, min_delinq, max_delinq, min_def, max_def
'601', '2000', '49800', '22148.252911813644', '13204.26245060617', '12', '60', '5.86', '15.86', '10.64133111480864', '44.14', '4262.69', '7.6', '177.4', '49.6806988352746', '0', '180', '0', '1'


#--Sentimental Value Checks: Borrowers

SELECT
  MIN(credit_score) AS min_cs, MAX(credit_score) AS max_cs,
  MIN(annual_income) AS min_inc, MAX(annual_income) AS max_inc,
  MIN(age) AS min_age, MAX(age) AS max_age,
  MIN(years_employed) AS min_yrs, MAX(years_employed) AS max_yrs,
  MIN(existing_monthly_debt) AS min_emd, MAX(existing_monthly_debt) AS max_emd
FROM borrower_profiles;

#--Results: 
# min_cs, max_cs, min_inc, max_inc, min_age, max_age, min_yrs, max_yrs, min_emd, max_emd
'528', '850', '12549', '157047', '22', '68', '0', '35', '124', '6130'

SELECT
  SUM(credit_score = 0)     AS cs_zero,
  SUM(credit_score = -1)    AS cs_neg1,
  SUM(credit_score = 999)   AS cs_999,
  SUM(annual_income = 0)    AS inc_zero,
  SUM(annual_income = -1)   AS inc_neg1,
  SUM(age = 0)              AS age_zero,
  SUM(age = 999)            AS age_999,
  SUM(years_employed = -1)  AS yrs_neg1,
  SUM(years_employed = 999) AS yrs_999
FROM borrower_profiles;

#--Results: 
# cs_zero, cs_neg1, cs_999, inc_zero, inc_neg1, age_zero, age_999, yrs_neg1, yrs_999
'0', '0', '0', '0', '0', '0', '0', '0', '0'

#--Sentinel Value Checks: Loans

-- Fake dates
SELECT MIN(application_date) AS min_date, MAX(application_date) AS max_date
FROM loan_applications;

#--Results:
# min_date, max_date
'2024-01-02', '2025-06-29'

-- Text placeholders
SELECT loan_purpose, COUNT(*) AS n
FROM loan_applications
GROUP BY loan_purpose
ORDER BY n DESC;

#--Results:
# loan_purpose, n
'Home Improvement', '70'
'Major Purchase', '68'
'Medical Expenses', '68'
'Vacation', '62'
'Auto Loan', '59'
'Business Loan', '58'
'Moving', '56'
'Wedding', '56'
'Education', '53'
'Debt Consolidation', '51'


SELECT loan_status, COUNT(*) AS n
FROM loan_applications
GROUP BY loan_status
ORDER BY n DESC;

#--Results: 
# loan_status, n
'Current', '239'
'Default', '146'
'Paid Off', '113'
'Late', '103'


SELECT
  SUM(loan_amount = 0)        AS amt_zero,
  SUM(loan_amount = -1)       AS amt_neg1,
  SUM(loan_amount = 999999)   AS amt_999999,
  SUM(term_months = 0)        AS term_zero,
  SUM(term_months = -1)       AS term_neg1,
  SUM(term_months = 999)      AS term_999,
  SUM(interest_rate = 0)      AS rate_zero,
  SUM(interest_rate = -1)     AS rate_neg1,
  SUM(interest_rate = 99)     AS rate_99,
  SUM(monthly_payment = 0)    AS pay_zero,
  SUM(monthly_payment = -1)   AS pay_neg1,
  SUM(dti_ratio = 0)          AS dti_zero,
  SUM(dti_ratio = -1)         AS dti_neg1,
  SUM(dti_ratio = 999)        AS dti_999,
  SUM(days_delinquent = -1)   AS delinq_neg1,
  SUM(days_delinquent = 999)  AS delinq_999,
  SUM(defaulted NOT IN (0,1)) AS bad_defaulted
FROM loan_applications;

#-- Results: 
# amt_zero, amt_neg1, amt_999999, term_zero, term_neg1, term_999, rate_zero, rate_neg1, rate_99, pay_zero, pay_neg1, dti_zero, dti_neg1, dti_999, delinq_neg1, delinq_999, bad_defaulted
'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'

#--Catergorical Value Counts : Borrowers
SELECT employment_status, COUNT(*) AS n
FROM borrower_profiles
GROUP BY employment_status
ORDER BY n DESC;

#--Results
 employment_status, n
'Full-Time', '252'
'Self-Employed', '90'
'Part-Time', '55'
'Contract', '54'
'Retired', '49'

SELECT home_ownership, COUNT(*) AS n 
FROM borrower_profiles
GROUP BY home_ownership
ORDER BY n DESC; 

#--Results: 
# home_ownership, n
'Mortgage', '216'
'Rent', '177'
'Own', '107'

SELECT education_level, COUNT(*) AS n 
FROM borrower_profiles
GROUP BY education_level
ORDER BY n DESC; 

#--ResultS:
# education_level, n
'Bachelor', '190'
'Master', '119'
'High School', '89'
'Associate', '85'
'Doctorate', '17'

SELECT dependents, COUNT(*) AS n
FROM borrower_profiles 
GROUP BY dependents
ORDER By n DESC; 

#--Results:
# dependents, n
'0', '172'
'2', '113'
'1', '111'
'3', '75'
'4', '29'

SELECT state, COUNT(*) AS n
FROM borrower_profiles
GROUP BY state 
ORDER BY n DESC;

#--Results:
# state, n
'NC', '25'
'KY', '25'
'WA', '25'
'MO', '23'
'NJ', '22'
'MN', '22'
'GA', '21'
'IN', '20'
'AZ', '20'
'MA', '20'
'CO', '19'
'AL', '19'
'MD', '17'
'IL', '17'
'UT', '16'
'LA', '16'
'NY', '15'
'TN', '15'
'SC', '15'
'WI', '15'
'OR', '14'
'OK', '13'
'CT', '12'
'TX', '12'
'FL', '11'
'MI', '11'
'CA', '10'
'OH', '10'
'VA', '10'
'PA', '10'



#--Categorical Value Counts: Loan Applications 

SELECT loan_purpose, COUNT(*) AS n 
FROM loan_applications
GROUP BY loan_purpose 
ORDER BY n DESC; 

#--Results: 
# loan_purpose, n
'Home Improvement', '70'
'Major Purchase', '68'
'Medical Expenses', '68'
'Vacation', '62'
'Auto Loan', '59'
'Business Loan', '58'
'Moving', '56'
'Wedding', '56'
'Education', '53'
'Debt Consolidation', '51'

SELECT defaulted, COUNT(*) AS n 
FROM loan_applications
GROUP BY defaulted
ORDER BY N DESC; 

#--Results: 
# defaulted, n
'0', '455'
'1', '146'

SELECT loan_status, COUNT(*) AS n 
FROM loan_applications
GROUP BY loan_status
ORDER BY n DESC; 

#--Results: 
# loan_status, n
'Current', '239'
'Default', '146'
'Paid Off', '113'
'Late', '103'

# -- Overall default rate 
SELECT COUNT(*) AS n_loans,
       SUM(defaulted) AS n_defaults,
       ROUND(AVG(defaulted) * 100, 2) AS overall_default_rate_pct
FROM loan_applications;

#-- Result: 
# n_loans, n_defaults, overall_default_rate_pct
'601', '146', '24.29'

#-- Target Gaps 
SELECT
  ROUND(AVG(defaulted) * 100, 2)              AS actual_default_rate_pct,
  12.00                                        AS target_default_rate_pct,
  ROUND(AVG(defaulted) * 100 - 12, 2)          AS gap_pp,
  ROUND(AVG(defaulted) * 100 / 12, 2)          AS times_over_target
FROM loan_applications;

#--Results: 
# actual_default_rate_pct, target_default_rate_pct, gap_pp, times_over_target
'24.29', '12.00', '12.29', '2.02'

#--Join keys 

-- Is borrower_id unique in borrower_profiles?
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT borrower_id) AS distinct_ids
FROM borrower_profiles;

#--Results: 
# total_rows, distinct_ids
'500', '500'


-- Any loans with no matching borrower?
SELECT COUNT(*) AS orphan_loans
FROM loan_applications l
LEFT JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE b.borrower_id IS NULL;

#--Results: 
# orphan_loans
'0'

#--This establishes a clean join: this states that the borrowers have multiple loans (a one too many relationship).

#-- Checks 

#--is the loan id unique?
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT loan_id) AS distinct_ids
FROM loan_applications;

#--Results: 
# total_rows, distinct_ids
'601', '601'

#--there are no duplicate loans 

#-- does the deafaulted agree with the loan_status?
SELECT loan_status, defaulted, COUNT(*) AS n
FROM loan_applications
GROUP BY loan_status, defaulted
ORDER BY loan_status, defaulted;

#--Results:
# loan_status, defaulted, n
'Current', '0', '239'
'Default', '1', '146'
'Late', '0', '103'
'Paid Off', '0', '113'

#--the defaulted agrees with the loan status: has a mapping of 1:1

#--checking days_deliquent against defaulted 
SELECT defaulted,
       MIN(days_delinquent) AS min_d,
       AVG(days_delinquent) AS avg_d,
       MAX(days_delinquent) AS max_d
FROM loan_applications
GROUP BY defaulted;

#--Results:
# defaulted, min_d, avg_d, max_d
'0', '0', '3.1978', '30'
'1', '31', '101.3288', '180'

#--confirmed that defaulted derives from delinquency 

------------------------------------------------------------------------------------------------------
#--2. Segment Analysis 

#--Create credit bucket scores 
SELECT 
CASE 
	WHEN credit_score < 600 THEN '520-599'
    WHEN credit_score < 650 THEN '600-649'
    WHEN credit_score < 700 THEN '650-699'
    WHEN credit_score < 750 THEN '700-749'
    ELSE '750+'
END AS credit_bucket, 
COUNT(*),
SUM(l.defaulted) 
FROM loan_applications l 
JOIN borrower_profiles b 
	ON l.borrower_id = b.borrower_id 
GROUP BY credit_bucket
ORDER BY credit_bucket;

#--Result: 
# credit_bucket, COUNT(*), SUM(l.defaulted)
'520-599', '116', '57'
'600-649', '93', '27'
'650-699', '75', '21'
'700-749', '86', '14'
'750+', '231', '27'

#--What does this tell me? 
#--1. the relationship is monotonic: default rates falls at every step as the credit score rises
#--2. Cliff at 600: Going from 520-599 to 600-649 is a 20% point drop. Sub of 600 borrowers default at 4x the rate as 750+ borrowers. 
#--3. Plateau at 620-699: separating 600-649 and 650-699 isn't buying much predictive power
#--4. Only 750+ category is meeting the 12% target. 11.7% is the only bucket at or below the company's level. 

#Verify Check 

SELECT '>= 600' AS cutoff, COUNT(*) AS n_loans, SUM(l.defaulted) AS n_defaults,
       ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE b.credit_score >= 600
UNION ALL
SELECT '>= 700', COUNT(*), SUM(l.defaulted), ROUND(AVG(l.defaulted) * 100, 2)
FROM loan_applications l JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE b.credit_score >= 700
UNION ALL
SELECT '>= 750', COUNT(*), SUM(l.defaulted), ROUND(AVG(l.defaulted) * 100, 2)
FROM loan_applications l JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE b.credit_score >= 750;

#--Result: 
# cutoff, n_loans, n_defaults, default_rate_pct
'>= 600', '485', '89', '18.35'
'>= 700', '317', '41', '12.93'
'>= 750', '231', '27', '11.69'
----------------------------------------------------------------------------------
#--DTI Buckets 
SELECT
  CASE
    WHEN l.dti_ratio < 20 THEN '< 20'
    WHEN l.dti_ratio < 30 THEN '20-29.9'
    WHEN l.dti_ratio < 40 THEN '30-39.9'
    WHEN l.dti_ratio < 50 THEN '40-49.9'
    ELSE '50+'
  END AS dti_bucket,
  COUNT(*)                         AS n_loans,
  MIN(l.dti_ratio)                 AS min_dti,
  MAX(l.dti_ratio)                 AS max_dti,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY dti_bucket
ORDER BY dti_bucket;

#--Result:
# dti_bucket, n_loans, min_dti, max_dti, n_defaults, default_rate_pct
'< 20', '48', '7.6', '19.9', '8', '16.67'
'20-29.9', '78', '20.3', '29.9', '10', '12.82'
'30-39.9', '107', '30.1', '39.9', '12', '11.21'
'40-49.9', '97', '40', '49.9', '23', '23.71'
'50+', '271', '50', '177.4', '93', '34.32'

#---What I noticed about DTI: 
#--1. DTI seems messier than the credit score buckets: it's not monotonic. It falls low at the 20-40 then it increases to a hard 40. 
#--2. The cliff is at 40
#--3. The < 20 bucket is a red herring
#--4. A DTI of 177.4 means monthly debt payments are 1.77x monthly income -- either a data entry issue or extreme edge case. 

#-- Nailing Threshold 

SELECT
  CASE
    WHEN l.dti_ratio < 30  THEN '< 30'
    WHEN l.dti_ratio < 35  THEN '30-34.9'
    WHEN l.dti_ratio < 40  THEN '35-39.9'
    WHEN l.dti_ratio < 45  THEN '40-44.9'
    WHEN l.dti_ratio < 50  THEN '45-49.9'
    ELSE '50+'
  END AS dti_bucket,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY dti_bucket
ORDER BY dti_bucket;

#--Result: 
# dti_bucket, n_loans, n_defaults, default_rate_pct
'< 30', '126', '18', '14.29'
'30-34.9', '54', '4', '7.41'
'35-39.9', '53', '8', '15.09'
'40-44.9', '38', '11', '28.95'
'45-49.9', '59', '12', '20.34'
'50+', '271', '93', '34.32'

#-- Default risk doubles above a DTI of 40 (12.9% below vs 31.5% above). Finer grained buckets between 30-50 show noise due to a small sample sizes, so 40 is recommended as a robust, coarse threshold rather than a precise inflection point. 

#-- DTI Verification 
SELECT 'DTI < 40' AS segment, COUNT(*) AS n_loans, SUM(l.defaulted) AS n_defaults,
       ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE l.dti_ratio < 40
UNION ALL
SELECT 'DTI >= 40', COUNT(*), SUM(l.defaulted), ROUND(AVG(l.defaulted) * 100, 2)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE l.dti_ratio >= 40;

#--Result: 
# segment, n_loans, n_defaults, default_rate_pct
'DTI < 40', '233', '30', '12.88'
'DTI >= 40', '368', '116', '31.52'

#--DTI < 40 alone lands at 12.88% — essentially at the 12% target.

#--Combined Rule 
SELECT
  CASE
    WHEN b.credit_score >= 700 AND l.dti_ratio <  40 THEN 'A: CS>=700 & DTI<40'
    WHEN b.credit_score>= 700 AND l.dti_ratio >= 40 THEN 'B: CS>=700 & DTI>=40'
    WHEN b.credit_score <  700 AND l.dti_ratio <  40 THEN 'C: CS<700  & DTI<40'
    ELSE                                                  'D: CS<700  & DTI>=40'
  END AS risk_segment,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY risk_segment
ORDER BY risk_segment;

#--Result: 
# risk_segment, n_loans, n_defaults, default_rate_pct
'A: CS>=700 & DTI<40', '138', '14', '10.14'
'B: CS>=700 & DTI>=40', '179', '27', '15.08'
'C: CS<700  & DTI<40', '95', '16', '16.84'
'D: CS<700  & DTI>=40', '189', '89', '47.09'

#-- Declining only Segment D goes from 24.29% to 13.83%. 

#--Row Verification 
SELECT 'Approve (A+B+C)' AS policy, COUNT(*) AS n_loans, SUM(l.defaulted) AS n_defaults,
       ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE NOT (b.credit_score < 700 AND l.dti_ratio >= 40)
UNION ALL
SELECT 'Decline (D only)', COUNT(*), SUM(l.defaulted), ROUND(AVG(l.defaulted) * 100, 2)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
WHERE b.credit_score < 700 AND l.dti_ratio >= 40;

#--Result:
# policy, n_loans, n_defaults, default_rate_pct
'Approve (A+B+C)', '412', '57', '13.83'
'Decline (D only)', '189', '89', '47.09'

-----------------------------------------------------------------------------------------
#-- Loan Purpose 

#-- Part A: Default rate by purpose 

SELECT
  l.loan_purpose,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY l.loan_purpose
ORDER BY default_rate_pct DESC;

#--Result: 
# loan_purpose, n_loans, n_defaults, default_rate_pct
'Wedding', '56', '18', '32.14'
'Home Improvement', '70', '20', '28.57'
'Auto Loan', '59', '16', '27.12'
'Business Loan', '58', '14', '24.14'
'Education', '53', '12', '22.64'
'Vacation', '62', '14', '22.58'
'Major Purchase', '68', '15', '22.06'
'Debt Consolidation', '51', '11', '21.57'
'Moving', '56', '12', '21.43'
'Medical Expenses', '68', '14', '20.59'

#--There is a rough two-tier split: 
#--Top 3: Wedding, Home Improvement, Auto-Loan: 54 defaults/185 loans = 29.2% 
#--Bottom 7: 92 defaults / 416 loans = 22.1% 

#--There is a 7 point gap with decent sample sizes on both sides. 

#-- Borrowers who took wedding loans 

SELECT
  l.loan_purpose,
  COUNT(*)                        AS n_loans,
  ROUND(AVG(b.credit_score), 1)   AS avg_credit_score,
  ROUND(AVG(l.dti_ratio), 1)      AS avg_dti,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY l.loan_purpose
ORDER BY default_rate_pct DESC;

#--Result: # loan_purpose, n_loans, avg_credit_score, avg_dti, default_rate_pct
'Wedding', '56', '704.5', '52.4', '32.14'
'Home Improvement', '70', '708.8', '51.2', '28.57'
'Auto Loan', '59', '692.7', '44.4', '27.12'
'Business Loan', '58', '697.0', '43.8', '24.14'
'Education', '53', '675.0', '46.1', '22.64'
'Vacation', '62', '721.6', '52', '22.58'
'Major Purchase', '68', '701.4', '54.3', '22.06'
'Debt Consolidation', '51', '719.6', '50.8', '21.57'
'Moving', '56', '724.4', '46.5', '21.43'
'Medical Expenses', '68', '710.6', '53.3', '20.59'


#--Does loan amount differ between defaulters and non-defaulters? 
SELECT
  l.defaulted,
  COUNT(*)                      AS n_loans,
  ROUND(AVG(l.loan_amount), 2)  AS avg_loan_amount,
  ROUND(MIN(l.loan_amount), 2)  AS min_amt,
  ROUND(MAX(l.loan_amount), 2)  AS max_amt
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY l.defaulted;

#--Results:
# defaulted, n_loans, avg_loan_amount, min_amt, max_amt
'0', '455', '22012.75', '2000', '49800'
'1', '146', '22570.55', '2400', '49700'

#--loan amount is NOT a risk factor. Defaulters and non-defaulters borrow essentially the same amount. Loan size tells you nothing about who's going to default.
------------------------------------------------------------------------------------------
#--Employment

#--< 2 years 
SELECT
  CASE WHEN b.years_employed < 2 THEN '< 2 years' ELSE '>= 2 years' END AS emp_tenure,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY emp_tenure
ORDER BY emp_tenure;

#--Result:
# emp_tenure, n_loans, n_defaults, default_rate_pct
'< 2 years', '84', '29', '34.52'
'>= 2 years', '517', '117', '22.63'

#-- Employment Status 

SELECT
  b.employment_status,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY b.employment_status
ORDER BY default_rate_pct DESC;

#--Result: 
# employment_status, n_loans, n_defaults, default_rate_pct
'Part-Time', '65', '18', '27.69'
'Self-Employed', '105', '26', '24.76'
'Full-Time', '305', '73', '23.93'
'Retired', '60', '14', '23.33'
'Contract', '66', '15', '22.73'


#--Employment status is not a useful risk factor.

#-- years employed (bucketed) 
SELECT
  CASE
    WHEN b.years_employed < 1  THEN '< 1'
    WHEN b.years_employed < 2  THEN '1-1.9'
    WHEN b.years_employed < 5  THEN '2-4.9'
    WHEN b.years_employed < 10 THEN '5-9.9'
    ELSE '10+'
  END AS tenure_bucket,
  COUNT(*)                         AS n_loans,
  SUM(l.defaulted)                 AS n_defaults,
  ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id
GROUP BY tenure_bucket
 ORDER BY MIN(b.years_employed);

#--Result: 
# tenure_bucket, n_loans, n_defaults, default_rate_pct
'< 1', '39', '11', '28.21'
'1-1.9', '45', '18', '40.00'
'2-4.9', '114', '20', '17.54'
'5-9.9', '126', '33', '26.19'
'10+', '277', '64', '23.10'

#--Borrowers with under 2 years of employment default at 34.5% vs 22.6% for those with 2+ years. Finer tenure buckets are non-monotonic and driven by small samples, so the 2-year threshold is recommended as a robust cutoff than a precise inflection point. 

---------------------------------------------------------------------------------------------------------

#--3. Correlation Analysis 

SELECT 'credit_score' AS variable,
  ROUND(
    (COUNT(*) * SUM(l.defaulted * b.credit_score) - SUM(l.defaulted) * SUM(b.credit_score))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(b.credit_score * b.credit_score) - SUM(b.credit_score) * SUM(b.credit_score))
      ), 3) AS corr
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id


UNION ALL


SELECT 'dti_ratio',
  ROUND(
    (COUNT(*) * SUM(l.defaulted * l.dti_ratio) - SUM(l.defaulted) * SUM(l.dti_ratio))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(l.dti_ratio * l.dti_ratio) - SUM(l.dti_ratio) * SUM(l.dti_ratio))
      ), 3)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id


UNION ALL


SELECT 'annual_income',
  ROUND(
    (COUNT(*) * SUM(l.defaulted * b.annual_income) - SUM(l.defaulted) * SUM(b.annual_income))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(b.annual_income * b.annual_income) - SUM(b.annual_income) * SUM(b.annual_income))
      ), 3)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id


UNION ALL


SELECT 'loan_amount',
  ROUND(
    (COUNT(*) * SUM(l.defaulted * l.loan_amount) - SUM(l.defaulted) * SUM(l.loan_amount))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(l.loan_amount * l.loan_amount) - SUM(l.loan_amount) * SUM(l.loan_amount))
      ), 3)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id


UNION ALL


SELECT 'interest_rate',
  ROUND(
    (COUNT(*) * SUM(l.defaulted * l.interest_rate) - SUM(l.defaulted) * SUM(l.interest_rate))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(l.interest_rate * l.interest_rate) - SUM(l.interest_rate) * SUM(l.interest_rate))
      ), 3)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id


UNION ALL


SELECT 'years_employed',
  ROUND(
    (COUNT(*) * SUM(l.defaulted * b.years_employed) - SUM(l.defaulted) * SUM(b.years_employed))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM(b.years_employed * b.years_employed) - SUM(b.years_employed) * SUM(b.years_employed))
      ), 3)
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id;

#--Results: 
# variable, corr
'credit_score', '-0.286'
'dti_ratio', '0.192'
'annual_income', '-0.082'
'loan_amount', '0.018'
'interest_rate', '0.199'
'years_employed', '-0.007'

#-- Credit Score wins by -0.286, which is the strongest correlation. 

#--Binary Flag: Correlation under 2 Years 

SELECT
  ROUND(
    (COUNT(*) * SUM(l.defaulted * (b.years_employed < 2)) - SUM(l.defaulted) * SUM(b.years_employed < 2))
    / SQRT(
        (COUNT(*) * SUM(l.defaulted) - SUM(l.defaulted) * SUM(l.defaulted))
        * (COUNT(*) * SUM((b.years_employed < 2) * (b.years_employed < 2)) - SUM(b.years_employed < 2) * SUM(b.years_employed < 2))
      ), 3) AS corr_under_2yrs
FROM loan_applications l
JOIN borrower_profiles b ON l.borrower_id = b.borrower_id;

#--Results:
0.096