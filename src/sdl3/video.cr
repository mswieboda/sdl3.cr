lib LibSDL3
  # SDL_video.h
  alias Window = Void
  alias WindowFlags = UInt64

  SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000_u32
  SDL_WINDOWPOS_CENTERED = 0x2FFF0000_u32

  fun create_window = SDL_CreateWindow(title : UInt8*, w : Int32, h : Int32, flags : WindowFlags) : Window*
  fun destroy_window = SDL_DestroyWindow(window : Window*)
end

module SDL3
  class Window
    @ptr : LibSDL3::Window*

    def initialize(title : String, w : Int32, h : Int32, flags : LibSDL3::WindowFlags)
      ptr = LibSDL3.create_window(title.to_unsafe, w, h, flags)
      raise "Failed to create window" if ptr.null?
      @ptr = ptr
    end

    def destroy
      LibSDL3.destroy_window(@ptr)
    end

    def to_unsafe
      @ptr
    end
  end
end
