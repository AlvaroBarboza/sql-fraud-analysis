# 🛡️ SQL Pipeline: Fraud Analysis & SLA Prioritization

## 📌 The Business Problem
In a high-volume e-commerce operation, document verification queues can become a critical bottleneck. Analysts need to prioritize documents not just by the oldest date (SLA), but also by the financial risk of the user (e.g., transaction volume and chargeback history).

## 💡 The Solution
This SQL script simulates an ETL pipeline to extract pending document data, calculate SLA days, and prioritize manual review queues using advanced SQL techniques.

## 🛠️ Key Techniques & SQL Skills Applied
- **Date & Time Functions:** To calculate exact SLA days since the document submission.
- **CTEs (Common Table Expressions):** To modularize the query, handle aggregations safely, and improve readability.
- **Window Functions (`RANK() OVER`):** To dynamically rank and prioritize users based on financial risk score and wait time.
- **Conditional Logic (`CASE WHEN`):** To tag users with "High Risk" flags based on historical chargeback events.

## 🚀 Business Impact
By automatically prioritizing high-risk and high-SLA tickets, the operation reduces potential financial losses from fraud while simultaneously improving the approval time for legitimate customers.
