lib LibSDL3
  # From SDL3/SDL_filesystem.h
  fun get_pref_path = SDL_GetPrefPath(org : LibC::Char*, app : LibC::Char*) : LibC::Char*

  # Crucial companion function from SDL3/SDL_stdinc.h to free the returned pointer
  fun free = SDL_free(mem : Void*) : Void
end

module SDL3
  module FileSystem
    extend self

    def pref_path(org : String, app : String) : String
      ptr = LibSDL3.get_pref_path(org.to_unsafe, app.to_unsafe)
      if ptr
        path = String.new(ptr)
        LibSDL3.free(ptr.as(Void*)) # Free the C-allocated pointer safely
        path
      else
        raise "Could not retrieve preference path: #{SDL3.get_error}"
      end
    end
  end
end
