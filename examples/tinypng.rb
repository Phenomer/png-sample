#!/usr/bin/ruby

require '../pngwriter'

img = [
  [ [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0] ],
  [ [0, 255, 0], [0, 255, 0], [0, 255, 0], [0, 255, 0] ],
  [ [0, 0, 255], [0, 0, 255], [0, 0, 255], [0, 0, 255] ]
]

png = PNGWriter.new(width: 4, height: 3, color: :rgb8)
png.from_array(img)
png.write('export_tinypng.png')
