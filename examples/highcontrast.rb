#!/usr/bin/ruby
# coding: utf-8

require '../pngwriter'

png_src = PNGWriter.new(width: 1000, height: 1000, color: :rgba8)
png_dst = PNGWriter.new(width: 1000, height: 1000, color: :rgba8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_src.from_string(raw.read)
end

0.upto(999) do |y|
  0.upto(999) do |x|
    pixel = png_src.get(x: x, y: y)
    # R・G・Bを足し合わせて3で割ってgrayscaleに変換
    pixel = pixel.collect{|n| n > 127 ? 255 : 0}
    png_dst.set(x: x, y: y, color: pixel)
  end
end

png_dst.write('export_highcontrast.png')
