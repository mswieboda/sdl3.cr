require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("Mouse Events Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

# Button 1 state
button1_rect = LibSDL3::FRect.new(x: 50.0, y: 50.0, w: 200.0, h: 50.0)
button1_text_state = "Press (hold)!"
button1_pressed = false

# Button 2 state
button2_rect = LibSDL3::FRect.new(x: 50.0, y: 150.0, w: 200.0, h: 50.0)
button2_text_state = "Click me!"
button2_clicked_time = 0_u64

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
    when LibSDL3::SDL_EVENT_MOUSE_BUTTON_DOWN
      mouse_x = event.button.x
      mouse_y = event.button.y

      # Check for button 1 press
      if event.button.button == 1 &&
         mouse_x >= button1_rect.x && mouse_x <= (button1_rect.x + button1_rect.w) &&
         mouse_y >= button1_rect.y && mouse_y <= (button1_rect.y + button1_rect.h)
        button1_pressed = true
        button1_text_state = "Pressed!"
      end
    when LibSDL3::SDL_EVENT_MOUSE_BUTTON_UP
      mouse_x = event.button.x
      mouse_y = event.button.y

      # Check for button 1 release (anywhere, but only if it was pressed)
      if event.button.button == 1 && button1_pressed
        button1_pressed = false
        button1_text_state = "Released!"
      end

      # Check for button 2 click
      if event.button.button == 1 &&
         mouse_x >= button2_rect.x && mouse_x <= (button2_rect.x + button2_rect.w) &&
         mouse_y >= button2_rect.y && mouse_y <= (button2_rect.y + button2_rect.h)
        button2_text_state = "Clicked!"
        button2_clicked_time = SDL3.get_ticks
      end
    end
  end

  # Reset button 1 text if mouse is not pressed and not hovered over
  unless button1_pressed
    _state, mouse_x, mouse_y = SDL3::Mouse.get_state
    if mouse_x < button1_rect.x || mouse_x > (button1_rect.x + button1_rect.w) ||
       mouse_y < button1_rect.y || mouse_y > (button1_rect.y + button1_rect.h)
      button1_text_state = "Press (hold)!"
    end
  end

  # Reset button 2 text after a delay
  if button2_text_state == "Clicked!" && (SDL3.get_ticks - button2_clicked_time) > 1000 # 1 second delay
    button2_text_state = "Click me!"
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Draw Button 1
  renderer.draw_color = {100_u8, 100_u8, 100_u8, 255_u8}
  renderer.fill_rect(button1_rect)
  renderer.draw_color = {200_u8, 200_u8, 200_u8, 255_u8}
  text_surface1 = font.render_text_blended(button1_text_state, SDL3.color(255, 255, 255, 255))
  text_texture1 = SDL3::Texture.from_surface(renderer, text_surface1)
  text_w1, text_h1 = text_texture1.size
  text_x1 = button1_rect.x + (button1_rect.w - text_w1) / 2
  text_y1 = button1_rect.y + (button1_rect.h - text_h1) / 2
  text_dstrect1 = LibSDL3::FRect.new(x: text_x1, y: text_y1, w: text_w1, h: text_h1)
  renderer.render_texture(text_texture1, text_dstrect1)
  text_texture1.destroy
  text_surface1.destroy

  # Draw Button 2
  renderer.draw_color = {100_u8, 100_u8, 100_u8, 255_u8}
  renderer.fill_rect(button2_rect)
  renderer.draw_color = {200_u8, 200_u8, 200_u8, 255_u8}
  text_surface2 = font.render_text_blended(button2_text_state, SDL3.color(255, 255, 255, 255))
  text_texture2 = SDL3::Texture.from_surface(renderer, text_surface2)
  text_w2, text_h2 = text_texture2.size
  text_x2 = button2_rect.x + (button2_rect.w - text_w2) / 2
  text_y2 = button2_rect.y + (button2_rect.h - text_h2) / 2
  text_dstrect2 = LibSDL3::FRect.new(x: text_x2, y: text_y2, w: text_w2, h: text_h2)
  renderer.render_texture(text_texture2, text_dstrect2)
  text_texture2.destroy
  text_surface2.destroy

  renderer.present
end

font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit