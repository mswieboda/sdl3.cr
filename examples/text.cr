require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Text Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)

running = true
while running
  event = uninitialized LibSDL3::Event
  while SDL3.poll_event(pointerof(event))
    case event.type
    when LibSDL3::SDL_EVENT_QUIT, LibSDL3::SDL_EVENT_WINDOW_CLOSE_REQUESTED
      running = false
    when LibSDL3::SDL_EVENT_KEY_DOWN
      if event.key.key == LibSDL3::ESCAPE
        running = false
      end
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Render debug text
  renderer.draw_color = {255_u8, 255_u8, 255_u8, 255_u8}
  renderer.render_debug_text(10.0, 10.0, "Hello, SDL3!")
  renderer.render_debug_text(10.0, 30.0, "This is debug text.")

  renderer.present
end

renderer.destroy
window.destroy
SDL3.quit
