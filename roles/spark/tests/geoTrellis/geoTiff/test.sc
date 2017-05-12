import geotrellis.raster.Tile
import geotrellis.spark._
import geotrellis.spark.io._
import geotrellis.spark.io.index.ZCurveKeyIndexMethod
import geotrellis.util._
import org.apache.spark.rdd.RDD
import org.joda.time.DateTime

val layer: RDD[(SpaceTimeKey, Tile)] with Metadata[TileLayerMetadata[SpaceTimeKey]] = ???

// Create the key index with our date range
val minDate: DateTime = new DateTime(2010, 12, 1, 0, 0)
val maxDate: DateTime = new DateTime(2010, 12, 1, 0, 0)

val indexKeyBounds: KeyBounds[SpaceTimeKey] = {
  val KeyBounds(minKey, maxKey) = layer.metadata.bounds.get // assuming non-empty layer
  KeyBounds(
    minKey.setComponent[TemporalKey](minDate),
    maxKey.setComponent[TemporalKey](maxDate)
  )
}

val keyIndex =
  ZCurveKeyIndexMethod.byMonth
    .createIndex(indexKeyBounds)

val writer: LayerWriter[LayerId] = ???
val layerId: LayerId = ???

writer.write(layerId, layer, keyIndex)
