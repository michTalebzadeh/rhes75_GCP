import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.SparkConf
import org.apache.spark.sql.hive.HiveContext
import java.util.Calendar
import org.apache.spark.sql.SparkSession
import scala.collection.mutable.ArrayBuffer

import org.apache.spark._
import org.apache.spark.rdd.NewHadoopRDD
import org.apache.hadoop.fs.Path
import scala.util.Random
import org.apache.spark.sql.functions._
//
//
import org.apache.log4j.Logger
import org.apache.log4j.Level

import com.google.cloud.hadoop.io.bigquery.BigQueryConfiguration
import com.google.cloud.hadoop.io.bigquery.BigQueryFileFormat
import com.google.cloud.hadoop.io.bigquery.GsonBigQueryInputFormat
import com.google.cloud.hadoop.io.bigquery.output.BigQueryOutputConfiguration
import com.google.cloud.hadoop.io.bigquery.output.IndirectBigQueryOutputFormat
import com.google.gson.JsonObject
import org.apache.hadoop.io.LongWritable
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat
import org.apache.hadoop.conf.Configuration


import org.apache.hadoop.io.LongWritable
import org.apache.avro.generic.GenericData
import com.google.cloud.hadoop.io.bigquery.AvroBigQueryInputFormat

import com.samelamin.spark.bigquery._
import java.io.{File, FileWriter, IOException, Writer}

object simple
{
  private var sparkAppName = "simple"
  private var sparkDefaultParllelism = null
  private var sparkDefaultParallelismValue = "12"
  private var sparkSerializer = null
  private var sparkSerializerValue = "org.apache.spark.serializer.KryoSerializer"
  private var sparkNetworkTimeOut = null
  private var sparkNetworkTimeOutValue = "3600"
  private var sparkStreamingUiRetainedBatches = null
  private var sparkStreamingUiRetainedBatchesValue = "5"
  private var sparkWorkerUiRetainedDrivers = null
  private var sparkWorkerUiRetainedDriversValue = "5"
  private var sparkWorkerUiRetainedExecutors = null
  private var sparkWorkerUiRetainedExecutorsValue = "30"
  private var sparkWorkerUiRetainedStages = null
  private var sparkWorkerUiRetainedStagesValue = "100"
  private var sparkUiRetainedJobs = null
  private var sparkUiRetainedJobsValue = "100"
  private var sparkJavaStreamingDurationsInSeconds = "10"
  private var sparkNumberOfSlaves = 14
  private var sparkRequestTopicShortName = null
  private var sparkImpressionTopicShortName = null
  private var sparkClickTopicShortName = null
  private var sparkConversionTopicShortName = null
  private var sparkNumberOfPartitions = 30
  private var sparkClusterDbIp = null
  private var clusterDbPort = null
  private var insertQuery = null
  private var insertOnDuplicateQuery = null
  private var sqlDriverName = null
  private var memorySet = "F"
  private var enableHiveSupport = null
  private var enableHiveSupportValue = "true"

