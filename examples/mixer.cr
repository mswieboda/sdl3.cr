require "../src/sdl3"

# Initialize SDL and SDL_mixer
SDL3.init(LibSDL3::SDL_INIT_VIDEO | LibSDL3::SDL_INIT_AUDIO)
SDL3::Mixer.init
SDL3::TTF.init

# Create a window and renderer
window = SDL3::Window.new("Mixer Example", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 16.0)

# Create a mixer
mixer = LibSDL3Mixer.create_mixer_device(LibSDL3::AUDIO_DEVICE_DEFAULT_PLAYBACK, nil)
if mixer.null?
  puts "Failed to create mixer: #{SDL3.get_error}"
  exit(1)
end

# Load the sound using SDL_mixer
audio = LibSDL3Mixer.load_audio(mixer, "assets/sfx/sample.wav", false)
if audio.null?
  puts "Failed to load audio: #{SDL3.get_error}"
  exit(1)
end

# Create a track
track = LibSDL3Mixer.create_track(mixer)
if track.null?
    puts "Failed to create track: #{SDL3.get_error}"
    exit(1)
end

LibSDL3Mixer.set_track_audio(track, audio)

# Button state
button_rect = LibSDL3::FRect.new(x: 50.0, y: 50.0, w: 200.0, h: 50.0)
button_text_state = "Play Sound"

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

      if event.button.button == 1 &&
         mouse_x >= button_rect.x && mouse_x <= (button_rect.x + button_rect.w) &&
         mouse_y >= button_rect.y && mouse_y <= (button_rect.y + button_rect.h)
        # Play the sound on the track
        LibSDL3Mixer.play_track(track, 0)
      end
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  # Draw Button
  renderer.draw_color = {100_u8, 100_u8, 100_u8, 255_u8}
  renderer.fill_rect(button_rect)
  renderer.draw_color = {200_u8, 200_u8, 200_u8, 255_u8}
  text_surface = font.render_text_blended(button_text_state, SDL3.color(255, 255, 255, 255))
  text_texture = SDL3::Texture.from_surface(renderer, text_surface)
  text_w, text_h = text_texture.size
  text_x = button_rect.x + (button_rect.w - text_w) / 2
  text_y = button_rect.y + (button_rect.h - text_h) / 2
  text_dstrect = LibSDL3::FRect.new(x: text_x, y: text_y, w: text_w, h: text_h)
  renderer.render_texture(text_texture, text_dstrect)
  text_texture.destroy
  text_surface.destroy

  renderer.present
end

# Cleanup
LibSDL3Mixer.destroy_audio(audio)
LibSDL3Mixer.destroy_track(track)
LibSDL3Mixer.destroy_mixer(mixer)
font.close
SDL3::TTF.quit
SDL3::Mixer.quit
renderer.destroy
window.destroy
SDL3.quit
