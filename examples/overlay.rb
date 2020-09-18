#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

# 背景画像
png_u = PNGFile.new(color: :rgba8)
png_u.from_file('background.jpg')

# 上に重ねる画像
# (背景画像より解像度が小さい透過PNG画像)
png_o = PNGFile.new(color: :rgba8)
png_o.from_file('1000x1000_rgba8.png')

# 重ね合わせる際の始点座標を計算
x_pos = png_u.width  - png_o.width
y_pos = png_u.height - png_o.height

0.upto(png_o.height - 1) do |y|
  0.upto(png_o.width - 1) do |x|
    overlay = png_o.get(x: x, y: y)
    if overlay[3] > 0 # alphaが0以上(透明でない)場合、色を上書き
      png_u.set(x: x+x_pos, y: y+y_pos, color: overlay)
    end
  end
end

png_u.write('export_overlay.png')
