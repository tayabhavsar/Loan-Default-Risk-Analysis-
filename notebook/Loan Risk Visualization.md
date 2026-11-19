Loan Risk Analysis - Visualizations 

Importing Data 


```python
import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns 

%matplotlib inline 

conn = sqlite3.connect("loans.db")

def run_query(sql):
    with sqlite3.connect(r"C:\Users\tayab\loans.db") as conn:
        return pd.read_sql_query(sql, conn)


```


```python
import sqlite3
conn = sqlite3.connect("loans.db")
```


```python
%cd "C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets"
```

    C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets
    


```python
borrower_profiles = pd.read_csv("borrower_profiles.csv")
loan_applications = pd.read_csv("loan_applications.csv")
```


```python
borrower_profiles
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>borrower_id</th>
      <th>age</th>
      <th>state</th>
      <th>education_level</th>
      <th>employment_status</th>
      <th>years_employed</th>
      <th>annual_income</th>
      <th>credit_score</th>
      <th>home_ownership</th>
      <th>dependents</th>
      <th>existing_monthly_debt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>BRW-0001</td>
      <td>62</td>
      <td>CT</td>
      <td>High School</td>
      <td>Self-Employed</td>
      <td>6</td>
      <td>31020</td>
      <td>596</td>
      <td>Rent</td>
      <td>1</td>
      <td>892</td>
    </tr>
    <tr>
      <th>1</th>
      <td>BRW-0002</td>
      <td>24</td>
      <td>CO</td>
      <td>High School</td>
      <td>Full-Time</td>
      <td>4</td>
      <td>40188</td>
      <td>543</td>
      <td>Own</td>
      <td>2</td>
      <td>869</td>
    </tr>
    <tr>
      <th>2</th>
      <td>BRW-0003</td>
      <td>50</td>
      <td>NC</td>
      <td>Bachelor</td>
      <td>Contract</td>
      <td>22</td>
      <td>41014</td>
      <td>611</td>
      <td>Mortgage</td>
      <td>0</td>
      <td>1806</td>
    </tr>
    <tr>
      <th>3</th>
      <td>BRW-0004</td>
      <td>43</td>
      <td>TX</td>
      <td>High School</td>
      <td>Full-Time</td>
      <td>19</td>
      <td>35036</td>
      <td>701</td>
      <td>Mortgage</td>
      <td>2</td>
      <td>928</td>
    </tr>
    <tr>
      <th>4</th>
      <td>BRW-0005</td>
      <td>46</td>
      <td>NY</td>
      <td>High School</td>
      <td>Full-Time</td>
      <td>18</td>
      <td>44528</td>
      <td>715</td>
      <td>Own</td>
      <td>0</td>
      <td>608</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>495</th>
      <td>BRW-0496</td>
      <td>27</td>
      <td>IL</td>
      <td>Bachelor</td>
      <td>Contract</td>
      <td>4</td>
      <td>60337</td>
      <td>661</td>
      <td>Mortgage</td>
      <td>0</td>
      <td>2359</td>
    </tr>
    <tr>
      <th>496</th>
      <td>BRW-0497</td>
      <td>23</td>
      <td>MO</td>
      <td>High School</td>
      <td>Full-Time</td>
      <td>3</td>
      <td>54617</td>
      <td>773</td>
      <td>Rent</td>
      <td>3</td>
      <td>1475</td>
    </tr>
    <tr>
      <th>497</th>
      <td>BRW-0498</td>
      <td>30</td>
      <td>CO</td>
      <td>Doctorate</td>
      <td>Self-Employed</td>
      <td>7</td>
      <td>85000</td>
      <td>845</td>
      <td>Mortgage</td>
      <td>3</td>
      <td>1894</td>
    </tr>
    <tr>
      <th>498</th>
      <td>BRW-0499</td>
      <td>62</td>
      <td>MA</td>
      <td>Bachelor</td>
      <td>Full-Time</td>
      <td>14</td>
      <td>62749</td>
      <td>811</td>
      <td>Rent</td>
      <td>1</td>
      <td>1339</td>
    </tr>
    <tr>
      <th>499</th>
      <td>BRW-0500</td>
      <td>31</td>
      <td>MO</td>
      <td>Associate</td>
      <td>Full-Time</td>
      <td>5</td>
      <td>67070</td>
      <td>604</td>
      <td>Mortgage</td>
      <td>0</td>
      <td>2856</td>
    </tr>
  </tbody>
</table>
<p>500 rows × 11 columns</p>
</div>




```python
loan_applications
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>loan_id</th>
      <th>borrower_id</th>
      <th>application_date</th>
      <th>loan_purpose</th>
      <th>loan_amount</th>
      <th>term_months</th>
      <th>interest_rate</th>
      <th>monthly_payment</th>
      <th>dti_ratio</th>
      <th>loan_status</th>
      <th>days_delinquent</th>
      <th>defaulted</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>LN-00001</td>
      <td>BRW-0001</td>
      <td>2024-01-08</td>
      <td>Vacation</td>
      <td>16100.0</td>
      <td>36</td>
      <td>13.05</td>
      <td>542.86</td>
      <td>55.5</td>
      <td>Paid Off</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>LN-00002</td>
      <td>BRW-0001</td>
      <td>2024-08-13</td>
      <td>Major Purchase</td>
      <td>5600.0</td>
      <td>48</td>
      <td>14.21</td>
      <td>153.62</td>
      <td>40.4</td>
      <td>Default</td>
      <td>138</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>LN-00003</td>
      <td>BRW-0002</td>
      <td>2025-06-28</td>
      <td>Moving</td>
      <td>44700.0</td>
      <td>36</td>
      <td>12.37</td>
      <td>1492.59</td>
      <td>70.5</td>
      <td>Paid Off</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>LN-00004</td>
      <td>BRW-0003</td>
      <td>2025-05-18</td>
      <td>Auto Loan</td>
      <td>9200.0</td>
      <td>48</td>
      <td>11.18</td>
      <td>238.58</td>
      <td>59.8</td>
      <td>Default</td>
      <td>34</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>LN-00005</td>
      <td>BRW-0004</td>
      <td>2025-03-24</td>
      <td>Moving</td>
      <td>11200.0</td>
      <td>36</td>
      <td>9.66</td>
      <td>359.61</td>
      <td>44.1</td>
      <td>Current</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>596</th>
      <td>LN-00597</td>
      <td>BRW-0497</td>
      <td>2025-02-06</td>
      <td>Wedding</td>
      <td>29100.0</td>
      <td>36</td>
      <td>7.38</td>
      <td>903.59</td>
      <td>52.3</td>
      <td>Default</td>
      <td>31</td>
      <td>1</td>
    </tr>
    <tr>
      <th>597</th>
      <td>LN-00598</td>
      <td>BRW-0498</td>
      <td>2024-04-19</td>
      <td>Moving</td>
      <td>4600.0</td>
      <td>12</td>
      <td>7.27</td>
      <td>398.60</td>
      <td>32.4</td>
      <td>Current</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>598</th>
      <td>LN-00599</td>
      <td>BRW-0499</td>
      <td>2024-02-24</td>
      <td>Education</td>
      <td>7800.0</td>
      <td>60</td>
      <td>9.86</td>
      <td>165.19</td>
      <td>28.8</td>
      <td>Current</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>599</th>
      <td>LN-00600</td>
      <td>BRW-0500</td>
      <td>2024-11-14</td>
      <td>Medical Expenses</td>
      <td>26400.0</td>
      <td>24</td>
      <td>11.44</td>
      <td>1235.85</td>
      <td>73.2</td>
      <td>Late</td>
      <td>15</td>
      <td>0</td>
    </tr>
    <tr>
      <th>600</th>
      <td>LN-00601</td>
      <td>BRW-0500</td>
      <td>2024-05-03</td>
      <td>Wedding</td>
      <td>7500.0</td>
      <td>12</td>
      <td>10.70</td>
      <td>661.81</td>
      <td>62.9</td>
      <td>Current</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>601 rows × 12 columns</p>
