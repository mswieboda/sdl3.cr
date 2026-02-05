lib LibSDL3
  fun get_ticks = SDL_GetTicks() : UInt64
  fun delay = SDL_Delay(ms : UInt32)
end

module SDL3
  def self.get_ticks
    LibSDL3.get_ticks
  end

  def self.delay(ms : UInt32)
    LibSDL3.delay(ms)
  end
end
