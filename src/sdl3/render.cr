lib LibSDL3
  # SDL_render.h
  alias Renderer = Void
  
  fun create_renderer = SDL_CreateRenderer(window : Window*, name : UInt8*) : Renderer*
  fun destroy_renderer = SDL_DestroyRenderer(renderer : Renderer*)
  fun set_render_draw_color = SDL_SetRenderDrawColor(renderer : Renderer*, r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Bool
  fun render_clear = SDL_RenderClear(renderer : Renderer*) : Bool
  fun render_present = SDL_RenderPresent(renderer : Renderer*) : Bool
  fun render_point = SDL_RenderPoint(renderer : Renderer*, x : Float32, y : Float32) : Bool
  fun render_points = SDL_RenderPoints(renderer : Renderer*, points : FPoint*, count : Int32) : Bool
  fun render_line = SDL_RenderLine(renderer : Renderer*, x1 : Float32, y1 : Float32, x2 : Float32, y2 : Float32) : Bool
  fun render_lines = SDL_RenderLines(renderer : Renderer*, points : FPoint*, count : Int32) : Bool
  fun render_rect = SDL_RenderRect(renderer : Renderer*, rect : FRect*) : Bool
  fun render_rects = SDL_RenderRects(renderer : Renderer*, rects : FRect*, count : Int32) : Bool
  fun render_fill_rect = SDL_RenderFillRect(renderer : Renderer*, rect : FRect*) : Bool
  fun render_fill_rects = SDL_RenderFillRects(renderer : Renderer*, rects : FRect*, count : Int32) : Bool
  fun create_texture = SDL_CreateTexture(renderer : Renderer*, format : PixelFormat, access : Int32, w : Int32, h : Int32) : Texture*
  fun create_texture_from_surface = SDL_CreateTextureFromSurface(renderer : Renderer*, surface : Surface*) : Texture*
  fun destroy_texture = SDL_DestroyTexture(texture : Texture*)
  fun render_texture = SDL_RenderTexture(renderer : Renderer*, texture : Texture*, srcrect : FRect*, dstrect : FRect*) : Bool
  fun render_texture_rotated = SDL_RenderTextureRotated(renderer : Renderer*, texture : Texture*, srcrect : FRect*, dstrect : FRect*, angle : Float64, center : FPoint*, flip : Int32) : Bool
  fun render_debug_text = SDL_RenderDebugText(renderer : Renderer*, x : Float32, y : Float32, text : UInt8*) : Bool
  fun set_render_vsync = SDL_SetRenderVSync(renderer : Renderer*, vsync : Int32) : Bool
  fun get_texture_size = SDL_GetTextureSize(texture : Texture*, w : Float32*, h : Float32*) : Bool

  SDL_RENDERER_VSYNC_DISABLED = 0
  SDL_RENDERER_VSYNC_ADAPTIVE = -1
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

    def draw_point(x : Float32, y : Float32)
      LibSDL3.render_point(@ptr, x, y)
    end

    def draw_points(points : Slice(LibSDL3::FPoint))
      LibSDL3.render_points(@ptr, points.to_unsafe, points.size)
    end

    def draw_line(x1 : Float32, y1 : Float32, x2 : Float32, y2 : Float32)
      LibSDL3.render_line(@ptr, x1, y1, x2, y2)
    end

    def draw_lines(points : Slice(LibSDL3::FPoint))
      LibSDL3.render_lines(@ptr, points.to_unsafe, points.size)
    end

    def draw_rect(rect : LibSDL3::FRect*)
      LibSDL3.render_rect(@ptr, rect)
    end

    def draw_rects(rects : Slice(LibSDL3::FRect))
      LibSDL3.render_rects(@ptr, rects.to_unsafe, rects.size)
    end

    def fill_rect(rect : LibSDL3::FRect*)
      LibSDL3.render_fill_rect(@ptr, rect)
    end

    def fill_rects(rects : Slice(LibSDL3::FRect))
      LibSDL3.render_fill_rects(@ptr, rects.to_unsafe, rects.size)
    end

    def create_texture(format : LibSDL3::PixelFormat, access : Int32, w : Int32, h : Int32)
      ptr = LibSDL3.create_texture(@ptr, format, access, w, h)
      raise "Failed to create texture" if ptr.null?
      Texture.new(ptr)
    end

    def render_texture(texture : Texture, source_rect : LibSDL3::FRect, dest_rect : LibSDL3::FRect)
      LibSDL3.render_texture(@ptr, texture.to_unsafe, pointerof(source_rect), pointerof(dest_rect))
    end

    def render_texture(texture : Texture, dest_rect : LibSDL3::FRect)
      LibSDL3.render_texture(@ptr, texture.to_unsafe, Pointer(LibSDL3::FRect).null, pointerof(dest_rect))
    end

    def render_texture(texture : Texture, x : Float32, y : Float32, source_rect : LibSDL3::FRect?)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      if rect = source_rect
        render_texture(texture: texture, source_rect: source_rect, dest_rect: dest_rect)
      else
        render_texture(texture: texture, dest_rect: dest_rect)
      end
    end

    def render_texture_rotated(texture : Texture, source_rect : LibSDL3::FRect, dest_rect : FRect, angle : Float64, center : FPoint*, flip : Int32)
      LibSDL3.render_texture_rotated(@ptr, texture.to_unsafe, pointerof(source_rect), pointerof(dest_rect), angle, center, flip)
    end

    def render_texture_rotated(texture : Texture, dest_rect : FRect, angle : Float64, center : FPoint*, flip : Int32)
      LibSDL3.render_texture_rotated(@ptr, texture.to_unsafe, Pointer(LibSDL3::FRect).null, pointerof(dest_rect), angle, center, flip)
    end

    def render_texture_rotated(texture : Texture, x : Float32, y : Float32, source_rect : LibSDL3::FRect?, angle : Float64, center : FPoint*, flip : Int32)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      if rect = source_rect
        render_texture(texture: texture, source_rect: source_rect, dest_rect: dest_rect, angle, center, flip)
      else
        render_texture(texture: texture, dest_rect: dest_rect, angle, center, flip)
      end
    end

    def render_debug_text(x : Float32, y : Float32, text : String)
      LibSDL3.render_debug_text(@ptr, x, y, text.to_unsafe)
    end

    def set_vsync(vsync : Int32)
      LibSDL3.set_render_vsync(@ptr, vsync)
    end
  end
end
