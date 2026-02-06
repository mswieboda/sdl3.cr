describe "SDL3 TTF" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
    SDL3::TTF.init
  end

  after_each do
    SDL3::TTF.quit
    SDL3.quit
  end

  it "initializes and quits TTF" do
    SDL3::TTF.was_init.should be > 0
  end

  it "opens and closes a font" do
    font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 24.0)
    font.close
  end

  it "renders text to a surface" do
    font = SDL3::TTF::Font.open("./assets/fonts/PressStart2P.ttf", 24.0)
    surface = font.render_text_blended("Hello, World!", SDL3.color(255, 255, 255, 255))
    surface.to_unsafe.should_not be_nil
    surface.destroy
    font.close
  end
end