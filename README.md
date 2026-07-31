# 📊 SQL Data Warehouse & Analytics Project

## 📖 Overview

This project demonstrates the complete process of building a modern Data Warehouse using SQL Server. The project follows industry-standard Data Engineering practices to transform raw data into meaningful business insights.

The implementation covers the complete ETL workflow, starting from importing raw data into the Bronze layer, cleaning and transforming the data in the Silver layer, and finally creating analytical data models in the Gold layer.

---

# 🎯 Project Objectives

- Build a SQL Server Data Warehouse from scratch.
- Design a scalable ETL pipeline.
- Clean and transform raw business data.
- Implement Bronze, Silver, and Gold architecture.
- Create analytical data models using Star Schema.
- Generate business-ready datasets for reporting and dashboards.

---

# 🏗️ Architecture

The project follows the Medallion Architecture:

## 🥉 Bronze Layer
- Load raw CSV files into SQL Server.
- Preserve original data without modifications.
- Create staging tables.
- Build load stored procedures.

## 🥈 Silver Layer
- Clean invalid records.
- Remove duplicates.
- Handle NULL values.
- Standardize data types.
- Apply business rules.

## 🥇 Gold Layer
- Create Fact Tables.
- Create Dimension Tables.
- Implement Star Schema.
- Prepare reporting-ready datasets.

---

# 🔄 ETL Workflow

Source Files (CSV)

↓

Bronze Layer (Raw Data)

↓

Silver Layer (Cleaned Data)

↓

Gold Layer (Business Model)

↓

Power BI / Reporting / Analytics

---

# 🛠️ Technologies Used

- SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- Stored Procedures
- CSV Files
- Git & GitHub
- Data Warehouse Concepts

---

# 📂 Project Structure

```
sql-data-warehouse-project/

│

├── datasets/

├── bronze/

├── silver/

├── gold/

├── scripts/

├── stored_procedures/

├── documentation/

└── README.md
```

---

# 📚 Concepts Covered

- Data Warehousing
- ETL Pipeline
- Medallion Architecture
- Data Modeling
- Star Schema
- Fact & Dimension Tables
- Primary & Foreign Keys
- Data Cleaning
- SQL Stored Procedures
- Data Transformation

---

# 🚀 Learning Outcomes

After completing this project, you will understand:

- How to build an end-to-end Data Warehouse.
- How ETL pipelines work in real-world projects.
- How to organize data using Bronze, Silver, and Gold layers.
- How to design analytical data models.
- How to prepare data for BI tools like Power BI.

---

# 📈 Future Enhancements

- Automate ETL using SSIS.
- Schedule jobs using SQL Server Agent.
- Integrate Azure Data Factory.
- Build Power BI dashboards.
- Add data quality monitoring.

---

# 👨‍💻 Author

**Archit Goyal**

Data Engineering | SQL Server | ETL | Data Warehousing
