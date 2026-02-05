@[Link("SDL3_image")]
lib LibSDL3Image
  fun version = IMG_Version() : Int32
  fun load = IMG_Load(file : UInt8*) : LibSDL3::Surface*
  fun load_texture = IMG_LoadTexture(renderer : LibSDL3::Renderer*, file : UInt8*) : LibSDL3::Texture*

  alias InitFlags = Int32
  # According to documentation, IMG_Init and IMG_Quit are no longer necessary in SDL_image 3.0.
  # So, no need to bind IMG_Init and IMG_Quit.
end

module SDL3
  module Image
    extend self

    def version
      LibSDL3Image.version
    end

    def load(file : String) : Surface
      ptr = LibSDL3Image.load(file.to_unsafe)
      raise "Failed to load image: #{file}" if ptr.null?
      Surface.new(ptr)
    end

    def load_texture(renderer : Renderer, file : String) : Texture
      ptr = LibSDL3Image.load_texture(renderer.to_unsafe, file.to_unsafe)
      raise "Failed to load texture: #{file}" if ptr.null?
      Texture.new(ptr)
    end
  end
end
