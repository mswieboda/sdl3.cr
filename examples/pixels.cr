require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init # For displaying text

window = SDL3::Window.new("Pixels Example", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

platform_name = SDL3::Platform.get_platform

# Get details for a common pixel format
format_details = LibSDL3.get_pixel_format_details(LibSDL3::PixelFormat::RGBA8888)
unless format_details
  puts "Failed to get pixel format details: #{SDL3.get_error}"
  exit(1)
end

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

  # Display platform name
  SDL3.render_text(renderer, font, "Platform: #{platform_name}", 10, 10)

  # Display pixel format info (some commented out due to missing bindings)
  # format_name = SDL3::Pixels.get_format_name(LibSDL3::PixelFormat::RGBA8888)
  # SDL3.render_text(renderer, font, "Format: #{format_name}", 10, 40)
  # SDL3.render_text(renderer, font, "Bits per pixel: #{format_details.value.bits_per_pixel}", 10, 70)
  # SDL3.render_text(renderer, font, "Bytes per pixel: #{format_details.value.bytes_per_pixel}", 10, 100)

  # Demonstrate mapping RGB
  r, g, b = 255_u8, 128_u8, 0_u8 # Orange
  pixel_value = SDL3.map_rgb(format_details, r, g, b)
  SDL3.render_text(renderer, font, "Mapped RGB (#{r}, #{g}, #{b}) to Pixel: #{pixel_value}", 10, 130)

  renderer.present
end

font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit

# Helper function for rendering text (extracted from previous examples)
module SDL3
  def self.render_text(renderer : Renderer, font : TTF::Font, text : String, x : Int32, y : Int32)
    text_surface = font.render_text_blended(text, SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: x.to_f32, y: y.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
  end
end
