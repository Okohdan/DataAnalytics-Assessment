
# SQL Assessment Queries Documentation

This README explains the SQL logic used in the assessment queries. Each section corresponds to one of the provided query files.

---

## Assessment_Q1
### Objective:
This query summarizes each user's total savings and investments by:

### Logic:
- Using CTEs to pre-aggregate data from `savings_savingsaccount` and `plans_plan`.
- Filtering:
  - `is_regular_savings = 1` for regular savings.
  - `is_a_fund = 1` for fund-based investments.
- Joining with `users_customuser` to link financial data to user profiles.
- Calculating **Total Deposits** as the sum of savings and investments.
- Formatting results using `FORMAT()` and ensuring null safety with `IFNULL()`.
- Applying meaningful aliases like `Savings Count`, `Investment Count`, and `Total Deposits` for clarity.

### Challenges Addressed

- **Ambiguous Grouping**: Solved using CTEs to simplify the final query.
- **ONLY_FULL_GROUP_BY Error**: Avoided by ensuring proper grouping of non-aggregated columns.
- **Null Handling**: Prevented errors using `IFNULL()` in calculations.
- **Unclear Labels**: Resolved with user-friendly aliases in the output.


## Assessment_Q2

### Objective:
Classify customers into frequency bands based on transaction behavior.

### Logic:
- Calculated monthly frequency per user.
- Grouped into categories:
  - `High Frequency`: ≥10 tx/month
  - `Medium Frequency`: 3–9 tx/month
  - `Low Frequency`: <3 tx/month

### Notes:
- Used `FIELD()` in `ORDER BY` to control custom category sorting.
---

## Assessment_Q3

### Objective:
Identify customer inactivity based on their transaction history.

### Logic:
- Selected transactions grouped by plan.
- Computed `inactivity_days` using `DATEDIFF(CURDATE(), transaction_date)`.
- Filtered where `transaction_status = 'success'`.

### Notes:
- Modified GROUP BY to include all non-aggregated columns (MySQL strict mode fix).
---

## Assessment_Q4

### Objective:
Calculate Customer Lifetime Value (CLV) estimates based on savings transactions.

### Key Metrics:
- **Tenure Month**: Number of months since user joined.
- **Total Transactions**: Count of successful confirmed savings.
- **Estimated CLV**: (Monthly average transactions × 12) × average transaction value (scaled).

### Notes:
- Used `NULLIF` to avoid division by zero.
- Replaced AVG with `SUM(...) / COUNT(...)` for accurate grouping.
- Ordered by CLV in descending order.

---

## Challenges Encountered
- `only_full_group_by` mode in MySQL required careful GROUP BY handling.
- AVG/ROUND conflicts when used in GROUP BY context — resolved via SUM/COUNT.
- Alias references in GROUP BY not allowed — used raw expressions.
---

