#!/usr/bin/ruby
# coding: utf-8

require 'zlib'
require 'stringio'

PNG_FILE = ARGV[0] || 'yuuri59.png'
Chunk    = Struct.new(:length, :type, :data, :crc)
IHDR     = Struct.new(:width, :height,
                      :cbits, :ctype,
                      :compress, :filter, :interrace)
PHYS     = Struct.new(:x, :y, :unit)

def ihdr(data)
  return IHDR.new(*data.unpack('NNCCCCC'))
end

def phys(data)
  return PHYS.new(*data.unpack('NNC'))
end

def chunk(png)
  c = Chunk.new
  c.length = png.read(4).unpack('N')[0]
  c.type   = png.read(4)
  c.data   = png.read(c.length)
  c.crc    = png.read(4).unpack('N')[0]
  return c
end

raw  = StringIO.new
zlib = Zlib::Inflate.new
ihdr = nil
phys = nil
open(PNG_FILE, 'rb') do |png|
  sig = png.read(8)
  if sig != "\x89PNG\r\n\x1A\n".b
    printf("This is not a PNG file: %s %s\n", PNG_FILE, sig.inspect)
    exit 1
  end

  while c = chunk(png)
    case c.type
    when 'IHDR'
      ihdr = ihdr(c.data)
      printf("[IHDR](%4sbyte): %s\n", c.length, ihdr.inspect)
    when 'tEXt'
      printf("[TEXT](%4sbyte): %s\n", c.length, c.data)
    when 'pHYs'
      phys = phys(c.data)
      printf("[PHYS](%4sbyte): %s\n", c.length, phys.inspect)
    when 'IDAT'
      printf("[IDAT](%4sbyte): %s\n", c.length, c.data[0..10].inspect)
      raw.write(zlib.inflate(c.data))
    when 'IEND'
      printf("[IEND](%4sbyte)\n", c.length)
      break
    else
      printf("[UNKNOWN: %s](%sbyte)\n", c.type, c.length)
    end
  end
end

zlib.finish
raw.seek(0)

# open('export.raw', 'wb') do |rf|
#   ihdr.height.times do
#     raw.read(1).unpack('C')
#     rf.write(raw.read(ihdr.width * 4))
#   end
# end
