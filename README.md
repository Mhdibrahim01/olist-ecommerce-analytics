# 📊 Olist E-Commerce Analytics: Strategic SQL Audit

## 📌 Project Overview
This repository contains a comprehensive SQL-based business intelligence audit of the **Olist E-Commerce dataset** (100k+ Brazilian orders). The project moves beyond basic querying to provide a deep-dive analysis of revenue growth, logistics efficiency, and customer lifetime value (LTV).

## 🚀 Key Business Questions Answered
* **Growth:** How has our revenue scaled month-over-month since launch?
* **Efficiency:** Where are the bottlenecks in our Brazilian logistics network?
* **Loyalty:** Who are our "Whales" and how do we segment our customer base?
* **Supply:** How dependent is our revenue on a small group of "Super Sellers"?

## 🛠️ Technical Stack
* **Language:** PostgreSQL
* **Techniques:** * **Advanced Window Functions:** `NTILE()`, `LAG()`, `DENSE_RANK()`, `SUM() OVER()`
    * **Complex CTEs:** Multi-layered logic for growth and segmentation.
    * **Data Transformation:** `STRING_AGG()`, `COALESCE()`, `DATE_PART()`, `TO_CHAR()`.
    * **Business Logic:** RFM Modeling and MoM growth velocity.

---

## 📂 Project Structure: The "Big 8" Queries

| File | Analysis Phase | Strategic Value |
| :--- | :--- | :--- |
| [01_top_categories.sql](./01_top_categories.sql) | **Product** | Identifies Health & Beauty as the #1 revenue driver (~$1.2M). |
| [02_annual_running_total.sql](./02_annual_running_total.sql) | **Sales** | Tracks the 2017 growth journey from $112k to $6M cumulative. |
| [03_logistics_performance.sql](./03_logistics_performance.sql) | **Operations** | Maps the 12-day "Logistics Gap" between São Paulo and remote states. |
| [04_seller_concentration.sql](./04_seller_concentration.sql) | **Supply Chain** | Highlights that 13% of revenue depends on a core group of 10 sellers. |
| [05_statistical_rfm.sql](./05_statistical_rfm.sql) | **Marketing** | Statistically segments users into Champions vs. At-Risk via NTILE. |
| [06_high_value_whales.sql](./06_high_value_whales.sql) | **Deep Dive** | Investigates the top 20 spenders (identifying $13k single-order leads). |
| [07_mom_growth_velocity.sql](./07_mom_growth_velocity.sql) | **Growth** | Calculates MoM revenue/AOV growth using `LAG()` functions. |
| [08_loyalty_tier_audit.sql](./08_loyalty_tier_audit.sql) | **Retention** | Rule-based VIP vs. One-time segmentation and Lifetime Value. |

---

## 📈 Executive Summary of Insights

### 1. The "Plateau" Warning
The **MoM Growth Analysis (Script 7)** reveals that while 2017 saw triple-digit growth, 2018 shows a stabilizing trend (0-15%). The business has moved from "Blitzscaling" to a "Mature" phase, requiring a shift in focus from new acquisition to margin optimization.

### 2. The Logistics "Standard"
Delivery performance is highly localized. **São Paulo** serves as the operational benchmark (8.7 days), while northern states face a "Geography Penalty" exceeding 20 days. Improving the logistics network in these lagging states could increase overall CSAT by an estimated 15%.

### 3. The 97% Retention Gap
Across both **RFM and Loyalty Tier audits (Scripts 5 & 8)**, the data reveals a critical bottleneck: **97% of customers are one-time buyers.** Olist acts as a "Discovery Engine," but lacks a "Retention Loop." 

### 4. High-Ticket Concentration
The **"Whale" Analysis (Script 6)** shows that our top spenders aren't just frequent shoppers—they are primarily one-time buyers of high-end tech and computers. This suggests a B2B or high-end consumer segment that could be targeted with specific financing or insurance products.

---

## 💡 Strategic Recommendations
1. **The "Second Order" Incentive:** Convert *Potential Loyalists* (2 orders) into *Champions* (3+ orders) by offering high-value discount codes within 30 days of the first delivery.
2. **Seller Diversification:** Reduce platform risk by incentivizing high-performing sellers in São Paulo to utilize regional distribution centers.
3. **Logistics Transparency:** Implement "Arrival Predictions" for northern states to manage customer expectations and reduce the negative impact of long delivery windows on review scores.
