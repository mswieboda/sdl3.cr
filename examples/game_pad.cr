require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO | LibSDL3::SDL_INIT_GAMEPAD)
SDL3::TTF.init

window = SDL3::Window.new("Gamepad Test", 800, 600, 0)
renderer = SDL3::Renderer.new(window)
renderer.set_vsync(1)

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

gamepads = Hash(LibSDL3::JoystickID, SDL3::Gamepad::GamepadWrapper).new

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
    when LibSDL3::SDL_EVENT_GAMEPAD_ADDED
      gamepad_id = event.gdevice.which
      gamepad_wrapper = SDL3::Gamepad.open_gamepad(gamepad_id)
      if gamepad_wrapper
        gamepads[gamepad_id] = gamepad_wrapper
        puts "Gamepad added: #{gamepad_wrapper.name} (ID: #{gamepad_id})"
      else
        puts "Failed to open gamepad with ID: #{gamepad_id}"
      end
    when LibSDL3::SDL_EVENT_GAMEPAD_REMOVED
      gamepad_id = event.gdevice.which
      if gamepads.has_key?(gamepad_id)
        gamepads[gamepad_id].destroy
        gamepads.delete(gamepad_id)
        puts "Gamepad removed: #{gamepad_id}"
      end
    when LibSDL3::SDL_EVENT_GAMEPAD_BUTTON_DOWN
      gamepad_id = event.gbutton.which
      button = LibSDL3::GamepadButton.new(event.gbutton.button)
      puts "Gamepad #{gamepad_id} button down: #{button}"
    when LibSDL3::SDL_EVENT_GAMEPAD_BUTTON_UP
      gamepad_id = event.gbutton.which
      button = LibSDL3::GamepadButton.new(event.gbutton.button)
      puts "Gamepad #{gamepad_id} button up: #{button}"
    when LibSDL3::SDL_EVENT_GAMEPAD_AXIS_MOTION
      gamepad_id = event.gaxis.which
      axis = LibSDL3::GamepadAxis.new(event.gaxis.axis)
      value = event.gaxis.value
      puts "Gamepad #{gamepad_id} axis #{axis} motion: #{value}"
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  y_offset = 10
  gamepads.each do |id, gamepad|
    renderer.draw_color = {255_u8, 255_u8, 255_u8, 255_u8}
    text_surface = font.render_text_blended("Gamepad ID: #{id}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Name: #{gamepad.name}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Type: #{gamepad.type}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Player Index: #{gamepad.player_index}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Vendor: #{gamepad.vendor}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Product: #{gamepad.product}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 20
    text_surface = font.render_text_blended("Product Version: #{gamepad.product_version}", SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: 10.0, y: y_offset.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
    y_offset += 30

    LibSDL3::GamepadAxis.values.each do |axis|
      if gamepad.axis(axis) != 0
        text_surface = font.render_text_blended("Axis #{axis}: #{gamepad.axis(axis)}", SDL3.color(255, 255, 255, 255))
        text_texture = SDL3::Texture.from_surface(renderer, text_surface)
        text_w, text_h = text_texture.size
        text_dstrect = LibSDL3::FRect.new(x: 30.0, y: y_offset.to_f32, w: text_w, h: text_h)
        renderer.render_texture(text_texture, text_dstrect)
        text_texture.destroy
        text_surface.destroy
        y_offset += 20
      end
    end
    y_offset += 10

    LibSDL3::GamepadButton.values.each do |button|
      if button != LibSDL3::GamepadButton::Invalid && gamepad.button(button)
        text_surface = font.render_text_blended("Button #{button} pressed", SDL3.color(255, 255, 255, 255))
        text_texture = SDL3::Texture.from_surface(renderer, text_surface)
        text_w, text_h = text_texture.size
        text_dstrect = LibSDL3::FRect.new(x: 30.0, y: y_offset.to_f32, w: text_w, h: text_h)
        renderer.render_texture(text_texture, text_dstrect)
        text_texture.destroy
        text_surface.destroy
        y_offset += 20
      end
    end
    y_offset += 30
  end

  renderer.present
end

gamepads.each_value do |gamepad|
  gamepad.destroy
end
font.close
SDL3::TTF.quit
renderer.destroy
window.destroy
SDL3.quit
