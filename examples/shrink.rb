#!/usr/bin/ruby
# coding: utf-8

require '../pngwriter'
require 'matrix'

# 画像の縮小スケール(1/SCALE)
SCALE      = 3
IN_WIDTH   = 1000
IN_HEIGHT  = 1000
OUT_WIDTH  = IN_WIDTH  / SCALE
OUT_HEIGHT = IN_HEIGHT / SCALE

png_src = PNGWriter.new(width: IN_WIDTH,  height: IN_HEIGHT,  color: :rgba8)
png_dst = PNGWriter.new(width: OUT_WIDTH, height: OUT_HEIGHT, color: :rgba8)

open('rgba8_1000x1000.raw', 'rb') do |raw|
  png_src.from_string(raw.read)
end

# 1ピクセル当たりの元ピクセル幅
xppx = IN_WIDTH.to_f  / OUT_WIDTH
yppx = IN_HEIGHT.to_f / OUT_HEIGHT

0.upto(OUT_HEIGHT - 1) do |y|
  start_y = (y * SCALE).to_i
  end_y   = (y * SCALE + yppx).to_i

  0.upto(OUT_WIDTH - 1) do |x|
    pixels  = []
    start_x = (x * SCALE).to_i
    end_x   = (x * SCALE + xppx).to_i
    # 縮小後のピクセルに対応する元ピクセルを収集
    start_y.upto(end_y) do |sy|
      start_x.upto(end_x) do |sx|
        pixels.push(png_src.get(x: sx, y: sy))
      end
    end
    # 縮小後のピクセルの値を計算
    # 全ての配列の要素の値を要素番号ごとに足し合わせて要素数で割る
    # [1,2,3,4] + [2,3,4,5] + [3,4,5,6] = [6,9,12,15]
    # [6,9,12,15] / 3 = [2,3,4,5]
    pixel = pixels.reduce{|out, px|
      Vector.elements(out, false) + Vector.elements(px, false)
    } / pixels.length

    printf("X(%-4d): %-4d - %-4d, Y(%-4d): %-4d - %-4d: %-4d %s\n",
           x, start_x, end_x, y, start_y, end_y, pixels.length, pixel.inspect)
    png_dst.set(x: x, y: y, color: pixel.to_a)
  end
end

png_dst.write('export_shrink.png')
