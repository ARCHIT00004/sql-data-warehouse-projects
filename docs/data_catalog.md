# Gold Layer Data Catalog

## Overview

The Gold Layer represents the final presentation layer of the data warehouse. It is designed using a Star Schema and contains business-ready dimension and fact views optimized for reporting, dashboards, and analytical queries.

The Gold Layer in this project includes:

- Customer Dimension (`gold.dim_customers`)
- Product Dimension (`gold.dim_products`)
- Sales Fact (`gold.fact_sales`)

---

# Customer Dimension (`gold.dim_customers`)

### Description

This dimension stores customer information by combining CRM and ERP data to provide a complete customer profile.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | System-generated surrogate key for each customer. |
| customer_id | INT | Original customer identifier from the CRM system. |
| customer_number | NVARCHAR(50) | Business customer reference number. |
| first_name | NVARCHAR(50) | Customer's given name. |
| last_name | NVARCHAR(50) | Customer's family name. |
| country | NVARCHAR(50) | Country associated with the customer. |
| marital_status | NVARCHAR(20) | Customer's marital status. |
| gender | NVARCHAR(20) | Gender obtained from CRM, with ERP used as a fallback source. |
| birthdate | DATE | Customer's birth date. |
| create_date | DATE | Date the customer record was created. |

---

# Product Dimension (`gold.dim_products`)

### Description

This dimension contains product information enriched with category and maintenance attributes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | System-generated surrogate key for each product. |
| product_id | INT | Original product identifier from CRM. |
| product_number | NVARCHAR(50) | Business product code. |
| product_name | NVARCHAR(100) | Name of the product. |
| category_id | NVARCHAR(50) | Identifier of the product category. |
| category | NVARCHAR(50) | High-level product category. |
| subcategory | NVARCHAR(50) | Detailed product classification. |
| maintenance | NVARCHAR(20) | Indicates whether maintenance is required. |
| cost | DECIMAL(10,2) | Standard product cost. |
| product_line | NVARCHAR(50) | Product line or series. |
| start_date | DATE | Date when the product became active. |

---

# Sales Fact (`gold.fact_sales`)

### Description

This fact view stores sales transactions and connects customer and product dimensions through surrogate keys.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | NVARCHAR(50) | Unique sales order identifier. |
| product_key | INT | Foreign key referencing the Product Dimension. |
| customer_key | INT | Foreign key referencing the Customer Dimension. |
| order_date | DATE | Date on which the order was placed. |
| shipping_date | DATE | Date on which the order was shipped. |
| due_date | DATE | Expected payment due date. |
| sales_amount | DECIMAL(10,2) | Total sales amount for the transaction. |
| quantity | INT | Number of units sold. |
| price | DECIMAL(10,2) | Selling price per unit. |

---

# Data Model

```
                +-----------------------+
                |   dim_customers       |
                +-----------------------+
                         |
                  customer_key
                         |
                         |
+--------------------+   |   +--------------------+
|    dim_products    |---+---|     fact_sales     |
+--------------------+       +--------------------+
       product_key
```

---

# Gold Layer Summary

| View | Business Purpose |
|------|------------------|
| **gold.dim_customers** | Maintains customer information enriched from multiple source systems. |
| **gold.dim_products** | Stores product and category details for analytical reporting. |
| **gold.fact_sales** | Captures sales transactions linked to customer and product dimensions for business analysis. |
