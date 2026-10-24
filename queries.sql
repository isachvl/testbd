-- 1
SELECT *
FROM clients
WHERE city = 'Новосибирск'
  AND registered_at >= DATE '2025-01-01'
  AND registered_at < DATE '2026-01-01'
ORDER BY registered_at, client_id;

-- 2.
SELECT currency, COUNT(*) AS account_count
FROM accounts
WHERE closed_at IS NULL
GROUP BY currency;

-- 3
SELECT c.client_id, c.full_name, COALESCE(SUM(t.amount), 0) AS total_in
FROM clients c
LEFT JOIN accounts a ON a.client_id = c.client_id
LEFT JOIN transactions t ON t.account_id = a.account_id AND t.tx_type = 'in'
GROUP BY c.client_id, c.full_name;

-- 4
SELECT c.*
FROM clients c
WHERE NOT EXISTS (
    SELECT 1 FROM accounts a WHERE a.client_id = c.client_id
);

-- 5
SELECT c.client_id, c.full_name, COUNT(*) AS account_count
FROM clients c
JOIN accounts a ON a.client_id = c.client_id
GROUP BY c.client_id, c.full_name
HAVING COUNT(*) > 2;

-- 6
SELECT account_id, tx_date, amount, COUNT(*) AS duplicate_count
FROM transactions
GROUP BY account_id, tx_date, amount
HAVING COUNT(*) > 1;

-- 7
WITH monthly AS (
    SELECT c.client_id, c.full_name,
           date_trunc('month', t.tx_date) AS month,
           SUM(t.amount) AS total_out
    FROM clients c
    JOIN accounts a ON a.client_id = c.client_id
    JOIN transactions t ON t.account_id = a.account_id
    WHERE t.tx_type = 'out'
    GROUP BY c.client_id, c.full_name, date_trunc('month', t.tx_date)
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY month ORDER BY total_out DESC, client_id
    ) AS place
    FROM monthly
)
SELECT month, client_id, full_name, total_out, place
FROM ranked
WHERE place <= 3
ORDER BY month, place;
