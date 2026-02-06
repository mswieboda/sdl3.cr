describe "SDL3 timer" do
  it "gets ticks and delays" do
    SDL3.init(0)
    start_time = SDL3.get_ticks
    SDL3.delay(10)
    end_time = SDL3.get_ticks
    (end_time - start_time).should be >= 10
    SDL3.quit
  end
end
