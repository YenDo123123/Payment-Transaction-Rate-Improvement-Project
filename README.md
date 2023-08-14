# **[Payment-Transaction-Rate-Improvement-Project](url)**

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
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/cfb5c351-1e0b-47b8-ad08-7a76607a89bd">

### **Define Problem with the Logic Tree method**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/f1e40ea2-673d-4cb1-9479-68258ac3c3ec">

## **Analyze the factors of Internal issues **
### **Analyze the difference in success rate and volume ratio between scenario IDs.** 
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/21f13e52-2e5e-47d3-9534-f6de984fc279">

### **Analyze the difference in success rate and volume ratio between payment platforms.** 
**Analyze the difference in success rate and volume ratio between payment platforms**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/e3b2667d-a6d8-4e96-9784-dee54223135c">

**Analyze the difference in success rate and volume ratio between payment platforms over time (by month)**
<img width="509" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/66c98ad9-ab6a-470f-a44b-f02ce84bb2d0">

### **Analyze the difference in success rate and volume ratio between payment channels.** 
**Analyze the difference in success rate and volume ratio between payment channels**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/61bb6f5c-3313-428a-9c5b-8ecea15da3f2">

**Analyze the difference in success rate and volume ratio between payment channels over time (by month)**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/06852d6f-23e7-43e0-aeb2-4f57799d48e7">

### **Analyze the main errors of failed transactions.** 
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/9c1e4b83-9b43-4d7f-bac6-1a88af667e60">

## **Analyze the factors of External issues **
### **Analyze the percentage of the total number of failed transactions were the transactions that occurred before the customer’s first successful Top-up time.**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/cf932098-7dc6-4639-ada6-5704f001f888">

### **Analyze the percentage of error reasons coming from customers in the total error messages.**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/2e1297e9-0777-4f32-a67f-0b321b411d12">


### **Analyze the impact of promotion on success rate result.**
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/6926f34d-ff11-49aa-8c75-fd8307dea38c">


## **Analyse and Recommendation**

<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/a2a0b140-0176-43d3-ac1b-e0b6b99f38c2">
<img width="589" alt="image" src="https://github.com/YenDo123123/Success-Rate-Analysis/assets/140786495/f622870a-e501-48e6-81da-f6a7469e61ed">

