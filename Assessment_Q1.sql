-- Pre-aggregate savings
WITH savings AS (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),

-- Pre-aggregate regular savings investments
is_regular_savings_investments AS (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE amount > 0 AND is_regular_savings = 1
    GROUP BY owner_id
),

-- Pre-aggregate fund investments
is_a_fund_investment AS (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
)

-- Final Join
SELECT 
    u.id AS `Owner ID`,
    CONCAT(u.first_name, ' ', u.last_name) AS `Name`,
    i.savings_count AS `Savings Count`,
    IFNULL(ifi.investment_count, 0) AS `Investment Count`,
    FORMAT(
        IFNULL(s.total_savings, 0) + IFNULL(i.total_investments, 0), 
        1
    ) AS `Total Deposits`
FROM users_customuser u
JOIN savings s ON u.id = s.owner_id
JOIN is_regular_savings_investments i ON u.id = i.owner_id
LEFT JOIN is_a_fund_investment ifi ON u.id = ifi.owner_id
ORDER BY `Total Deposits` DESC;
