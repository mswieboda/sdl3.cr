@[Link("SDL3_ttf")]
lib LibSDL3TTF
  fun init = TTF_Init() : Bool
  fun quit = TTF_Quit()
  fun was_init = TTF_WasInit() : Int32
  fun open_font = TTF_OpenFont(file : UInt8*, ptsize : Float32) : Font*
  fun close_font = TTF_CloseFont(font : Font*)
  fun render_text_blended = TTF_RenderText_Blended(font : Font*, text : UInt8*, length : UInt64, fg : LibSDL3::Color) : LibSDL3::Surface*

  alias Font = Void
end

module SDL3
  module TTF
    extend self

    def init
      unless LibSDL3TTF.init
        raise "Failed to initialize SDL3_ttf"
      end
    end

    def quit
      LibSDL3TTF.quit
    end

    def was_init
      LibSDL3TTF.was_init
    end

    # TODO: test this
    def init?
      was_init != 1
    end

    class Font
      @ptr : LibSDL3TTF::Font*

      def self.open(file : String, ptsize : Float32)
        ptr = LibSDL3TTF.open_font(file.to_unsafe, ptsize)
        raise "Failed to open font" if ptr.null?
        new(ptr)
      end

      def initialize(@ptr : LibSDL3TTF::Font*); end

      def close
        LibSDL3TTF.close_font(@ptr)
      end

      def to_unsafe
        @ptr
      end

      def render_text_blended(text : String, fg : LibSDL3::Color)
        ptr = LibSDL3TTF.render_text_blended(@ptr, text.to_unsafe, text.bytesize, fg)
        raise "Failed to render text blended" if ptr.null?
        Surface.new(ptr)
      end
    end
  end
end
