@[Link("SDL3")]
lib LibSDL3
end

module SDL3
  def self.render_text(renderer : Renderer, font : TTF::Font, text : String, x : Int32, y : Int32)
    text_surface = font.render_text_blended(text, SDL3.color(255, 255, 255, 255))
    text_texture = SDL3::Texture.from_surface(renderer, text_surface)
    text_w, text_h = text_texture.size
    text_dstrect = LibSDL3::FRect.new(x: x.to_f32, y: y.to_f32, w: text_w, h: text_h)
    renderer.render_texture(text_texture, text_dstrect)
    text_texture.destroy
    text_surface.destroy
  end
end

require "./sdl3/core/init"
require "./sdl3/core/error"
require "./sdl3/core/log"
require "./sdl3/core/timer"
require "./sdl3/core/version"
require "./sdl3/core/platform"
require "./sdl3/core/misc"
require "./sdl3/gfx/ttf"
require "./sdl3/gfx/image"
require "./sdl3/gfx/video"
require "./sdl3/gfx/pixels"
require "./sdl3/gfx/rect"
require "./sdl3/gfx/surface"
require "./sdl3/gfx/texture"
require "./sdl3/gfx/render"
require "./sdl3/input/events"
require "./sdl3/input/keycode"
require "./sdl3/input/scancode"
require "./sdl3/input/keyboard"
require "./sdl3/input/mouse"
require "./sdl3/input/game_pad"
require "./sdl3/audio/audio"

