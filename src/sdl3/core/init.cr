lib LibSDL3
  # SDL_init.h
  alias InitFlags = UInt32

  SDL_INIT_VIDEO = 0x00000020_u32
  SDL_INIT_AUDIO = 0x00000010_u32

  fun init = SDL_Init(flags : InitFlags) : Bool
  fun quit = SDL_Quit
  fun was_init = SDL_WasInit(flags : InitFlags) : InitFlags
end

module SDL3
  extend self

  def init(flags : LibSDL3::InitFlags)
    unless LibSDL3.init(flags)
      raise "Failed to initialize SDL"
    end
  end

  def quit
    LibSDL3.quit
  end

  def was_init(flags : LibSDL3::InitFlags)
    LibSDL3.was_init(flags)
  end
end
