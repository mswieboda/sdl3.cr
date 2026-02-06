lib LibSDL3
  # SDL_gamepad.h

  # Opaque Structs
  alias Gamepad = Void
  alias Joystick = Void # From SDL_joystick.h, used in SDL_GetGamepadJoystick

  struct GUID
    data : StaticArray(UInt8, 16)
  end

  # Enums
  enum GamepadType : LibC::Int
    Unknown = 0
    Standard = 1
    Xbox360 = 2
    XboxOne = 3
    PS3 = 4
    PS4 = 5
    PS5 = 6
    NintendoSwitchPro = 7
    NintendoSwitchJoyConLeft = 8
    NintendoSwitchJoyConRight = 9
    NintendoSwitchJoyConPair = 10
    GameCube = 11
    Count = 12
  end

  enum GamepadButton : LibC::Int
    Invalid = -1
    South = 0
    East = 1
    West = 2
    North = 3
    Back = 4
    Guide = 5
    Start = 6
    LeftStick = 7
    RightStick = 8
    LeftShoulder = 9
    RightShoulder = 10
    DPADUp = 11
    DPADDown = 12
    DPADLeft = 13
    DPADRight = 14
    Misc1 = 15
    RightPaddle1 = 16
    LeftPaddle1 = 17
    RightPaddle2 = 18
    LeftPaddle2 = 19
    Touchpad = 20
    Misc2 = 21
    Misc3 = 22
    Misc4 = 23
    Misc5 = 24
    Misc6 = 25
    Count = 26
  end

  enum GamepadAxis : LibC::Int
    Invalid = -1
    LeftX = 0
    LeftY = 1
    RightX = 2
    RightY = 3
    LeftTrigger = 4
    RightTrigger = 5
    Count = 6
  end

  # Structs
  # SDL_GamepadBinding - leaving out for now due to complex union structure
  # For now, let's just expose the functions that use simpler types

  # Functions
  fun add_gamepad_mapping = SDL_AddGamepadMapping(mapping : LibC::Char*) : LibC::Int
  fun add_gamepad_mappings_from_file = SDL_AddGamepadMappingsFromFile(file : LibC::Char*) : LibC::Int
  fun reload_gamepad_mappings = SDL_ReloadGamepadMappings() : Bool
  fun has_gamepad = SDL_HasGamepad() : Bool
  fun get_gamepads = SDL_GetGamepads(count : LibC::Int*) : JoystickID*
  fun is_gamepad = SDL_IsGamepad(instance_id : JoystickID) : Bool
  fun get_gamepad_name_for_id = SDL_GetGamepadNameForID(instance_id : JoystickID) : LibC::Char*
  fun get_gamepad_type_for_id = SDL_GetGamepadTypeForID(instance_id : JoystickID) : GamepadType
  fun get_gamepad_guid_for_id = SDL_GetGamepadGUIDForID(instance_id : JoystickID) : GUID # Assuming GUID is defined in version.cr
  fun get_gamepad_vendor_for_id = SDL_GetGamepadVendorForID(instance_id : JoystickID) : UInt16
  fun get_gamepad_product_for_id = SDL_GetGamepadProductForID(instance_id : JoystickID) : UInt16
  fun get_gamepad_product_version_for_id = SDL_GetGamepadProductVersionForID(instance_id : JoystickID) : UInt16

  fun open_gamepad = SDL_OpenGamepad(instance_id : JoystickID) : Gamepad*
  fun get_gamepad_from_id = SDL_GetGamepadFromID(instance_id : JoystickID) : Gamepad*
  fun get_gamepad_id = SDL_GetGamepadID(gamepad : Gamepad*) : JoystickID
  fun get_gamepad_name = SDL_GetGamepadName(gamepad : Gamepad*) : LibC::Char*
  fun get_gamepad_type = SDL_GetGamepadType(gamepad : Gamepad*) : GamepadType
  fun get_gamepad_player_index = SDL_GetGamepadPlayerIndex(gamepad : Gamepad*) : LibC::Int
  fun get_gamepad_vendor = SDL_GetGamepadVendor(gamepad : Gamepad*) : UInt16
  fun get_gamepad_product = SDL_GetGamepadProduct(gamepad : Gamepad*) : UInt16
  fun get_gamepad_product_version = SDL_GetGamepadProductVersion(gamepad : Gamepad*) : UInt16
  fun get_gamepad_axis = SDL_GetGamepadAxis(gamepad : Gamepad*, axis : GamepadAxis) : Int16
  fun get_gamepad_button = SDL_GetGamepadButton(gamepad : Gamepad*, button : GamepadButton) : Bool

  fun rumble_gamepad = SDL_RumbleGamepad(gamepad : Gamepad*, low_frequency_rumble : UInt16, high_frequency_rumble : UInt16, duration_ms : UInt32) : Bool
  fun rumble_gamepad_triggers = SDL_RumbleGamepadTriggers(gamepad : Gamepad*, left_rumble : UInt16, right_rumble : UInt16, duration_ms : UInt32) : Bool
  fun set_gamepad_led = SDL_SetGamepadLED(gamepad : Gamepad*, red : UInt8, green : UInt8, blue : UInt8) : Bool
  fun close_gamepad = SDL_CloseGamepad(gamepad : Gamepad*)

  fun set_gamepad_events_enabled = SDL_SetGamepadEventsEnabled(enabled : Bool)
  fun gamepad_events_enabled = SDL_GamepadEventsEnabled() : Bool
  fun update_gamepads = SDL_UpdateGamepads()

