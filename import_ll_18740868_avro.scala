import org.apache.spark.sql.functions._
import java.sql.{Date, Timestamp}

println ("\nStarted at"); spark.sql("SELECT FROM_unixtime(unix_timestamp(), 'dd/MM/yyyy HH:mm:ss.ss') ").collect.foreach(println)
//
// Get a DF first based on Databricks CSV libraries ignore column heading because of column called "Type"
//
//val df = spark.read.format("com.databricks.spark.csv").option("inferSchema", "true").option("header", "true").load("hdfs://rhes75:9000/data/stg/accounts/ll/18740868")
val df = spark.read.option("header", true).csv("hdfs://rhes75:9000/data/stg/accounts/ll/18740868")

//
// [Transaction Date: string, Transaction Type: string, Sort Code: string, Account Number: string, Transaction Description: string, Debit Amount: string, Credit Amount: string, Balance: string, : string]
//
//case class Accounts( TransactionDate: String, TransactionType: String, SortCode: String, AccountNumber: String, TransactionDescription: String, DebitAmount: String, CreditAmount: String, Balance: Double)

// Map the columns to names
//
val a = df.select(col("Transaction Date").as("Transactiondate"),col("Transaction Type").as("Transactiontype"), col("Sort Code").as("SortCode"), col("Account Number").as("AccountNUmber"),
     col("Transaction Description").as("TransactionDescription"), col("Debit Amount").as("DebitAmount"), col("Credit Amount").as("CreditAmount"), col("Balance").as("Balance"))

//
// Create a Spark temporary table
//
a.toDF.registerTempTable("tmp")

//
// Test it here
//
//sql("select TransactionDate, TransactionType, SortCode, AccountNumber, TransactionDescription, DebitAmount, CreditAmount, Balance from tmp").take(2)
//
// Need to create and populate target ORC table ll_18740868_avro in database accounts.in Hive
//
sql("use accounts")
//
// Drop and create table ll_18740868_avro
//
sql("DROP TABLE IF EXISTS accounts.ll_18740868_avro")
var sqltext = ""
sqltext = """
CREATE TABLE accounts.ll_18740868_avro (
TransactionDate            DATE
,TransactionType           String
,SortCode		   String
,AccountNumber	           String
,TransactionDescription	   String
,DebitAmount               Double
,CreditAmount              Double
,Balance	           Double
)
COMMENT 'from csv file from excel sheet'
STORED AS AVRO
"""
sql(sqltext)
//
// Put data in Hive table. Clean up is already done
//
sqltext = """
INSERT INTO TABLE accounts.ll_18740868_avro
SELECT 
          TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(TransactionDate,'dd/MM/yyyy'),'yyyy-MM-dd')) AS TransactionDate
	, TransactionType
        , SortCode
	, AccountNumber
	, TransactionDescription
	, DebitAmount
        , CreditAmount
        , Balance
FROM tmp
"""
sql(sqltext)
//
// Test all went OK by looking at some old transactions
//
sql("Select TransactionDate, DebitAmount, CreditAmount, Balance from ll_18740868_avro where TransactionDate < '2011-05-30'").collect.foreach(println)
//
println ("\nFinished at"); spark.sql("SELECT FROM_unixtime(unix_timestamp(), 'dd/MM/yyyy HH:mm:ss.ss') ").collect.foreach(println)
sys.exit()
