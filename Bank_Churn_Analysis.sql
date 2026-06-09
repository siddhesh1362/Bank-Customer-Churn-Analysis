-- TOTAL CUSTOMERS
SELECT COUNT(*) AS total_customers
FROM bank_churn;

-- Total churned customers
SELECT COUNT(*) AS churned_customers
FROM bank_churn
WHERE Exited = 1;

-- Overall churn rate 
SELECT
    COUNT(*) AS total_customer,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited)/COUNT(*),2) AS churn_rate_percentage
FROM bank_churn;

-- KEY PERFORMANCE INDICATORS
SELECT
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    COUNT(*) - SUM(Exited) AS retained_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent,
    ROUND(AVG(Balance), 2) AS avg_balance,
    ROUND(AVG(EstimatedSalary), 2) AS avg_salary
FROM bank_churn;
 
-- Churn vs retained customers
SELECT
      Exited,COUNT(*) AS total_customers
FROM bank_churn
GROUP BY Exited;    

-- CHURN RATE BY GEOGRAPHY
SELECT
      Geography,
      COUNT(*) AS total_customers,
      SUM(Exited) AS total_churned_customers,
      ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY Geography
ORDER BY churn_rate_percent DESC;

-- CHURN RATE BY GENDER

SELECT 
	  Gender,
      COUNT(*) AS total_customers,
      SUM(Exited) AS churned_customers,
      ROUND(100.0 * SUM(Exited) / COUNT(*),2) AS churn_rate_percentage
FROM bank_churn
GROUP BY Gender
ORDER BY churn_rate_percentage DESC;      
      
 -- AVERRAGE CHURN BY AGE
SELECT
      Exited,
      ROUND(AVG(Age),2) as average_age
 FROM bank_churn
 GROUP BY Exited;
 
 -- CHURN RATE BY ACTIVE MEMBERSHIP
 SELECT
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY IsActiveMember
ORDER BY churn_rate_percent DESC;

-- CHURN RATE BY AGE BAND
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+'
    END AS age_band,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+'
    END
ORDER BY churn_rate_percent DESC;

-- CHURN RATE BY NO OF PRODUCTS

SELECT
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- HIGH VALUE CUSTOMERS WHO CHURNED
SELECT
    CustomerId,
    Surname,
    Geography,
    Gender,
    Age,
    Balance,
    NumOfProducts,
    EstimatedSalary
FROM bank_churn
WHERE Exited = 1
ORDER BY Balance DESC, EstimatedSalary DESC
LIMIT 20;

-- TOP RISKY SEGMENT
SELECT
    Geography,
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+'
    END AS age_band,
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY
    Geography,
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+'
    END,
    NumOfProducts
HAVING COUNT(*) >= 50
ORDER BY churn_rate_percent DESC;

-- Business recommendation

SELECT
    Geography,
    NumOfProducts,
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM bank_churn
GROUP BY Geography, NumOfProducts, IsActiveMember
HAVING COUNT(*) >= 30
ORDER BY churn_rate_percent DESC;

-- VIEW 

CREATE VIEW churn_analysis_view AS
SELECT
    CustomerId,
    Surname,
    Geography,
    Gender,
    Age,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+'
    END AS age_band,
    CreditScore,
    CASE
        WHEN CreditScore < 500 THEN 'Poor'
        WHEN CreditScore BETWEEN 500 AND 649 THEN 'Fair'
        WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good'
        ELSE 'Excellent'
    END AS credit_band,
    Tenure,
    Balance,
    NumOfProducts,
    HasCrCard,
    IsActiveMember,
    EstimatedSalary,
    Exited
FROM bank_churn;