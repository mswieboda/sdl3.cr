require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init # For displaying blend mode names

window = SDL3::Window.new("BlendMode Example", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

# Create a checkerboard background surface
bg_width = 300
bg_height = 300
background_surface = SDL3::Surface.new(bg_width, bg_height)
unless background_surface
  puts "Failed to create checkerboard surface: #{SDL3.get_error}"
  exit(1)
end

# Draw checkerboard pattern
tile_size = 25
color1 = SDL3.color(50, 50, 50, 255) # Dark gray
color2 = SDL3.color(150, 150, 150, 255) # Light gray

(0...bg_height).step(tile_size) do |y|
  (0...bg_width).step(tile_size) do |x|
    rect = SDL3::Rect.new(x: x, y: y, w: tile_size, h: tile_size)
    if ((x / tile_size) + (y / tile_size)) % 2 == 0
      background_surface.fill_rect(rect, color1)
    else
      background_surface.fill_rect(rect, color2)
    end
  end
end
background_texture = SDL3::Texture.from_surface(renderer, background_surface)

# Create transparent red square as the first foreground element
foreground1_surface = SDL3::Surface.new(100, 100)
unless foreground1_surface
  puts "Failed to create foreground1 surface: #{SDL3.get_error}"
  exit(1)
end
color_red = SDL3.color(255, 0, 0, 150) # Red with 50% alpha
foreground1_surface.fill(color_red)
foreground1_texture = SDL3::Texture.from_surface(renderer, foreground1_surface)

# Create transparent green square as the second foreground element
foreground2_surface = SDL3::Surface.new(100, 100)
unless foreground2_surface
  puts "Failed to create foreground2 surface: #{SDL3.get_error}"
  exit(1)
end
color_green = SDL3.color(0, 255, 0, 150) # Green with 50% alpha
foreground2_surface.fill(color_green)
foreground2_texture = SDL3::Texture.from_surface(renderer, foreground2_surface)

blend_modes = [
  LibSDL3::SDL_BLENDMODE_NONE,
  LibSDL3::SDL_BLENDMODE_BLEND,
  LibSDL3::SDL_BLENDMODE_ADD,
  LibSDL3::SDL_BLENDMODE_MOD,
  LibSDL3::SDL_BLENDMODE_MUL,
  LibSDL3::SDL_BLENDMODE_BLEND_PREMULTIPLIED,
  LibSDL3::SDL_BLENDMODE_ADD_PREMULTIPLIED,
  SDL3::BlendMode.compose_custom(
    src_color_factor: LibSDL3::BlendFactor::One,
    dst_color_factor: LibSDL3::BlendFactor::One,
    color_operation: LibSDL3::BlendOperation::Add,
    src_alpha_factor: LibSDL3::BlendFactor::One,
    dst_alpha_factor: LibSDL3::BlendFactor::One,
    alpha_operation: LibSDL3::BlendOperation::Add
  ) # Example: Simple Screen blending
]
blend_mode_names = [
  "NONE",
  "BLEND",
  "ADD",
  "MOD",
  "MUL",
  "BLEND_PREMULTIPLIED",
  "ADD_PREMULTIPLIED",
  "CUSTOM (Screen)"
]
current_blend_mode_index = 0

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
        current_blend_mode_index = (current_blend_mode_index + 1) % blend_modes.size
        puts "Switched blend mode to: #{blend_mode_names[current_blend_mode_index]}"
      end
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Render background
  bg_dst_rect = SDL3::FRect.new(x: 50.0, y: 50.0, w: 300.0, h: 300.0)
  renderer.render_texture(background_texture, bg_dst_rect)

  # Render foregrounds with current blend mode
  current_blend_mode = blend_modes[current_blend_mode_index]
  foreground1_texture.blend_mode = current_blend_mode
  foreground2_texture.blend_mode = current_blend_mode

  # First foreground element (e.g., red square)
  fg1_dst_rect = SDL3::FRect.new(x: 100.0, y: 100.0, w: 100.0, h: 100.0)
  renderer.render_texture(foreground1_texture, fg1_dst_rect)

  # Second foreground element (e.g., green square), overlapping the first
  fg2_dst_rect = SDL3::FRect.new(x: 150.0, y: 150.0, w: 100.0, h: 100.0)
  renderer.render_texture(foreground2_texture, fg2_dst_rect)

  # Display current blend mode name
  SDL3.render_text(renderer, font, "Press SPACE to change blend mode", 10, 10)
  SDL3.render_text(renderer, font, "Blend Mode: #{blend_mode_names[current_blend_mode_index]}", 10, 40)

  renderer.present
end

font.close
SDL3::TTF.quit
LibSDL3.destroy_surface(background_surface) # Add this
background_texture.destroy
LibSDL3.destroy_surface(foreground1_surface) # Add this
foreground1_texture.destroy # Add this
LibSDL3.destroy_surface(foreground2_surface) # Add this
foreground2_texture.destroy # Add this
renderer.destroy
window.destroy
SDL3.quit
