CREATE TABLE oraclehadoop.tmp
AS
SELECT t.calendar_month_desc, c.channel_desc, SUM(s.amount_sold) AS TotalSales
FROM oraclehadoop.sales s, oraclehadoop.times t, oraclehadoop.channels c
WHERE s.time_id = t.time_id
AND   s.channel_id = c.channel_id
GROUP BY t.calendar_month_desc, c.channel_desc
