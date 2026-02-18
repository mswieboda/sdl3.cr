lib LibSDL3
  # SDL_render.h
  alias Renderer = Void

  struct Vertex
    position : LibSDL3::FPoint
    color : LibSDL3::FColor
    tex_coord : LibSDL3::FPoint
  end

  enum TextureAccess : Int32
    Static = 0
    Streaming = 1
    Target = 2
  end

  enum RendererLogicalPresentation : Int32
    Disabled = 0
    Stretch = 1
    Letterbox = 2
    Overscan = 3
    IntegerScale = 4
  end
  
  fun create_renderer = SDL_CreateRenderer(window : Window*, name : UInt8*) : Renderer*
  fun destroy_renderer = SDL_DestroyRenderer(renderer : Renderer*)
  fun get_render_draw_color = SDL_GetRenderDrawColor(renderer : Renderer*, r : UInt8*, g : UInt8*, b : UInt8*, a : UInt8*) : Bool
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
  fun render_geometry = SDL_RenderGeometry(renderer : Renderer*, texture : Texture*, vertices : Vertex*, num_vertices : Int32, indices : Int32*, num_indices : Int32) : Bool
  fun render_texture = SDL_RenderTexture(renderer : Renderer*, texture : Texture*, srcrect : FRect*, dstrect : FRect*) : Bool
  fun render_texture_rotated = SDL_RenderTextureRotated(renderer : Renderer*, texture : Texture*, srcrect : FRect*, dstrect : FRect*, angle : Float64, center : FPoint*, flip : Int32) : Bool
  fun render_debug_text = SDL_RenderDebugText(renderer : Renderer*, x : Float32, y : Float32, text : UInt8*) : Bool
  fun set_render_vsync = SDL_SetRenderVSync(renderer : Renderer*, vsync : Int32) : Bool
  fun get_texture_size = SDL_GetTextureSize(texture : Texture*, w : Float32*, h : Float32*) : Bool
  fun set_render_draw_blend_mode = SDL_SetRenderDrawBlendMode(renderer : Renderer*, blendMode : BlendMode) : Bool
  fun get_render_draw_blend_mode = SDL_GetRenderDrawBlendMode(renderer : Renderer*, blendMode : BlendMode*) : Bool
  fun set_render_logical_presentation = SDL_SetRenderLogicalPresentation(renderer : Renderer*, w : Int32, h : Int32, mode : RendererLogicalPresentation) : Bool
  fun get_render_logical_presentation = SDL_GetRenderLogicalPresentation(renderer : Renderer*, w : Int32*, h : Int32*, mode : RendererLogicalPresentation*) : Bool
  fun set_render_target = SDL_SetRenderTarget(renderer : Renderer*, texture : Texture*) : Bool
  fun get_render_target = SDL_GetRenderTarget(renderer : Renderer*) : Texture*

  SDL_RENDERER_VSYNC_DISABLED = 0
  SDL_RENDERER_VSYNC_ADAPTIVE = -1
end

struct LibSDL3::Vertex
  property position : LibSDL3::FPoint
  property color : LibSDL3::FColor
  property tex_coord : LibSDL3::FPoint

  def initialize (x : Float32, y : Float32, @color : LibSDL3::FColor)
    @position = LibSDL3::FPoint.new(x: x, y: y)
    @tex_coord = LibSDL3::FPoint.new(x: 0_f32, y: 0_f32)
  end

  def initialize (@position : LibSDL3::FPoint, @color : LibSDL3::FColor, @tex_coord : LibSDL3::FColor)
  end
end

