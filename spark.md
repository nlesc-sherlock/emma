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


