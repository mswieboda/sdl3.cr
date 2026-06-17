lib LibSDL3
  # SDL_init.h
  alias InitFlags = UInt32

  SDL_INIT_NONE = 0_u32
  SDL_INIT_VIDEO = 0x00000020_u32
  SDL_INIT_AUDIO = 0x00000010_u32
  SDL_INIT_GAMEPAD = 0x00002000_u32

  HINT_VIDEO_MAC_FULLSCREEN_SPACES = "SDL_VIDEO_MAC_FULLSCREEN_SPACES"

  fun init = SDL_Init(flags : InitFlags) : Bool
  fun quit = SDL_Quit
  fun was_init = SDL_WasInit(flags : InitFlags) : InitFlags
  fun set_hint = SDL_SetHint(name : LibC::Char*, value : LibC::Char*) : Bool
end

module SDL3
  module InitFlags
    None = LibSDL3::SDL_INIT_NONE
    Video = LibSDL3::SDL_INIT_VIDEO
    Audio = LibSDL3::SDL_INIT_AUDIO
    GamePad = LibSDL3::SDL_INIT_GAMEPAD
  end

  extend self

  def init
    init(InitFlags::Video | InitFlags::Audio | InitFlags::GamePad)
  end

  def init(flags : LibSDL3::InitFlags)
    unless LibSDL3.init(flags)
      raise "Failed to initialize SDL"
    end
  end

  def quit
    if init?
      Mixer.quit
      TTF.quit
    end

    LibSDL3.quit
  end

  def init?
    LibSDL3.was_init(InitFlags::None) > 0
  end

  def init?(flags : LibSDL3::InitFlags)
    (LibSDL3.was_init(flags) & flags) == flags
  end

  def set_hint(name : String, value : String)
    LibSDL3.set_hint(name, value)
  end
end
