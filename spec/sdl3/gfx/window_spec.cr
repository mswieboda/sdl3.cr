describe "SDL3 window" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
  end

  it "creates and destroys a window" do
    window = SDL3::Window.new("Test Window", 100, 100, 0)
    window.destroy
  end
end
