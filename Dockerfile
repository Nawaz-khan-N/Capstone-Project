FROM ubuntu:20.04

# Set environment variables
ENV HADOOP_VERSION=3.3.1 \
    SPARK_VERSION=3.1.2 \
    SQOOP_VERSION=1.4.7 \
    HIVE_VERSION=3.1.2 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    PATH=$PATH:/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:/opt/sqoop/bin

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk python3 python3-pip ssh rsync wget curl maven && \
    apt-get clean

# Install Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzvf hadoop-$HADOOP_VERSION.tar.gz -C /opt && \
    mv /opt/hadoop-$HADOOP_VERSION /opt/hadoop && \
    rm hadoop-$HADOOP_VERSION.tar.gz

# Install Spark
RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.2.tgz && \
    tar -xzvf spark-$SPARK_VERSION-bin-hadoop3.2.tgz -C /opt && \
    mv /opt/spark-$SPARK_VERSION-bin-hadoop3.2 /opt/spark && \
    rm spark-$SPARK_VERSION-bin-hadoop3.2.tgz

# Install Sqoop
RUN wget https://downloads.apache.org/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0.tar.gz && \
    tar -xzvf sqoop-$SQOop_VERSION.bin__hadoop-2.6.0.tar.gz -C /opt && \
    mv /opt/sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0 /opt/sqoop && \
    rm sqoop-$SQOOP_VERSION.bin__hadoop-2.6.0.tar.gz

# Install Hive
RUN wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt && \
    mv /opt/apache-hive-$HIVE_VERSION-bin /opt/hive && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz

# Setup Hadoop and Spark environment variables
RUN echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc && \
    echo "export HADOOP_HOME=/opt/hadoop" >> ~/.bashrc && \
    echo "export SPARK_HOME=/opt/spark" >> ~/.bashrc && \
    echo "export HIVE_HOME=/opt/hive" >> ~/.bashrc && \
    echo "export SQOOP_HOME=/opt/sqoop" >> ~/.bashrc && \
    echo "export PATH=$PATH:/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:/opt/sqoop/bin" >> ~/.bashrc

# Install Python dependencies
RUN pip3 install --upgrade pip

# Expose necessary ports
EXPOSE 8080 50070 8088 10000

# Start SSH service
CMD service ssh start && bash

# Set working directory
WORKDIR /app

# (Optional) Define ENTRYPOINT for specific script execution
ENTRYPOINT ["bash", "-c", "source /opt/spark/conf/spark-env.sh && /opt/spark/bin/spark-submit app.py"]