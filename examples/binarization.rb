#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

THRESHOLD = 127

png_src = PNGFile.new(color: :rgba8)
png_src.from_file(ARGV[0])

png_dst = PNGFile.new(width: png_src.width,
                      height: png_src.height,
                      color: :gray8)

png_src.collect do |x, y, color|
  v = color.sum / 4 > THRESHOLD ? 255 : 0
  png_dst.set(x: x, y: y, color: v)
end

png_dst.write('export_binarization.png')
