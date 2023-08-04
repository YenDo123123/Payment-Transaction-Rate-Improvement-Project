-- Analyze the factors of Internal issues
-- Analyze the difference in success rate and volume ratio between scenario IDs.
WITH new_table AS (
    SELECT customer_id, transaction_id, fact_2020.scenario_id, transaction_type, status_id
        , COUNT (transaction_id) OVER () AS nb_total_trans
        , COUNT (CASE WHEN status_id = 1 THEN transaction_id END) OVER () AS nb_total_succ_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    WHERE transaction_type = 'Top-up account' 
)
SELECT DISTINCT scenario_id
    , COUNT (scenario_id) OVER (PARTITION BY scenario_id) AS nb_trans
    , COUNT (CASE WHEN status_id = 1 THEN scenario_id END) OVER (PARTITION BY scenario_id) AS nb_success_trans
    , FORMAT (COUNT (scenario_id) OVER (PARTITION BY scenario_id) * 1.00 / nb_total_trans, 'p') AS volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN scenario_id END) OVER (PARTITION BY scenario_id) *1.0 
    /
     COUNT (scenario_id) OVER (PARTITION BY scenario_id), 'p') AS success_rate 
FROM new_table; 
-- Analyze the difference in success rate and volume ratio between payment platforms 
WITH new_table AS (
    SELECT customer_id, transaction_id, transaction_time, payment_platform, status_id
        , COUNT (transaction_id) OVER () AS nb_total_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_platform AS platform
    ON fact_2020.platform_id = platform.platform_id
    WHERE transaction_type = 'Top-up account'
)
SELECT DISTINCT payment_platform
    , COUNT (payment_platform) OVER (PARTITION BY payment_platform) AS nb_trans
    , COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform) AS nb_success_trans
    , FORMAT (COUNT (payment_platform) OVER (PARTITION BY payment_platform) * 1.0 
    /
    nb_total_trans, 'p') AS volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform) *1.0 
    /
    COUNT (payment_platform) OVER (PARTITION BY payment_platform), 'p') AS success_rate 
FROM new_table; 
--Analyze the difference in success rate and volume ratio between payment platforms over time (by month)
WITH new_table AS (
    SELECT customer_id, transaction_id, transaction_time, payment_platform, status_id
        , MONTH (transaction_time) AS [month]
        , COUNT (transaction_id) OVER (PARTITION BY MONTH (transaction_time) ORDER BY MONTH (transaction_time)) AS monthly_nb_total_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_platform AS platform
    ON fact_2020.platform_id = platform.platform_id
    WHERE transaction_type = 'Top-up account'
)
SELECT DISTINCT payment_platform
    , [month]
    , COUNT (payment_platform) OVER (PARTITION BY payment_platform, [month]) AS monthly_nb_trans
    , COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform, [month]) AS monthly_nb_success_trans
    , FORMAT (COUNT (payment_platform) OVER (PARTITION BY payment_platform, [month]) * 1.0 / monthly_nb_total_trans, 'p') AS monthly_volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform, monthly_nb_total_trans) *1.0 
    /
    COUNT (payment_platform) OVER (PARTITION BY payment_platform, monthly_nb_total_trans), 'p') AS monthly_success_rate 
FROM new_table;

-- Analyze the difference in success rate and volume ratio between payment channels**
WITH new_table AS (
    SELECT customer_id, transaction_id, transaction_time, fact_2020.payment_channel_id, payment_method, status_id
        , COUNT (transaction_id) OVER () AS nb_total_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_payment_channel AS payment_channel
    ON fact_2020.payment_channel_id = payment_channel.payment_channel_id
    WHERE transaction_type = 'Top-up account'
)
SELECT DISTINCT payment_method
    , COUNT (payment_method) OVER (PARTITION BY payment_method) AS nb_trans
    , COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method) AS nb_success_trans
    , FORMAT (COUNT (payment_method) OVER (PARTITION BY payment_method) * 1.0 / nb_total_trans, 'p') AS volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method) *1.0 
    /
    COUNT (payment_method) OVER (PARTITION BY payment_method), 'p') AS success_rate 
FROM new_table

-- Analyze the difference in success rate and volume ratio between payment channels over time (by month)
WITH new_table AS (
    SELECT customer_id, transaction_id, transaction_time, fact_2020.payment_channel_id, payment_method, status_id
        , MONTH (transaction_time) AS [month]
        , COUNT (transaction_id) OVER (PARTITION BY MONTH (transaction_time) ORDER BY MONTH (transaction_time)) AS monthly_nb_total_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_payment_channel AS payment_channel
    ON fact_2020.payment_channel_id = payment_channel.payment_channel_id
    WHERE transaction_type = 'Top-up account'
)
SELECT DISTINCT payment_method
    , [month]
    , COUNT (payment_method) OVER (PARTITION BY payment_method, [month]) AS monthly_nb_trans
    , COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method, [month]) AS monthly_nb_success_trans
    , FORMAT (COUNT (payment_method) OVER (PARTITION BY payment_method, [month]) * 1.0 / monthly_nb_total_trans, 'p') AS monthly_volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method, [month]) *1.0 
    /
    COUNT (payment_method) OVER (PARTITION BY payment_method, [month]), 'p') AS monthly_success_rate 
FROM new_table

-- Analyze the main errors of failed transactions.
WITH new_table AS (
    SELECT customer_id, transaction_id, transaction_time, fact_2020.status_id, status_description
        , MONTH (transaction_time) AS [month]
        , COUNT (transaction_id) OVER (PARTITION BY MONTH (transaction_time) ORDER BY MONTH (transaction_time)) AS monthly_nb_total_trans
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_status AS sta
    ON fact_2020.status_id = sta.status_id
    WHERE transaction_type = 'Top-up account'
)
SELECT DISTINCT status_id, status_description
    , [month]
    , COUNT (status_id) OVER (PARTITION BY status_id, [month]) AS monthly_nb_trans
    , FORMAT (COUNT (status_id) OVER (PARTITION BY status_id, [month]) * 1.0 / monthly_nb_total_trans, 'p') AS monthly_volume_ratio
FROM new_table
WHERE status_id != 1
ORDER BY [month]