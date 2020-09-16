#!/usr/bin/ruby
#-*- coding: utf-8 -*-

#
# 8bit Grayscaleのピクセルデータを保持する255×255の二次元配列を作成し、
# それを元にしたPNGファイル(image.png)を出力する
#
# X:0, Y:0   +------------+ X:255, Y:0
#            |            |
#            |            |
#            |            |
# X:0, Y:255 +------------+ X:255, Y:255
#

# pngfileライブラリを読み取る
# これでPNGFileクラスが利用できるようになる
require '../pngfile'

# 画像解像度
WIDTH  = 255
HEIGHT = 255

# width:  横解像度
# height: 縦解像度
# color:  色のフォーマット
#   rgb8:   8bit RGB
#   rgba8:  8bit RGBA(RGB + 透過)
#   gray8:  8bit Grayscale
#   graya8: 8bit Grayscale + 透過
png = PNGFile.new(width: WIDTH, height: HEIGHT, color: :gray8)

# 全てのピクセルに、ピクセルの座標に合わせた色を設定
0.upto(HEIGHT - 1) do |y|
  0.upto(WIDTH - 1) do |x|
    png.set(x: x, y: y, color: (x + y) / 2)
  end
end

# PNG画像ファイルとして出力
png.write('export_grayscale.png')

