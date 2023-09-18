use oraclehadoop;
set hive.execution.engine=mr;
drop table if exists sales_avro;
 CREATE TABLE sales_avro
 (
  PROD_ID        bigint                       ,
  CUST_ID        bigint                       ,
  TIME_ID        timestamp                    ,
  CHANNEL_ID     bigint                       ,
  PROMO_ID       bigint                       ,
  QUANTITY_SOLD  decimal(10)                  ,
  AMOUNT_SOLD    decimal(10)
)
STORED AS AVRO
;
show create table sales_avro;
!exit
