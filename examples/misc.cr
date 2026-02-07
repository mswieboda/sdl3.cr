require "../src/sdl3"

SDL3.init(0) # No specific subsystem needed for OpenURL

puts "Attempting to open URL: https://www.libsdl.org"
if SDL3::Misc.open_url("https://www.libsdl.org")
  puts "Successfully requested to open URL."
else
  puts "Failed to open URL: #{SDL3.get_error}"
end

SDL3.quit
