require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("Platform Example", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

platform_name = SDL3::Platform.get_platform
puts "Running on platform: #{platform_name}"

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

  text_surface = font.render_text_blended("Platform: #{platform_name}", SDL3.color(255, 255, 255, 255))
  text_texture = SDL3::Texture.from_surface(renderer, text_surface)
  text_w, text_h = text_texture.size
  text_dstrect = LibSDL3::FRect.new(x: 10.0, y: 10.0, w: text_w, h: text_h)
  renderer.render_texture(text_texture, text_dstrect)
  text_texture.destroy
  text_surface.destroy

  renderer.present
end

font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit
