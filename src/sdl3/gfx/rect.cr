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

module SDL3
  alias Rect = LibSDL3::Rect
  alias FRect = LibSDL3::FRect
  alias FPoint = LibSDL3::FPoint
end
