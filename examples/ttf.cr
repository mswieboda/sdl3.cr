require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("TTF Text Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)

# Create a text engine from the renderer
text_engine = SDL3::TTF::TextEngine.create(renderer)

# Open the font
font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 24.0)

# Create a text object
text = text_engine.create_text(font, "SDL3::TTF::Text is cool!")
text.color = SDL3.color(255, 255, 255, 255)

# Create another text object with wrapping
wrapped_text = text_engine.create_text(font, "This text should be wrapped if it is too long for the specified width.")
wrapped_text.color = SDL3.color(0, 255, 0, 255)
wrapped_text.wrap_width = 400

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

  # Draw the text objects
  # Notice how we don't need to create textures or surfaces manually here!
  text.draw(20.0, 20.0)
  wrapped_text.draw(20.0, 80.0)

  renderer.present

  frame_time = SDL3.get_ticks - frame_start
  if frame_time < FRAME_DELAY
    SDL3.delay((FRAME_DELAY - frame_time).to_u32)
  end
end

text.destroy
wrapped_text.destroy
text_engine.destroy
font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit
