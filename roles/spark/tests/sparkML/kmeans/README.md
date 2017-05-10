#Spark-shell
To connect spark-shell you need to do:
```
spark-shell
```

Download data and load it into hdfs:
```
#Create dir in HDFS, if you login as Ubuntu
hadoop dfs -mkdir /user/ubuntu/files

#Download sample_kmeans_data.txt file
wget https://raw.githubusercontent.com/apache/spark/master/data/mllib/sample_kmeans_data.txt

#Upload the sample_kmeans_data.txt to HDFS
hadoop dfs -put ./sample_kmeans_data.txt /user/ubuntu/files/sample_kmeans_data.txt
```
