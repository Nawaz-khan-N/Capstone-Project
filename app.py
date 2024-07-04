from pyspark.sql import SparkSession
import os

#Database Name
database_name = "my_retail_data"

#Table name
table_name = "retail_data"

#SparkSession
spark = SparkSession.builder.appName("Retail Data Processing").getOrCreate()

#Checking Database
if not spark.catalog.databaseExists(database_name):
  # Create the database
  spark.sql(f"CREATE DATABASE {database_name}")

schema = ["Store", "Date", "Temperature", "Fuel_Price", "MarkDown1", "MarkDown2", 
         "MarkDown3", "MarkDown4", "MarkDown5", "CPI", "Unemployment", "IsHoliday"]

#CSV File location to pass to HDFS
data_path = "/app/data/Features_data_set_1.csv"

#NameNode Port
hdfs_namenode_port = os.getenv("HDFS_NAMENODE_PORT")

#Reding csv file from HDFS
data_df = spark.read.csv(f"hdfs://namenode:{hdfs_namenode_port}/user/caps/{data_path}", header=True, schema=schema)


#Hive table creation
spark.sql(f"""CREATE TABLE {database_name}.{table_name}
              USING hive
              AS SELECT * FROM data_df""")

#Printing table data
spark.sql(f"SELECT * FROM {database_name}.{table_name}").show()

spark.stop()
