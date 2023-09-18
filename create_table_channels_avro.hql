use oraclehadoop;
set hive.execution.engine=mr;
drop table if exists channels_avro;
 CREATE TABLE channels_avro
 (
   channel_id         double               
 , channel_desc       string               
 , channel_class      string               
 , channel_class_id   double               
 , channel_total      string               
 , channel_total_id   double               
)
STORED AS AVRO
;
show create table channels_avro;
insert into table channels_avro select * from channels;
select count(1) from channels_avro;
!exit
