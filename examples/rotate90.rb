#!/usr/bin/ruby
# coding: utf-8

require '../pngfile'

png_src = PNGFile.new(color: :rgba8)
png_src.from_file(ARGV[0])
png_src.rotate90
png_src.write('export_rotate90.png')
