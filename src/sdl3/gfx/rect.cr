lib LibSDL3
  struct FPoint
    x : Float32
    y : Float32
  end

  struct FRect
    x : Float32
    y : Float32
    w : Float32
    h : Float32
  end

  struct Rect
    x : Int32
    y : Int32
    w : Int32
    h : Int32
  end
end


struct LibSDL3::FPoint
  def initialize(@x : Float32 = 0_f32, @y : Float32 = 0_f32)
  end
end

struct LibSDL3::FRect
  def initialize(@x : Float32 = 0_f32, @y : Float32 = 0_f32, @w : Float32 = 0_f32, @h : Float32 = 0_f32)
  end

  def width
    w
  end

  def width=(width : Float32)
    self.w = width
  end

  def height
    h
  end

  def height=(height : Float32)
    self.h = height
  end

  def to_rect
    LibSDL3::Rect.new(x: x.to_i, y: y.to_i, w: w.to_i, h: h.to_i)
  end
end

struct LibSDL3::Rect
  def initialize(@x : Int32 = 0, @y : Int32 = 0, @w : Int32 = 0, @h : Int32 = 0)
  end

  def width
    w
  end

  def width=(width : Int32)
    self.w = width
  end

  def height
    h
  end

  def height=(height : Int32)
    self.h = height
  end

  def to_frect
    LibSDL3::FRect.new(x: x.to_f32, y: y.to_f32, w: w.to_f32, h: h.to_f32)
  end
end

module SDL3
  alias Rect = LibSDL3::Rect
  alias FRect = LibSDL3::FRect
  alias FPoint = LibSDL3::FPoint
end
