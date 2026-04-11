require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("Open URL Example", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

button_rect = LibSDL3::FRect.new(x: 220.0, y: 200.0, w: 200.0, h: 50.0)
button_text = "Open URL"

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
    when LibSDL3::SDL_EVENT_MOUSE_BUTTON_UP
      mouse_x = event.button.x
      mouse_y = event.button.y

      if event.button.button == 1 &&
         mouse_x >= button_rect.x && mouse_x <= (button_rect.x + button_rect.w) &&
         mouse_y >= button_rect.y && mouse_y <= (button_rect.y + button_rect.h)
        puts "Attempting to open URL: https://www.libsdl.org"
        if SDL3::Misc.open_url("https://www.libsdl.org")
          puts "Successfully requested to open URL."
        else
          puts "Failed to open URL: #{SDL3.get_error}"
        end
      end
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Draw Button
  renderer.draw_color = {100_u8, 100_u8, 100_u8, 255_u8}
  renderer.fill_rect(button_rect)
  renderer.draw_color = {200_u8, 200_u8, 200_u8, 255_u8}
  text_surface = font.render_text_blended(button_text, SDL3.color(255, 255, 255, 255))
  text_texture = SDL3::Texture.from_surface(renderer, text_surface)
  text_w, text_h = text_texture.size
  text_x = button_rect.x + (button_rect.w - text_w) / 2
  text_y = button_rect.y + (button_rect.h - text_h) / 2
  text_dstrect = LibSDL3::FRect.new(x: text_x, y: text_y, w: text_w, h: text_h)
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
