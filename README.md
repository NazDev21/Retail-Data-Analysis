# Customer & Sales Performance Analysis
---
## Project Background
This project analyzes a **synthetic e-commerce dataset** to simulate how a retail organization might evaluate customer purchasing behavior, product performance, sales channel efficiency, and regional shipping operations.

The objective of the analysis is to identify patterns in **revenue generation, product return behavior, and customer lifetime value** that could help retail administrators and business analysts improve operational efficiency and commercial decision-making.

While the dataset is **synthetically generated**, the analytical workflow mirrors the type of analysis commonly performed by data analysts working within retail and e-commerce organizations. The analysis focuses on understanding how customer loyalty, product categories, sales channels, and regional shipping patterns influence revenue outcomes, profit margins, and long-term customer retention.

Retail and e-commerce organizations typically monitor several operational and financial metrics when evaluating performance, including:

* Product revenue and profit margins by category and sales channel
* Customer return rates and return behavior by product and brand
* Regional shipping performance and delivery efficiency
* Customer lifetime value and loyalty tier distribution
* Sales channel and payment method profitability

This project demonstrates how these types of metrics can be analyzed using SQL and data visualization techniques to support data-driven decision making.

### Key Analysis Areas

Insights and recommendations are provided across the following key areas:

- **Revenue Distribution by Product Category and Customer Loyalty Tier**
- **Product and Brand Return Rate Analysis**
- **Regional Shipping Performance by Product Category and Customer Segment**
- **Sales Channel and Payment Method Profit Margin Analysis**
- **Customer Lifetime Value by Signup Cohort and Product Launch Year**

---

### Supporting Resources

SQL queries regarding data cleaning procedures can be found here:
**[SQL Data Cleaning Queries](code/)** 

SQL queries regarding business questions can be found here:
**[SQL Analysis Queries](code/retail_customer_sales_analysis.sql)** 

The raw and clean retail datasets can be found here:
**[Retail Datasets](data/)**

An interactive Power BI dashboard used to explore trends and insights can be found here:
**[Power BI Dashboard](linkhere)**

### Dashboard Preview
![Power BI Dashboard](linkhere)

---

### Data Structure & Initial Checks

The dataset used in this project consists of synthetic e-commerce transactional and customer records designed to simulate operational retail data. After cleaning and preprocessing, the dataset contains **4,982 order records, 1,688 customer profiles, and 20 product listings** with multiple variables related to customer demographics, purchasing behavior, product performance, and sales operations.

### Main Data Structure

The analysis datasets consists of three primary analytical tables derived from retail records.

![ERD](visuals/Final_ERD.png)

### Initial Data Quality Checks

Several preprocessing and validation steps were performed before analysis:

* Removed **42 duplicate records across the three files (18 duplicate order IDs in the orders file, 22 duplicate customer IDs in the customers file, and 2 duplicate product IDs in the products file)**

* Standardized null representations, which appeared in up to **7 inconsistent forms per field (blank, nan, NAN, Nan, NULL, Null, [null], and None),** and confirmed missing value counts across all fields in each file

* Removed records containing negative numeric values, including **279 orders with negative prices, and 24 customers with negative lifetime values**

* Standardized categorical fields affected by inconsistent casing and formatting, including **sales channel, payment method, shipping region, order status, customer segment, loyalty status, preferred channel, customer status, country, state, and city**

* Standardized date fields to a single format, resolving up to **5 competing date formats found in order dates, shipping dates, customer date of birth, and signup dates**

* Removed leading and trailing whitespace from string fields across all three files, affecting hundreds of records in **name, email, address, and categorical columns**

* Identified customers with placeholder or invalid phone numbers **(e.g., 000-000-0000, 9999999999)** and email addresses with inconsistent casing

* Standardized the marketing_opt_in field, which used **4 different representations for a binary yes/no value (Yes, Y, No, N)**

* Verified that **shipping dates occurred after order dates**, and **signup_dates occurred after date_of_birth dates**

These steps ensured the dataset was clean and suitable for exploratory analysis.

---

# Executive Summary

### Overview of Findings

Five key insights emerged from the analysis of customer orders, product performance, and sales operations data:

1. **Apparel is the dominant revenue-generating category across all loyalty tiers**, with Bronze loyalty customers contributing the highest total revenue of $144,786.95 — surpassing Gold and Platinum tiers — suggesting that mid-tier loyalty customers represent a significant and potentially underleveraged revenue segment.
2. **The Hydrating Face Serum by Luma carries the highest actual return rate at 17%**, while the Classic Crew Tee by Modern Harbor accounts for the highest absolute volume of returns at 67 units — indicating that return risk is driven by both product-specific quality concerns and high-volume exposure.
3. **The Beauty category exhibits the most volatile shipping performance across all regions**, recording return rates as high as 40% in the Midwest and 100% in the Northeast among VIP customers — pointing to potential fulfillment or product presentation issues that disproportionately affect high-value customer segments.
4. **Performance Leggings sold Online via Gift Card generate the highest total profit at $20,107.61**, with the Online channel consistently dominating profitability across payment methods — indicating that digital sales paired with prepaid payment instruments yield the strongest margin outcomes.
5. **Customers who signed up in 2023 and purchased products launched in 2023 show the highest average lifetime value of $913.38 among recent cohorts**, while 2025 signups show the lowest lifetime value at $818.25 — suggesting that customers who engage with contemporary product launches at the time of their signup tend to develop stronger long-term spending relationships.

For retail leadership, these findings highlight the importance of monitoring **loyalty tier revenue distribution, product and category return behavior, regional logistics performance by customer segment, sales channel and payment method profitability, and customer cohort lifetime value** to improve operational efficiency and commercial decision-making.

---

# Insights Deep Dive

---

# Recommendations
