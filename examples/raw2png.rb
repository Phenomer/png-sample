#!/usr/bin/ruby

require '../pngfile'

# PNG(32bit RGBA) to RAW(32bit RGBA)
# $ convert input.png -depth 8 rgba:output.raw
#
# JPG to RAW(32bit RGBA)
# $ convert input.jpg -depth 8 rgba:output.raw

png = PNGFile.new(width: 1000, height: 1000, color: :rgba8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png.from_string(raw.read)
end

png.write('export_raw2png.png')
