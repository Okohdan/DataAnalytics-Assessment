SELECT
    s.owner_id AS `Customer ID`,
    CONCAT(u.first_name, ' ', u.last_name) AS Name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS `Tenure Month`,
    COUNT(s.id) AS `Total Transactions`,
    
    -- Estimated CLV = (Avg Txn per Month) * 12 * Avg Confirmed Amount (scaled)
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12 
        * (SUM(s.confirmed_amount * 0.001) / COUNT(s.id)), 2
    ) AS `Estimated CLV`

FROM users_customuser u
JOIN savings_savingsaccount s 
    ON u.id = s.owner_id 
WHERE 
    s.confirmed_amount > 0
    AND s.transaction_status = 'success'

GROUP BY 
    s.owner_id, 
    CONCAT(u.first_name, ' ', u.last_name),
    u.date_joined

ORDER BY `Estimated CLV` DESC;
