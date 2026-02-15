@[Link("SDL3_ttf")]
lib LibSDL3TTF
  alias Font = Void
  alias TextEngine = Void
  alias Text = Void

  enum TTF_HorizontalAlignment : Int32
    TTF_HORIZONTAL_ALIGN_INVALID = -1
    TTF_HORIZONTAL_ALIGN_LEFT
    TTF_HORIZONTAL_ALIGN_CENTER
    TTF_HORIZONTAL_ALIGN_RIGHT
  end

  fun init = TTF_Init() : Bool
  fun quit = TTF_Quit()
  fun was_init = TTF_WasInit() : Int32
  fun open_font = TTF_OpenFont(file : LibC::Char*, ptsize : Float32) : Font*
  fun open_font_io = TTF_OpenFontIO(src : LibSDL3::IOStream*, closeio : Bool, ptsize : Float32) : Font*
  fun close_font = TTF_CloseFont(font : Font*)
  fun render_text_blended = TTF_RenderText_Blended(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_blended_wrapped = TTF_RenderText_Blended_Wrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, wrap_width : Int32) : LibSDL3::Surface*
  fun create_text = TTF_CreateText(engine : TextEngine*, font : Font*, text : LibC::Char*, length : LibC::SizeT) : Text
  fun create_renderer_text_engine = TTF_CreateRendererTextEngine(renderer : LibSDL3::Renderer*) : TextEngine
  fun draw_renderer_text = TTF_DrawRendererText(text : Text*, x : Float32, y : Float32) : Bool
  fun get_text_size = TTF_GetTextSize(text : Text*, w : LibC::Int*, y : LibC::Int*) : Bool
  fun set_font_wrap = TTF_SetFontWrapAlignment(font : Font*, align : TTF_HorizontalAlignment) : Void
  fun set_text_wrap_whitespace_visible = TTF_SetTextWrapWhitespaceVisible(text : Text*, visible : Bool) : Bool
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

    def create_renderer_text_engine(renderer : SDL3::Renderer) : TextEngine
      LibSDL3TTF.create_renderer_text_engine(renderer.to_unsafe)
    end

    class Font
      @ptr : LibSDL3TTF::Font*

      def initialize(@ptr : LibSDL3TTF::Font*)
      end

      def self.open(file : String, ptsize : Float32)
        ptr = LibSDL3TTF.open_font(file.to_unsafe, ptsize)
        raise "Failed to open font" if ptr.null?
        new(ptr)
      end

      def self.open_io(io_stream : IOStream, ptsize : Float32, close_io : Bool = false)
        ptr = LibSDL3TTF.open_font_io(io_stream.to_unsafe, close_io, ptsize)
        raise "Failed to open font from IO stream" if ptr.null?
        new(ptr)
      end

      def close
        LibSDL3TTF.close_font(@ptr)
      end

      def to_unsafe
        @ptr
      end

      def render_text_blended(text : String, color : LibSDL3::Color) : Surface
        ptr = LibSDL3TTF.render_text_blended(@ptr, text.to_unsafe, text.bytesize, color)
        raise "Failed to render text blended" if ptr.null?
        Surface.new(ptr)
      end

      def render_text_blended_wrapped(text : String, color : LibSDL3::Color, width : Int32 = 0) : Surface
        ptr = LibSDL3TTF.render_text_blended_wrapped(@ptr, text.to_unsafe, text.bytesize, color, width)
        raise "Failed to render text blended" if ptr.null?
        Surface.new(ptr)
      end

      def create_text(engine : LibSDL3TTF::TextEngine, text : String) : LibSDL3::Text
        LibSDL3TTF.create_text(engine.to_unsafe, to_unsafe, text, text.bytesize)
      end

      def font_wrap=(align : TTF_HorizontalAlignment)
        LibSDL3TTF.set_font_wrap(to_unsafe, align)
      end
    end

    class Text
      @ptr : LibSDL3TTF::Text*

      def initialize(@ptr : LibSDL3TTF::Text*)
      end

      def to_unsafe
        @ptr
      end

      # TODO: move this to a SDL3::Text class
      def draw(x : Float32, y : Float32) : Bool
        LibSDL3TTF.draw_renderer_text(to_unsafe, x, y)
      end

      # TODO: move this to a SDL3::Text class
      def wrap_whitespace_visible=(visible : Bool) : Bool
        LibSDL3TTF.set_text_wrap_whitespace_visible(to_unsafe, visible)
      end

      def size : Tuple(Int32, Int32)
        w = 0
        h = 0

        LibSDL3TTF.get_text_size(to_unsafe, pointerof(w), pointerof(h))

        {w, h}
      end
    end
  end
end