</div>




```python
import os


for p in [r"C:\Users\tayab\loans.db",
          r"C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets\loans.db"]:
    if os.path.exists(p):
        print(f"{os.path.getsize(p):>8} bytes  {p}")
    else:
        print(f"{'missing':>8}        {p}")

```

           0 bytes  C:\Users\tayab\loans.db
      102400 bytes  C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets\loans.db
    


```python
import os
import pandas as pd


print("cwd:", os.getcwd())
print("csvs here:", [f for f in os.listdir() if f.lower().endswith(".csv")])


borrowers = pd.read_csv("borrower_profiles.csv")
loans = pd.read_csv("loan_applications.csv")


print("borrowers:", borrowers.shape)
print("loans:", loans.shape)

```

    cwd: C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets
    csvs here: ['alien_sightings.csv', 'All_Data_Aldi.csv', 'All_Data_ASDA.csv', 'All_Data_Morrisons.csv', 'All_Data_Sains.csv', 'All_Data_Tesco.csv', 'all_stocks_5yr.csv', 'banking.csv', 'borrower_profiles.csv', 'car_sales.csv', 'DailyIndiaClimate.csv', 'health_insurance.csv', 'homesales.csv', 'imdb_movies.csv', 'laptop_prices.csv', 'list_of_usa_addresses.csv', 'loan_applications.csv', 'Microsoft_Stock.csv', 'patient_visits.csv', 'real_estate.csv', 'smoking.csv', 'Telco-Customer-Churn.csv', 'US Debt Tracker.csv', 'USHouseholdIncome.csv', 'u_food_marketing.csv', 'Vehicle Data.csv', 'WeatherHistory.csv', 'WorldContinents.csv']
    borrowers: (500, 11)
    loans: (601, 12)
    


