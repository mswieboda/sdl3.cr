require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Texture Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

# Create a surface
surface = SDL3::Surface.new(100, 100, LibSDL3::PixelFormat::RGBA8888)

# Fill the surface with a color
details = LibSDL3.get_pixel_format_details(surface.to_unsafe.value.format)
color = SDL3.map_rgb(details, 255_u8, 0_u8, 0_u8)
surface.fill_rect(color)

# Create a texture from the surface
texture = SDL3::Texture.from_surface(renderer, surface)

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
  dstrect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: 100.0, h: 100.0)
  renderer.render_texture(texture, dstrect)

  renderer.present
end

texture.destroy
surface.destroy
renderer.destroy
window.destroy
SDL3.quit
