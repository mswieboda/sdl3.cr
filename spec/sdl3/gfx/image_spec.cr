describe "SDL3 Image" do
  before_each do
    SDL3.init(0)
  end

  after_each do
    # SDL3::Image.quit # Not needed for SDL_image 3.0
    SDL3.quit
  end

  it "gets the version" do
    SDL3::Image.version.should be_a(Int32)
  end

  it "loads an image from a file into a surface" do
    # Create a dummy renderer for loading textures
    window = SDL3::Window.new("Test Window", 1, 1, 0)
    renderer = SDL3::Renderer.new(window)

    surface = SDL3::Image.load("./assets/img/player.png")
    surface.to_unsafe.should_not be_nil
    surface.destroy

    texture = SDL3::Image.load_texture(renderer, "./assets/img/player.png")
    texture.to_unsafe.should_not be_nil
    texture.destroy

    renderer.destroy
    window.destroy
  end
end
