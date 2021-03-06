#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

png_src = PNGFile.new(width: 1000, height: 1000, color: :rgba8)
png_dst = PNGFile.new(width: 1000, height: 1000, color: :ga8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_src.from_string(raw.read)
end

0.upto(999) do |y|
  0.upto(999) do |x|
    pixel = png_src.get(x: x, y: y)
    # R・G・Bを足し合わせて3で割ってgrayscaleに変換
    # pixel[3]はalpha
    grayscale = pixel[0..2].sum / 3
    png_dst.set(x: x, y: y, color: [grayscale, pixel[3]])
  end
end

png_dst.write('export_raw2gray-alpha.png')
