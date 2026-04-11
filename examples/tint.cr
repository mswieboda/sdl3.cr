require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Tint Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

path = "./assets/img/player.png"
tint1 = SDL3::Color.new(r: 255, a: 128)
tint2 = SDL3::Color.new(g: 255, a: 128)

# Create an IOStream from the image file
iostream = SDL3::IOStream.from_file(path, "rb")

# Create a surface from the IOStream
surface_img = SDL3::Surface.load_png_io(iostream, true) # `true` to close the iostream when surface is destroyed

# Create a texture from the surface
texture_surface_img = SDL3::Texture.from_surface(renderer, surface_img)

# Create a texture with SDL3::Image
texture_img = SDL3::Image.load_texture(renderer, path)

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

  # clear
  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Render the textures
  draw_texture_tinted(r: renderer, texture: texture_surface_img, x: 32, y: 32, tint: tint1)
  draw_texture_tinted(r: renderer, texture: texture_img, x: 32, y: 192, tint: tint2)

  # draw
  renderer.present
end

texture_surface_img.destroy
surface_img.destroy
texture_img.destroy
renderer.destroy
window.destroy
SDL3.quit


def draw_texture_tinted(r : SDL3::Renderer, texture : SDL3::Texture, x : Float32, y : Float32, tint : SDL3::Color?)
  # set tint
  if t = tint
    # draw the original texture, so we have a tint overlay, if alpha != 255
    r.render_texture_rotated(
      texture: texture,
      x: x,
      y: y
    )

    # save the old tint
    orig_tint = texture.tint
    texture.tint = t

    r.render_texture_rotated(
      texture: texture,
      x: x,
      y: y
    )

    texture.tint = orig_tint
  else
    r.render_texture_rotated(
      texture: texture,
      x: x,
      y: y
    )
  end
end
