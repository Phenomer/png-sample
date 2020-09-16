#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

# 拡大率
SCALE = 3

png_src = PNGFile.new(color: :rgba8)
png_src.from_file(ARGV[0])
png_dst = PNGFile.new(width:  png_src.width * SCALE,
                      height: png_src.height * SCALE,
                      color: :rgba8)

0.upto(png_src.height - 1) do |y|
  start_y = y * SCALE
  end_y   = y * SCALE + SCALE - 1

  0.upto(png_src.width - 1) do |x|
    start_x = x * SCALE
    end_x   = x * SCALE + SCALE - 1
    pixel = png_src.get(x: x, y: y)
    #printf("X(%-4d): %-4d - %-4d, Y(%-4d): %-4d - %-4d\n",
    #       x, start_x, end_x, y, start_y, end_y)
    start_y.upto(end_y) do |sy|
      start_x.upto(end_x) do |sx|
        png_dst.set(x: sx, y: sy, color: pixel)
      end
    end
  end
end

png_dst.write('export_enlarge.png')
