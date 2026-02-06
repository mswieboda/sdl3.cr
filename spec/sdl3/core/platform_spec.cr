describe "SDL3 Platform" do
  before_each do
    SDL3.init(0) # No specific subsystem needed for SDL_GetPlatform
  end

  after_each do
    SDL3.quit
  end

  it "gets the platform name" do
    platform_name = SDL3::Platform.get_platform
    platform_name.should be_a(String)
    platform_name.should_not be_empty
    # puts "Platform name: #{platform_name}"
  end
end
