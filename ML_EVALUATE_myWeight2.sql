-- In addition to creating the model, running a query that contains the CREATE MODEL statement trains the model using the data retrieved by your query's SELECT statement.
/*
precision — A metric for classification models. Precision identifies the frequency with which a model was correct when predicting the positive class.
recall — A metric for classification models that answers the following question: Out of all the possible positive labels, how many did the model correctly identify?
accuracy — Accuracy is the fraction of predictions that a classification model got right.
f1_score — A measure of the accuracy of the model. The f1 score is the harmonic average of the precision and recall. An f1 score's best value is 1. The worst value is 0.
log_loss — The loss function used in a logistic regression. This is the measure of how far the model's predictions are from the correct labels.
roc_auc — The area under the ROC curve. This is the probability that a classifier is more confident that a randomly chosen positive example is actually positive than that a randomly chosen negative example is positive. For more information, see Classification in the Machine Learning Crash Course.
[
  {
    "precision": "NaN",
    "recall": "0.75",
    "accuracy": "0.42857142857142855",
    "f1_score": "0.5166666666666667",
    "log_loss": "1.3740113868611783",
    "roc_auc": "0.9602092499999999"
  }
]
*/
SELECT
  *
FROM
  ML.EVALUATE(MODEL `test.myWeight2`,
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
