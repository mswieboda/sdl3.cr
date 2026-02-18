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

  draw_rects(renderer)
  draw_line(renderer)
  draw_triangle(renderer)
  draw_quarter_circle(renderer)
  draw_arc_outline(renderer)
  draw_arc(renderer)

  renderer.present
end

def draw_rects(renderer)
  # Draw a red rectangle
  renderer.draw_color = {255_u8, 0_u8, 0_u8, 255_u8}
  rect = LibSDL3::FRect.new(x: 100.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.draw_rect(rect)

  # Draw a green filled rectangle
  renderer.draw_color = {0_u8, 255_u8, 0_u8, 255_u8}
  filled_rect = LibSDL3::FRect.new(x: 350.0, y: 100.0, w: 200.0, h: 150.0)
  renderer.fill_rect(filled_rect)
end

def draw_line(renderer)
  # Draw a blue line
  renderer.draw_color = {0_u8, 0_u8, 255_u8, 255_u8}
  renderer.draw_line(100.0, 300.0, 550.0, 450.0)
end

def draw_triangle(renderer)
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
end

def draw_quarter_circle(renderer)
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
end

def draw_arc_outline(renderer)
  # --- Customizable Outlined Arc Drawing ---
  # Parameters for the arc
  center_x = 200
  center_y = 150
  radius_x = 48 # Horizontal radius for elliptical shape
  radius_y = 24 # Vertical radius for elliptical shape
  thickness = 8  # The width of the arc
  start_angle = 0 # Start at 0 degrees
  end_angle = Math::PI * 1   # End at 180 degrees (a half circle)
  segments = 64              # Number of segments for smoothness

  inner_arc_points = [] of SDL3::FPoint
  outer_arc_points = [] of SDL3::FPoint
  angle_step = (end_angle - start_angle) / segments

  # Generate points for inner and outer arcs
  (segments + 1).times do |i|
    angle = start_angle + i * angle_step

    # Calculate points on inner and outer edges of the arc
    inner_radius_x = radius_x
    inner_radius_y = radius_y
    outer_radius_x = radius_x + thickness
    outer_radius_y = radius_y + thickness

    # Inner point
    inner_x = center_x + inner_radius_x * Math.cos(angle)
    inner_y = center_y + inner_radius_y * Math.sin(angle)
    inner_arc_points << SDL3::FPoint.new(x: inner_x.to_f32, y: inner_y.to_f32)

    # Outer point
    outer_x = center_x + outer_radius_x * Math.cos(angle)
    outer_y = center_y + outer_radius_y * Math.sin(angle)
    outer_arc_points << SDL3::FPoint.new(x: outer_x.to_f32, y: outer_y.to_f32)
  end

  renderer.draw_color = {255_u8, 255_u8, 0_u8, 255_u8} # Yellow for outline

  # Draw inner arc
  if inner_arc_points.size > 1
    renderer.draw_lines(Slice.new(inner_arc_points.to_unsafe, inner_arc_points.size))
  end

  # Draw outer arc
  if outer_arc_points.size > 1
    renderer.draw_lines(Slice.new(outer_arc_points.to_unsafe, outer_arc_points.size))
  end

  # Draw connecting lines at start and end of the arc
  if inner_arc_points.size > 0 && outer_arc_points.size > 0
    # Line at start of arc
    renderer.draw_line(inner_arc_points.first.x, inner_arc_points.first.y, outer_arc_points.first.x, outer_arc_points.first.y)
    # Line at end of arc
    renderer.draw_line(inner_arc_points.last.x, inner_arc_points.last.y, outer_arc_points.last.x, outer_arc_points.last.y)
  end
  # --- End of Outlined Arc Drawing ---
end

def draw_arc(renderer)
  # --- Customizable Arc Drawing ---
  # Parameters for the arc
  center_x = 320
  center_y = 320
  radius_x = 32 # Horizontal radius for elliptical shape
  radius_y = 64 # Vertical radius for elliptical shape
  thickness = 16  # The width of the arc
  start_angle = Math::PI * 0.25 # Start at 45 degrees
  end_angle = Math::PI * 1.5   # End at 270 degrees
  segments = 64              # Number of segments for smoothness

  arc_vertices = [] of SDL3::Vertex
  arc_indices = [] of Int32
  angle_step = (end_angle - start_angle) / segments

  color = SDL3::FColor.new(r: 1.0, g: 1.0, b: 0.0, a: 1.0) # Yellow

  # Generate vertices
  (segments + 1).times do |i|
    angle = start_angle + i * angle_step

    # Calculate points on inner and outer edges of the arc
    inner_radius_x = radius_x
    inner_radius_y = radius_y
    outer_radius_x = radius_x + thickness
    outer_radius_y = radius_y + thickness

    # Inner vertex
    inner_x = center_x + inner_radius_x * Math.cos(angle)
    inner_y = center_y + inner_radius_y * Math.sin(angle)
    arc_vertices << SDL3::Vertex.new(inner_x.to_f32, inner_y.to_f32, color)

    # Outer vertex
    outer_x = center_x + outer_radius_x * Math.cos(angle)
    outer_y = center_y + outer_radius_y * Math.sin(angle)
    arc_vertices << SDL3::Vertex.new(outer_x.to_f32, outer_y.to_f32, color)
  end

  # Generate indices to form a triangle strip
  segments.times do |i|
    v_inner_prev = i * 2
    v_outer_prev = i * 2 + 1
    v_inner_curr = i * 2 + 2
    v_outer_curr = i * 2 + 3

    # First triangle of the quad
    arc_indices << v_inner_prev
    arc_indices << v_outer_prev
    arc_indices << v_inner_curr

    # Second triangle of the quad
    arc_indices << v_outer_prev
    arc_indices << v_inner_curr
    arc_indices << v_outer_curr
  end

  # Render the arc geometry
  if arc_vertices.size > 0 && arc_indices.size > 0
    renderer.render_geometry(arc_vertices, arc_indices)
  end
  # --- End of Arc Drawing ---
end

renderer.destroy
window.destroy
SDL3.quit
