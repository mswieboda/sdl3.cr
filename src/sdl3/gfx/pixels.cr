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

  struct FColor
    r : Float32
    g : Float32
    b : Float32
    a : Float32
  end

  struct Palette
    ncolors : Int32
    colors : Color*
    version : UInt32
    refcount : Int32
  end

  fun create_palette = SDL_CreatePalette(ncolors : LibC::Int) : Palette*
  # fun set_palette_colors = SDL_SetPaletteColors(palette : Palette*, colors : Color*, firstcolor : LibC::Int, ncolors : LibC::Int) : Bool
  fun destroy_palette = SDL_DestroyPalette(palette : Palette*)

  fun get_pixel_format_details = SDL_GetPixelFormatDetails(format : PixelFormat) : PixelFormatDetails*
  fun map_rgb = SDL_MapRGB(format : PixelFormatDetails*, palette : Palette*, r : UInt8, g : UInt8, b : UInt8) : UInt32
end

struct LibSDL3::Color
  property r : UInt8
  property g : UInt8
  property b : UInt8
  property a : UInt8

  def initialize(@r : UInt8 = 0_u8, @g : UInt8 = 0_u8, @b : UInt8 = 0_u8, @a : UInt8 = 255_u8)
  end

  def to_u32
    (r.to_u32 << 24) | (g.to_u32 << 16) | (b.to_u32 << 8) | a.to_u32
  end

  def to_fcolor
    FColor.new(r: r / 255, g: g / 255, b: b / 255, a: a / 255)
  end

  def to_hex(with_alpha = false)
    hex = "#"
    hex += r.to_s(base: 16, upcase: true)
    hex += g.to_s(base: 16, upcase: true)
    hex += b.to_s(base: 16, upcase: true)
    hex += a.to_s(base: 16, upcase: true) if with_alpha
    hex
  end

  def self.from_hex(hex : String)
    code = hex.lchop('#').lchop("0x")
    alpha = code[6..7].empty? ? "ff" : code[6..7]

    Color.new(
      r: code[0..1].to_u8(base: 16),
      g: code[2..3].to_u8(base: 16),
      b: code[4..5].to_u8(base: 16),
      a: alpha.to_u8(base: 16)
    )
  end

  def self.random(a : UInt8 = 255)
    Color.new(
      r: rand(256),
      g: rand(256),
      b: rand(256),
      a: a
    )
  end

  def self.random_chunks(size : UInt8 = 8, a : UInt8 = 255)
    rand_max = (256 // size) + 1

    Color.new(
      r: rand(rand_max) * size,
      g: rand(rand_max) * size,
      b: rand(rand_max) * size,
      a: a
    )
  end
end

struct LibSDL3::FColor
  property r : Float32
  property g : Float32
  property b : Float32
  property a : Float32

  def initialize(@r : Float32 = 0_f32, @g : Float32 = 0_f32, @b : Float32 = 0_f32, @a : Float32 = 1_f32)
  end

  def to_color : Color
    Color.new(
      r: (r * 255).to_u8,
      g: (g * 255).to_u8,
      b: (b * 255).to_u8,
      a: (a * 255).to_u8
    )
  end

  def self.random(a : Float32 = 1_f32) : FColor
    FColor.new(
      r: rand(1_f32),
      g: rand(1_f32),
      b: rand(1_f32),
      a: a
    )
  end

  def self.random_chunks(size : UInt8 = 8, a : Float32 = 1_f32) : FColor
    rand_max = (1_f32 // size) + 1

    FColor.new(
      r: rand(rand_max) * size,
      g: rand(rand_max) * size,
      b: rand(rand_max) * size,
      a: a
    )
  end
end

module SDL3
  alias Color = LibSDL3::Color
  alias FColor = LibSDL3::FColor
  alias PixelFormat = LibSDL3::PixelFormat

  def self.map_rgb(format : LibSDL3::PixelFormatDetails*, r : UInt8, g : UInt8, b : UInt8)
    LibSDL3.map_rgb(format, Pointer(LibSDL3::Palette).null, r, g, b)
  end

  def self.color(r : UInt8 = 0, g : UInt8 = 0, b : UInt8 = 0, a : UInt8 = 255) : Color
    Color.new(r: r, g: g, b: b, a: a)
  end

  def self.color_all(value : UInt8, a : UInt8 = 255) : Color
    color(r: value, g: value, b: value, a: a)
  end

  def self.fcolor(r : Float32 = 0_f32, g : Float32 = 0_f32, b : Float32 = 0_f32, a : Float32 = 1_f32) : Color
    Color.new(r: r, g: g, b: b, a: a)
  end

  def self.fcolor_all(value : Float32, a : Float32 = 1_f32) : Color
    color(r: value, g: value, b: value, a: a)
  end

  module Pixels
    extend self

    def get_format_name(format : LibSDL3::PixelFormat) : String
      String.new(LibSDL3.get_pixel_format_name(format))
    end

    def get_rgba(pixelvalue : UInt32, format : LibSDL3::PixelFormatDetails*, palette : LibSDL3::Palette? = nil) : Color
      r = 0_u8
      g = 0_u8
      b = 0_u8
      a = 0_u8

      LibSDL3.get_rgba(pixelvalue, format, palette, pointerof(r), pointerof(g), pointerof(b), pointerof(a))

      Color.new(r: r, g: g, b: b, a: a)
    end

    def map_rgba(format : LibSDL3::PixelFormatDetails*, r : UInt8, g : UInt8, b : UInt8, a : UInt8) : UInt32
      LibSDL3.map_rgba(format, Pointer(LibSDL3::Palette).null, r, g, b, a)
    end
  end
end
