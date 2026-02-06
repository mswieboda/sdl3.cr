lib LibSDL3
  fun get_error = SDL_GetError() : UInt8*
  fun set_error = SDL_SetError(fmt : UInt8*, ...) : Bool
  fun clear_error = SDL_ClearError() : Bool
end

module SDL3
  def self.get_error
    String.new(LibSDL3.get_error)
  end

  def self.clear_error
    LibSDL3.clear_error
  end
end
