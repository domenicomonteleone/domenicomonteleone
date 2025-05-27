# 📦 Retail Demand Forecasting – Capstone Project

Welcome!  
This is my capstone project for **Google's Data Analytics Professional Certificate**.  
Presented in the final course, it applies the entire data analysis process to a real-world case study using the **6-Phase Analysis Methodology**:  
**Ask → Prepare → Process → Analyze → Share → Act**.

---

## 📌 Objective

To identify demand patterns and forecasting opportunities from historical sales data using data cleaning, analysis, and visualization techniques.

---

## 📁 Project Structure

- `data/` → Raw and cleaned datasets  
- `analysis/` → R scripts for data cleaning and exploration  
- `reports/` → Final report (PDF or HTML from R Markdown)  
- `images/` → Screenshots of dashboards/visualizations  
- `README.md` → Project documentation

---

## 🧰 Tools Used

- **R & RStudio**  
- **ggplot2, dplyr, lubridate** (packages)  
- **R Markdown** for reporting  
- **Tableau Public**  
- **Excel** (initial exploration)

---

## 🔧 Steps Followed

### ✅ Ask – Defining the Business Task  
The goal is to analyze historical product demand to uncover trends, seasonality, and patterns to help the company:  
- Understand how demand varies over time, by product and warehouse  
- Improve inventory management and order fulfillment  
- Support production planning and resource allocation  
- Forecast demand to reduce excess stock and stockouts  

**Key Stakeholders**:  
Supply chain managers, inventory planners, and business strategists.

---

### ✅ Prepare – Collecting and Understanding the Data  
Dataset: [Historical Product Demand](https://www.kaggle.com/datasets/felixzhao/productdemandforecasting/code) from Kaggle.

**Features include**:  
- `Product_Code` – Unique product ID  
- `Warehouse` – Fulfillment location  
- `Product_Category` – Product group  
- `Order_Demand` – Units ordered
- `Date` – Order date  

**Initial checks**:  
Missing values, data types, formatting issues.

---

### ✅ Process – Cleaning and Preparing the Data  
Steps taken in R:
- Standardized column names  
- Removed NAs and malformed values  
- Parsed `Order_Demand` into numeric, handling parentheses  
- Converted `Date` to proper format  
- Extracted `Month` from `Date`  
- Filtered dataset for valid, complete records  

Packages used: `dplyr`, `lubridate`, `base R`.

---

### ✅ Analyze – Identifying Patterns and Trends  
Analytical tasks:
1. **Aggregated Monthly Demand** – Trend over time  
2. **Demand by Warehouse & Category** – Performance breakdown  
3. **Seasonality Analysis** – Recurring monthly patterns  
4. **3-6 Months Moving Average Forecast** – Simple time series prediction  
5. **Top 5 Products** – Most requested items  
6. **Annual Demand by Warehouse & Product Category** – Interactive table  

**Tools**: `ggplot2` for static plots, Tableau for interactive visualizations.

---

### ✅ Share – Communicating the Results  
Results shared in different formats:
- 📄 **R Markdown HTML Report** – Full analysis and visuals  
- 📊 **Tableau Dashboard** – Interactive exploration by month, category, warehouse  
- 💻 **GitHub Repository** – Code and documentation

🔗 [GitHub Repository](#)  
🔗 [Tableau Dashboard](#)

---

### ✅ Act – Recommendations and Next Steps  

### 🔚 Final Conclusions

The comparison between the actual demand and the moving averages reveals important insights for forecasting strategy.

- The **3-month moving average** offers a more responsive view of recent demand changes, making it suitable for **short-term forecasting and tactical decisions**. However, its sensitivity can introduce more volatility and may lead to overreaction to outliers or temporary fluctuations.

- In contrast, the **6-month moving average** provides a **smoother and more stable trend**, helping to identify longer-term patterns. This makes it ideal for **strategic planning**, but less suitable for environments where quick adaptation is required.

In conclusion, a **combined approach**—using short-term and long-term moving averages together—can help balance **reactivity and stability**, supporting more informed decision-making. By understanding the strengths and limitations of each method, organizations can tailor their forecasting models to better align with their operational and strategic needs.


#### 🏢 Business Applications
- Align inventory levels with seasonal demand  
- Customize warehouse operations by location  
- Support marketing and staffing with seasonal insight  

#### 🚀 Next Steps
- Explore advanced models (e.g., **ARIMA**, **Prophet**)  
- Build dynamic dashboards for continuous monitoring  
- Automate data refresh and forecast generation  
- Integrate external variables: prices, promotions, lead times

#### 📊 Data Opportunities
Future enhancements could include:
- Revenue and pricing data  
- Inventory and delivery performance  
- Promotion calendars  
- Customer feedback and return reasons

---

