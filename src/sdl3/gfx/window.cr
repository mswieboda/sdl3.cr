lib LibSDL3
  # SDL_video.h
  alias Window = Void
  alias WindowFlags = UInt64

  SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000_u32
  SDL_WINDOWPOS_CENTERED  = 0x2FFF0000_u32

  SDL_WINDOW_FULLSCREEN          = 0x0000000000000001_u64
  SDL_WINDOW_OPENGL              = 0x0000000000000002_u64
  SDL_WINDOW_OCCLUDED            = 0x0000000000000004_u64
  SDL_WINDOW_HIDDEN              = 0x0000000000000008_u64
  SDL_WINDOW_BORDERLESS          = 0x0000000000000010_u64
  SDL_WINDOW_RESIZABLE           = 0x0000000000000020_u64
  SDL_WINDOW_MINIMIZED           = 0x0000000000000040_u64
  SDL_WINDOW_MAXIMIZED           = 0x0000000000000080_u64
  SDL_WINDOW_MOUSE_GRABBED       = 0x0000000000000100_u64
  SDL_WINDOW_INPUT_FOCUS         = 0x0000000000000200_u64
  SDL_WINDOW_MOUSE_FOCUS         = 0x0000000000000400_u64
  SDL_WINDOW_EXTERNAL            = 0x0000000000000800_u64
  SDL_WINDOW_MODAL               = 0x0000000000001000_u64
  SDL_WINDOW_HIGH_PIXEL_DENSITY  = 0x0000000000002000_u64
  SDL_WINDOW_MOUSE_CAPTURE       = 0x0000000000004000_u64
  SDL_WINDOW_MOUSE_RELATIVE_MODE = 0x0000000000008000_u64
  SDL_WINDOW_ALWAYS_ON_TOP       = 0x0000000000010000_u64
  SDL_WINDOW_UTILITY             = 0x0000000000020000_u64
  SDL_WINDOW_TOOLTIP             = 0x0000000000040000_u64
  SDL_WINDOW_POPUP_MENU          = 0x0000000000080000_u64
  SDL_WINDOW_KEYBOARD_GRABBED    = 0x0000000000100000_u64
  SDL_WINDOW_FILL_DOCUMENT       = 0x0000000000200000_u64
  SDL_WINDOW_VULKAN              = 0x0000000010000000_u64
  SDL_WINDOW_METAL               = 0x0000000020000000_u64
  SDL_WINDOW_TRANSPARENT         = 0x0000000040000000_u64
  SDL_WINDOW_NOT_FOCUSABLE       = 0x0000000080000000_u64

  fun create_window = SDL_CreateWindow(title : UInt8*, w : Int32, h : Int32, flags : WindowFlags) : Window*
  fun destroy_window = SDL_DestroyWindow(window : Window*)
  fun get_window_size = SDL_GetWindowSize(window : Window*, w : Int32*, h : Int32*) : Bool
  fun set_window_resizable = SDL_SetWindowResizable(window : Window*, resizable : Bool) : Bool
end

module SDL3
  class Window
    @ptr : LibSDL3::Window*

    @[Flags]
    enum Flags : LibSDL3::WindowFlags
      None              = 0
      Fullscreen        = LibSDL3::SDL_WINDOW_FULLSCREEN
      OpenGL            = LibSDL3::SDL_WINDOW_OPENGL
      Occluded          = LibSDL3::SDL_WINDOW_OCCLUDED
      Hidden            = LibSDL3::SDL_WINDOW_HIDDEN
      Borderless        = LibSDL3::SDL_WINDOW_BORDERLESS
      Resizable         = LibSDL3::SDL_WINDOW_RESIZABLE
      Minimized         = LibSDL3::SDL_WINDOW_MINIMIZED
      Maximized         = LibSDL3::SDL_WINDOW_MAXIMIZED
      MouseGrabbed      = LibSDL3::SDL_WINDOW_MOUSE_GRABBED
      InputFocus        = LibSDL3::SDL_WINDOW_INPUT_FOCUS
      MouseFocus        = LibSDL3::SDL_WINDOW_MOUSE_FOCUS
      External          = LibSDL3::SDL_WINDOW_EXTERNAL
      Modal             = LibSDL3::SDL_WINDOW_MODAL
      HighPixelDensity  = LibSDL3::SDL_WINDOW_HIGH_PIXEL_DENSITY
      MouseCapture      = LibSDL3::SDL_WINDOW_MOUSE_CAPTURE
      MouseRelativeMode = LibSDL3::SDL_WINDOW_MOUSE_RELATIVE_MODE
      AlwaysOnTop       = LibSDL3::SDL_WINDOW_ALWAYS_ON_TOP
      Utility           = LibSDL3::SDL_WINDOW_UTILITY
      Tooltip           = LibSDL3::SDL_WINDOW_TOOLTIP
      PopupMenu         = LibSDL3::SDL_WINDOW_POPUP_MENU
      KeyboardGrabbed   = LibSDL3::SDL_WINDOW_KEYBOARD_GRABBED
      FillDocument      = LibSDL3::SDL_WINDOW_FILL_DOCUMENT
      Vulkan            = LibSDL3::SDL_WINDOW_VULKAN
      Metal             = LibSDL3::SDL_WINDOW_METAL
      Transparent       = LibSDL3::SDL_WINDOW_TRANSPARENT
      NotFocusable      = LibSDL3::SDL_WINDOW_NOT_FOCUSABLE
    end

    def initialize(title : String, w : Int32, h : Int32, flags : Flags | LibSDL3::WindowFlags | Int = WindowFlags::None)
      f = case flags
          when Flags then flags.value
          else flags.to_u64
          end
      ptr = LibSDL3.create_window(title.to_unsafe, w, h, f)
      raise "Failed to create window" if ptr.null?
      @ptr = ptr
    end

    def self.new(title : String, w : Int32, h : Int32, flags : Array(Flags))
      merged_flags = Flags::None
      flags.each { |flag| merged_flags |= flag }
      new(title, w, h, merged_flags)
    end

    def destroy
      LibSDL3.destroy_window(@ptr)
    end

    def resizable=(resizable : Bool)
      LibSDL3.set_window_resizable(@ptr, resizable)
    end

    def size : Tuple(Int32, Int32)
      w = 0
      h = 0
      LibSDL3.get_window_size(@ptr, pointerof(w), pointerof(h))
      {w, h}
    end

    def to_unsafe
      @ptr
    end
  end
end
