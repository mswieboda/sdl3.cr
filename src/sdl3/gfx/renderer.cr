lib LibSDL3
  # SDL_render.h
  alias Renderer = Void

  @[Packed]
  struct Vertex
    fpoint : LibSDL3::FPoint
    fcolor : LibSDL3::FColor
    texture_fpoint : LibSDL3::FPoint
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
  fun get_renderer = SDL_GetRenderer(window : Window*) : Renderer*
  fun get_num_render_drivers = SDL_GetNumRenderDrivers : Int32
  fun get_render_driver = SDL_GetRenderDriver(index : Int32) : UInt8*
  fun get_renderer_name = SDL_GetRendererName(renderer : Renderer*) : UInt8*
  fun get_renderer_properties = SDL_GetRendererProperties(renderer : Renderer*) : PropertiesID
  fun get_gpu_renderer_device = SDL_GetGPURendererDevice(renderer : Renderer*) : GPUDevice*
  fun get_render_output_size = SDL_GetRenderOutputSize(renderer : Renderer*, w : Int32*, h : Int32*) : Bool
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
  fun set_render_scale = SDL_SetRenderScale(renderer : Renderer*, scale_x : Float32, scale_y : Float32) : Bool
  fun get_render_scale = SDL_GetRenderScale(renderer : Renderer*, scale_x : Float32*, scale_y : Float32*) : Bool
  fun set_default_texture_scale_mode = SDL_SetDefaultTextureScaleMode(renderer : Renderer*, scale_mode : ScaleMode) : Bool
  fun get_default_texture_scale_mode = SDL_GetDefaultTextureScaleMode(renderer : Renderer*, scale_mode : ScaleMode*) : Bool
  fun set_render_clip_rect = SDL_SetRenderClipRect(renderer : Renderer*, rect : Rect*) : Bool
  fun get_render_clip_rect = SDL_GetRenderClipRect(renderer : Renderer*, rect : Rect*) : Bool
  fun get_render_coordinates_from_window_coordinates = SDL_GetRenderCoordinatesFromWindowCoordinates(renderer : Renderer*, window_x : Float32, window_y : Float32, x : Float32*, y : Float32*) : Bool
  fun render_coordinates_from_window = SDL_RenderCoordinatesFromWindow(renderer : Renderer*, window_x : Float32, window_y : Float32, x : Float32*, y : Float32*) : Bool

  alias GPURenderState = Void

  @[Packed]
  struct GPURenderStateCreateInfo
    fragment_shader : GPUShader*
    num_sampler_bindings : Int32
    sampler_bindings : GPUTextureSamplerBinding*
    num_storage_textures : Int32
    storage_textures : GPUTexture**
    num_storage_buffers : Int32
    storage_buffers : GPUBuffer**
    props : PropertiesID
  end

  fun create_gpu_render_state = SDL_CreateGPURenderState(renderer : Renderer*, createinfo : GPURenderStateCreateInfo*) : GPURenderState*
  fun set_gpu_render_state_fragment_uniforms = SDL_SetGPURenderStateFragmentUniforms(state : GPURenderState*, slot_index : UInt32, data : Void*, length : UInt32) : Bool
  fun set_gpu_render_state = SDL_SetGPURenderState(renderer : Renderer*, state : GPURenderState*) : Bool
  fun destroy_gpu_render_state = SDL_DestroyGPURenderState(state : GPURenderState*)

  SDL_RENDERER_VSYNC_DISABLED = 0
  SDL_RENDERER_VSYNC_ADAPTIVE = -1

  SDL_PROP_RENDERER_NAME_STRING                               = "SDL.renderer.name"
  SDL_PROP_RENDERER_WINDOW_POINTER                            = "SDL.renderer.window"
  SDL_PROP_RENDERER_SURFACE_POINTER                           = "SDL.renderer.surface"
  SDL_PROP_RENDERER_VSYNC_NUMBER                              = "SDL.renderer.vsync"
  SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER                   = "SDL.renderer.max_texture_size"
  SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER                   = "SDL.renderer.texture_formats"
  SDL_PROP_RENDERER_TEXTURE_WRAPPING_BOOLEAN                  = "SDL.renderer.texture_wrapping"
  SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER                  = "SDL.renderer.output_colorspace"
  SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN                       = "SDL.renderer.HDR_enabled"
  SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT                     = "SDL.renderer.SDR_white_point"
  SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT                        = "SDL.renderer.HDR_headroom"
  SDL_PROP_RENDERER_GPU_DEVICE_POINTER                        = "SDL.renderer.gpu.device"

  SDL_PROP_RENDERER_CREATE_GPU_SHADERS_SPIRV_BOOLEAN          = "SDL.renderer.create.gpu.shaders_spirv"
  SDL_PROP_RENDERER_CREATE_GPU_SHADERS_DXIL_BOOLEAN           = "SDL.renderer.create.gpu.shaders_dxil"
  SDL_PROP_RENDERER_CREATE_GPU_SHADERS_MSL_BOOLEAN            = "SDL.renderer.create.gpu.shaders_msl"
