val sonnets = sc.textFile("s3a://files/sonnets.txt")
val counts = sonnets.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey(_ + _)

counts.saveAsTextFile("hdfs://user/spark/files/output")

#At the moment it is not possible to save output to S3
#counts.saveAsTextFile("s3a://files/output")