  def main(args: Array[String])
  {


   var startTimeQuery = System.currentTimeMillis

  // Create a SparkSession. No need to create SparkContext. In Spark 2.0 the same effects can be achieved through SparkSession, without explicitly creating SparkConf, SparkContext or SQLContext as they are encapsulated within the SparkSession
  val spark =  SparkSession.
               builder().
               appName(sparkAppName).
               config("spark.driver.allowMultipleContexts", "true").
               config("spark.hadoop.validateOutputSpecs", "false").
               getOrCreate()

             // change the values accordingly.
             spark.conf.set("sparkDefaultParllelism", sparkDefaultParallelismValue)
             spark.conf.set("sparkSerializer", sparkSerializerValue)
             spark.conf.set("sparkNetworkTimeOut", sparkNetworkTimeOutValue)

import spark.implicits._
spark.sparkContext.setLogLevel("ERROR")
println ("\nStarted at"); spark.sql("SELECT FROM_unixtime(unix_timestamp(), 'dd/MM/yyyy HH:mm:ss.ss') ").collect.foreach(println)

val HadoopConf = spark.sparkContext.hadoopConfiguration

//get and set the env variables

val bucket = HadoopConf.get("fs.gs.system.bucket")
val projectId = HadoopConf.get("fs.gs.project.id")
val jobName = "simplejob"

HadoopConf.set(BigQueryConfiguration.PROJECT_ID_KEY, projectId)
HadoopConf.set(BigQueryConfiguration.GCS_BUCKET_KEY, bucket)

val inputTable = "accounts.ll_18201960_orc"
val fullyQualifiedInputTableId = projectId+":"+inputTable
val targetDataset = "test"
val targetTable = "ll_18201960"
val outputTable = targetDataset+"."+targetTable
val fullyQualifiedOutputTableId = projectId+":"+outputTable
val jsonKeyFile="/home/hduser/GCPFirstProject-d75f1b3a9817.json"
val datasetLocation="europe-west2"
val writedisposition="WRITE_TRUNCATE"
// Set up GCP credentials
spark.sqlContext.setGcpJsonKeyFile(jsonKeyFile)
// Set up BigQuery project and bucket
spark.sqlContext.setBigQueryProjectId(projectId)
spark.sqlContext.setBigQueryGcsBucket(bucket)
spark.sqlContext.setBigQueryDatasetLocation(datasetLocation)
var sqltext = ""
  // Delete existing data in BigQuery table if exists
  sqltext = "SELECT size_bytes FROM "+targetDataset+".__TABLES__ WHERE table_id='"+targetTable+"'"
  var size = spark.sqlContext.runDMLQuery(sqltext)
try
{
  println("\nDeleting data from the output table " + outputTable + " if it exists")
  sqltext = "DELETE from " + outputTable + " WHERE True"
  spark.sqlContext.runDMLQuery(sqltext)
} 
catch
{
  case ex: IOException => { println("Table "+ fullyQualifiedOutputTableId + " not found")}
}
//read data from the staging (input) Table
println("\nreading data from " + inputTable)
val df = spark.sqlContext
          .read
          .format("com.samelamin.spark.bigquery")
          .option("tableReferenceSource",fullyQualifiedInputTableId)
          .load()

println("\nInput table schema")
df.printSchema

// Create a new DF based on CAST columns
//
//val df2 = df.select((to_date(unix_timestamp('transactiondate,"yyyy-MM-dd'").cast("timestamp"))).as("transactiondate"), 'transactiontype).as("transactiontype"), substring('sortcode,2,8).as("sortcode"), 'accountnumber.as("accountnumber"),
val df2 = df.select('transactiondate.cast("DATE").as("transactiondate"), 'transactiontype.as("transactiontype"), substring('sortcode,2,8).as("sortcode"), 'accountnumber.as("accountnumber"),
     'transactiondescription.as("transactiondescription"), 'debitamount.cast("DOUBLE").as("debitamount"), 'creditamount.cast("DOUBLE").as("creditamount"), 'balance.cast("DOUBLE").as("balance"))

println("\nModified table schema for output storage")
df2.printSchema

// Save data to a BigQuery table
println("\nsaving data to " + outputTable)

df2.saveAsBigQueryTable(fullyQualifiedOutputTableId)

println("\nreading data from " + outputTable + ", and counting rows")

// Load everything from the table and count the number of rows
val ll_18201960 = spark.sqlContext.bigQueryTable(fullyQualifiedOutputTableId)
ll_18201960.agg(count("*").as("Rows in the output table " + outputTable)).show

// Temp output bucket needed to read a new table that is deleted upon completion of job.
val gcsTempBucket = HadoopConf.get(BigQueryConfiguration.GCS_BUCKET_KEY)
var tempPath = s"gs://$gcsTempBucket/spark-bigquery/${java.lang.System.currentTimeMillis}/"
HadoopConf.set(BigQueryConfiguration.TEMP_GCS_PATH_KEY, tempPath)
// Load everything from the table accounts.transactioncodes_gcp
val transactiontypes = spark.sqlContext.bigQueryTable(projectId+":"+"accounts.transactioncodes_gcp")
//transactiontypes.select("*").orderBy('id).collect.foreach(println)
//df2.collect.foreach(println)

var HASHTAG = "TALEBZADEH"
println("\nIndividual Payments to Talebzadeh by Date")
ll_18201960.filter('transactiondescription.contains(HASHTAG)).orderBy('transactiondate).select('transactiondate, 'debitamount).collect.foreach(println)
println("\nTotal Payments to Talebzadeh")

ll_18201960.filter('transactiondescription.contains(HASHTAG) && 'debitamount > 0).agg(sum('debitamount).cast("Float").as("Talebzadeh Pays")).collect.foreach(println)
HASHTAG = "PAY"
println("\nIndividual Payments by Date")
ll_18201960.filter('transactiontype.contains(HASHTAG)).orderBy('transactiondate).select('transactiondate,'transactiontype,'transactiondescription,'debitamount).collect.foreach(println)
println("\nTotal Cash Payments")
ll_18201960.filter('transactiontype.contains(HASHTAG) && 'debitamount > 0).agg(sum('debitamount).cast("Float").as("Cash Pays")).collect.foreach(println)
println("\ngroupBy transactiontype")
ll_18201960.groupBy('transactiontype).agg(count('transactiontype)as("Total transactiontype")).join(transactiontypes,"transactiontype").select("transactiontype","description","Total transactiontype").collect.foreach(println)
// In below groupBy and sort are alias to each other
ll_18201960.filter('transactiontype === "DEB").groupBy('transactiondate).agg(sum('debitamount).cast("Float").as("Total Debit Card")).orderBy(desc("transactiondate")).show(5)

println("\nTotal Credit")
val credit = ll_18201960.agg(sum('creditamount).cast("DECIMAL(10,2)").as("Credits")).collect.foreach(println)
println("\nTotal Debits")
val debit = ll_18201960.agg(sum('debitamount).cast("DECIMAL(10,2)").as("Debits")).collect.foreach(println)
HASHTAG = " LOAN"
println("\nLoans to the Company")
ll_18201960.filter('transactiondescription.contains(HASHTAG) && 'creditamount > 0).orderBy('transactiondate).select('transactiondate,'transactiontype,'transactiondescription,'creditamount).collect.foreach(println)
println("\nTotal loans")
ll_18201960.filter('transactiondescription.contains(HASHTAG) && 'creditamount > 0).agg(sum('creditamount).cast("DECIMAL(10,2)").as("loans")).collect.foreach(println)
println("\nBalance today")
val Balance = ll_18201960.agg(sum("creditamount").cast("DECIMAL(10,2)")-sum("debitamount").cast("DECIMAL(10,2)")).as("Balance").collect.foreach(println)

println("\nLast entry date in the transaction table")
ll_18201960.select(max('transactiondate).as("Last entry date")).collect.foreach(println)

println ("\nFinished at"); spark.sql("SELECT FROM_unixtime(unix_timestamp(), 'dd/MM/yyyy HH:mm:ss.ss') ").collect.foreach(println)
sys.exit
  }
}
