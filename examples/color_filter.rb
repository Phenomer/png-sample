#!/usr/bin/ruby

require '../pngfile'
require '../color'

png = PNGFile.new(color: :rgba8)
png.from_file(ARGV[0])

png.collect! do |x, y, color|
  h,s,v = Color.rgb2hsv(*color[0..2])
  if s > 10 && v > 10 && (11..17).include?(h)
    color
  else
    [0,0,0,0]
  end
end

png.write('export_color_filter.png')
