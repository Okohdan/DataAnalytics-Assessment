-- Step 1: Calculate per-customer monthly frequency
WITH customer_tx AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_tx,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS months_active
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success' AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),

-- Step 2: Compute average tx per month + category
frequency_classified AS (
    SELECT 
        c.owner_id,
        ROUND(c.total_tx / c.months_active, 2) AS avg_tx_per_month,
        CASE
            WHEN (c.total_tx / c.months_active) >= 10 THEN 'High Frequency'
            WHEN (c.total_tx / c.months_active) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_tx c
)

-- Step 3: Aggregate by frequency category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM frequency_classified
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
