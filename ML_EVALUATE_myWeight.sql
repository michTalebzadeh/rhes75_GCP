/*
An important metric in the evaluation results is the R2 score. The R2 score is a statistical measure that determines if the linear regression predictions approximate the actual data. 0 indicates that the model explains none of the variability of the response data around the mean. 1 indicates that the model explains all the variability of the response data around the mean.
[
  {
    "mean_absolute_error": "0.16789279999999604",
    "mean_squared_error": "0.03692913514898116",
    "mean_squared_log_error": "6.508142321070195E-6",
    "median_absolute_error": "0.1528927999999894",
    "r2_score": "-3.2247490691456884",
    "explained_variance": "-2.864375403532904E-14"
  }
]
*/
SELECT
  *
FROM
  ML.EVALUATE(MODEL `test.myWeight`,
(
SELECT
  RANK() OVER (ORDER BY weightkg DESC) AS Rank,
  DOW AS DayofWeek,
  DNUMBER AS DayNumber,
  ROUND(weightkg,3) AS AverageForDayOfWeekInKg,
  ROUND(StandardDeviation,2) AS StandardDeviation,
  sampleSize AS sampleSizeInDays
FROM (
  SELECT
    DISTINCT FORMAT_DATE('%A', datetaken) AS DOW,
    CAST(FORMAT_DATE('%u', datetaken) AS int64) AS DNUMBER,
    AVG(weight) OVER (PARTITION BY FORMAT_DATE('%A', datetaken)) AS weightkg,
    COUNT(FORMAT_DATE('%A', datetaken)) OVER (PARTITION BY FORMAT_DATE('%A', datetaken)) AS sampleSize,
    STDDEV(weight) OVER (PARTITION BY FORMAT_DATE('%A', datetaken)) AS StandardDeviation
  FROM
    test.weights_date
  WHERE
    datetaken BETWEEN '2018-01-01'
    AND '2018-12-31' )
  )
)

