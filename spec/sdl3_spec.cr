require "./spec_helper"
require "../src/sdl3"

describe SDL3 do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
  end

  it "initializes and quits SDL video subsystem" do
    SDL3.was_init(LibSDL3::SDL_INIT_VIDEO).should eq(LibSDL3::SDL_INIT_VIDEO)
  end

  it "creates and destroys a window" do
    window = SDL3::Window.new("Test Window", 100, 100, 0)
    window.destroy
  end

  it "creates and destroys a renderer" do
    window = SDL3::Window.new("Test Renderer Window", 100, 100, 0)
    renderer = SDL3::Renderer.new(window)
    renderer.destroy
    window.destroy
  end

  it "handles a quit event" do
    event = uninitialized LibSDL3::Event
    event.type = LibSDL3::SDL_EVENT_QUIT
    SDL3.push_event(pointerof(event))

    found_quit_event = false
    while SDL3.poll_event(pointerof(event))
      if event.type == LibSDL3::SDL_EVENT_QUIT
        found_quit_event = true
        break
      end
    end

    found_quit_event.should be_true
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