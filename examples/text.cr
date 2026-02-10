require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("Text Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)

# Open the font
font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 24.0)

# Render text to a surface
text_surface = font.render_text_blended("Hello, SDL3 TTF!", SDL3.color(255, 255, 255, 255))

# Create a texture from the surface
text_texture = SDL3::Texture.from_surface(renderer, text_surface)

# Create an IOStream from the font file
font_file_path = "./assets/fonts/PressStart2P.ttf"
font_iostream = SDL3::IOStream.from_file(font_file_path, "rb")

# Open the font from IOStream
font_io = SDL3::TTF::Font.open_io(font_iostream, 18.0, true) # `true` to close the iostream when font is closed

# Render second text to a surface
text_io_surface = font_io.render_text_blended("Loaded via IOStream!", SDL3.color(0, 255, 0, 255))

# Create a texture from the second surface
text_io_texture = SDL3::Texture.from_surface(renderer, text_io_surface)

FRAME_DELAY = (1000 // 60).to_u64

running = true
while running
  frame_start = SDL3.get_ticks

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

  # Render the text texture
  dstrect = LibSDL3::FRect.new(x: 10.0, y: 10.0, w: text_surface.to_unsafe.value.w.to_f, h: text_surface.to_unsafe.value.h.to_f)
  renderer.render_texture(text_texture, dstrect)

  # Render the second text texture
  dstrect_io = LibSDL3::FRect.new(x: 10.0, y: 50.0, w: text_io_surface.to_unsafe.value.w.to_f, h: text_io_surface.to_unsafe.value.h.to_f)
  renderer.render_texture(text_io_texture, dstrect_io)

  renderer.present

  frame_time = SDL3.get_ticks - frame_start
  if frame_time < FRAME_DELAY
    SDL3.delay((FRAME_DELAY - frame_time).to_u32)
  end
end

text_io_texture.destroy
text_io_surface.destroy
font_io.close
text_texture.destroy
text_surface.destroy
font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit
