require "../spec_helper"

describe "SDL3 Mouse" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
  end

  after_each do
    SDL3.quit
  end

  it "gets mouse state" do
    state, x, y = SDL3::Mouse.get_state
    state.should be_a(SDL3::MouseState)
    x.should be_a(Float32)
    y.should be_a(Float32)
  end

  it "creates and destroys a system cursor" do
    cursor = SDL3::Mouse::Cursor.create_system(LibSDL3::SystemCursor::CROSSHAIR)
    cursor.to_unsafe.should_not be_nil
    cursor.destroy
  end

  it "shows and hides the cursor" do
    SDL3::Mouse.show
    SDL3::Mouse.visible?.should be_true
    SDL3::Mouse.hide
    SDL3::Mouse.visible?.should be_false
    SDL3::Mouse.show
  end
end
