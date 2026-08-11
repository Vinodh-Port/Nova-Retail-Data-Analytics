# Nova-Retail-Data-Analytics

An end-to-end data analytics and business intelligence project automating an enterprise retail chain's operational data pipeline. This repository demonstrates how raw retail transactional records are ingested via an ETL process, modeled in a relational database ecosystem, and transformed into an interactive multi-page management dashboard using advanced DAX metrics.

---

## 📊 Dashboard Insights & Core Metrics

The data pipeline extracts critical operational, regional, and customer behavioral insights from the **Nova - Retail** dataset across three primary analytical views:

### 1. High-Level Performance Indicators (Executive Overview KPIs)
* **Total Revenue Generated:** ₹383.11M
* **Total Order Volume:** 75.12K orders
* **Average Order Value (AOV):** ₹5.10K
* **Year-over-Year Growth (YoY %):** 0.97%
* **Total Customer Base:** 38.78K unique customers

### 2. Revenue Distribution & Product Engineering
* **Quarterly Revenue Breakdown:**
  * **Q4:** Generates **₹98M (25.63%)** of total revenue.
  * **Q3:** Generates **₹96M (25.10%)** of total revenue.
  * **Q2:** Generates **₹95M (24.81%)** of total revenue.
  * **Q1:** Generates **₹94M (24.46%)** of total revenue.
* **Top Revenue-Generating Product Categories:**
  * Highly dominated by **Footwear (₹13.9M)** and **Books & Stationery (₹13.8M)**, closely followed by **Pet Supplies (₹13.7M)**, **Bedding & Bath (₹13.5M)**, and **Cameras & Accessories (₹13.5M)**.
* **Average Order Value (AOV) Leaders by Product:**
  * **Footwear (₹182)** and **Pet Supplies (₹181)** maintain the highest average order value per unit, closely followed by **Women's Clothing (₹180)** and **Cameras & Accessories (₹180)**.

### 3. Customer Intelligence & Behavioral Segmentation
* **Customer Base Breakdown:**
  * **Repeat Customers:** Represents **49.17K** repeat buyers driving sustained revenue.
  * **One-Time Customers:** Represents **718** single-purchase visitors.
  * *Business Insight: A heavily weighted repeat customer cohort indicates high brand loyalty and strong retention across core retail product lines.*
* **Top High-Value VIP Patrons (by Revenue & Volume):**
  * **Customer ID 33455:** Total Revenue **₹116,965** across **17 orders** (AOV ₹6,880.29).
  * **Customer ID 42816:** Total Revenue **₹112,004** across **15 orders** (AOV ₹7,466.93).
  * **Customer ID 8141:** Total Revenue **₹110,784** across **16 orders** (AOV ₹6,924.00).

### 4. Operational, Regional & Fulfillment Performance
* **Fulfillment & Logistics Status Ratios:**
  * **Orders Shipped Rate:** **33.428%**
  * **Orders Success Rate:** **33.287%**
  * **Orders Failed Rate:** **33.285%**
  * **Total Orders Returned:** **30K orders**
* **Regional Sales & Volume Distribution (by Customer City):**
  * **Mumbai:** Leads both Revenue at **₹389M (25.40%)** and Order Volume at **76K (25.35%)**.
  * **Pune:** Generates **₹382M (24.98%)** revenue across **75K (25.03%)** orders.
  * **Bangalore:** Generates **₹380M (24.84%)** revenue across **75K (24.93%)** orders.
  * **Delhi:** Generates **₹379M (24.78%)** revenue across **74K (24.70%)** orders.
* **Store Operations & Payroll Analysis:**
  * Tracks **100 physical stores** managed by **1K total employees**.
  * Store salary expenditures are led by **Store 74 (₹1.21M)** and **Store 22 (₹0.95M)**.

---

## 🛠️ Tech Stack & Analytical Ecosystem

* **Relational Database Server:** Microsoft SQL Server (SSMS) for structuring, cleaning data integrity gaps, and testing optimization constraints.
* **Business Intelligence Tool:** Power BI Desktop for star-schema relational data modeling, DAX measures, and dynamic interactive reporting across 3 custom pages.
* **Data Extraction & Ingestion (ETL):** Automated processing pipelines handling transactional retail data across relational tables (`Orders`, `Customers`, `Products`, `Stores`, `Employees`, `Calendar`).
