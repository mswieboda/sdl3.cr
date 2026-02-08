require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init # For displaying text

# Window dimensions
window_width = 800
window_height = 800

# Logical rendering dimensions
logical_width = 320
logical_height = 240

window = SDL3::Window.new("Logical Presentation Example", window_width, window_height, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

# Create a checkerboard background surface (fills logical area)
background_surface = LibSDL3.create_surface(logical_width, logical_height, LibSDL3::PixelFormat::RGBA8888)
unless background_surface
  puts "Failed to create checkerboard surface: #{SDL3.get_error}"
  exit(1)
end

# Draw checkerboard pattern
tile_size = 20
color1_obj = SDL3.color(50, 50, 50, 255) # Dark gray
color2_obj = SDL3.color(150, 150, 150, 255) # Light gray
color1_u32 = (color1_obj.r.to_u32 << 24) | (color1_obj.g.to_u32 << 16) | (color1_obj.b.to_u32 << 8) | color1_obj.a.to_u32
color2_u32 = (color2_obj.r.to_u32 << 24) | (color2_obj.g.to_u32 << 16) | (color2_obj.b.to_u32 << 8) | color2_obj.a.to_u32

(0...logical_height).step(tile_size) do |y|
  (0...logical_width).step(tile_size) do |x|
    rect = LibSDL3::Rect.new(x: x, y: y, w: tile_size, h: tile_size)
    if ((x / tile_size) + (y / tile_size)) % 2 == 0
      LibSDL3.fill_surface_rect(background_surface, pointerof(rect), color1_u32)
    else
      LibSDL3.fill_surface_rect(background_surface, pointerof(rect), color2_u32)
    end
  end
end
background_texture = SDL3::Texture.from_surface(renderer, SDL3::Surface.new(background_surface))

# Logical Presentation Modes
presentation_modes = [
  SDL3::LogicalPresentation::Disabled,
  SDL3::LogicalPresentation::Stretch,
  SDL3::LogicalPresentation::Letterbox,
  SDL3::LogicalPresentation::Overscan,
  SDL3::LogicalPresentation::IntegerScale,
]
presentation_mode_names = [
  "DISABLED",
  "STRETCH",
  "LETTERBOX",
  "OVERSCAN",
  "INTEGER_SCALE",
]
current_mode_index = 0

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
      elsif event.key.key == LibSDL3::SPACE
        current_mode_index = (current_mode_index + 1) % presentation_modes.size
        mode = presentation_modes[current_mode_index]
        renderer.set_logical_presentation(logical_width, logical_height, mode)
        puts "Switched logical presentation to: #{presentation_mode_names[current_mode_index]}"
      end
    end
  end

  # Clear with a distinct color to show letterboxing/overscan areas
  renderer.draw_color = {255_u8, 0_u8, 255_u8, 255_u8} # Magenta
  renderer.clear

  # Render background, which will be scaled by the logical presentation
  bg_dst_rect = LibSDL3::FRect.new(x: 0.0, y: 0.0, w: logical_width.to_f32, h: logical_height.to_f32)
  renderer.render_texture(background_texture, bg_dst_rect)

  # Display current mode name
  SDL3.render_text(renderer, font, "Press SPACE to change presentation mode", 10, 10)
  SDL3.render_text(renderer, font, "Mode: #{presentation_mode_names[current_mode_index]}", 10, 40)
  SDL3.render_text(renderer, font, "Logical Size: #{logical_width}x#{logical_height}", 10, 70)
  SDL3.render_text(renderer, font, "Window Size: #{window_width}x#{window_height}", 10, 100)

  renderer.present
end

font.close
SDL3::TTF.quit
LibSDL3.destroy_surface(background_surface)
background_texture.destroy
renderer.destroy
window.destroy
SDL3.quit
