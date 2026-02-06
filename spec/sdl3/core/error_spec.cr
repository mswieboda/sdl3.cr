describe "SDL3 error" do
  it "sets and gets an error" do
    SDL3.clear_error
    LibSDL3.set_error("This is a test error")
    SDL3.get_error.should eq("This is a test error")
    SDL3.clear_error
    SDL3.get_error.should eq("")
  end
end
