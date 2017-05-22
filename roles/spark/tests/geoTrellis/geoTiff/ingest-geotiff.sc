import geotrellis.spark._
import geotrellis.spark.io._
import geotrellis.spark.io.hadoop._  
import org.apache.hadoop.fs.Path

val tilesDir = new Path("hdfs:///user/ubuntu/files")
val source = sc.hadoopGeoTiffRDD(tilesDir, ".tif")

