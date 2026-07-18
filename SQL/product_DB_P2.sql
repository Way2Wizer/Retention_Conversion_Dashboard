-------------------------------------------------
-- PHASE 2
-------------------------------------------------

-- Step 1: Ensure dates are cast correctly
WITH cleaned_data AS (
    SELECT 
        Customer_Name,
        CAST(Order_Date AS DATE) AS Order_Date
    FROM product_sales_dataset_final
),
-- Step 2: exact first month a customer made a purchase
first_purchase AS (
    SELECT 
        Customer_Name, 
        MIN(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1)) AS cohort_month
    FROM cleaned_data
    GROUP BY Customer_Name
),
-- Step 3: Count total unique customers in each starting cohort
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT Customer_Name) AS total_cohort_size
    FROM first_purchase
    GROUP BY cohort_month
),
-- Step 4: Map out every single month a customer made a purchase
monthly_activity AS (
    SELECT DISTINCT 
        Customer_Name, 
        DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS activity_month
    FROM cleaned_data
),
-- Step 5: Calculate the gap (in months) between first purchase and subsequent activity
retention_counts AS (
    SELECT
        f.cohort_month,
        DATEDIFF(month, f.cohort_month, m.activity_month) AS month_index,
        COUNT(DISTINCT m.Customer_Name) AS active_customers
    FROM first_purchase f
    JOIN monthly_activity m
        ON f.Customer_Name = m.Customer_Name
    GROUP BY 
        f.cohort_month, 
        DATEDIFF(month, f.cohort_month, m.activity_month)
)
-- Step 6: Bring it all together and calculate the final retention percentage
SELECT 
    r.cohort_month,
    c.total_cohort_size,
    r.month_index,
    r.active_customers,
    ROUND(CAST(r.active_customers AS FLOAT) / c.total_cohort_size, 4) AS retention_rate
FROM retention_counts r
JOIN cohort_sizes c 
    ON r.cohort_month = c.cohort_month
ORDER BY 
    r.cohort_month, 
    r.month_index;