module SDL3
  alias LogicalPresentation = LibSDL3::RendererLogicalPresentation
  alias Vertex = LibSDL3::Vertex

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

    def draw_color : Color
      r = 0_u8
      g = 0_u8
      b = 0_u8
      a = 0_u8

      LibSDL3.get_render_draw_color(to_unsafe, pointerof(r), pointerof(g), pointerof(b), pointerof(a))

      Color.new(r: r, g: g, b: b, a: a)
    end

    def draw_color=(color : Tuple(UInt8, UInt8, UInt8, UInt8))
      LibSDL3.set_render_draw_color(to_unsafe, color[0], color[1], color[2], color[3])
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

    def draw_rect(rect : LibSDL3::FRect)
      LibSDL3.render_rect(@ptr, pointerof(rect))
    end

    def draw_rects(rects : Slice(LibSDL3::FRect))
      LibSDL3.render_rects(@ptr, rects.to_unsafe, rects.size)
    end

    def fill_rect(rect : LibSDL3::FRect)
      LibSDL3.render_fill_rect(@ptr, pointerof(rect))
    end

    def fill_rects(rects : Slice(LibSDL3::FRect))
      LibSDL3.render_fill_rects(@ptr, rects.to_unsafe, rects.size)
    end

    def create_texture(format : LibSDL3::PixelFormat, access : Int32, w : Int32, h : Int32)
      ptr = LibSDL3.create_texture(@ptr, format, access, w, h)
      raise "Failed to create texture" if ptr.null?
      Texture.new(ptr)
    end

    def render_geometry(texture : Texture, vertices : Array(Vertex), indices : Array(Int32))
      LibSDL3.render_geometry(to_unsafe, texture.to_unsafe, vertices.to_unsafe, vertices.size, indices.to_unsafe, indices.size)
    end

    def render_geometry(vertices : Array(Vertex), indices : Array(Int32))
      LibSDL3.render_geometry(to_unsafe, Pointer(Texture).null, vertices.to_unsafe, vertices.size, indices.to_unsafe, indices.size)
    end

    def render_texture(texture : Texture, source_rect : LibSDL3::FRect, dest_rect : LibSDL3::FRect)
      LibSDL3.render_texture(@ptr, texture.to_unsafe, pointerof(source_rect), pointerof(dest_rect))
    end

    def render_texture(texture : Texture, dest_rect : LibSDL3::FRect)
      LibSDL3.render_texture(@ptr, texture.to_unsafe, Pointer(LibSDL3::FRect).null, pointerof(dest_rect))
    end

    def render_texture(texture : Texture, x : Float32, y : Float32, source_rect : LibSDL3::FRect? = nil)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      if rect = source_rect
        render_texture(texture: texture, source_rect: source_rect, dest_rect: dest_rect)
      else
        render_texture(texture: texture, dest_rect: dest_rect)
      end
    end

    def render_texture_rotated(texture : Texture, source_rect : LibSDL3::FRect, dest_rect : FRect, angle : Float64 = 0.0, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        @ptr,
        texture.to_unsafe,
        pointerof(source_rect),
        pointerof(dest_rect),
        angle,
        Pointer(LibSDL3::FPoint).null,
        flip
      )
    end

    def render_texture_rotated(texture : Texture, source_rect : LibSDL3::FRect, dest_rect : FRect, angle : Float64 = 0.0, center : FPoint = FPoint.new, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        @ptr,
        texture.to_unsafe,
        pointerof(source_rect),
        pointerof(dest_rect),
        angle,
        pointerof(center),
        flip
      )
    end

    def render_texture_rotated(texture : Texture, dest_rect : FRect, angle : Float64 = 0.0, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        @ptr,
        texture.to_unsafe,
        Pointer(LibSDL3::FRect).null,
        pointerof(dest_rect),
        angle,
        Pointer(LibSDL3::FPoint).null,
        flip
      )
    end

    def render_texture_rotated(texture : Texture, dest_rect : FRect, angle : Float64 = 0.0, center : FPoint = FPoint.new, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        @ptr,
        texture.to_unsafe,
        Pointer(LibSDL3::FRect).null,
        pointerof(dest_rect),
        angle,
        pointerof(center),
        flip
      )
    end

    def render_texture_rotated(texture : Texture, x : Float32, y : Float32, source_rect : LibSDL3::FRect?, angle : Float64, center : FPoint, flip : Int32)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      if rect = source_rect
        render_texture_rotated(texture: texture, source_rect: source_rect, dest_rect: dest_rect, angle: angle, center: pointerof(center), flip: flip)
      else
        render_texture_rotated(texture: texture, dest_rect: dest_rect, angle: angle, center: pointerof(center), flip: flip)
      end
    end

    def render_texture_rotated(texture : Texture, x : Float32, y : Float32, angle : Float64 = 0.0, flip : Int32 = 0)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      render_texture_rotated(texture: texture, dest_rect: dest_rect, angle: angle, flip: flip)
    end

    def render_debug_text(x : Float32, y : Float32, text : String)
      LibSDL3.render_debug_text(@ptr, x, y, text.to_unsafe)
    end

    def set_vsync(vsync : Int32)
      LibSDL3.set_render_vsync(@ptr, vsync)
    end

    def set_render_draw_blend_mode(blend_mode : LibSDL3::BlendMode) : Bool
      LibSDL3.set_render_draw_blend_mode(@ptr, blend_mode)
    end

    def get_render_draw_blend_mode : LibSDL3::BlendMode
      blend_mode_ptr = uninitialized LibSDL3::BlendMode
      LibSDL3.get_render_draw_blend_mode(@ptr, pointerof(blend_mode_ptr))
      blend_mode_ptr
    end

    def set_render_target(texture : Texture?) : Bool
      LibSDL3.set_render_target(@ptr, texture.try(&.to_unsafe))
    end

    def get_render_target : Texture?
      ptr = LibSDL3.get_render_target(@ptr)
      if ptr.null?
        nil
      else
        Texture.new(ptr)
      end
    end

    def set_logical_presentation(w : Int32, h : Int32, mode : LibSDL3::RendererLogicalPresentation)
      LibSDL3.set_render_logical_presentation(@ptr, w, h, mode)
    end

    def get_logical_presentation(w : Int32, h : Int32, mode : LibSDL3::RendererLogicalPresentation)
      ptr = LibSDL3.get_render_logical_presentation(@ptr, pointerof(w), pointerof(h), pointerof(mode))
    end

    def create_text_engine : TTF::TextEngine
      TTF::TextEngine.create(self)
    end
  end
end
