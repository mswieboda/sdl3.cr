require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Image Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

# Load the first image
texture = SDL3::Image.load_texture(renderer, "./assets/img/player.png")
w, h = texture.size

# Create an IOStream from the image file
image_file_path = "./assets/img/player.png"
image_iostream = SDL3::IOStream.from_file(image_file_path, "rb")

# Load the second texture from IOStream
texture_io = SDL3::Image.load_texture_io(renderer, image_iostream, true) # `true` to close the iostream when texture is destroyed
w_io, h_io = texture_io.size

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

  # Render the first texture
  dstrect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: w, h: h)
  renderer.render_texture(texture, dstrect)

  # Render the second texture
  dstrect_io = LibSDL3::FRect.new(x: 100.0, y: 300.0, w: w_io, h: h_io) # Render next to the first one
  renderer.render_texture(texture_io, dstrect_io)

  renderer.present
end

texture_io.destroy
texture.destroy
renderer.destroy
window.destroy
SDL3.quit