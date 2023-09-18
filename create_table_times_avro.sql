use oraclehadoop;
DROP TABLE IF EXISTS times_avro;
CREATE TABLE times_avro
 (
  TIME_ID                  timestamp                    ,
  DAY_NAME                 varchar(9)                  ,
  DAY_NUMBER_IN_WEEK       int                       ,
  DAY_NUMBER_IN_MONTH      int                       ,
  CALENDAR_WEEK_NUMBER     int                       ,
  FISCAL_WEEK_NUMBER       int                       ,
  WEEK_ENDING_DAY          timestamp                    ,
  WEEK_ENDING_DAY_ID       bigint                      ,
  CALENDAR_MONTH_NUMBER    int                       ,
  FISCAL_MONTH_NUMBER      int                       ,
  CALENDAR_MONTH_DESC      varchar(8)                  ,
  CALENDAR_MONTH_ID        bigint                      ,
  FISCAL_MONTH_DESC        varchar(8)                  ,
  FISCAL_MONTH_ID          bigint                      ,
  DAYS_IN_CAL_MONTH        bigint                      ,
  DAYS_IN_FIS_MONTH        bigint                      ,
  END_OF_CAL_MONTH         timestamp                    ,
  END_OF_FIS_MONTH         timestamp                    ,
  CALENDAR_MONTH_NAME      varchar(9)                  ,
  FISCAL_MONTH_NAME        varchar(9)                  ,
  CALENDAR_QUARTER_DESC    varchar(7)                     ,
  CALENDAR_QUARTER_ID      bigint                      ,
  FISCAL_QUARTER_DESC      varchar(7)                     ,
  FISCAL_QUARTER_ID        bigint                      ,
  DAYS_IN_CAL_QUARTER      bigint                      ,
  DAYS_IN_FIS_QUARTER      bigint                      ,
  END_OF_CAL_QUARTER       timestamp                    ,
  END_OF_FIS_QUARTER       timestamp                    ,
  CALENDAR_QUARTER_NUMBER  int                       ,
  FISCAL_QUARTER_NUMBER    int                       ,
  CALENDAR_YEAR            int                       ,
  CALENDAR_YEAR_ID         bigint                      ,
  FISCAL_YEAR              int                       ,
  FISCAL_YEAR_ID           bigint                      ,
  DAYS_IN_CAL_YEAR         bigint                      ,
  DAYS_IN_FIS_YEAR         bigint                      ,
  END_OF_CAL_YEAR          timestamp                    ,
  END_OF_FIS_YEAR          timestamp                    
 )
STORED AS AVRO
;
show create table times_avro;
insert overwrite table times_avro select * from times;
select count(1) from times_avro;
!exit
