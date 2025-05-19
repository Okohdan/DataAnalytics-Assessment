
# SQL Assessment Queries Documentation

This README explains the SQL logic used in the assessment queries. Each section corresponds to one of the provided query files.

---

## Assessment_Q1

### Objective:
Aggregate customer activity across Savings and Investment plans.

### Sections:
- Savings aggregation: `savings_savingsaccount`
- Regular savings investments: `plans_plan` with `is_regular_savings = 1`
- Fund investments: `plans_plan` with `is_a_fund = 1`

### Key Metrics:
- Total count and value per category
- Sum of deposits across all categories
- Joined by `owner_id`
---

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

