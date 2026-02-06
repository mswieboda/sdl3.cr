lib LibSDL3
  enum PixelFormat
    UNKNOWN = 0
    INDEX1LSB = 0x11100100
    INDEX1MSB = 0x11200100
    INDEX4LSB = 0x12100400
    INDEX4MSB = 0x12200400
    INDEX8 = 0x13000801
    RGB332 = 0x14110801
    XRGB4444 = 0x15120c02
    XBGR4444 = 0x15520c02
    XRGB1555 = 0x15130f02
    XBGR1555 = 0x15530f02
    ARGB4444 = 0x15321002
    RGBA4444 = 0x15421002
    ABGR4444 = 0x15721002
    BGRA4444 = 0x15821002
    ARGB1555 = 0x15331002
    RGBA5551 = 0x15441002
    ABGR1555 = 0x15731002
    BGRA5551 = 0x15841002
    RGB565 = 0x15151002
    BGR565 = 0x15551002
    RGB24 = 0x17101803
    BGR24 = 0x17401803
    XRGB8888 = 0x16161804
    RGBX8888 = 0x16261804
    XBGR8888 = 0x16561804
    BGRX8888 = 0x16661804
    ARGB8888 = 0x16362004
    RGBA8888 = 0x16462004
    ABGR8888 = 0x16762004
    BGRA8888 = 0x16862004
    XRGB2101010 = 0x16172004
    XBGR2101010 = 0x16572004
    ARGB2101010 = 0x16372004
    ABGR2101010 = 0x16772004
    YV12 = 0x32315659
    IYUV = 0x56555949
    YUY2 = 0x32595559
    UYVY = 0x59565955
    YVYU = 0x55595659
    NV12 = 0x3231564e
    NV21 = 0x3132564e
    EXTERNAL_OES = 0x2053454f
  end

  struct PixelFormatDetails
    format : PixelFormat
    bits_per_pixel : UInt8
    bytes_per_pixel : UInt8
    padding : UInt8[2]
    r_mask : UInt32
    g_mask : UInt32
    b_mask : UInt32
    a_mask : UInt32
    r_bits : UInt8
    g_bits : UInt8
    b_bits : UInt8
    a_bits : UInt8
    r_shift : UInt8
    g_shift : UInt8
    b_shift : UInt8
    a_shift : UInt8
  end

  struct Color
    r : UInt8
    g : UInt8
    b : UInt8
    a : UInt8
  end

  struct Palette
    ncolors : Int32
    colors : Color*
    version : UInt32
    refcount : Int32
  end

  fun get_pixel_format_details = SDL_GetPixelFormatDetails(format : PixelFormat) : PixelFormatDetails*
  fun map_rgb = SDL_MapRGB(format : PixelFormatDetails*, palette : Palette*, r : UInt8, g : UInt8, b : UInt8) : UInt32
end

module SDL3
  def self.map_rgb(format : LibSDL3::PixelFormatDetails*, r : UInt8, g : UInt8, b : UInt8)
    LibSDL3.map_rgb(format, Pointer(LibSDL3::Palette).null, r, g, b)
  end

  def self.color(r : UInt8, g : UInt8, b : UInt8, a : UInt8) : LibSDL3::Color
    LibSDL3::Color.new(r: r, g: g, b: b, a: a)
  end
end