```python
import sqlite3
import os


DB_PATH = r"C:\Users\tayab\Documents\Data Projects\Datasets\Analyst Builder Datasets\loans.db"


conn = sqlite3.connect(DB_PATH)
borrowers.to_sql("borrowers", conn, if_exists="replace", index=False)
loans.to_sql("loan_applications", conn, if_exists="replace", index=False)
conn.commit()
conn.close()


print("db size:", os.path.getsize(DB_PATH), "bytes")

```

    db size: 102400 bytes
    


```python
def run_query(sql):
    with sqlite3.connect(DB_PATH) as c:
        return pd.read_sql_query(sql, c)


print(run_query("SELECT name FROM sqlite_master WHERE type='table'"))
print(run_query("SELECT COUNT(*) AS n FROM loan_applications"))

```

                    name
    0          borrowers
    1  loan_applications
         n
    0  601
    


```python
run_query("""
    SELECT COUNT(*) AS unmatched
    FROM loan_applications l
    LEFT JOIN borrowers b
      ON l.borrower_id = b.borrower_id
    WHERE b.borrower_id IS NULL
""")

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>unmatched</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
run_query("PRAGMA table_info(loan_applications)")
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>cid</th>
      <th>name</th>
      <th>type</th>
      <th>notnull</th>
      <th>dflt_value</th>
      <th>pk</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>loan_id</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>borrower_id</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>application_date</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>loan_purpose</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>loan_amount</td>
      <td>REAL</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>term_months</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>interest_rate</td>
      <td>REAL</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>7</td>
      <td>monthly_payment</td>
      <td>REAL</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>8</td>
      <td>dti_ratio</td>
      <td>REAL</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>9</td>
      <td>loan_status</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>10</td>
      <td>days_delinquent</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>11</td>
      <td>defaulted</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
run_query("SELECT loan_status, COUNT(*) AS n FROM loan_applications GROUP BY loan_status")
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>loan_status</th>
      <th>n</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Current</td>
      <td>239</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Default</td>
      <td>146</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Late</td>
      <td>103</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Paid Off</td>
      <td>113</td>
    </tr>
  </tbody>
</table>
</div>




```python
run_query("PRAGMA table_info(borrowers)")
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>cid</th>
      <th>name</th>
      <th>type</th>
      <th>notnull</th>
      <th>dflt_value</th>
      <th>pk</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>borrower_id</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>age</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>state</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>education_level</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>employment_status</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>5</td>
      <td>years_employed</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>6</td>
      <td>annual_income</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>7</td>
      <td>credit_score</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>8</td>
      <td>home_ownership</td>
      <td>TEXT</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>9</td>
      <td>dependents</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>10</td>
      <td>existing_monthly_debt</td>
      <td>INTEGER</td>
      <td>0</td>
      <td>None</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
