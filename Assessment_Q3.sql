-- Savings accounts with no inflow in the last 365 days
SELECT 
    p.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    DATE(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), s.transaction_date) AS inactivity_days
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE 
    s.transaction_status = 'success'
    AND s.transaction_date IS NOT NULL
    AND DATEDIFF(CURDATE(), s.transaction_date) > 365
    AND p.is_regular_savings = 1

UNION ALL

-- Investment plans with no inflow in the last 365 days, excluding those already captured in savings
SELECT 
    p.id AS plan_id,
    s.owner_id,
    'Investment' AS type,
    DATE(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), s.transaction_date) AS inactivity_days
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE 
    s.transaction_status = 'success'
    AND s.transaction_date IS NOT NULL
    AND DATEDIFF(CURDATE(), s.transaction_date) > 365
    AND p.is_a_fund = 1
    AND p.is_regular_savings = 0;  -- exclude those already counted as savings
