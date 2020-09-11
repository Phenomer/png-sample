#!/usr/bin/ruby
# coding: utf-8

require '../pngwriter'

# PNG(32bit RGBA) to RAW(32bit RGBA)
# $ convert input.png -depth 8 rgba:output.raw

png_u = PNGWriter.new(width: 2000, height: 1500, color: :rgba8)
png_o = PNGWriter.new(width: 1000, height: 1000, color: :rgba8)

open('rgba8_2000x1500.raw', 'rb') do |raw|
  png_u.from_string(raw.read)
end

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_o.from_string(raw.read)
end

x_pos = 1000
y_pos = 500
0.upto(999) do |y|
  0.upto(999) do |x|
    overlay = png_o.get(x: x, y: y)
    if overlay[3] > 0 # alphaが0以上(透明でない)場合上書き
      png_u.set(x: x+x_pos, y: y+y_pos, color: overlay)
    end
  end
end

png_u.write('export_overlay.png')
