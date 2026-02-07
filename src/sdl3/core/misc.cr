lib LibSDL3
  # SDL_misc.h
  fun open_url = SDL_OpenURL(url : LibC::Char*) : Bool
end

module SDL3
  module Misc
    extend self

    def open_url(url : String) : Bool
      LibSDL3.open_url(url.to_unsafe)
    end
  end
end
