describe "SDL3 renderer" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
  end

  it "creates and destroys a renderer" do
    window = SDL3::Window.new("Test Renderer Window", 100, 100, 0)
    renderer = SDL3::Renderer.new(window)
    renderer.destroy
    window.destroy
  end
end
