require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Texture Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

# Create a surface
surface_color = SDL3::Surface.new(100, 100)

# Fill the surface with a color
color = SDL3.color(255, 0, 0, 255)
surface_color.fill(color)

# Create an IOStream from the image file
iostream = SDL3::IOStream.from_file("./assets/img/player.png", "rb")

# Create a surface from the IOStream
surface_img = SDL3::Surface.load_png_io(iostream, true) # `true` to close the iostream when surface is destroyed

# Create a texture from the surface
texture_color = SDL3::Texture.from_surface(renderer, surface_color)
texture_img = SDL3::Texture.from_surface(renderer, surface_img)

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
  dstrect = SDL3::FRect.new(x: 100.0, y: 100.0, w: 100.0, h: 100.0)
  renderer.render_texture(texture_color, dstrect)

  img_width, img_height = texture_img.size
  dstrect = SDL3::FRect.new(x: 50.0, y: 300.0, w: img_width, h: img_height)
  renderer.render_texture(texture_img, dstrect)

  renderer.present
end

texture_color.destroy
texture_img.destroy
surface_color.destroy
surface_img.destroy
renderer.destroy
window.destroy
SDL3.quit
