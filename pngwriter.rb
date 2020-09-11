#!/usr/bin/ruby
# coding: utf-8

require 'zlib'

class PNGWriter
  class StructuralError < StandardError; end
  COLORS = {
    g8:     {ctype: 0, cnum: 1, cbits:  8},
    g16:    {ctype: 0, cnum: 1, cbits: 16},
    ga8:    {ctype: 4, cnum: 2, cbits:  8},
    ga16:   {ctype: 4, cnum: 2, cbits: 16},
    rgb8:   {ctype: 2, cnum: 3, cbits:  8},
    rgb16:  {ctype: 2, cnum: 3, cbits: 16},
    rgba8:  {ctype: 6, cnum: 4, cbits:  8},
    rgba16: {ctype: 6, cnum: 4, cbits: 16}
  }

  def initialize(width:, height:, color: :rgba8)
    @width, @height = width, height
    unless COLORS.has_key?(color)
      raise "Unknown Color Type - #{color}"
    end
    @color   = COLORS[color]
    @cpack_t = (@color[:cbits] == 8 ? 'C*' : 'n*')
    @image   = Array.new(@height){
      Array.new(@width){
        Array.new(@color[:cnum], 0)
      }
    }
  end
  attr_accessor :image

  def set(x:, y:, color:)
    check_range(x, y)
    @image[y][x] = color
  end

  def get(x:, y:)
    check_range(x, y)
    @image[y][x]
  end

  def from_array(ary)
    img  = ary.flatten
    size = @width * @height * @color[:cnum]
    if img.length != size
      raise StructuralError, "Invalid Array Size - Expected: #{size}, but #{img.length}"
    end
    @image = ary.flatten.each_slice(@color[:cnum]).each_slice(@width).to_a
  end

  def from_string(str)
    @image = from_array(str.unpack(@cpack_t))
  end

  def write(export_png)
    z = Zlib::Deflate.new
    open(export_png, 'wb') do |png_file|
      write_signature(png_file)
      write_chunk(png_file, 'IHDR', ihdr())
      write_chunk(png_file, 'pHYs', phys())

      buffer = String.new
      @image.each do |row|
        # 0でフィルタなし
        buffer << z.deflate([0].pack('C') + row.flatten.pack(@cpack_t))
        if buffer.length >= 9600
          write_chunk(png_file, 'IDAT', buffer.slice!(0..9599))
        end
      end
      buffer << z.finish
      while (buf = buffer.slice!(0..9599)).length > 0
        write_chunk(png_file, 'IDAT', buf)
      end
      write_chunk(png_file, 'IEND', '')
    end
  end

  private
  def check_range(x, y)
    unless (0..@width).include?(x) or (0..@height).include?(y)
      raise StructuralError, "Out of range: X: #{x}, Y: #{y}"
    end
  end

  def write_signature(file)
    file.write("\x89PNG\r\n\x1A\n".b)
  end

  def write_chunk(file, type, data)
    file.write([data.length].pack('N') + type + data +
               [Zlib.crc32(type+data)].pack('N'))
  end

  def ihdr(compress: 0, filter: 0, interrace: 0)
    return [@width, @height, @color[:cbits], @color[:ctype],
            compress, filter, interrace].pack('NNCCCCC')
  end

  def phys(x: 2835, y: 2835, unit: 1)
    return [x, y, unit].pack('NNC')
  end
end
