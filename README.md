# **[Success-Rate-Analysis-Project](url)**

## **Introduction**
This is an analysis of payment transactions from 2019 to 2020 of Paytm Wallet of Paytm company. 
- PayTM is an Indian multinational financial technology company specializing specializes in digital payment systems, e-commerce and financial services.
- Paytm wallet is a secure and RBI (Reserve Bank of India)-approved digital/mobile wallet that provides a myriad of financial features to fulfill every consumer’s payment needs. Paytm wallet can be topped up through UPI (Unified Payments Interface), internet banking, or credit/debit cards. Users can also transfer money from a Paytm wallet to the recipient's bank account or their own Paytm wallet. 

I analyzed data from 5 tables
-	fact_transaction: Store information of all types of transactions: Payments, Top-up, Transfers, Withdrawals
-	dim_scenario: Detailed description of transaction types
-	dim_payment_channel: Detailed description of payment methods
-	dim_platform: Detailed description of payment devices
-	dim_status: Detailed description of the results of the transaction

This is a project that shows my ability to: 
- Use Microsoft SQL Server to conduct data exploration to analyze why the success rate of Top-up transactions is the lowest in 2020 & suggest solutions to improve the success rate.

## **Business Request**
The business request for this data analyst project was to analyze why the success rate of Top-up transactions is the lowest in 2020 & suggest solutions to improve the success rate. This report will be used by Business Owner of Top-up transactions. 

## **Skills and Concepts demonstrated**
- Problem-solving skills with the 5W1H method and Logic Tree method
- SQL
  - CASE Expression
  - JOIN Clause
  - Aggregate functions
  - CTE's, Window functions, FORMAT functions
  - ORDER BY command
  - Comparison operators
 
## **Problem-solving skills with the 5W1H method and Logic Tree Method**
With the support of my mentor (Mr. Hieu Nguyen), below is the result of the Problem-solving session. 

### **Define Problem with the 5W1H method**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/59d6f737-eda0-421f-b3f6-229355bad63a">

### **Define Problem with the Logic Tree method**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/64b8feb5-27d4-49c3-b5f8-ad107c25f1ac">

## **Analyze the factors of Internal issues **

### **Analyze the difference in success rate and volume ratio between scenario IDs.** 
My code:

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
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN scenario_id END) OVER (PARTITION BY scenario_id) *1.0 / COUNT (scenario_id) OVER (PARTITION BY scenario_id), 'p') AS success_rate 
FROM new_table; 

### **Analyze the difference in success rate and volume ratio between payment platforms.** 
**Analyze the difference in success rate and volume ratio between payment platforms**
My code: 
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
    , FORMAT (COUNT (payment_platform) OVER (PARTITION BY payment_platform) * 1.0 / nb_total_trans, 'p') AS volume_ratio
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform) *1.0 / COUNT (payment_platform) OVER (PARTITION BY payment_platform), 'p') AS success_rate 
FROM new_table; 

**Analyze the difference in success rate and volume ratio between payment platforms over time (by month)**
My code: 
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
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_platform END) OVER (PARTITION BY payment_platform, monthly_nb_total_trans) *1.0 / COUNT (payment_platform) OVER (PARTITION BY payment_platform, monthly_nb_total_trans), 'p') AS monthly_success_rate 
FROM new_table

### **Analyze the difference in success rate and volume ratio between payment channels.** 
**Analyze the difference in success rate and volume ratio between payment channels**
My code: 
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
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method) *1.0 / COUNT (payment_method) OVER (PARTITION BY payment_method), 'p') AS success_rate 
FROM new_table
**Analyze the difference in success rate and volume ratio between payment channels over time (by month)**
My code: 
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
    , FORMAT (COUNT (CASE WHEN status_id = 1 THEN payment_method END) OVER (PARTITION BY payment_method, [month]) *1.0 / COUNT (payment_method) OVER (PARTITION BY payment_method, [month]), 'p') AS monthly_success_rate 
FROM new_table

### **Analyze the main errors of failed transactions.** 
My code: 
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

## **Analyze the factors of External issues **
### **Analyze the percentage of the total number of failed transactions were the transactions that occurred before the customer’s first successful Top-up time.**
My code: 
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

### **Analyze the percentage of error reasons coming from customers in the total error messages.**
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
FROM new_table

### **Analyze the impact of promotion on success rate result.**
My code: 
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

## **Analyse and Recommendation**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/271e4840-cc0f-4202-8220-8b3eb3e45d1c">

<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/958e1e65-e5d8-439e-9e44-84e1a7542d54">