def run_query(query):
    with sqlite3.connect(DB_PATH) as c:
        return pd.read_sql_query(query, c)
```


```python
analysis = run_query("""
SELECT
    l.loan_id,
    l.borrower_id,
    l.loan_purpose,
    l.loan_amount,
    l.term_months,
    l.interest_rate,
    l.dti_ratio,
    l.loan_status,
    l.defaulted,
    b.credit_score,
    b.annual_income,
    b.employment_status,
    b.years_employed,
    b.home_ownership,
    b.dependents,
    b.existing_monthly_debt
FROM loan_applications l
JOIN borrowers b
    ON l.borrower_id = b.borrower_id
""")


analysis.shape          # should be (601, 16)
analysis['defaulted'].mean()   # your overall default rate

```




    np.float64(0.24292845257903495)



Credit Score Bucket Visualization


```python
bins   = [519, 599, 649, 699, 749, 850]
labels = ['520-599', '600-649', '650-699', '700-749', '750+']


analysis['credit_bucket'] = pd.cut(
    analysis['credit_score'], bins=bins, labels=labels
)

```


```python
from matplotlib.ticker import PercentFormatter


sns.set_theme(style="whitegrid")


rate_by_credit = (
    analysis.groupby('credit_bucket', observed=True)['defaulted']
    .agg(default_rate='mean', n='count')
    .reset_index()
)


fig, ax = plt.subplots(figsize=(9, 5))
sns.barplot(data=rate_by_credit, x='credit_bucket', y='default_rate', ax=ax)


ax.axhline(0.12, color='crimson', linestyle='--', label='Target (12%)')
ax.set_title('Default Rate by Credit Score Bucket')
ax.set_xlabel('Credit Score')
ax.set_ylabel('Default Rate')
ax.yaxis.set_major_formatter(PercentFormatter(1.0))
ax.legend()
plt.tight_layout()

