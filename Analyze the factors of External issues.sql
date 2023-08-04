-- Analyze the factors of External issues
-- Analyze the percentage of the total number of failed transactions were the transactions that occurred before the customer’s first successful Top-up time.**
WITH topup_transaction_table AS (
    SELECT customer_id, transaction_time, fact_2020.status_id
        , COUNT (transaction_id) OVER () AS nb_total_trans
    , FIRST_VALUE (fact_2020.status_id) OVER (PARTITION BY customer_id ORDER BY transaction_time) AS first_status_id
    , MAX (fact_2020.status_id) OVER (PARTITION BY customer_id) AS max_status_id
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_scenario AS scena
    ON fact_2020.scenario_id= scena.scenario_id
    LEFT JOIN dbo.dim_status AS sta
    ON fact_2020.status_id = sta.status_id
    WHERE transaction_type = 'Top-up account'
)
, rank_of_successful_transactions_table AS(
    SELECT *
            , CASE WHEN status_id = 1 THEN RANK () OVER (PARTITION BY customer_id ORDER BY transaction_time) END AS rank
    FROM topup_transaction_table
    WHERE first_status_id != 1 AND max_status_id = 1
) 
,  processing_table AS (
    SELECT customer_id
        , MIN (rank -1) OVER (PARTITION BY customer_id ORDER BY rank) AS nb_failed_transaction_before_first_successul_transaction1 -- This line is only used for processing
        , nb_total_trans
    FROM rank_of_successful_transactions_table
    WHERE rank >1
) 
, nb_failed_transaction_before_first_successul_transaction_table AS (
    SELECT DISTINCT customer_id 
        , MIN (nb_failed_transaction_before_first_successul_transaction1) OVER (PARTITION BY customer_id ORDER BY nb_failed_transaction_before_first_successul_transaction1) AS nb_failed_transaction_before_first_successul_transaction
        , nb_total_trans
    FROM processing_table
) 
SELECT DISTINCT SUM (nb_failed_transaction_before_first_successul_transaction) OVER () AS total_nb_failed_transaction_before_first_successul_transaction
    , nb_total_trans
    , FORMAT (SUM (nb_failed_transaction_before_first_successul_transaction) OVER () *1.0/ nb_total_trans , 'p') AS pct
FROM nb_failed_transaction_before_first_successul_transaction_table

-- Analyze the percentage of error reasons coming from customers in the total error messages
My code: 
WITH new_table AS (
    SELECT customer_id, transaction_id, fact_2020.status_id, status_description
    , COUNT (transaction_id) OVER () AS total_nb_transactions
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_status AS sta
    ON fact_2020.status_id = sta.status_id
    WHERE fact_2020.status_id NOT IN ('1','-9','-11','-13','-15')
) 
SELECT DISTINCT status_description
, COUNT (transaction_id) OVER (PARTITION BY status_description) AS nb_transactions_per_error
, total_nb_transactions
, FORMAT (COUNT (transaction_id) OVER (PARTITION BY status_description) *1.0/ total_nb_transactions, 'p') AS pct
FROM new_table;

-- Analyze the impact of promotion on success rate result
WITH new_table AS (
    SELECT customer_id, transaction_id, fact_2020.status_id, promotion_id
    , COUNT (transaction_id) OVER () AS total_nb_transactions
    , COUNT (transaction_id) OVER (PARTITION BY fact_2020.status_id, promotion_id) AS nb_transactions_per_status_id
    FROM dbo.fact_transaction_2020 AS fact_2020 
    LEFT JOIN dbo.dim_status AS sta
    ON fact_2020.status_id = sta.status_id
) 
, new_table2 AS (
SELECT DISTINCT status_id
    , promotion_id
    , nb_transactions_per_status_id
    , total_nb_transactions
    FROM new_table
--    ORDER BY status_id, promotion_id
) 
SELECT DISTINCT SUM (CASE WHEN status_id != 1 AND promotion_id = '0' THEN nb_transactions_per_status_id END) OVER () AS nb_failed_transactions_without_promotion
, SUM (CASE WHEN status_id != 1 AND promotion_id != '0' THEN nb_transactions_per_status_id END) oVER () AS nb_failed_transactions_with_promotion
, total_nb_transactions
, FORMAT (SUM (CASE WHEN status_id != 1 AND promotion_id = '0' THEN nb_transactions_per_status_id END) OVER () *1.0/ total_nb_transactions, 'p') AS pct_failed_transactions_without_promotion
, FORMAT (SUM (CASE WHEN status_id != 1 AND promotion_id != '0' THEN nb_transactions_per_status_id END) OVER () *1.0/ total_nb_transactions, 'p') AS pct_failed_transactions_with_promotion