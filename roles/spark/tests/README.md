#Spark-shell
To connect spark-shell with drivers to read from S3 you need to do:
```
spark-shell
```

Download data and load it into S3:
```
#Create a bucket in S3
s3cmd mb s3://files

#Download sonnets.txt files
wget http://www.gutenberg.org/cache/epub/1041/pg1041.txt -o sonnets.txt

#Upload the sonnets.txt to S3 storage
s3cmd put sonnets.txt s3://files/
```
