require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Geometry Test", 640, 480, 0)
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

  # Draw a red rectangle
  renderer.draw_color = {255_u8, 0_u8, 0_u8, 255_u8}
  rect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.draw_rect(pointerof(rect))

  # Draw a green filled rectangle
  renderer.draw_color = {0_u8, 255_u8, 0_u8, 255_u8}
  filled_rect = LibSDL3::FRect.new(x: 350.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.fill_rect(pointerof(filled_rect))

  # Draw a blue line
  renderer.draw_color = {0_u8, 0_u8, 255_u8, 255_u8}
  renderer.draw_line(100.0, 300.0, 550.0, 450.0)

  renderer.present
end

renderer.destroy
window.destroy
SDL3.quit