end

module SDL3
  module Gamepad
    extend self

    def has_gamepad : Bool
      LibSDL3.has_gamepad
    end

    def get_gamepads : Tuple(Array(LibSDL3::JoystickID), LibC::Int)
      count = uninitialized LibC::Int
      gamepad_ids_ptr = LibSDL3.get_gamepads(pointerof(count))

      if gamepad_ids_ptr.null? || count <= 0
        {[] of LibSDL3::JoystickID, 0}
      else
        gamepad_ids = Array(LibSDL3::JoystickID).new(count) do |i|
          (gamepad_ids_ptr + i).value
        end
        LibSDL3.free(gamepad_ids_ptr)
        {gamepad_ids, count}
      end
    end

    def open_gamepad(instance_id : LibSDL3::JoystickID) : GamepadWrapper?
      gamepad_ptr = LibSDL3.open_gamepad(instance_id)
      if gamepad_ptr.null?
        nil
      else
        GamepadWrapper.new(gamepad_ptr)
      end
    end

    # Wrapper class for SDL_Gamepad*
    class GamepadWrapper
      @ptr : LibSDL3::Gamepad*

      def initialize(@ptr : LibSDL3::Gamepad*)
      end

      def destroy
        LibSDL3.close_gamepad(@ptr)
      end

      def to_unsafe
        @ptr
      end

      def id : LibSDL3::JoystickID
        LibSDL3.get_gamepad_id(@ptr)
      end

      def name : String
        String.new(LibSDL3.get_gamepad_name(@ptr))
      end

      def type : GamepadType
        LibSDL3.get_gamepad_type(@ptr)
      end

      def player_index : LibC::Int
        LibSDL3.get_gamepad_player_index(@ptr)
      end

      def vendor : UInt16
        LibSDL3.get_gamepad_vendor(@ptr)
      end

      def product : UInt16
        LibSDL3.get_gamepad_product(@ptr)
      end

      def product_version : UInt16
        LibSDL3.get_gamepad_product_version(@ptr)
      end

      def axis(axis_type : GamepadAxis) : Int16
        LibSDL3.get_gamepad_axis(@ptr, axis_type)
      end

      def button(button_type : GamepadButton) : Bool
        LibSDL3.get_gamepad_button(@ptr, button_type)
      end

      def rumble(low_frequency_rumble : UInt16, high_frequency_rumble : UInt16, duration_ms : UInt32) : Bool
        LibSDL3.rumble_gamepad(@ptr, low_frequency_rumble, high_frequency_rumble, duration_ms)
      end

      def rumble_triggers(left_rumble : UInt16, right_rumble : UInt16, duration_ms : UInt32) : Bool
        LibSDL3.rumble_gamepad_triggers(@ptr, left_rumble, right_rumble, duration_ms)
      end

      def set_led(red : UInt8, green : UInt8, blue : UInt8) : Bool
        LibSDL3.set_gamepad_led(@ptr, red, green, blue)
      end
    end
  end
end
