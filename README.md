# **[Success-Rate-Analysis-Project](url)**

## **Introduction**
This is an analysis of payment transactions from 2019 to 2020 of Paytm Wallet of Paytm company. 
- PayTM is an Indian multinational financial technology company specializing specializes in digital payment systems, e-commerce and financial services.
- Paytm wallet is a secure and RBI (Reserve Bank of India)-approved digital/mobile wallet that provides a myriad of financial features to fulfill every consumer’s payment needs. Paytm wallet can be topped up through UPI (Unified Payments Interface), internet banking, or credit/debit cards. Users can also transfer money from a Paytm wallet to the recipient's bank account or their own Paytm wallet. 

I analyzed data from 5 tables: 
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
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/9ade2c40-7ef4-45fb-8ddd-e2362b9ee3f3">

### **Analyze the difference in success rate and volume ratio between payment platforms.** 
**Analyze the difference in success rate and volume ratio between payment platforms**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/e8d3fab1-4bdc-4319-b1de-7333002af1a3">

**Analyze the difference in success rate and volume ratio between payment platforms over time (by month)**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/e72fd34f-d0e2-42ef-8e21-e76fe7cd98e0">

### **Analyze the difference in success rate and volume ratio between payment channels.** 
**Analyze the difference in success rate and volume ratio between payment channels**

<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/f337c78e-68d1-4d7f-ae04-303a811255f5">

**Analyze the difference in success rate and volume ratio between payment channels over time (by month)**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/c125b2fb-5a9b-4bef-acb6-358d1170bf24">

### **Analyze the main errors of failed transactions.** 
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/fe78bcd6-fd7c-4b2e-8f68-b603aa2549c6">

## **Analyze the factors of External issues **
### **Analyze the percentage of the total number of failed transactions were the transactions that occurred before the customer’s first successful Top-up time.**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/e1b13984-c0d6-433e-ba9c-9a843ad0c45d">

### **Analyze the percentage of error reasons coming from customers in the total error messages.**

<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/f384e43f-6bb3-47fe-8239-76b91c45efb0">

### **Analyze the impact of promotion on success rate result.**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/1224b599-6495-4ce2-a9dc-3f5b71ddcfcb">


## **Analyse and Recommendation**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/271e4840-cc0f-4202-8220-8b3eb3e45d1c">

<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/958e1e65-e5d8-439e-9e44-84e1a7542d54">

