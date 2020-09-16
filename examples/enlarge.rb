#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

SCALE      = 3
IN_WIDTH   = 1000
IN_HEIGHT  = 1000
OUT_WIDTH  = IN_WIDTH  * SCALE
OUT_HEIGHT = IN_HEIGHT * SCALE

png_src = PNGFile.new(width: IN_WIDTH,  height: IN_HEIGHT,  color: :rgba8)
png_dst = PNGFile.new(width: OUT_WIDTH, height: OUT_HEIGHT, color: :rgba8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_src.from_string(raw.read)
end

0.upto(IN_HEIGHT - 1) do |y|
  start_y = y * SCALE
  end_y   = y * SCALE + SCALE - 1

  0.upto(IN_WIDTH - 1) do |x|
    start_x = x * SCALE
    end_x   = x * SCALE + SCALE - 1
    pixel = png_src.get(x: x, y: y)
    printf("X(%-4d): %-4d - %-4d, Y(%-4d): %-4d - %-4d\n",
           x, start_x, end_x, y, start_y, end_y)
    start_y.upto(end_y) do |sy|
      start_x.upto(end_x) do |sx|
        png_dst.set(x: sx, y: sy, color: pixel)
      end
    end
  end
end

png_dst.write('export_enlarge.png')
