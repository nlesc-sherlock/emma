# Spark

Spark is installed in `/data/shared/spark` directory as Spark Standalone mode.
* For master use `spark://<spark-master>:7077`
* The UI on http://<spark-master>:8080
* The JupyterHub on http://<spark-master>:8000

To get shell of Spark cluster run:
```
spark-shell --master spark://<spark-master>:7077
```

Before staring interaction with Spark, we recommend the read of [RDD, DataFrame and Data Set](https://indatalabs.com/blog/data-engineering/convert-spark-rdd-to-dataframe-dataset) and its [programming guide](http://spark.apache.org/docs/latest/programming-guide.html).

## SparkML
The installation followed the instructions for [SparkML using Spark 2.1.1](http://spark.apache.org/docs/latest/ml-guide.html).
All the dependencies should be installed. However, since Spark is a **pre-built tarball** the user should be aware of the [netlib-java dependency](http://spark.apache.org/docs/latest/ml-guide.html#dependencies) which requires an include.
```
com.github.fommil.netlib:all:1.1.2
```

## GeoTrellis
The installation followed the information available at [GeoTrellis GitHub](https://github.com/locationtech/geotrellis). The same repository has a **doc** dir where there is a [guide on how to use the library in Spark](https://github.com/locationtech/geotrellis/blob/master/docs/guide/spark.rst). When using sbt, maven or gradle the Geotrellis jars should be downloaded from [org.locationtech.geotrellis](https://mvnrepository.com/artifact/org.locationtech.geotrellis).

Before starting using GeoTrellis, we recommend the read of [Core concepts for Geo-trellis](https://geotrellis.readthedocs.io/en/1.0/guide/core-concepts/).

## SciSpark
SciSpark was installed using the [instructions available at SciSpark GitHub page](https://github.com/SciSpark/SciSpark/wiki/2.-Installation).

## Examples

A python notebook to do [Unsupervised classification of imagery using scikit-learn](http://nbviewer.jupyter.org/gist/om-henners/c6c8d40389dab75cf535). This example shows how to classify imagery (for example from LANDSAT) using scikit-learn. There are many classification methods available, but for this example they use K-Means as it's simple and fast. It uses [**numpy**](http://www.numpy.org/) and [**rasterio**](https://github.com/mapbox/rasterio).

## Debug mode
All information to debug set Spark for remote debugging and performance tuning.

### Remote debugging
To set Spark for remote debugging the user should set *spark_debug_mode* to **true** in **emma/vars/spark_vars/.yml** and reconfigure Spark to have only an executor per worker. In **emma/vars/spark_vars/.yml** the user should set *spark_executor_cores* equal to *spark_worker_cores* and *spark_executor_memory* equal to *spark_worker_memory*. Such setting allows us to open a single debugger per executor, i.e., one per node.

By default **driver's debugging port** is *5005* while the **worker's debugging port** is *5006*. They are defined in **emma/vars/spark_vars/.yml** by the variables *worker_debug_port* and *driver_debug_port*. To have either a worker or driver *waiting on startup* the variables *worker_waiting_on_startup* and *driver_waiting_on_startup* should be set to **y** (yes), by default they are set to **n** (no). 

For the configuration take place the user should restart Spark and Jupyterhub.
```
ansible-playbook shutdown_platform.yml --tags "spark,jupyterhub"
ansible-playbook start_platform.yml --tags "spark,jupyterhub"
```

### Tuning garbage collection
Spark is written in Scala, therefore, each process is a Java virtual machine (JVM). JVM memory management is done by a Garbage Collector (GC). The type of GC to be used is defined by variable *gc_type*. If the user wants to obtain GC debug information (s)he should set in **emma/vars/spark_vars/.yml** *gc_debug* to:
```
-XX:+PrintFlagsFinal -XX:+PrintReferenceGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintAdaptiveSizePolicy
```

[Tuning Java Garbage Collection for Apache Spark Applications](https://databricks.com/blog/2015/05/28/tuning-java-garbage-collection-for-spark-applications.html) is a blog post which explains how memory management in a JVM is done and how we can tune GC for Spark applications.
