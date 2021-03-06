#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

png = PNGFile.new(width: 255, height: 255, color: :rgba8)

0.upto(254) do |y|
  0.upto(254) do |x|
    png.set(x: x, y: y, color: [x, y, (x+y)/2, 255-x])
  end
end

png.write('export_alpha_gradation.png')
