lib LibSDL3
  alias Texture = Void

  fun get_texture_size = SDL_GetTextureSize(texture : Texture*, w : Float32*, h : Float32*) : Bool
  fun set_texture_blend_mode = SDL_SetTextureBlendMode(texture : Texture*, blendMode : BlendMode) : Bool
  fun get_texture_blend_mode = SDL_GetTextureBlendMode(texture : Texture*, blendMode : BlendMode*) : Bool
end

module SDL3
  class Texture
    @ptr : LibSDL3::Texture*

    def self.from_surface(renderer : Renderer, surface : Surface)
      ptr = LibSDL3.create_texture_from_surface(renderer.to_unsafe, surface.to_unsafe)
      raise "Failed to create texture from surface" if ptr.null?
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

    def set_blend_mode(blend_mode : LibSDL3::BlendMode) : Bool
      LibSDL3.set_texture_blend_mode(@ptr, blend_mode)
    end

    def get_blend_mode : LibSDL3::BlendMode
      blend_mode_ptr = uninitialized LibSDL3::BlendMode
      LibSDL3.get_texture_blend_mode(@ptr, pointerof(blend_mode_ptr))
      blend_mode_ptr
    end
  end
end
