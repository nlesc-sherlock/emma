# Spark

Spark is installed in `/data/shared/spark` directory as Spark Standalone mode.
* For master use `spark://<spark-master>:7077`
* The UI on http://<spark-master>:8080
* The JupyterHub on http://<spark-master>:8000

To get shell of Spark cluster run:
```
spark-shell --master spark://<spark-master>:7077
```

##SparkML
The installation followed the instructions for [SparkML using Spark 2.1.1](http://spark.apache.org/docs/latest/ml-guide.html).
All the dependencies should be installed. However, since Spark is a **pre-built tarball** the user should be aware of the [netlib-java dependency](http://spark.apache.org/docs/latest/ml-guide.html#dependencies) which requires an include.
```
com.github.fommil.netlib:all:1.1.2
```

##GeoTrellis
The installation followed the information available at [GeoTrellis GitHub](https://github.com/locationtech/geotrellis). The same repository has a **doc* dir where there is a [guide on how to use the library in Spark](https://github.com/locationtech/geotrellis/blob/master/docs/guide/spark.rst).
