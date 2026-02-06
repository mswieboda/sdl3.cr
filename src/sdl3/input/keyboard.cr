lib LibSDL3
  fun get_keyboard_state = SDL_GetKeyboardState(numkeys : Int32*) : Bool*
  fun get_mod_state = SDL_GetModState() : Keymod
  fun get_key_from_scancode = SDL_GetKeyFromScancode(scancode : Scancode, modstate : Keymod, key_event : Bool) : Keycode
  fun get_scancode_from_key = SDL_GetScancodeFromKey(key : Keycode, modstate : Keymod*) : Scancode
  fun get_key_name = SDL_GetKeyName(key : Keycode) : UInt8*
  fun get_scancode_name = SDL_GetScancodeName(scancode : Scancode) : UInt8*
  fun start_text_input = SDL_StartTextInput(window : Window*) : Bool
  fun stop_text_input = SDL_StopTextInput(window : Window*) : Bool
  fun text_input_active = SDL_TextInputActive(window : Window*) : Bool
end

module SDL3
  def self.get_keyboard_state
    numkeys = 0
    ptr = LibSDL3.get_keyboard_state(pointerof(numkeys))
    Slice.new(ptr, numkeys)
  end

  def self.get_mod_state
    LibSDL3.get_mod_state
  end

  def self.get_key_from_scancode(scancode : LibSDL3::Scancode, modstate : LibSDL3::Keymod, key_event : Bool)
    LibSDL3.get_key_from_scancode(scancode, modstate, key_event)
  end

  def self.get_scancode_from_key(key : LibSDL3::Keycode)
    modstate = 0_u16
    LibSDL3.get_scancode_from_key(key, pointerof(modstate))
  end

  def self.get_key_name(key : LibSDL3::Keycode)
    String.new(LibSDL3.get_key_name(key))
  end

  def self.get_scancode_name(scancode : LibSDL3::Scancode)
    String.new(LibSDL3.get_scancode_name(scancode))
  end

  def self.start_text_input(window : Window)
    LibSDL3.start_text_input(window.to_unsafe)
  end

  def self.stop_text_input(window : Window)
    LibSDL3.stop_text_input(window.to_unsafe)
  end

  def self.text_input_active(window : Window)
    LibSDL3.text_input_active(window.to_unsafe)
  end
end
