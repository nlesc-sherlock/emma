import geotrellis.raster._
import geotrellis.raster.io.geotiff._
import geotrellis.raster.resample._
import geotrellis.spark._
import geotrellis.spark.io._
import geotrellis.spark.tiling._
import geotrellis.vector._
import org.apache.spark.HashPartitioner
import org.apache.spark.rdd.RDD

val rdd: RDD[(ProjectedExtent, Tile)] = ???

// Tile this RDD to a grid layout. This will transform our raster data into a
// common grid format, and merge any overlapping data.

// We'll be tiling to a 512 x 512 tile size, and using the RDD's bounds as the tile bounds.
val layoutScheme = FloatingLayoutScheme(512)

// We gather the metadata that we will be targeting with the tiling here.
// The return also gives us a zoom level, which we ignore.
val (_: Int, metadata: TileLayerMetadata[SpatialKey]) =
  rdd.collectMetadata[SpatialKey](layoutScheme)

// Here we set some options for our tiling.
// For this example, we will set the target partitioner to one
// that has the same number of partitions as our original RDD.
val tilerOptions =
  Tiler.Options(
    resampleMethod = Bilinear,
    partitioner = new HashPartitioner(rdd.partitions.length)
  )

// Now we tile to an RDD with a SpaceTimeKey.

val tiledRdd =
  rdd.tileToLayout[SpatialKey](metadata, tilerOptions)


// At this point, we want to combine our RDD and our Metadata to get a TileLayerRDD[SpatialKey]

val layerRdd: TileLayerRDD[SpatialKey] =
  ContextRDD(tiledRdd, metadata)

// Now we can save this layer off to a GeoTrellis backend (Accumulo, HDFS, S3, etc)
// In this example, though, we're going to just filter it by some bounding box
// and then save the result as a GeoTiff.

val areaOfInterest: Extent = ???

val raster: Raster[Tile] =
  layerRdd
    .filter()                            // Use the filter/query API to
    .where(Intersects(areaOfInterest))   // filter so that only tiles intersecting
    .result                              // the Extent are contained in the result
    .stitch                 // Stitch together this RDD into a Raster[Tile]

GeoTiff(raster, metadata.crs).write("/some/path/result.tif")
