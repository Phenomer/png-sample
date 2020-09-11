#!/usr/bin/ruby
# coding: utf-8

require '../pngwriter'

png_src = PNGWriter.new(width: 1000, height: 1000, color: :rgba8)
png_dst = PNGWriter.new(width: 1000, height: 1000, color: :g8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_src.from_string(raw.read)
end

0.upto(999) do |y|
  0.upto(999) do |x|
    pixel = png_src.get(x: x, y: y)
    # R・G・Bを足し合わせて3で割ってgrayscaleに変換
    grayscale = pixel[0..2].sum / 3
    png_dst.set(x: x, y: y, color: grayscale)
  end
end

png_dst.write('export_raw2gray.png')
