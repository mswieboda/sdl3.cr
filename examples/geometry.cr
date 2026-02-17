require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Geometry Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)

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

  # Draw a red rectangle
  renderer.draw_color = {255_u8, 0_u8, 0_u8, 255_u8}
  rect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.draw_rect(rect)

  # Draw a green filled rectangle
  renderer.draw_color = {0_u8, 255_u8, 0_u8, 255_u8}
  filled_rect = LibSDL3::FRect.new(x: 350.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.fill_rect(filled_rect)

  # Draw a blue line
  renderer.draw_color = {0_u8, 0_u8, 255_u8, 255_u8}
  renderer.draw_line(100.0, 300.0, 550.0, 450.0)

  # Draw a triangle with render_geometry
  offset_x = 64_f32
  offset_y = 16_f32
  vertices = [
    SDL3::Vertex.new(32_f32 + offset_x, 5_f32 + offset_y, SDL3::FColor.new(r: 1_f32)),
    SDL3::Vertex.new(12_f32 + offset_x, 43_f32 + offset_y, SDL3::FColor.new(g: 1_f32)),
    SDL3::Vertex.new(52_f32 + offset_x, 43_f32 + offset_y, SDL3::FColor.new(b: 1_f32)),
  ]
  indices = [0, 1, 2]
  renderer.render_geometry(vertices, indices)

  # Draw a quarter circle with a triangle fan
  circle_vertices = [] of SDL3::Vertex
  circle_indices = [] of Int32
  center_x = 100.0
  center_y = 400.0
  radius = 80.0
  resolution = 16

  # Center vertex (white)
  circle_vertices << SDL3::Vertex.new(center_x.to_f32, center_y.to_f32, SDL3::FColor.new(r: 1.0, g: 1.0, b: 1.0, a: 1.0))

  # Arc vertices (yellow)
  (resolution + 1).times do |i|
    angle = Math::PI + i * (0.5 * Math::PI / resolution)
    x = center_x + radius * Math.cos(angle)
    y = center_y + radius * Math.sin(angle)
    circle_vertices << SDL3::Vertex.new(x.to_f32, y.to_f32, SDL3::FColor.new(r: 1.0, g: 1.0, b: 0.0, a: 1.0))
  end

  # Indices for triangle fan
  resolution.times do |i|
    circle_indices << 0
    circle_indices << i + 1
    circle_indices << i + 2
  end
  renderer.render_geometry(circle_vertices, circle_indices)

  renderer.present
end

renderer.destroy
window.destroy
SDL3.quit
