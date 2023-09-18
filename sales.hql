SELECT
          rs.Customer_ID
        , rs.Number_of_orders
        , rs.Total_customer_amount
        , rs.Average_order
        , rs.Standard_deviation
FROM
(
        SELECT cust_id AS Customer_ID,
        COUNT(amount_sold) AS Number_of_orders,
        SUM(amount_sold) AS Total_customer_amount,
        AVG(amount_sold) AS Average_order,
        stddev_samp(amount_sold) AS Standard_deviation
        FROM oraclehadoop.sales
        GROUP BY cust_id
        HAVING SUM(amount_sold) > 94000
        AND AVG(amount_sold) < stddev_samp(amount_sold)
) rs
ORDER BY
          -- Total_customer_amount DESC
          rs.Total_customer_amount DESC


