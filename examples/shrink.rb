#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'
require 'matrix'

# 画像の縮小スケール(1/SCALE)
SCALE      = 3

png_src = PNGFile.new(color: :rgba8)
png_src.from_file(ARGV[0])
png_dst = PNGFile.new(width:  png_src.width / SCALE,
                      height: png_src.height / SCALE,
                      color: :rgba8)

# 1ピクセル当たりの元ピクセル幅
xppx = png_src.width.to_f  / png_dst.width
yppx = png_src.height.to_f / png_dst.height

0.upto(png_dst.height - 1) do |y|
  start_y = (y * SCALE).to_i
  end_y   = (y * SCALE + yppx).to_i

  0.upto(png_dst.width - 1) do |x|
    start_x = (x * SCALE).to_i
    end_x   = (x * SCALE + xppx).to_i
    # 縮小後のピクセルに対応する元ピクセルを収集
    pixels = png_src.collect(x: start_x..end_x,
                             y: start_y..end_y) do |x, y, color|
      color
    end

    # 縮小後のピクセルの値を計算
    # 全ての配列の要素の値を要素番号ごとに足し合わせて要素数で割る
    # [1,2,3,4] + [2,3,4,5] + [3,4,5,6] = [6,9,12,15]
    # [6,9,12,15] / 3 = [2,3,4,5]
    pixel = pixels.reduce{|out, px|
      Vector.elements(out, false) + Vector.elements(px, false)
    } / pixels.length

    # printf("X(%-4d): %-4d - %-4d, Y(%-4d): %-4d - %-4d: %-4d %s\n",
    #        x, start_x, end_x, y, start_y, end_y, pixels.length, pixel.inspect)
    png_dst.set(x: x, y: y, color: pixel.to_a)
  end
end

png_dst.write('export_shrink.png')
