describe "SDL3 events" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
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
end
