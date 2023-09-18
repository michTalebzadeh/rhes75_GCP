SELECT
CAST(AVG(DayNumber) AS INT64) AS DayNumber,
AverageForDayOfWeekInKg
FROM
  ML.PREDICT(MODEL `test.myWeight2`,
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
GROUP BY (AverageForDayOfWeekInKg)
ORDER BY (AverageForDayOfWeekInKg) DESC

/*
[
  {
    "DayNumber": "7",
    "AverageForDayOfWeekInKg": "74.445"
  },
  {
    "DayNumber": "1",
    "AverageForDayOfWeekInKg": "74.348"
  },
  {
    "DayNumber": "2",
    "AverageForDayOfWeekInKg": "74.31"
  },
  {
    "DayNumber": "3",
    "AverageForDayOfWeekInKg": "74.296"
  },
  {
    "DayNumber": "4",
    "AverageForDayOfWeekInKg": "74.231"
  },
  {
    "DayNumber": "6",
    "AverageForDayOfWeekInKg": "74.19"
  },
  {
    "DayNumber": "5",
    "AverageForDayOfWeekInKg": "74.147"
  }
]
*/

