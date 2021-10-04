--Question 1

SELECT *
FROM subscriptions
LIMIT 100;

--looks like two segments, 87 and 30.

--To confirm it, I ran the below query:

SELECT segment
FROM subscriptions
GROUP BY segment;

--Question 2
SELECT MIN(subscription_start) AS 'earliest subscription',
MAX(subscription_start) AS 'latest subscription'
FROM subscriptions;

--Data provided: December 2016, and January, February, March of 2017

SELECT
MIN(subscription_end) AS 'earliest cancel',
MAX(subscription_end) AS 'latest cancel'
FROM subscriptions;

--However December churn rates can't be provided, since the earliest cancel can only start in January.

--Question 3

WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  )
  
SELECT *
FROM months;

--Question 4
WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
  )

SELECT *
FROM cross_join
LIMIT 100;

--Question 5
WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
 ),
status AS (
SELECT id,
  first_day AS month,
  
  --is_active_87
  CASE
   WHEN (subscription_start < first_day)
   AND (
     subscription_end > first_day OR
     subscription_end IS NULL
   )
   AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87,
  
  --is_active_30
 CASE
  WHEN (subscription_start < first_day)
  AND (
    subscription_end > first_day OR
    subscription_end IS NULL
  )
  AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30
  
FROM cross_join
)

SELECT *
FROM status
LIMIT 100;

--Question 6
WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
 ),
status AS (
SELECT id,
  first_day AS month,
  
  --is_active_87
  CASE
   WHEN (subscription_start < first_day)
   AND (
     subscription_end > first_day OR
     subscription_end IS NULL
   )
   AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87,
  
  --is_active_30
 CASE
  WHEN (subscription_start < first_day)
  AND (
    subscription_end > first_day OR
    subscription_end IS NULL
  )
  AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30,
  
  --is_canceled_87
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 87) THEN 1
   ELSE 0
  END AS is_canceled_87,
  
  --is_canceled_30
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 30) THEN 1
   ELSE 0
  END AS is_canceled_30

FROM cross_join
)

SELECT *
FROM status
LIMIT 100;

--Question 7
WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
 ),
status AS (
SELECT id,
  first_day AS month,
  
  --is_active_87
  CASE
   WHEN (subscription_start < first_day)
   AND (
     subscription_end > first_day OR
     subscription_end IS NULL
   )
   AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87,
  
  --is_active_30
 CASE
  WHEN (subscription_start < first_day)
  AND (
    subscription_end > first_day OR
    subscription_end IS NULL
  )
  AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30,
  
  --is_canceled_87
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 87) THEN 1
   ELSE 0
  END AS is_canceled_87,
  
  --is_canceled_30
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 30) THEN 1
   ELSE 0
  END AS is_canceled_30

FROM cross_join
),
status_aggregate AS (
  SELECT month,
  SUM(is_active_87) AS sum_active_87,
  SUM(is_active_30) AS sum_active_30,
  SUM(is_canceled_87) AS sum_canceled_87,
  SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY 1
)

SELECT *
FROM status_aggregate;

--Question 8
WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
 ),
status AS (
SELECT id,
  first_day AS month,
  
  --is_active_87
  CASE
   WHEN (subscription_start < first_day)
   AND (
     subscription_end > first_day OR
     subscription_end IS NULL
   )
   AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87,
  
  --is_active_30
 CASE
  WHEN (subscription_start < first_day)
  AND (
    subscription_end > first_day OR
    subscription_end IS NULL
  )
  AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30,
  
  --is_canceled_87
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 87) THEN 1
   ELSE 0
  END AS is_canceled_87,
  
  --is_canceled_30
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 30) THEN 1
   ELSE 0
  END AS is_canceled_30

FROM cross_join
),
status_aggregate AS (
  SELECT month,
  SUM(is_active_87) AS sum_active_87,
  SUM(is_active_30) AS sum_active_30,
  SUM(is_canceled_87) AS sum_canceled_87,
  SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY 1
)

SELECT month,
ROUND(CAST (sum_canceled_87 AS FLOAT) / sum_active_87*100, 2) AS churn_rate_87,
ROUND (CAST (sum_canceled_30 AS FLOAT) / sum_active_30*100, 2) AS churn_rate_30
FROM status_aggregate
GROUP BY 1;

--additional code to answer the question in the slides

WITH months AS (
  SELECT '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
  
  UNION
  SELECT '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
  
  UNION
  SELECT '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
  ),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
 ),
status AS (
SELECT id,
  first_day AS month,
  
  --is_active_87
  CASE
   WHEN (subscription_start < first_day)
   AND (
     subscription_end > first_day OR
     subscription_end IS NULL
   )
   AND (segment = 87) THEN 1
    ELSE 0
  END AS is_active_87,
  
  --is_active_30
 CASE
  WHEN (subscription_start < first_day)
  AND (
    subscription_end > first_day OR
    subscription_end IS NULL
  )
  AND (segment = 30) THEN 1
    ELSE 0
  END AS is_active_30,
  
  --is_canceled_87
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 87) THEN 1
   ELSE 0
  END AS is_canceled_87,
  
  --is_canceled_30
 CASE
  WHEN (subscription_end BETWEEN first_day AND last_day)
  AND (segment = 30) THEN 1
   ELSE 0
  END AS is_canceled_30

FROM cross_join
),
status_aggregate AS (
  SELECT month,
  SUM(is_active_87) AS sum_active_87,
  SUM(is_active_30) AS sum_active_30,
  SUM(is_canceled_87) AS sum_canceled_87,
  SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY 1
),
overall_churn_rate AS (
  SELECT month,
  sum_active_87 + sum_active_30 AS active,
  sum_canceled_87 + sum_canceled_87 AS cancel
  FROM status_aggregate
  GROUP BY 1
)
SELECT month,
ROUND(CAST(cancel AS FLOAT)/active*100, 2) AS churn_rate
FROM overall_churn_rate;
