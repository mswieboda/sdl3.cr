lib LibSDL3
  alias Texture = Void
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
  end
end
