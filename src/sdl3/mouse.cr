lib LibSDL3
  alias Cursor = Void

  enum SystemCursor
    DEFAULT
    TEXT
    WAIT
    CROSSHAIR
    PROGRESS
    NWSE_RESIZE
    NESW_RESIZE
    EW_RESIZE
    NS_RESIZE
    MOVE
    NOT_ALLOWED
    POINTER
    NW_RESIZE
    N_RESIZE
    NE_RESIZE
    E_RESIZE
    SE_RESIZE
    S_RESIZE
    SW_RESIZE
    W_RESIZE
    COUNT
  end

  fun get_mouse_state = SDL_GetMouseState(x : Float32*, y : Float32*) : UInt32
  fun get_global_mouse_state = SDL_GetGlobalMouseState(x : Float32*, y : Float32*) : UInt32
  fun get_relative_mouse_state = SDL_GetRelativeMouseState(x : Float32*, y : Float32*) : UInt32
  fun warp_mouse_in_window = SDL_WarpMouseInWindow(window : Window*, x : Float32, y : Float32)
  fun warp_mouse_global = SDL_WarpMouseGlobal(x : Float32, y : Float32) : Bool
  fun set_relative_mouse_mode = SDL_SetRelativeMouseMode(window : Window*, enabled : Bool) : Bool
  fun capture_mouse = SDL_CaptureMouse(enabled : Bool) : Bool
  fun create_cursor = SDL_CreateCursor(data : UInt8*, mask : UInt8*, w : Int32, h : Int32, hot_x : Int32, hot_y : Int32) : Cursor*
  fun create_color_cursor = SDL_CreateColorCursor(surface : Surface*, hot_x : Int32, hot_y : Int32) : Cursor*
  fun create_system_cursor = SDL_CreateSystemCursor(id : SystemCursor) : Cursor*
  fun set_cursor = SDL_SetCursor(cursor : Cursor*) : Bool
  fun get_cursor = SDL_GetCursor() : Cursor*
  fun get_default_cursor = SDL_GetDefaultCursor() : Cursor*
  fun destroy_cursor = SDL_DestroyCursor(cursor : Cursor*)
  fun show_cursor = SDL_ShowCursor() : Bool
  fun hide_cursor = SDL_HideCursor() : Bool
  fun cursor_visible = SDL_CursorVisible() : Bool
end

module SDL3
  module Mouse
    extend self

    def get_state
      x = 0.0_f32
      y = 0.0_f32
      state = LibSDL3.get_mouse_state(pointerof(x), pointerof(y))
      {state, x, y}
    end

    def get_global_state
      x = 0.0_f32
      y = 0.0_f32
      state = LibSDL3.get_global_mouse_state(pointerof(x), pointerof(y))
      {state, x, y}
    end

    def get_relative_state
      x = 0.0_f32
      y = 0.0_f32
      state = LibSDL3.get_relative_mouse_state(pointerof(x), pointerof(y))
      {state, x, y}
    end

    def warp_in_window(window : Window, x : Float32, y : Float32)
      LibSDL3.warp_mouse_in_window(window.to_unsafe, x, y)
    end

    def warp_global(x : Float32, y : Float32)
      LibSDL3.warp_mouse_global(x, y)
    end

    def set_relative_mode(window : Window, enabled : Bool)
      LibSDL3.set_relative_mouse_mode(window.to_unsafe, enabled)
    end

    def capture(enabled : Bool)
      LibSDL3.capture_mouse(enabled)
    end

    class Cursor
      @ptr : LibSDL3::Cursor*

      def self.create(data : UInt8*, mask : UInt8*, w : Int32, h : Int32, hot_x : Int32, hot_y : Int32)
        ptr = LibSDL3.create_cursor(data, mask, w, h, hot_x, hot_y)
        raise "Failed to create cursor" if ptr.null?
        new(ptr)
      end

      def self.create_color(surface : Surface, hot_x : Int32, hot_y : Int32)
        ptr = LibSDL3.create_color_cursor(surface.to_unsafe, hot_x, hot_y)
        raise "Failed to create color cursor" if ptr.null?
        new(ptr)
      end

      def self.create_system(id : LibSDL3::SystemCursor)
        ptr = LibSDL3.create_system_cursor(id)
        raise "Failed to create system cursor" if ptr.null?
        new(ptr)
      end

      def initialize(@ptr : LibSDL3::Cursor*); end

      def destroy
        LibSDL3.destroy_cursor(@ptr)
      end

      def to_unsafe
        @ptr
      end
    end

    def set_cursor(cursor : Cursor)
      LibSDL3.set_cursor(cursor.to_unsafe)
    end

    def get_cursor
      ptr = LibSDL3.get_cursor
      ptr.null? ? nil : Cursor.new(ptr)
    end

    def get_default_cursor
      ptr = LibSDL3.get_default_cursor
      ptr.null? ? nil : Cursor.new(ptr)
    end

    def show
      LibSDL3.show_cursor
    end

    def hide
      LibSDL3.hide_cursor
    end

    def visible?
      LibSDL3.cursor_visible
    end
  end
end
