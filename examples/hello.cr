require "../src/sdl3"

puts "Crystal: Initializing SDL3..."
SDL3.init(LibSDL3::SDL_INIT_VIDEO)
puts "Crystal: SDL3 Initialized."

puts "Crystal: Creating window..."
window = SDL3::Window.new("Hello SDL3", 640, 480, 0)
puts "Crystal: Window created."

puts "Crystal: Creating renderer..."
renderer = SDL3::Renderer.new(window)
puts "Crystal: Renderer created."

running = true
frame_count = 0
puts "Crystal: Entering main loop..."
while running
  event = uninitialized LibSDL3::Event
  while SDL3.poll_event(pointerof(event))
    case event.type
    when LibSDL3::SDL_EVENT_QUIT, LibSDL3::SDL_EVENT_WINDOW_CLOSE_REQUESTED
      puts "Crystal: Quit event received."
      running = false
    end
  end

  if frame_count < 10
    puts "Crystal: Frame #{frame_count}"
  end
  frame_count += 1

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  renderer.draw_color = {255_u8, 0_u8, 0_u8, 255_u8}
  # Draw a simple red rect to prove rendering is working
  rect = LibSDL3::FRect.new(x: 100, y: 100, w: 200, h: 200)
  renderer.fill_rect(rect)

  renderer.present
end

puts "Crystal: Cleaning up..."
renderer.destroy
window.destroy
SDL3.quit
puts "Crystal: Exited."
