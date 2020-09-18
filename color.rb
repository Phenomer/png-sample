#!/usr/bin/ruby
# coding: utf-8

module Color
  # RGB(赤・緑・青)をHSV(色相・彩度・明度)に変換
  def self.rgb2hsv(r, g, b)
    r, g, b = r.to_f, g.to_f, b.to_f
    max     = [r, g, b].max
    min     = [r, g, b].min
    h, s, v = 0, 0, max

    if max != min
      if max == r
        h = 60 * ((g - b) / (max - min))
      end
      if max == g
        h = 60 * (2 + (b - r) / (max - min))
      end
      if max == b
        h = 60 * (4 + (r - g) / (max - min))
      end
      s = 255 * (max - min) / max
    end

    if h < 0
      h += 360
    end

    return h, s, v
  end

  def self.hsv2rgb(h, s, v)
    h, s, v = h.to_f, s.to_f, v.to_f
    r, g, b = 0, 0, 0

    if s == 0
      r, g, b = v, v, v
      return r, g, b
    end

    if h == 360
      h = 0.0
    end
    
    dh = (h / 60).floor
    f  = (h / 60) - dh
    m  = v * (1 - s / 255)
    n  = v * (1 - s / 255 * f)
    k  = v * (1 - s / 255 * (1 - f))

    case dh
    when 0
      return v, k, m
    when 1
      return n, v, m
    when 2
      return m, v, k
    when 3
      return m, n, v
    when 4
      return k, m, v
    when 5
      return v, m, n
    end
  end
end
