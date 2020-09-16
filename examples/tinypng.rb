#!/usr/bin/ruby

require '../pngfile'

img = [
  [ [255, 0, 0], [255, 0, 0], [255, 0, 0], [255, 0, 0] ],
  [ [0, 255, 0], [0, 255, 0], [0, 255, 0], [0, 255, 0] ],
  [ [0, 0, 255], [0, 0, 255], [0, 0, 255], [0, 0, 255] ]
]

png = PNGFile.new(width: 4, height: 3, color: :rgb8)
png.from_array(img)
png.write('export_tinypng.png')
