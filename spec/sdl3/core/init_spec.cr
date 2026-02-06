describe "SDL3 init" do
  it "initializes and quits SDL video subsystem" do
    SDL3.init(LibSDL3::SDL_INIT_VIDEO)
    SDL3.was_init(LibSDL3::SDL_INIT_VIDEO).should eq(LibSDL3::SDL_INIT_VIDEO)
    SDL3.quit
    SDL3.was_init(0).should eq(0)
  end
end
