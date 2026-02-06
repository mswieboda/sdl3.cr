require "../spec_helper"

describe "SDL3 Gamepad" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_GAMEPAD)
  end

  after_each do
    SDL3.quit
  end

  # NOTE: gamepad won't be connected during spec runs
  #   but at least this spec checks checking for has_gamepad, get_gamepads
  #   and makes sure those bindings don't error/crash

  it "checks for gamepad presence" do
    SDL3::Gamepad.has_gamepad.should be_false
  end

  it "gets gamepad devices (if any)" do
    gamepad_ids, count = SDL3::Gamepad.get_gamepads
    count.should be >= 0
    gamepad_ids.size.should eq(count)
  end

  it "opens and closes a gamepad (if available)" do
    gamepad_ids, count = SDL3::Gamepad.get_gamepads

    if count > 0
      first_gamepad_id = gamepad_ids.first

      gamepad = SDL3::Gamepad.open_gamepad(first_gamepad_id)
      gamepad.should_not be_nil

      name = gamepad.not_nil!.name
      name.should_not be_empty

      gamepad.not_nil!.destroy
    else
      # No gamepads found to test opening/closing
    end
  end

  # Add more specific tests if a gamepad is reliably available in CI
end
