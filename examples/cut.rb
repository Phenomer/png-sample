#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

# Y軸が350～699の範囲のみを切り取る
Y_CUT = 350..699

png_src = PNGFile.new(color: :rgba8)
png_src.from_file(ARGV[0])
png_dst = PNGFile.new(width:  png_src.width,
                      height: Y_CUT.size,
                      color: :rgba8)

Y_CUT.each do |y|
  0.upto(png_src.width - 1) do |x|
    color = png_src.get(x: x, y: y)
    png_dst.set(x: x, y: y - Y_CUT.min, color: color)
  end
end

png_dst.write('export_cut.png')
