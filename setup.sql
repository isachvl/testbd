CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY,
    full_name TEXT,
    city TEXT,
    registered_at DATE
);

CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    client_id INTEGER REFERENCES clients(client_id),
    currency TEXT,
    opened_at DATE,
    closed_at DATE
);

CREATE TABLE transactions (
    tx_id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(account_id),
    tx_date TIMESTAMP,
    amount NUMERIC,
    tx_type TEXT CHECK (tx_type IN ('in', 'out'))
);

INSERT INTO clients VALUES
(1, 'Иван Петров', 'Новосибирск', '2025-02-10'),
(2, 'Анна Иванова', 'Томск', '2025-03-15'),
(3, 'Олег Сидоров', 'Новосибирск', '2024-12-20'),
(4, 'Мария Орлова', 'Новосибирск', '2025-09-01');

INSERT INTO accounts VALUES
(1, 1, 'RUB', '2025-02-10', NULL),
(2, 1, 'USD', '2025-02-11', NULL),
(3, 1, 'RUB', '2025-02-12', '2025-06-01'),
(4, 2, 'RUB', '2025-03-15', NULL),
(5, 3, 'RUB', '2025-01-01', NULL);


INSERT INTO transactions VALUES
(1, 1, '2025-03-01 10:00:00', 1000, 'in'),
(2, 1, '2025-03-02 11:00:00', 300, 'out'),
(3, 4, '2025-03-03 12:00:00', 700, 'out'),
(4, 5, '2025-03-04 13:00:00', 200, 'out'),
(5, 1, '2025-04-01 10:00:00', 500, 'out'),
(6, 4, '2025-04-02 12:00:00', 900, 'in'),
(7, 4, '2025-04-02 12:00:00', 900, 'in');
