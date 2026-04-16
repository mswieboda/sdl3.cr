require "../src/sdl3"

SDL3.init(LibSDL3::SDL_INIT_VIDEO)

window = SDL3::Window.new("Tint Deferred Test", 640, 480, 0)
renderer = SDL3::Renderer.new(window)
renderer.vsync = 1

texture = SDL3::Image.load_texture(renderer, "./assets/img/player.png")

class DrawColorCommand
end

class DrawTextureCommand
  property texture : SDL3::Texture
  property dest_rect : SDL3::FRect
  property tint_r : UInt8 = 255_u8
  property tint_g : UInt8 = 255_u8
  property tint_b : UInt8 = 255_u8
  property tint_a : UInt8 = 255_u8
  property has_tint : Bool = false

  def initialize(
    @texture : SDL3::Texture,
    @dest_rect : SDL3::FRect,
    tint : SDL3::Color? = nil
  )
    if t = tint
      @tint_r, @tint_g, @tint_b, @tint_a = t.r, t.g, t.b, t.a
      @has_tint = true
    end
  end
end

alias Command = DrawTextureCommand | DrawColorCommand

class Layer
  getter commands = [] of Command

  def push(cmd : Command)
    @commands << cmd
  end

  def clear
    @commands.clear
  end
end

layers = Hash(Int32, Layer).new
sorted_z_indices = [] of Int32

def push_cmd(cmd : Command, layers, sorted_z_indices)
  layer = layers[0] ||= begin
    sorted_z_indices << 0
    Layer.new
  end
  layer.push(cmd)
end

# Add commands
w, h = texture.size

def _render_texture_rotated(r, texture, dest_rect)
  r.blend_mode = LibSDL3::SDL_BLENDMODE_BLEND
  texture.blend_mode = LibSDL3::SDL_BLENDMODE_BLEND
  r.render_texture(texture, dest_rect)
end

error_count = 0
frame_count = 0
running = true

while running && frame_count < 10
  frame_count += 1
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

  renderer.draw_color = {20_u8, 20_u8, 20_u8, 255_u8}
  renderer.clear

  # Re-push every frame just like GameSDL
  push_cmd(DrawTextureCommand.new(texture, SDL3::FRect.new(x: 100_f32, y: 100_f32, w: w, h: h), SDL3::Color.new(r: 255, g: 0, b: 0, a: 128)), layers, sorted_z_indices)
  push_cmd(DrawTextureCommand.new(texture, SDL3::FRect.new(x: 200_f32, y: 100_f32, w: w, h: h), SDL3::Color.new(r: 0, g: 255, b: 0, a: 128)), layers, sorted_z_indices)
  push_cmd(DrawTextureCommand.new(texture, SDL3::FRect.new(x: 300_f32, y: 100_f32, w: w, h: h), SDL3::Color.new(r: 0, g: 0, b: 255, a: 128)), layers, sorted_z_indices)

  sorted_z_indices.each do |z|
    layer = layers[z]
    next if layer.commands.empty?

    commands = layer.commands
    cursor = 0

    while cursor < commands.size
      command = commands[cursor]

      case command
      when DrawTextureCommand
        tr, tg, tb, ta = command.tint_r, command.tint_g, command.tint_b, command.tint_a

        renderer.blend_mode = LibSDL3::SDL_BLENDMODE_BLEND
        command.texture.blend_mode = LibSDL3::SDL_BLENDMODE_BLEND

        if command.has_tint && (tr != 255 || tg != 255 || tb != 255)
          # Pass 1: Base texture (Full original alpha)
          LibSDL3.set_texture_color_mod(command.texture.to_unsafe, 255_u8, 255_u8, 255_u8)
          LibSDL3.set_texture_alpha_mod(command.texture.to_unsafe, 255_u8)

          _render_texture_rotated(renderer, command.texture, command.dest_rect)

          # Pass 2: Tint overlay (Target color and alpha)
          LibSDL3.set_texture_color_mod(command.texture.to_unsafe, tr, tg, tb)
          LibSDL3.set_texture_alpha_mod(command.texture.to_unsafe, ta)

          # READ BACK TO VERIFY
          check_r, check_g, check_b, check_a = 0_u8, 0_u8, 0_u8, 0_u8
          LibSDL3.get_texture_color_mod(command.texture.to_unsafe, pointerof(check_r), pointerof(check_g), pointerof(check_b))
          LibSDL3.get_texture_alpha_mod(command.texture.to_unsafe, pointerof(check_a))

          if check_r != tr || check_g != tg || check_b != tb || check_a != ta
            error_count += 1
            puts "ERROR [deferred loop]: Frame #{frame_count}, Command #{cursor} tint mismatch!"
            puts "  Expected: #{tr}, #{tg}, #{tb}, #{ta}"
            puts "  Got:      #{check_r}, #{check_g}, #{check_b}, #{check_a}"
          end

          _render_texture_rotated(renderer, command.texture, command.dest_rect)

          # Pass 3: Tint overlay again (Second layer to intensify)
          _render_texture_rotated(renderer, command.texture, command.dest_rect)
        else
          LibSDL3.set_texture_color_mod(command.texture.to_unsafe, 255_u8, 255_u8, 255_u8)
          LibSDL3.set_texture_alpha_mod(command.texture.to_unsafe, ta)

          _render_texture_rotated(renderer, command.texture, command.dest_rect)
        end
      end

      cursor += 1
    end
    layer.clear
  end

  renderer.present

  sleep 300.milliseconds
end

if error_count == 0
  puts "SUCCESS: No tint mismatches detected."
else
  puts "FAILURE: Detected #{error_count} tint mismatches."
end

texture.destroy
renderer.destroy
window.destroy
SDL3.quit
