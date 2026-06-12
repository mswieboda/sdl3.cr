# Crystal bindings for SDL3_clipboard
# Docs: https://wiki.libsdl.org/SDL3/CategoryClipboard

lib LibSDL3
  fun set_clipboard_text = SDL_SetClipboardText(text : LibC::Char*) : Bool
  fun get_clipboard_text = SDL_GetClipboardText : LibC::Char*
  fun has_clipboard_text = SDL_HasClipboardText : Bool
end

module SDL3
  module Clipboard
    extend self

    def text : String
      ptr = LibSDL3.get_clipboard_text
      if ptr.null?
        ""
      else
        str = String.new(ptr)
        LibSDL3.free(ptr.as(Void*))
        str
      end
    end

    def text=(val : String) : Bool
      LibSDL3.set_clipboard_text(val.to_unsafe)
    end

    def has_text? : Bool
      LibSDL3.has_clipboard_text
    end
  end
end
