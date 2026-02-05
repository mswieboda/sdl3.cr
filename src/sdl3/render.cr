lib LibSDL3
  # SDL_render.h
  alias Renderer = Void
  
  fun create_renderer = SDL_CreateRenderer(window : Window*, name : UInt8*) : Renderer*
  fun destroy_renderer = SDL_DestroyRenderer(renderer : Renderer*)
  fun set_render_draw_color = SDL_SetRenderDrawColor(renderer : Renderer*, r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Bool
  fun render_clear = SDL_RenderClear(renderer : Renderer*) : Bool
  fun render_present = SDL_RenderPresent(renderer : Renderer*) : Bool
end

module SDL3
  class Renderer
    @ptr : LibSDL3::Renderer*

    def initialize(window : Window, name : String? = nil)
      name_ptr = name.is_a?(String) ? name.to_unsafe : Pointer(UInt8).null
      ptr = LibSDL3.create_renderer(window.to_unsafe, name_ptr)
      raise "Failed to create renderer" if ptr.null?
      @ptr = ptr
    end

    def destroy
      LibSDL3.destroy_renderer(@ptr)
    end

    def to_unsafe
      @ptr
    end

    def draw_color=(color : Tuple(UInt8, UInt8, UInt8, UInt8))
      LibSDL3.set_render_draw_color(@ptr, color[0], color[1], color[2], color[3])
    end

    def clear
      LibSDL3.render_clear(@ptr)
    end

    def present
      LibSDL3.render_present(@ptr)
    end
  end
end
