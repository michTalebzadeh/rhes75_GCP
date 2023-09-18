 CREATE OR REPLACE MODEL test.myWeight
 OPTIONS
 ( model_type='linear_reg',
   data_split_col='DayofWeek',
   data_split_method='seq',
   ls_init_learn_rate=.15,
   l1_reg=1,
   max_iterations=5,
   data_split_eval_fraction=0.3,
   input_label_cols=['AverageForDayOfWeekInKg']
 )
 AS
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
    AND '2018-12-31' and CAST(FORMAT_DATE('%u', datetaken) AS int64) <> 7)
