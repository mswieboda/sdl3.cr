lib LibSDL3
  enum ScaleMode : Int32
    None = 0
    Linear = 1
    Best = 2
  end
  struct Surface
    flags : UInt32
    format : LibSDL3::PixelFormat
    w : Int32
    h : Int32
    pitch : Int32
    pixels : Void*
    refcount : Int32
    reserved : Void*
  end
  fun create_surface = SDL_CreateSurface(width : Int32, height : Int32, format : PixelFormat) : Surface*
  fun destroy_surface = SDL_DestroySurface(surface : Surface*)
  fun load_bmp = SDL_LoadBMP(file : UInt8*) : Surface*
  fun fill_surface_rect = SDL_FillSurfaceRect(surface : Surface*, rect : Rect*, color : UInt32) : Bool

  fun load_surface_io = SDL_LoadSurface_IO(src : IOStream*, closeio : Bool) : Surface*
  fun load_bmp_io = SDL_LoadBMP_IO(src : IOStream*, closeio : Bool) : Surface*
  fun load_png_io = SDL_LoadPNG_IO(src : IOStream*, closeio : Bool) : Surface*
end

module SDL3
  class Surface
    @ptr : LibSDL3::Surface*

    def initialize(width : Int32, height : Int32, format : LibSDL3::PixelFormat = LibSDL3::PixelFormat::RGBA8888)
      ptr = LibSDL3.create_surface(width, height, format)
      raise "Failed to create surface" if ptr.null?
      @ptr = ptr
    end

    def self.load_bmp(file : String)
      ptr = LibSDL3.load_bmp(file.to_unsafe)
      raise "Failed to load BMP" if ptr.null?
      new(ptr)
    end

    def self.load_io(io_stream : IOStream, close_io : Bool = false)
      ptr = LibSDL3.load_surface_io(io_stream.to_unsafe, close_io)
      raise "Failed to load surface from IO stream" if ptr.null?
      new(ptr)
    end

    def self.load_bmp_io(io_stream : IOStream, close_io : Bool = false)
      ptr = LibSDL3.load_bmp_io(io_stream.to_unsafe, close_io)
      raise "Failed to load BMP from IO stream" if ptr.null?
      new(ptr)
    end

    def self.load_png_io(io_stream : IOStream, close_io : Bool = false)
      ptr = LibSDL3.load_png_io(io_stream.to_unsafe, close_io)
      raise "Failed to load PNG from IO stream" if ptr.null?
      new(ptr)
    end

    def initialize(@ptr : LibSDL3::Surface*); end

    def destroy
      LibSDL3.destroy_surface(@ptr)
    end

    def to_unsafe
      @ptr
    end

    def fill_rect(rect : LibSDL3::Rect, color : Color)
      LibSDL3.fill_surface_rect(@ptr, pointerof(rect), SDL3.color_to_u32(color))
    end

    def fill(color : Color)
      LibSDL3.fill_surface_rect(@ptr, Pointer(LibSDL3::Rect).null, SDL3.color_to_u32(color))
    end
  end
end
