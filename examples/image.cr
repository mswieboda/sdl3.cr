require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Image Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

# Load the image
texture = SDL3::Image.load_texture(renderer, "./assets/img/player.png")
w, h = texture.size

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

  # Render the texture
  dstrect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: w, h: h)
  renderer.render_texture(texture, dstrect)

  renderer.present
end

texture.destroy
renderer.destroy
window.destroy
SDL3.quit