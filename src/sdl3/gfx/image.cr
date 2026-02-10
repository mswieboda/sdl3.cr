@[Link("SDL3_image")]
lib LibSDL3Image
  fun version = IMG_Version() : Int32
  fun load = IMG_Load(file : LibC::Char*) : LibSDL3::Surface*
  fun load_texture = IMG_LoadTexture(renderer : LibSDL3::Renderer*, file : LibC::Char*) : LibSDL3::Texture*

  fun load_io = IMG_Load_IO(src : LibSDL3::IOStream*, closeio : Bool) : LibSDL3::Surface*
  fun load_typed_io = IMG_LoadTyped_IO(src : LibSDL3::IOStream*, closeio : Bool, type : LibC::Char*) : LibSDL3::Surface*
  fun load_texture_io = IMG_LoadTexture_IO(renderer : LibSDL3::Renderer*, src : LibSDL3::IOStream*, closeio : Bool) : LibSDL3::Texture*
  fun load_texture_typed_io = IMG_LoadTextureTyped_IO(renderer : LibSDL3::Renderer*, src : LibSDL3::IOStream*, closeio : Bool, type : LibC::Char*) : LibSDL3::Texture*
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

    def load_io(io_stream : IOStream, close_io : Bool = false) : Surface
      ptr = LibSDL3Image.load_io(io_stream.to_unsafe, close_io)
      raise "Failed to load image from IO stream" if ptr.null?
      Surface.new(ptr)
    end

    def load_typed_io(io_stream : IOStream, type : String, close_io : Bool = false) : Surface
      ptr = LibSDL3Image.load_typed_io(io_stream.to_unsafe, close_io, type.to_unsafe)
      raise "Failed to load typed image from IO stream" if ptr.null?
      Surface.new(ptr)
    end

    def load_texture_io(renderer : Renderer, io_stream : IOStream, close_io : Bool = false) : Texture
      ptr = LibSDL3Image.load_texture_io(renderer.to_unsafe, io_stream.to_unsafe, close_io)
      raise "Failed to load texture from IO stream" if ptr.null?
      Texture.new(ptr)
    end

    def load_texture_typed_io(renderer : Renderer, io_stream : IOStream, type : String, close_io : Bool = false) : Texture
      ptr = LibSDL3Image.load_texture_typed_io(renderer.to_unsafe, io_stream.to_unsafe, close_io, type.to_unsafe)
      raise "Failed to load typed texture from IO stream" if ptr.null?
      Texture.new(ptr)
    end

    def load_texture(renderer : Renderer, file : String) : Texture
      ptr = LibSDL3Image.load_texture(renderer.to_unsafe, file.to_unsafe)
      raise "Failed to load texture: #{file}" if ptr.null?
      Texture.new(ptr)
    end
  end
end
