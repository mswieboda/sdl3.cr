lib LibSDL3
  # SDL_platform.h
  fun get_platform = SDL_GetPlatform() : LibC::Char*
end

module SDL3
  module Platform
    extend self

    def get_platform : String
      String.new(LibSDL3.get_platform)
    end
  end
end
