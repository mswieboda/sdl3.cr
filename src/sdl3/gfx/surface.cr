lib LibSDL3
  enum ScaleMode : Int32
    Invalid = -1
    Nearest =  0
    Linear  =  1
    PixelArt = 2
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

  fun blit_surface = SDL_BlitSurface(src : Surface*, srcrect : Rect*, dst : Surface*, dstrect : Rect*) : Bool
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

    def initialize(width : Int32 = 0, height : Int32 = 0, format : LibSDL3::PixelFormat = LibSDL3::PixelFormat::RGBA8888)
      ptr = LibSDL3.create_surface(width, height, format)
      raise "Failed to create surface" if ptr.null?
      @ptr = ptr
    end

    def self.load_bmp(file : String)
      ptr = LibSDL3.load_bmp(file.to_unsafe)
      raise "Failed to load BMP" if ptr.null?
      new(ptr)
    end

    def self.load_png(file : String)
      iostream = IOStream.from_file(file, "rb")
      ptr = LibSDL3.load_png_io(iostream.to_unsafe, true)
      raise "Failed to load PNG: #{SDL3.get_error}" if ptr.null?
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

    def format
      @ptr.value.format
    end

    def w
      @ptr.value.w
    end

    def width
      w
    end

    def h
      @ptr.value.h
    end

    def height
      h
    end

    def blit(source_rect : LibSDL3::Rect?, dest_rect : LibSDL3::Rect?, dest_surface : Surface) : Bool
      if source_rect.is_a?(LibSDL3::Rect) && dest_rect.is_a?(LibSDL3::Rect)
        src = source_rect.as(LibSDL3::Rect)
        dst = dest_rect.as(LibSDL3::Rect)
        LibSDL3.blit_surface(@ptr, pointerof(src), dest_surface.to_unsafe, pointerof(dst))
      elsif source_rect.is_a?(LibSDL3::Rect)
        src = source_rect.as(LibSDL3::Rect)
        LibSDL3.blit_surface(@ptr, pointerof(src), dest_surface.to_unsafe, Pointer(LibSDL3::Rect).null)
      elsif dest_rect.is_a?(LibSDL3::Rect)
        dst = dest_rect.as(LibSDL3::Rect)
        LibSDL3.blit_surface(@ptr, Pointer(LibSDL3::Rect).null, dest_surface.to_unsafe, pointerof(dst))
      else
        LibSDL3.blit_surface(@ptr, Pointer(LibSDL3::Rect).null, dest_surface.to_unsafe, Pointer(LibSDL3::Rect).null)
      end
    end

    def destroy
      LibSDL3.destroy_surface(@ptr)
    end

    def to_unsafe
      @ptr
    end

    def fill_rect(rect : LibSDL3::Rect, color : Color)
      LibSDL3.fill_surface_rect(@ptr, pointerof(rect), color.to_u32)
    end

    def fill(color : Color)
      LibSDL3.fill_surface_rect(@ptr, Pointer(LibSDL3::Rect).null, color.to_u32)
    end

    def self.create_text_engine : TTF::TextEngine
      TTF::TextEngine.create_surface_text_engine
    end

    def draw_text(text : TTF::Text, x : Float32, y : Float32) : Bool
      LibSDL3TTF.draw_surface_text(text.to_unsafe, x, y, to_unsafe)
    end
  end
end
