require "../spec_helper"

describe "SDL3 log" do
  it "sets log priority and logs a message" do
    SDL3.set_log_priority(LibSDL3::LogCategory::APPLICATION, LibSDL3::LogPriority::INFO)
    SDL3.log("This is a test log message")
    # We can't easily check the output, so we just check that it doesn't crash
    
    SDL3.set_log_priority(LibSDL3::LogCategory::APPLICATION, LibSDL3::LogPriority::CRITICAL)
    SDL3.log("This message should not be visible")
  end
end
