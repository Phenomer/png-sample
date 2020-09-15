#!/usr/bin/ruby
# coding: utf-8

PNG_FILE = ARGV[0]
Chunk    = Struct.new(:length, :type, :data, :crc)
IHDR     = Struct.new(:width, :height,
                      :cbits, :ctype,
                      :compress, :filter, :interrace)
PHYS     = Struct.new(:x, :y, :unit)

def chunk(png)
  c = Chunk.new
  c.length = png.read(4).unpack('L>')[0]
  c.type   = png.read(4)
  c.data   = png.read(c.length)
  c.crc    = png.read(4).unpack('L>')[0]
  return c
end

open(PNG_FILE, 'rb') do |png|
  sig = png.read(8)
  if sig != "\x89PNG\r\n\x1A\n".b
    printf("This is not a PNG file: %s %s\n", PNG_FILE, sig.inspect)
    exit 1
  end

  while c = chunk(png)
    case c.type
    when 'IHDR'
      ihdr = IHDR.new(*c.data.unpack('L>L>CCCCC'))
      printf("[IHDR](%4sbyte): %s\n", c.length, ihdr.inspect)
    when 'tEXt'
      printf("[TEXT](%4sbyte): %s\n", c.length, c.data)
    when 'pHYs'
      phys = PHYS.new(*c.data.unpack('L>L>C'))
      printf("[PHYS](%4sbyte): %s\n", c.length, phys.inspect)
    when 'IDAT'
      printf("[IDAT](%4sbyte): %s\n", c.length, c.data[0..10].inspect)
    when 'IEND'
      printf("[IEND](%4sbyte)\n", c.length)
      break
    else
      printf("[UNKNOWN: %s](%sbyte)\n", c.type, c.length)
    end
  end
end
