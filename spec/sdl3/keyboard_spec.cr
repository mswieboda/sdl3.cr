require "../spec_helper"

describe "SDL3 keyboard" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
  end

  it "handles a keydown event" do
    event = uninitialized LibSDL3::Event
    event.type = LibSDL3::SDL_EVENT_KEY_DOWN
    event.key.scancode = LibSDL3::Scancode::A
    SDL3.push_event(pointerof(event))

    found_key_event = false
    while SDL3.poll_event(pointerof(event))
      if event.type == LibSDL3::SDL_EVENT_KEY_DOWN
        if event.key.scancode == LibSDL3::Scancode::A
          found_key_event = true
          break
        end
      end
    end

    found_key_event.should be_true
  end
end
