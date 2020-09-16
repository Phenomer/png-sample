#!/usr/bin/ruby

require '../pngfile'

THRESHOLD = 127

png = PNGFile.new(color: :rgba8)
png.from_file(ARGV[0])

png.collect! do |x, y, color|
  color.collect{|c| c > THRESHOLD ? 255 : 0}
end

png.write('export_highlight.png')