end

struct LibSDL3::Vertex
  def initialize(@fpoint : LibSDL3::FPoint, @fcolor : LibSDL3::FColor, @texture_fpoint : LibSDL3::FPoint)
  end

  def initialize(@fpoint : LibSDL3::FPoint, @fcolor : LibSDL3::FColor)
    @texture_fpoint = LibSDL3::FPoint.new(0_f32, 0_f32)
  end
end

module SDL3
  alias TextureAccess = LibSDL3::TextureAccess
  alias LogicalPresentation = LibSDL3::RendererLogicalPresentation
  alias Vertex = LibSDL3::Vertex

  def self.render_drivers : Array(String)
    count = LibSDL3.get_num_render_drivers
    Array.new(count) do |i|
      String.new(LibSDL3.get_render_driver(i))
    end
  end

  def self.get_renderer_info : Array(String)
    render_drivers
  end

  class Renderer
    @ptr : LibSDL3::Renderer*

    def initialize(window : Window, name : String? = nil)
      name_ptr = name.is_a?(String) ? name.to_unsafe : Pointer(UInt8).null
      ptr = LibSDL3.create_renderer(window.to_unsafe, name_ptr)
      raise "Failed to create renderer" if ptr.null?
      @ptr = ptr
    end

    def name : String
      properties.get_string(LibSDL3::SDL_PROP_RENDERER_NAME_STRING) || "unknown"
    end

    def properties : SDL3::Properties
      SDL3::Properties.new(LibSDL3.get_renderer_properties(to_unsafe))
    end

    def destroy
      LibSDL3.destroy_renderer(to_unsafe)
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
      LibSDL3.render_clear(to_unsafe)
    end

    def clip_rect=(rect : Rect)
      LibSDL3.set_render_clip_rect(to_unsafe, pointerof(rect))
    end

    def clip_rect=(rect : Nil)
      LibSDL3.set_render_clip_rect(to_unsafe, Pointer(LibSDL3::Rect).null)
    end

    def clip_rect : Rect?
      rect = LibSDL3::Rect.new

      if LibSDL3.get_render_clip_rect(to_unsafe, pointerof(rect))
        rect
      else
        nil
      end
    end

    def scale=(val : Tuple(Float32, Float32))
      LibSDL3.set_render_scale(to_unsafe, val[0], val[1])
    end

    def scale : Tuple(Float32, Float32)
      x = 0_f32
      y = 0_f32
      LibSDL3.get_render_scale(to_unsafe, pointerof(x), pointerof(y))
      {x, y}
    end

    def default_texture_scale_mode=(mode : LibSDL3::ScaleMode)
      LibSDL3.set_default_texture_scale_mode(to_unsafe, mode)
    end

    def default_texture_scale_mode : LibSDL3::ScaleMode
      mode = uninitialized LibSDL3::ScaleMode
      LibSDL3.get_default_texture_scale_mode(to_unsafe, pointerof(mode))
      mode
    end

    def present
      LibSDL3.render_present(to_unsafe)
    end

    def draw_point(x : Float32, y : Float32)
      LibSDL3.render_point(to_unsafe, x, y)
    end

    def draw_points(points : Slice(FPoint))
      LibSDL3.render_points(to_unsafe, points.to_unsafe, points.size)
    end

    def draw_line(x1 : Float32, y1 : Float32, x2 : Float32, y2 : Float32)
      LibSDL3.render_line(to_unsafe, x1, y1, x2, y2)
    end

    def draw_lines(points : Slice(FPoint))
      LibSDL3.render_lines(to_unsafe, points.to_unsafe, points.size)
    end

    def draw_rect(rect : FRect)
      LibSDL3.render_rect(to_unsafe, pointerof(rect))
    end

    def draw_rects(rects : Slice(FRect))
      LibSDL3.render_rects(to_unsafe, rects.to_unsafe, rects.size)
    end

    def fill_rect(rect : FRect)
      LibSDL3.render_fill_rect(to_unsafe, pointerof(rect))
    end

    def fill_rects(rects : Slice(FRect))
      LibSDL3.render_fill_rects(to_unsafe, rects.to_unsafe, rects.size)
    end

    def create_texture(format : LibSDL3::PixelFormat, access : Int32, w : Int32, h : Int32)
      ptr = LibSDL3.create_texture(to_unsafe, format, access, w, h)
      raise "Failed to create texture" if ptr.null?
      Texture.new(ptr)
    end

    def render_geometry(texture : Texture, vertices : Array(Vertex), indices : Array(Int32))
      LibSDL3.render_geometry(to_unsafe, texture.to_unsafe, vertices.to_unsafe, vertices.size, indices.to_unsafe, indices.size)
    end

    def render_geometry(vertices : Array(Vertex), indices : Array(Int32))
      LibSDL3.render_geometry(to_unsafe, Pointer(Texture).null, vertices.to_unsafe, vertices.size, indices.to_unsafe, indices.size)
    end

    def render_texture(texture : Texture, source_rect : FRect, dest_rect : FRect)
      LibSDL3.render_texture(to_unsafe, texture.to_unsafe, pointerof(source_rect), pointerof(dest_rect))
    end

    def render_texture(texture : Texture, dest_rect : FRect)
      LibSDL3.render_texture(to_unsafe, texture.to_unsafe, Pointer(FRect).null, pointerof(dest_rect))
    end

    def render_texture(texture : Texture, x : Float32, y : Float32, source_rect : FRect? = nil)
      w, h = texture.size
      dest_rect = SDL3::FRect.new(x: x, y: y, w: w, h: h)

      if rect = source_rect
        render_texture(texture: texture, source_rect: source_rect, dest_rect: dest_rect)
      else
        render_texture(texture: texture, dest_rect: dest_rect)
      end
    end

    def render_texture_rotated(texture : Texture, source_rect : FRect, dest_rect : FRect, angle : Float64 = 0.0, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        to_unsafe,
        texture.to_unsafe,
        pointerof(source_rect),
        pointerof(dest_rect),
        angle,
        Pointer(FPoint).null,
        flip
      )
    end

    def render_texture_rotated(texture : Texture, source_rect : FRect, dest_rect : FRect, angle : Float64 = 0.0, center : FPoint = FPoint.new, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        to_unsafe,
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
        to_unsafe,
        texture.to_unsafe,
        Pointer(FRect).null,
        pointerof(dest_rect),
        angle,
        Pointer(FPoint).null,
        flip
      )
    end

    def render_texture_rotated(texture : Texture, dest_rect : FRect, angle : Float64 = 0.0, center : FPoint = FPoint.new, flip : Int32 = 0)
      LibSDL3.render_texture_rotated(
        to_unsafe,
        texture.to_unsafe,
        Pointer(FRect).null,
        pointerof(dest_rect),
        angle,
        pointerof(center),
        flip
      )
    end

    def render_texture_rotated(texture : Texture, x : Float32, y : Float32, source_rect : FRect?, angle : Float64, center : FPoint, flip : Int32)
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
      LibSDL3.render_debug_text(to_unsafe, x, y, text.to_unsafe)
    end

    def vsync=(vsync : Int32)
      LibSDL3.set_render_vsync(to_unsafe, vsync)
    end

    def blend_mode=(blend_mode : LibSDL3::BlendMode)
      set_render_draw_blend_mode(blend_mode)
    end

    def blend_mode
      get_render_draw_blend_mode
    end

    def set_render_draw_blend_mode(blend_mode : LibSDL3::BlendMode) : Bool
      LibSDL3.set_render_draw_blend_mode(to_unsafe, blend_mode)
    end

    def get_render_draw_blend_mode : LibSDL3::BlendMode
      blend_mode_ptr = uninitialized LibSDL3::BlendMode
      LibSDL3.get_render_draw_blend_mode(to_unsafe, pointerof(blend_mode_ptr))
      blend_mode_ptr
    end

    def render_target=(texture : Texture?)
      set_render_target(texture)
    end

    def set_render_target(texture : Texture?) : Bool
      LibSDL3.set_render_target(to_unsafe, texture ? texture.to_unsafe : Pointer(Void).null)
    end

    def render_target : Texture?
      get_render_target
    end

    def get_render_target : Texture?
      ptr = LibSDL3.get_render_target(to_unsafe)
      if ptr.null?
        nil
      else
        Texture.new(ptr)
      end
    end

    def logical_presentation=(data : Tuple(Int32, Int32, LibSDL3::RendererLogicalPresentation))
      set_logical_presentation(w: data[0], h: data[1], mode: data[2])
    end

    def set_logical_presentation(w : Int32, h : Int32, mode : LibSDL3::RendererLogicalPresentation)
      LibSDL3.set_render_logical_presentation(to_unsafe, w, h, mode)
    end

    def logical_presentation : Tuple(Int32, Int32, LibSDL3::RendererLogicalPresentation)
      w = 0
      h = 0
      mode = LibSDL3::RendererLogicalPresentation::Disabled

      LibSDL3.get_render_logical_presentation(to_unsafe, pointerof(w), pointerof(h), pointerof(mode))

      {w, h, mode}
    end

    def get_logical_presentation(w : Int32*, h : Int32*, mode : LibSDL3::RendererLogicalPresentation*)
      LibSDL3.get_render_logical_presentation(to_unsafe, w, h, mode)
    end

    def create_text_engine : TTF::TextEngine
      TTF::TextEngine.create(self)
    end

    def gpu_device : LibSDL3::GPUDevice*
      LibSDL3.get_gpu_renderer_device(to_unsafe)
    end

    def create_gpu_render_state(create_info : LibSDL3::GPURenderStateCreateInfo) : GPURenderState
      ptr = LibSDL3.create_gpu_render_state(to_unsafe, pointerof(create_info))
      raise "Failed to create GPU render state" if ptr.null?
      GPURenderState.new(ptr)
    end

    def gpu_render_state=(state : GPURenderState?)
      LibSDL3.set_gpu_render_state(to_unsafe, state ? state.to_unsafe : Pointer(LibSDL3::GPURenderState).null)
    end

    def max_texture_size : Int64
      properties.get_number(LibSDL3::SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER)
    end
  end

  class GPURenderState
    @ptr : LibSDL3::GPURenderState*

    def initialize(@ptr)
    end

    def set_fragment_uniforms(slot_index : UInt32, data : Slice(UInt8))
      LibSDL3.set_gpu_render_state_fragment_uniforms(@ptr, slot_index, data.to_unsafe.as(Void*), data.size.to_u32)
    end

    def destroy
      LibSDL3.destroy_gpu_render_state(@ptr)
    end

    def to_unsafe
      @ptr
    end
  end
end
