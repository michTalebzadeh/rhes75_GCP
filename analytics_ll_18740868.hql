--last 10 payments to harrods
/*
SELECT *
FROM (
      SELECT transactiondate, transactiondescription, debitamount
      , RANK() OVER (ORDER BY transactiondate desc) AS rank
      FROM accounts.ll_18740868 WHERE transactiondescription LIKE '%HARRODS%'
     ) tmp
WHERE rank <= 10
SELECT *
FROM (
      SELECT transactiondate, transactiondescription, debitamount
      , AVG(debitamount) OVER (partition by transactiondate ORDER BY transactiondate) AS rank
      FROM accounts.ll_18740868 WHERE transactiondescription LIKE '%HARRODS%'
     ) tmp
WHERE rank > 50
*/
-- All spent per catalog
SELECT DISTINCT hashtag, round(TotalSpent,2) AS TotalSpent, (TotalSpent)*100./Total AS Percentage
FROM (
        SELECT p.hashtag
      , SUM(debitamount) OVER (PARTITION BY p.hashtag) AS TotalSpent
      , SUM(debitamount) OVER () AS Total
      FROM accounts.ll_18740868 l, accounts.catalog p
      WHERE l.transactiondescription = p.transactiondescription 
      AND l.transactiontype = "DEB"
     ) tmp
WHERE (TotalSpent*100)/Total > 1.0
ORDER BY TotalSpent, hashtag