```


    
![png](output_20_0.png)
    


Findings: 
1. 520-599 credit bucket is a disaster zone - it is roughly 4x the 12% target.
2. 600-649 and 650-699 buckets are identical, both at around 28%.
3. 750+ is at or just under the 12% target. 

Counts


```python
rate_by_credit = (
    analysis.groupby('credit_bucket', observed=True)['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .reset_index()
)
rate_by_credit['pct_of_all_defaults'] = (
    rate_by_credit['defaults'] / analysis['defaulted'].sum()
)
rate_by_credit

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>credit_bucket</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
      <th>pct_of_all_defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>520-599</td>
      <td>0.491379</td>
      <td>116</td>
      <td>57</td>
      <td>0.390411</td>
    </tr>
    <tr>
      <th>1</th>
      <td>600-649</td>
      <td>0.290323</td>
      <td>93</td>
      <td>27</td>
      <td>0.184932</td>
    </tr>
    <tr>
      <th>2</th>
      <td>650-699</td>
      <td>0.280000</td>
      <td>75</td>
      <td>21</td>
      <td>0.143836</td>
    </tr>
    <tr>
      <th>3</th>
      <td>700-749</td>
      <td>0.162791</td>
      <td>86</td>
      <td>14</td>
      <td>0.095890</td>
    </tr>
    <tr>
      <th>4</th>
      <td>750+</td>
      <td>0.116883</td>
      <td>231</td>
      <td>27</td>
      <td>0.184932</td>
    </tr>
  </tbody>
</table>
</div>



The 520-599 credit bucket is only 19% of the loan book (116/601) but drives 39% of  all defaults. 

Cut-off Analysis 


```python
for cutoff in [600, 650, 700, 750]:
    kept = analysis[analysis['credit_score'] >= cutoff]
    print(f"Cutoff {cutoff}: {len(kept):>3} loans kept "
          f"({len(kept)/len(analysis):>5.1%} of book), "
          f"default rate {kept['defaulted'].mean():>5.1%}")

```

    Cutoff 600: 485 loans kept (80.7% of book), default rate 18.4%
    Cutoff 650: 392 loans kept (65.2% of book), default rate 15.8%
    Cutoff 700: 317 loans kept (52.7% of book), default rate 12.9%
    Cutoff 750: 231 loans kept (38.4% of book), default rate 11.7%
    

600 cutoff removes 57 defaults but the remaining book still defaults at 18%. 

700 cutoff gets to roughly 12% but declines half of the book. 

DTI Box Plot Visualization


```python
analysis['default_label'] = analysis['defaulted'].map({0: 'No Default', 1: 'Default'})


fig, ax = plt.subplots(figsize=(7, 5))
sns.boxplot(data=analysis, x='default_label', y='dti_ratio', ax=ax)
ax.set_title('DTI Ratio by Default Status')
ax.set_ylabel('DTI Ratio (%)')
plt.tight_layout()

```


    
![png](output_29_0.png)
    


DTI Buckets - Cutoff 


```python
analysis['dti_bucket'] = pd.cut(
    analysis['dti_ratio'],
    bins=[0, 20, 30, 40, 50, 60, 100],
    labels=['<20', '20-30', '30-40', '40-50', '50-60', '60+']
)


dti_summary = (
    analysis.groupby('dti_bucket', observed=True)['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .reset_index()
)
dti_summary['pct_of_all_defaults'] = (
    dti_summary['defaults'] / analysis['defaulted'].sum()
)
dti_summary

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dti_bucket</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
      <th>pct_of_all_defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>&lt;20</td>
      <td>0.166667</td>
      <td>48</td>
      <td>8</td>
      <td>0.054795</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20-30</td>
      <td>0.128205</td>
      <td>78</td>
      <td>10</td>
      <td>0.068493</td>
    </tr>
    <tr>
      <th>2</th>
      <td>30-40</td>
      <td>0.117117</td>
      <td>111</td>
      <td>13</td>
      <td>0.089041</td>
    </tr>
    <tr>
      <th>3</th>
      <td>40-50</td>
      <td>0.234043</td>
      <td>94</td>
      <td>22</td>
      <td>0.150685</td>
    </tr>
    <tr>
      <th>4</th>
      <td>50-60</td>
      <td>0.323232</td>
      <td>99</td>
      <td>32</td>
      <td>0.219178</td>
    </tr>
    <tr>
      <th>5</th>
      <td>60+</td>
      <td>0.355705</td>
      <td>149</td>
      <td>53</td>
      <td>0.363014</td>
    </tr>
  </tbody>
</table>
</div>




```python
analysis['dti_ratio'].describe()
```




    count    601.000000
    mean      49.680699
    std       24.113652
    min        7.600000
    25%       32.200000
    50%       48.100000
    75%       62.400000
    max      177.400000
    Name: dti_ratio, dtype: float64




```python
import numpy as np


bins = [0, 20, 30, 40, 50, 60, np.inf]
labels = ['<20', '20-30', '30-40', '40-50', '50-60', '60+']


analysis['dti_bucket'] = pd.cut(
    analysis['dti_ratio'],
    bins=bins,
    labels=labels
)


analysis['dti_bucket'].isna().sum()

```




    np.int64(0)




```python
dti_summary = (
    analysis.groupby('dti_bucket', observed=True)['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .reset_index()
)
dti_summary['pct_of_all_defaults'] = (
    dti_summary['defaults'] / analysis['defaulted'].sum()
)
dti_summary

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dti_bucket</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
      <th>pct_of_all_defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>&lt;20</td>
      <td>0.166667</td>
      <td>48</td>
      <td>8</td>
      <td>0.054795</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20-30</td>
      <td>0.128205</td>
      <td>78</td>
      <td>10</td>
      <td>0.068493</td>
    </tr>
    <tr>
      <th>2</th>
      <td>30-40</td>
      <td>0.117117</td>
      <td>111</td>
      <td>13</td>
      <td>0.089041</td>
    </tr>
    <tr>
      <th>3</th>
      <td>40-50</td>
      <td>0.234043</td>
      <td>94</td>
      <td>22</td>
      <td>0.150685</td>
    </tr>
    <tr>
      <th>4</th>
      <td>50-60</td>
      <td>0.323232</td>
      <td>99</td>
      <td>32</td>
      <td>0.219178</td>
    </tr>
    <tr>
      <th>5</th>
      <td>60+</td>
      <td>0.356725</td>
      <td>171</td>
      <td>61</td>
      <td>0.417808</td>
    </tr>
  </tbody>
</table>
</div>



DTI of 30-40 is the sweet pot (11.7% right at target) 

Cliff is at 40, rate doubles to 23.4% and keeps climbing 

DTI of 60+ is 28% of the loan book but 42% of all defaults 

 Default Rate by Loan Purpose 


```python
purpose_summary = (
    analysis.groupby('loan_purpose')['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .sort_values('default_rate', ascending=False)
    .reset_index()
)
purpose_summary['pct_of_all_defaults'] = (
    purpose_summary['defaults'] / analysis['defaulted'].sum()
)
purpose_summary

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>loan_purpose</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
      <th>pct_of_all_defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Wedding</td>
      <td>0.321429</td>
      <td>56</td>
      <td>18</td>
      <td>0.123288</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Home Improvement</td>
      <td>0.285714</td>
      <td>70</td>
      <td>20</td>
      <td>0.136986</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Auto Loan</td>
      <td>0.271186</td>
      <td>59</td>
      <td>16</td>
      <td>0.109589</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Business Loan</td>
      <td>0.241379</td>
      <td>58</td>
      <td>14</td>
      <td>0.095890</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Education</td>
      <td>0.226415</td>
      <td>53</td>
      <td>12</td>
      <td>0.082192</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Vacation</td>
      <td>0.225806</td>
      <td>62</td>
      <td>14</td>
      <td>0.095890</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Major Purchase</td>
      <td>0.220588</td>
      <td>68</td>
      <td>15</td>
      <td>0.102740</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Debt Consolidation</td>
      <td>0.215686</td>
      <td>51</td>
      <td>11</td>
      <td>0.075342</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Moving</td>
      <td>0.214286</td>
      <td>56</td>
      <td>12</td>
      <td>0.082192</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Medical Expenses</td>
      <td>0.205882</td>
      <td>68</td>
      <td>14</td>
      <td>0.095890</td>
    </tr>
  </tbody>
</table>
</div>



Spread went from 20.6% to 32.1%; 1.5x range and every purpose sits well with the 21% target.

Conclusion: loan purpose is a weak signal: Wedding is the worst, and Medical Expenses is the best but the gap is small enough that the loan purpose shouldn't drive an approval decision. 


```python
analysis.groupby('defaulted')['loan_amount'].agg(['mean', 'median', 'count'])
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mean</th>
      <th>median</th>
      <th>count</th>
    </tr>
    <tr>
      <th>defaulted</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>22012.747253</td>
      <td>20400.0</td>
      <td>455</td>
    </tr>
    <tr>
      <th>1</th>
      <td>22570.547945</td>
      <td>20400.0</td>
      <td>146</td>
    </tr>
  </tbody>
</table>
</div>




```python
from scipy import stats


stats.ttest_ind(
    analysis.loc[analysis['defaulted'] == 1, 'loan_amount'],
    analysis.loc[analysis['defaulted'] == 0, 'loan_amount'],
    equal_var=False
)

```




    TtestResult(statistic=np.float64(0.4446426913811921), pvalue=np.float64(0.6569689296483779), df=np.float64(246.0026688174719))



Medians are identical, the means differ by 2.5%, and the p-value = 0.656 which is greater than 0.05. This is nowhere 
near significant. 

Findings: Loan amount does not differ meaningfully between defaulters and non-defaulters. 

Employment 


```python
emp_summary = (
    analysis.groupby('employment_status')['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .sort_values('default_rate', ascending=False)
    .reset_index()
)
emp_summary['pct_of_all_defaults'] = (
    emp_summary['defaults'] / analysis['defaulted'].sum()
)
emp_summary

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>employment_status</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
      <th>pct_of_all_defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Part-Time</td>
      <td>0.276923</td>
      <td>65</td>
      <td>18</td>
      <td>0.123288</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Self-Employed</td>
      <td>0.247619</td>
      <td>105</td>
      <td>26</td>
      <td>0.178082</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Full-Time</td>
      <td>0.239344</td>
      <td>305</td>
      <td>73</td>
      <td>0.500000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Retired</td>
      <td>0.233333</td>
      <td>60</td>
      <td>14</td>
      <td>0.095890</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Contract</td>
      <td>0.227273</td>
      <td>66</td>
      <td>15</td>
      <td>0.102740</td>
    </tr>
  </tbody>
</table>
</div>



Employment status does not meaningfully separate defaulters from non-defaulters. 


```python
tenure_summary = (
    analysis.groupby('tenure_bucket', observed=True)['defaulted']
    .agg(default_rate='mean', n='count', defaults='sum')
    .reset_index()
)
tenure_summary
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>tenure_bucket</th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>&lt;2 yrs</td>
      <td>0.311111</td>
      <td>135</td>
      <td>42</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2-5 yrs</td>
      <td>0.115789</td>
      <td>95</td>
      <td>11</td>
    </tr>
    <tr>
      <th>2</th>
      <td>5-10 yrs</td>
      <td>0.300000</td>
      <td>110</td>
      <td>33</td>
    </tr>
    <tr>
      <th>3</th>
      <td>10+ yrs</td>
      <td>0.229885</td>
      <td>261</td>
      <td>60</td>
    </tr>
  </tbody>
</table>
</div>




```python
analysis['tenure_bucket'] = pd.cut(
    analysis['years_employed'],
    bins=[-1, 2, 5, 10, np.inf],
    labels=['<=2 yrs', '2-5 yrs', '5-10 yrs', '10+ yrs']
)

analysis.groupby('tenure_bucket', observed=True)['defaulted'].agg(
    default_rate='mean', n='count', defaults='sum'
)

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>default_rate</th>
      <th>n</th>
      <th>defaults</th>
    </tr>
    <tr>
      <th>tenure_bucket</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;=2 yrs</th>
      <td>0.311111</td>
      <td>135</td>
      <td>42</td>
    </tr>
    <tr>
      <th>2-5 yrs</th>
      <td>0.115789</td>
      <td>95</td>
      <td>11</td>
    </tr>
    <tr>
      <th>5-10 yrs</th>
      <td>0.300000</td>
      <td>110</td>
      <td>33</td>
    </tr>
    <tr>
      <th>10+ yrs</th>
      <td>0.229885</td>
      <td>261</td>
      <td>60</td>
    </tr>
  </tbody>
</table>
</div>




```python
print(tenure_summary['n'].sum(), tenure_summary['defaults'].sum())
```

    601 146
    


```python
analysis['under_2yrs'] = analysis['years_employed'] < 2
analysis.groupby('under_2yrs')['defaulted'].agg(['mean', 'count'])

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mean</th>
      <th>count</th>
    </tr>
    <tr>
      <th>under_2yrs</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>False</th>
      <td>0.226306</td>
      <td>517</td>
    </tr>
    <tr>
      <th>True</th>
      <td>0.345238</td>
      <td>84</td>
    </tr>
  </tbody>
</table>
</div>




```python
from scipy.stats import chi2_contingency


table = pd.crosstab(analysis['employment_status'], analysis['defaulted'])
chi2_contingency(table)
```




    Chi2ContingencyResult(statistic=np.float64(0.5602898446163267), pvalue=np.float64(0.9673725149707899), dof=4, expected_freq=array([[ 49.96672213,  16.03327787],
           [230.90682196,  74.09317804],
           [ 49.20965058,  15.79034942],
           [ 45.42429285,  14.57570715],
           [ 79.49251248,  25.50748752]]))




```python

```
