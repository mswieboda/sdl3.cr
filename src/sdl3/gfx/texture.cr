lib LibSDL3
  alias Texture = Void

  fun get_texture_size = SDL_GetTextureSize(texture : Texture*, w : Float32*, h : Float32*) : Bool
  fun set_texture_blend_mode = SDL_SetTextureBlendMode(texture : Texture*, blendMode : BlendMode) : Bool
  fun get_texture_blend_mode = SDL_GetTextureBlendMode(texture : Texture*, blendMode : BlendMode*) : Bool
  fun set_texture_color_mod = SDL_SetTextureColorMod(texture : Texture*, r : UInt8, g : UInt8, b : UInt8) : Bool
  fun get_texture_color_mod = SDL_GetTextureColorMod(texture : Texture*, r : UInt8*, g : UInt8*, b : UInt8*) : Bool
  fun set_texture_alpha_mod = SDL_SetTextureAlphaMod(texture : Texture*, alpha : UInt8) : Bool
  fun get_texture_alpha_mod = SDL_GetTextureAlphaMod(texture : Texture*, alpha : UInt8*) : Bool
  fun set_texture_scale_mode = SDL_SetTextureScaleMode(texture : Texture*, scaleMode : ScaleMode) : Bool
  fun get_texture_scale_mode = SDL_GetTextureScaleMode(texture : Texture*, scaleMode : ScaleMode*) : Bool
  fun update_texture = SDL_UpdateTexture(texture : Texture*, rect : Rect*, pixels : Void*, pitch : Int32) : Bool
  fun lock_texture = SDL_LockTexture(texture : Texture*, rect : Rect*, pixels : Void**, pitch : Int32*) : Bool
  fun unlock_texture = SDL_UnlockTexture(texture : Texture*)
end

module SDL3
  class Texture
    @ptr : LibSDL3::Texture*

    def self.from_surface(renderer : Renderer, surface : Surface)
      ptr = LibSDL3.create_texture_from_surface(renderer.to_unsafe, surface.to_unsafe)
      raise "Failed to create texture from surface" if ptr.null?
      new(ptr)
    end

    def self.create(
      renderer : Renderer,
      format : PixelFormat,
      access : TextureAccess,
      w : Int32,
      h : Int32
    )
      ptr = LibSDL3.create_texture(renderer.to_unsafe, format, access, w, h)
      raise "Failed to create texture" if ptr.null?
      new(ptr)
    end

    def initialize(@ptr : LibSDL3::Texture*); end

    def destroy
      LibSDL3.destroy_texture(@ptr)
    end

    def to_unsafe
      @ptr
    end

    def size : Tuple(Float32, Float32)
      w = 0.0_f32
      h = 0.0_f32
      LibSDL3.get_texture_size(@ptr, pointerof(w), pointerof(h))
      {w, h}
    end

    def blend_mode=(blend_mode : LibSDL3::BlendMode)
      LibSDL3.set_texture_blend_mode(@ptr, blend_mode)
    end

    def blend_mode : LibSDL3::BlendMode
      blend_mode_ptr = uninitialized LibSDL3::BlendMode
      LibSDL3.get_texture_blend_mode(@ptr, pointerof(blend_mode_ptr))
      blend_mode_ptr
    end

    def color_mod=(color : Color)
      LibSDL3.set_texture_color_mod(to_unsafe, color.r, color.g, color.b)
    end

    def alpha_mod=(alpha : UInt8)
      LibSDL3.set_texture_alpha_mod(to_unsafe, alpha)
    end

    def tint=(color : Color)
      LibSDL3.set_texture_color_mod(to_unsafe, color.r, color.g, color.b)
      LibSDL3.set_texture_alpha_mod(to_unsafe, color.a)
    end

    def tint : Color
      r = 0_u8
      g = 0_u8
      b = 0_u8
      a = 0_u8

      LibSDL3.get_texture_color_mod(@ptr, pointerof(r), pointerof(g), pointerof(b))
      LibSDL3.get_texture_alpha_mod(@ptr, pointerof(a))

      Color.new(r: r, g: g, b: b, a: a)
    end

    def scale_mode=(scale_mode : LibSDL3::ScaleMode) : Bool
      LibSDL3.set_texture_scale_mode(@ptr, scale_mode)
    end

    def scale_mode : LibSDL3::ScaleMode
      scale_mode_ptr = uninitialized LibSDL3::ScaleMode
      LibSDL3.get_texture_scale_mode(@ptr, pointerof(scale_mode_ptr))
      scale_mode_ptr
    end

    def update(rect : LibSDL3::Rect?, pixels : Pointer(Void), pitch : Int32) : Bool
      LibSDL3.update_texture(@ptr, rect.try(&.pointerof), pixels, pitch)
    end

    def lock(rect : LibSDL3::Rect?) : Tuple(Pointer(Void), Int32)
      pixels_ptr = uninitialized Pointer(Void)
      pitch = uninitialized Int32
      success = LibSDL3.lock_texture(@ptr, rect.try(&.pointerof), pointerof(pixels_ptr), pointerof(pitch))
      raise "Failed to lock texture" unless success
      {pixels_ptr, pitch}
    end

    def unlock : Void
      LibSDL3.unlock_texture(@ptr)
    end
  end
end
