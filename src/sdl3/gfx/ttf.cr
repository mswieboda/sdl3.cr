@[Link("SDL3_ttf")]
lib LibSDL3TTF
  alias Font = Void
  alias TextEngine = Void
  alias Text = Void
  alias TextData = Void
  alias TextLayout = Void

  enum TTF_HorizontalAlignment : Int8
    TTF_HORIZONTAL_ALIGN_INVALID = -1
    TTF_HORIZONTAL_ALIGN_LEFT
    TTF_HORIZONTAL_ALIGN_CENTER
    TTF_HORIZONTAL_ALIGN_RIGHT
  end

  enum FontStyleFlags : UInt8
    TTF_STYLE_NORMAL = 0x00
    TTF_STYLE_BOLD = 0x01
    TTF_STYLE_ITALIC = 0x02
    TTF_STYLE_UNDERLINE = 0x04
    TTF_STYLE_STRIKETHROUGH = 0x08
  end

  enum HintingFlags : Int8
    TTF_HINTING_INVALID = -1
    TTF_HINTING_NORMAL
    TTF_HINTING_LIGHT
    TTF_HINTING_MONO
    TTF_HINTING_NONE
    TTF_HINTING_LIGHT_SUBPIXEL
  end

  enum Direction : UInt8
    Invalid = 0
    LTR = 4
    RTL
    TTB
    BTT
  end

  enum ImageType : UInt8
    TTF_IMAGE_INVALID
    TTF_IMAGE_ALPHA
    TTF_IMAGE_COLOR
    TTF_IMAGE_SDF
  end

  # TODO: unimplemented for now
  # enum GPUTextEngineWinding : Int8
  #   TTF_GPU_TEXTENGINE_WINDING_INVALID = -1
  #   TTF_GPU_TEXTENGINE_WINDING_CLOCKWISE
  #   TTF_GPU_TEXTENGINE_WINDING_COUNTER_CLOCKWISE
  # end

  # TODO: need to add LibSDL3::GPUTexture first
  # struct GPUAtlasDrawSequence
  #   atlas_texture : LibSDL3::GPUTexture*
  #   xy : LibSDL3::FPoint*
  #   uv : LibSDL3::FPoint*
  #   num_vertices : LibC::Int
  #   indices : LibC::Int*
  #   num_indices : LibC::Int
  #   image_type : ImageType
  #   next : GPUAtlasDrawSequence*
  # end

  struct SubString
    flags : UInt32
    offset : LibC::Int
    length : LibC::Int
    line_index : LibC::Int
    cluster_index : LibC::Int
    rect : LibSDL3::Rect
  end

  fun version = TTF_Version() : LibC::Int
  fun get_free_type_version = TTF_GetFreeTypeVersion(major : LibC::Int*, minor : LibC::Int*, patch : LibC::Int*)
  fun get_harf_buzz_version = TTF_GetHarfBuzzVersion(major : LibC::Int*, minor : LibC::Int*, patch : LibC::Int*)
  fun init = TTF_Init() : Bool
  fun open_font = TTF_OpenFont(file : LibC::Char*, ptsize : Float32) : Font*
  fun open_font_io = TTF_OpenFontIO(src : LibSDL3::IOStream*, closeio : Bool, ptsize : Float32) : Font*
  fun open_font_with_properties = TTF_OpenFontWithProperties(props : LibSDL3::PropertiesID) : Font*
  fun copy_font = TTF_CopyFont(existing_font : Font*) : Font*
  fun get_font_properties = TTF_GetFontProperties(font : Font*) : LibSDL3::PropertiesID
  fun get_font_generation = TTF_GetFontGeneration(font : Font*) : UInt32
  fun add_fallback_font = TTF_AddFallbackFont(font : Font*, fallback : Font*) : Bool
  fun remove_fallback_font = TTF_RemoveFallbackFont(font : Font*, fallback : Font*)
  fun clear_fallback_fonts = TTF_ClearFallbackFonts(font : Font*)
  fun set_font_size = TTF_SetFontSize(font : Font*, ptsize : Float32) : Bool
  fun set_font_size_dpi = TTF_SetFontSizeDPI(font : Font*, ptsize : Float32, hdpi : LibC::Int, vdpi : LibC::Int) : Bool
  fun get_font_size = TTF_GetFontSize(font : Font*) : Float32
  fun get_font_dpi = TTF_GetFontDPI(font : Font*, hdpi : LibC::Int*, vdpi : LibC::Int*) : Bool
  fun set_font_style = TTF_SetFontStyle(font : Font*, style : FontStyleFlags)
  fun get_font_style = TTF_GetFontStyle(font : Font*) : FontStyleFlags
  fun set_font_outline = TTF_SetFontOutline(font : Font*, outline : LibC::Int) : Bool
  fun get_font_outline = TTF_GetFontOutline(font : Font*) : LibC::Int
  fun set_font_hinting = TTF_SetFontHinting(font : Font*, hinting : HintingFlags)
  fun get_font_hinting = TTF_GetFontHinting(font : Font*) : HintingFlags
  fun get_num_font_faces = TTF_GetNumFontFaces(font : Font*) : LibC::Int
  fun set_font_sdf = TTF_SetFontSDF(font : Font*, enabled : Bool) : Bool
  fun get_font_sdf = TTF_GetFontSDF(font : Font*) : Bool
  fun get_font_weight = TTF_GetFontWeight(font : Font*) : LibC::Int
  fun set_font_wrap_alignment = TTF_SetFontWrapAlignment(font : Font*, align : TTF_HorizontalAlignment)
  fun get_font_wrap_alignment = TTF_GetFontWrapAlignment(font : Font*) : TTF_HorizontalAlignment
  fun get_font_height = TTF_GetFontHeight(font : Font*) : LibC::Int
  fun get_font_ascent = TTF_GetFontAscent(font : Font*) : LibC::Int
  fun get_font_descent = TTF_GetFontDescent(font : Font*) : LibC::Int
  fun set_font_line_skip = TTF_SetFontLineSkip(font : Font*, lineskip : LibC::Int)
  fun get_font_line_skip = TTF_GetFontLineSkip(font : Font*) : LibC::Int
  fun set_font_kerning = TTF_SetFontKerning(font : Font*, enabled : Bool)
  fun get_font_kerning = TTF_GetFontKerning(font : Font*) : Bool
  fun font_is_fixed_width = TTF_FontIsFixedWidth(font : Font*) : Bool
  fun font_is_scalable = TTF_FontIsScalable(font : Font*) : Bool
  fun get_font_family_name = TTF_GetFontFamilyName(font : Font*) : LibC::Char*
  fun get_font_style_name = TTF_GetFontStyleName(font : Font*) : LibC::Char*
  fun set_font_direction = TTF_SetFontDirection(font : Font*, direction : Direction) : Bool
  fun get_font_direction = TTF_GetFontDirection(font : Font*) : Direction
  fun string_to_tag = TTF_StringToTag(string : LibC::Char*) : UInt32
  fun tag_to_string = TTF_TagToString(tag : UInt32, string : LibC::Char*, size : LibC::SizeT)
  fun set_font_script = TTF_SetFontScript(font : Font*, script : UInt32) : Bool
  fun get_font_script = TTF_GetFontScript(font : Font*) : UInt32
  fun get_glyph_script = TTF_GetGlyphScript(ch : UInt32) : UInt32
  fun set_font_language = TTF_SetFontLanguage(font : Font*, language_bcp47 : LibC::Char*) : Bool
  fun font_has_glyph = TTF_FontHasGlyph(font : Font*, ch : UInt32) : Bool
  fun get_glyph_image = TTF_GetGlyphImage(font : Font*, ch : UInt32, image_type : ImageType*) : LibSDL3::Surface*
  fun get_glyph_image_for_index = TTF_GetGlyphImageForIndex(font : Font*, glyph_index : UInt32, image_type : ImageType*) : LibSDL3::Surface*
  fun get_glyph_metrics = TTF_GetGlyphMetrics(font : Font*, ch : UInt32, minx : LibC::Int*, maxx : LibC::Int*, miny : LibC::Int*, maxy : LibC::Int*, advance : LibC::Int*) : Bool
  fun get_glyph_kerning = TTF_GetGlyphKerning(font : Font*, previous_ch : UInt32, ch : UInt32, kerning : LibC::Int*) : Bool
  fun get_string_size = TTF_GetStringSize(font : Font*, text : LibC::Char*, length : LibC::SizeT, w : LibC::Int*, h : LibC::Int*) : Bool
  fun get_string_size_wrapped = TTF_GetStringSizeWrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, wrap_width : LibC::Int, w : LibC::Int*, h : LibC::Int*) : Bool
  fun measure_string = TTF_MeasureString(font : Font*, text : LibC::Char*, length : LibC::SizeT, max_width : LibC::Int, measured_width : LibC::Int*, measured_length : LibC::SizeT*) : Bool
  fun render_text_solid = TTF_RenderText_Solid(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_solid_wrapped = TTF_RenderText_Solid_Wrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, wrapLength : LibC::Int) : LibSDL3::Surface*
  fun render_glyph_solid = TTF_RenderGlyph_Solid(font : Font*, ch : UInt32, fg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_shaded = TTF_RenderText_Shaded(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, bg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_shaded_wrapped = TTF_RenderText_Shaded_Wrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, bg : LibSDL3::Color, wrap_width : LibC::Int) : LibSDL3::Surface*
  fun render_glyph_shaded = TTF_RenderGlyph_Shaded(font : Font*, ch : UInt32, fg : LibSDL3::Color, bg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_blended = TTF_RenderText_Blended(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_blended_wrapped = TTF_RenderText_Blended_Wrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, wrap_width : Int32) : LibSDL3::Surface*
  fun render_glyph_blended = TTF_RenderGlyph_Blended(font : Font*, ch : UInt32, fg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_lcd = TTF_RenderText_LCD(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, bg : LibSDL3::Color) : LibSDL3::Surface*
  fun render_text_lcd_wrapped = TTF_RenderText_LCD_Wrapped(font : Font*, text : LibC::Char*, length : LibC::SizeT, fg : LibSDL3::Color, bg : LibSDL3::Color, wrap_width : LibC::Int) : LibSDL3::Surface*
  fun render_glyph_lcd = TTF_RenderGlyph_LCD(font : Font*, ch : UInt32, fg : LibSDL3::Color, bg : LibSDL3::Color) : LibSDL3::Surface*
  fun create_surface_text_engine = TTF_CreateSurfaceTextEngine() : TextEngine*
  fun draw_surface_text = TTF_DrawSurfaceText(text : Text*, x : Float32, y : Float32, surface : LibSDL3::Surface*) : Bool
  fun destroy_surface_text_engine = TTF_DestroySurfaceTextEngine(engine : TextEngine*)
  fun create_renderer_text_engine = TTF_CreateRendererTextEngine(renderer : LibSDL3::Renderer*) : TextEngine*
  fun create_renderer_text_engine_with_properties = TTF_CreateRendererTextEngineWithProperties(props : LibSDL3::PropertiesID) : TextEngine*
  fun draw_renderer_text = TTF_DrawRendererText(text : Text*, x : Float32, y : Float32) : Bool
  fun destroy_renderer_text_engine = TTF_DestroyRendererTextEngine(engine : TextEngine*)

  # TODO: need to add GPUDevice first
  # fun create_gpu_text_engine = TTF_CreateGPUTextEngine(device : LibSDL3::GPUDevice*) : TextEngine*

  # TODO: need to add LibSDL3::GPUTexture first
  # fun get_gpu_text_draw_data = TTF_GetGPUTextDrawData(text : Text*) : GPUAtlasDrawSequence*

  # TODO: will be unused without TTF_CreateGPUTextEngine
  # fun create_gpu_text_engine_with_properties = TTF_CreateGPUTextEngineWithProperties(props : LibSDL3::PropertiesID) : TextEngine*
  # fun destroy_gpu_text_engine = TTF_DestroyGPUTextEngine(engine : TextEngine*)
  # fun set_gpu_text_engine_winding = TTF_SetGPUTextEngineWinding(engine : TextEngine*, winding : GPUTextEngineWinding)
  # fun get_gpu_text_engine_winding = TTF_GetGPUTextEngineWinding(engine : TextEngine*) : GPUTextEngineWinding

  fun create_text = TTF_CreateText(engine : TextEngine*, font : Font*, text : LibC::Char*, length : LibC::SizeT) : Text*
  fun get_text_properties = TTF_GetTextProperties(text : Text*) : LibSDL3::PropertiesID
  fun set_text_engine = TTF_SetTextEngine(text : Text*, engine : TextEngine*) : Bool
  fun get_text_engine = TTF_GetTextEngine(text : Text*) : TextEngine*
  fun set_text_font = TTF_SetTextFont(text : Text*, font : Font*) : Bool
  fun get_text_font = TTF_GetTextFont(text : Text*) : Font*
  fun set_text_direction = TTF_SetTextDirection(text : Text*, direction : Direction) : Bool
  fun get_text_direction = TTF_GetTextDirection(text : Text*) : Direction
  fun set_text_script = TTF_SetTextScript(text : Text*, script : UInt32) : Bool
  fun get_text_script = TTF_GetTextScript(text : Text*) : UInt32
  fun set_text_color = TTF_SetTextColor(text : Text*, r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Bool
  fun set_text_color_float = TTF_SetTextColorFloat(text : Text*, r : Float32, g : Float32, b : Float32, a : Float32) : Bool
  fun get_text_color = TTF_GetTextColor(text : Text*, r : UInt8*, g : UInt8*, b : UInt8*, a : UInt8*) : Bool
  fun get_text_color_float = TTF_GetTextColorFloat(text : Text*, r : Float32*, g : Float32*, b : Float32*, a : Float32*) : Bool
  fun set_text_position = TTF_SetTextPosition(text : Text*, x : LibC::Int, y : LibC::Int) : Bool
  fun get_text_position = TTF_GetTextPosition(text : Text*, x : LibC::Int*, y : LibC::Int*) : Bool
  fun set_text_wrap_width = TTF_SetTextWrapWidth(text : Text*, wrap_width : LibC::Int) : Bool
  fun get_text_wrap_width = TTF_GetTextWrapWidth(text : Text*, wrap_width : LibC::Int*) : Bool
  fun set_text_wrap_whitespace_visible = TTF_SetTextWrapWhitespaceVisible(text : Text*, visible : Bool) : Bool
  fun text_wrap_whitespace_visible = TTF_TextWrapWhitespaceVisible(text : Text*) : Bool
  fun set_text_string = TTF_SetTextString(text : Text*, string : LibC::Char*, length : LibC::SizeT) : Bool
  fun insert_text_string = TTF_InsertTextString(text : Text*, offset : LibC::Int, string : LibC::Char*, length : LibC::SizeT) : Bool
  fun append_text_string = TTF_AppendTextString(text : Text*, string : LibC::Char*, length : LibC::SizeT) : Bool
  fun delete_text_string = TTF_DeleteTextString(text : Text*, offset : LibC::Int, length : LibC::Int) : Bool
  fun get_text_size = TTF_GetTextSize(text : Text*, w : LibC::Int*, h : LibC::Int*) : Bool
  fun get_text_sub_string = TTF_GetTextSubString(text : Text*, offset : LibC::Int, substring : SubString*) : Bool
  fun get_text_sub_string_for_line = TTF_GetTextSubStringForLine(text : Text*, line : LibC::Int, substring : SubString*) : Bool
  fun get_text_sub_strings_for_range = TTF_GetTextSubStringsForRange(text : Text*, offset : LibC::Int, length : LibC::Int, count : LibC::Int*) : SubString**
  fun get_text_sub_string_for_point = TTF_GetTextSubStringForPoint(text : Text*, x : LibC::Int, y : LibC::Int, substring : SubString*) : Bool
  fun get_previous_text_sub_string = TTF_GetPreviousTextSubString(text : Text*, substring : SubString*, previous : SubString*) : Bool
  fun get_next_text_sub_string = TTF_GetNextTextSubString(text : Text*, substring : SubString*, next : SubString*) : Bool
  fun update_text = TTF_UpdateText(text : Text*) : Bool
  fun destroy_text = TTF_DestroyText(text : Text*)
  fun close_font = TTF_CloseFont(font : Font*)
  fun quit = TTF_Quit()
  fun was_init = TTF_WasInit() : LibC::Int
end

module SDL3
  module TTF
    extend self

    enum Alignment : Int32
      Invalid = LibSDL3TTF::TTF_HorizontalAlignment::TTF_HORIZONTAL_ALIGN_INVALID
      Left    = LibSDL3TTF::TTF_HorizontalAlignment::TTF_HORIZONTAL_ALIGN_LEFT
      Center  = LibSDL3TTF::TTF_HorizontalAlignment::TTF_HORIZONTAL_ALIGN_CENTER
      Right   = LibSDL3TTF::TTF_HorizontalAlignment::TTF_HORIZONTAL_ALIGN_RIGHT
    end

    enum Style : UInt32
      Normal        = LibSDL3TTF::FontStyleFlags::TTF_STYLE_NORMAL
      Bold          = LibSDL3TTF::FontStyleFlags::TTF_STYLE_BOLD
      Italic        = LibSDL3TTF::FontStyleFlags::TTF_STYLE_ITALIC
      Underline     = LibSDL3TTF::FontStyleFlags::TTF_STYLE_UNDERLINE
      StrikeThrough = LibSDL3TTF::FontStyleFlags::TTF_STYLE_STRIKETHROUGH
    end

    enum HintingFlags : Int32
      Invalid   = LibSDL3TTF::HintingFlags::TTF_HINTING_INVALID
      Normal    = LibSDL3TTF::HintingFlags::TTF_HINTING_NORMAL
      Light     = LibSDL3TTF::HintingFlags::TTF_HINTING_LIGHT
      Mono      = LibSDL3TTF::HintingFlags::TTF_HINTING_MONO
      None      = LibSDL3TTF::HintingFlags::TTF_HINTING_NONE
      SubPixel  = LibSDL3TTF::HintingFlags::TTF_HINTING_LIGHT_SUBPIXEL
    end

    alias Direction = LibSDL3TTF::Direction

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

      def to_unsafe : LibSDL3TTF::Font*
        @ptr
      end

      def close
        LibSDL3TTF.close_font(to_unsafe)
      end

      def copy : Font
        ptr = LibSDL3TTF.copy_font(to_unsafe)
        raise "Failed to copy font" if ptr.null?
        new(ptr)
      end

      def add_fallback(font : Font)
        LibSDL3TTF.add_fallback_font(to_unsafe, font.to_unsafe)
      end

      def remove_fallback(font : Font)
        LibSDL3TTF.remove_fallback_font(to_unsafe, font.to_unsafe)
      end

      def clear_fallbacks
        LibSDL3TTF.clear_fallback_fonts(to_unsafe)
      end

      def size=(point_size : Float32)
        LibSDL3TTF.set_font_size(to_unsafe, point_size)
      end

      def size
        LibSDL3TTF.get_font_size(to_unsafe)
      end

      def set_dpi(point_size : Float32, hdpi : Int32, vdpi : Int32)
        LibSDL3TTF.set_font_size_dpi(to_unsafe, point_size, hdpi, vdpi)
      end

      def size_dpi
        LibSDL3TTF.get_font_dpi(to_unsafe, hdpi, vdpi)
      end

      def style=(style : Style)
        LibSDL3TTF.set_font_style(to_unsafe, style)
      end

      def style : Style
        LibSDL3TTF.get_font_style
      end

      def outline=(outline : Int32)
        LibSDL3TTF.set_font_outline(to_unsafe, outline)
      end

      def outline
        LibSDL3TTF.get_font_outline(to_unsafe)
      end

      def hinting=(hinting : Hinting)
        LibSDL3TTF.set_font_hinting(to_unsafe hinting)
      end

      def hinting : Hinting
        LibSDL3TTF.get_font_hinting(to_unsafe)
      end

      def faces : Int32
        LibSDL3TTF.get_num_font_faces(to_unsafe)
      end

      def sdf=(enabled : Bool)
        LibSDL3TTF.set_font_sdf(to_unsafe, enabled)
      end

      def sdf
        LibSDL3TTF.get_font_sdf(to_unsafe)
      end

      def weight : Int32
        LibSDL3TTF.get_font_weight(to_unsafe)
      end

      def wrap=(align : Alignment)
        LibSDL3TTF.set_font_wrap_alignment(to_unsafe, align)
      end

      def wrap : Alignment
        LibSDL3TTF.get_font_wrap_alignment(to_unsafe)
      end

      def height : Int32
        LibSDL3TTF.get_font_height(to_unsafe)
      end

      def ascent : Int32
        LibSDL3TTF.get_font_ascent(to_unsafe)
      end

      def descent : Int32
        LibSDL3TTF.get_font_descent(to_unsafe)
      end

      def line_skip=(line_skip = Int32)
        LibSDL3TTF.set_font_line_skip(to_unsafe, line_skip)
      end

      def line_skip : Int32
        LibSDL3TTF.get_font_line_skip(to_unsafe)
      end

      def kerning=(enabled : Bool)
        LibSDL3TTF.set_font_kerning(to_unsafe, enabled)
      end

      def kerning
        LibSDL3TTF.get_font_kerning(to_unsafe)
      end

      def fixed_width? : Bool
        LibSDL3TTF.font_is_fixed_width(to_unsafe)
      end

      def scalable? : Bool
        LibSDL3TTF.font_is_scalable(to_unsafe)
      end

      def family_name : String
        LibSDL3TTF.get_font_family_name(to_unsafe)
      end

      def style_name : String
        LibSDL3TTF.get_font_style_name(to_unsafe)
      end

      def direction=(direction : Direction)
        LibSDL3TTF.set_font_direction(to_unsafe, direction)
      end

      def direction : Direction
        LibSDL3TTF.get_font_direction(to_unsafe)
      end

      def text_size(text : String) : Tuple{Int32, Int32}
        w = 0
        h = 0

        LibSDL3TTF.get_string_size(to_unsafe, text, text.bytesize, pointerof(w), pointerof(h))

        {w, h}
      end

      def text_wrapped_size(text : String, wrap_width : Int32) : Tuple{Int32, Int32}
        w = 0
        h = 0

        LibSDL3TTF.get_string_size_wrapped(to_unsafe, text, text.bytesize, wrap_width, pointerof(w), pointerof(h))

        {w, h}
      end

      def measure(text : String, max_width : Int32) : Tuple(Int32, Int32)
        width = 0
        length = 0

        LibSDL3TTF.measure_string(to_unsafe, text, text.bytesize, max_width, pointerof(width), pointerof(length))

        {width, length}
      end

      {% for type in ["solid", "blended"] %}
        def render_text_{{type.id}}(text : String, color : Color) : Surface
          ptr = LibSDL3TTF.render_text_{{type.id}}(to_unsafe, text.to_unsafe, text.bytesize, color)
          raise "Failed to render text {{type.id}}" if ptr.null?
          Surface.new(ptr)
        end

        def render_text_{{type.id}}_wrapped(text : String, color : Color, wrap_length : Int32) : Surface
          ptr = LibSDL3TTF.render_text_{{type.id}}_wrapped(to_unsafe, text.to_unsafe, text.bytesize, color, wrap_length)
          raise "Failed to render text {{type.id}} wrapped" if ptr.null?
          Surface.new(ptr)
        end

        def render_glyph_{{type.id}}(char : UInt32, color : Color) : Surface
          ptr = LibSDL3TTF.render_glyph_{{type.id}}(to_unsafe, char, color)
          raise "Failed to render glyph {{type.id}}" if ptr.null?
          Surface.new(ptr)
        end
      {% end %}

      {% for type in ["shaded", "lcd"] %}
        def render_text_{{type.id}}(text : String, fg_color : Color, bg_color : Color) : Surface
          ptr = LibSDL3TTF.render_text_{{type.id}}(to_unsafe, text.to_unsafe, text.bytesize, fg_color, bg_color)
          raise "Failed to render text {{type.id}}" if ptr.null?
          Surface.new(ptr)
        end

        def render_text_{{type.id}}_wrapped(text : String, fg_color : Color, bg_color : Color, wrap_length : Int32) : Surface
          ptr = LibSDL3TTF.render_text_{{type.id}}_wrapped(to_unsafe, text.to_unsafe, text.bytesize, fg_color, bg_color, wrap_length)
          raise "Failed to render text {{type.id}} wrapped" if ptr.null?
          Surface.new(ptr)
        end

        def render_glyph_{{type.id}}(char : UInt32, fg_color : Color, bg_color : Color) : Surface
          ptr = LibSDL3TTF.render_glyph_{{type.id}}(to_unsafe, char, fg_color, bg_color)
          raise "Failed to render glyph {{type.id}}" if ptr.null?
          Surface.new(ptr)
        end
      {% end %}

      def create_text(engine : TextEngine, text : String) : Text
        LibSDL3TTF.create_text(engine.to_unsafe, to_unsafe, text, text.bytesize)
      end
    end

    class TextEngine
      enum Type
        Surface
        Renderer
      end

      getter type : Type

      @ptr : LibSDL3TTF::TextEngine*

      def initialize(@ptr : LibSDL3TTF::TextEngine*, @type = Type::Renderer)
      end

      def to_unsafe : LibSDL3TTF::TextEngine*
        @ptr
      end

      def self.create(renderer : SDL3::Renderer) : TextEngine
        ptr = LibSDL3TTF.create_renderer_text_engine(renderer.to_unsafe)
        raise "Failed to create renderer text engine" if ptr.null?
        TextEngine.new(ptr, Type::Renderer)
      end

      def self.create_surface_text_engine : TextEngine
        ptr = LibSDL3TTF.create_surface_text_engine
        raise "Failed to create surface text engine" if ptr.null?
        TextEngine.new(ptr, Type::Surface)
      end

      def destroy
        case type
        when Type::Surface
          LibSDL3TTF.destroy_surface_text_engine(to_unsafe)
        when Type::Renderer
          LibSDL3TTF.destroy_renderer_text_engine(to_unsafe)
        else
          LibSDL3TTF.destroy_renderer_text_engine(to_unsafe)
        end
      end

      def create_text(font : Font, text : String) : Text
        ptr = LibSDL3TTF.create_text(to_unsafe, font.to_unsafe, text, text.bytesize)
        raise "Failed to create text from text engine" if ptr.null?
        Text.new(ptr)
      end
    end

    class Text
      @ptr : LibSDL3TTF::Text*

      def initialize(@ptr : LibSDL3TTF::Text*)
      end

      def to_unsafe : LibSDL3TTF::Text*
        @ptr
      end

      def text_engine=(text_engine : TextEngine)
        LibSDL3TTF.set_text_engine(to_unsafe, text_engine.to_unsafe)
      end

      def text_engine : TextEngine
        ptr = LibSDL3TTF.get_text_engine(to_unsafe)
        raise "Failed to get text engine from text" if ptr.null?
        TextEngine.new(ptr)
      end

      def font=(font : Font)
        LibSDL3TTF.set_text_font(to_unsafe, font.to_unsafe)
      end

      def font : Font
        ptr = LibSDL3TTF.get_text_font(to_unsafe)
        raise "Failed to get font from text" if ptr.null?
        Font.new(ptr)
      end

      def direction=(direction : Direction)
        LibSDL3TTF.set_text_direction(to_unsafe, direction)
      end

      def direction : Direction
        LibSDL3TTF.get_text_direction(to_unsafe)
      end

      def color=(color : Color)
        LibSDL3TTF.set_text_color(to_unsafe, color.r, color.g, color.b, color.a)
      end

      def color : Color
        r = 0
        g = 0
        b = 0
        a = 0

        LibSDL3TTF.get_text_color(to_unsafe, pointerof(r), pointerof(g), pointerof(b), pointerof(a))

        Color.new(r: r, g: g, b: b, a: a)
      end

      def wrap_width=(wrap_width : Int32)
        LibSDL3TTF.set_text_wrap_width(to_unsafe, wrap_width)
      end

      def wrap_width
        wrap_width = 0

        LibSDL3TTF.get_text_wrap_width(to_unsafe, pointerof(wrap_width))

        wrap_width
      end

      def wrap_whitespace_visible=(visible : Bool) : Bool
        LibSDL3TTF.set_text_wrap_whitespace_visible(to_unsafe, visible)
      end

      def whitespace_visible?
        LibSDL3TTF.text_wrap_whitespace_visible(to_unsafe)
      end

      def text=(text : String)
        LibSDL3TTF.set_text_string(to_unsafe, text, text.bytesize)
      end

      def size : Tuple(Int32, Int32)
        w = 0
        h = 0

        LibSDL3TTF.get_text_size(to_unsafe, pointerof(w), pointerof(h))

        {w, h}
      end

      def width
        size[0]
      end

      def height
        size[1]
      end

      def destroy
        LibSDL3TTF.destroy_text(to_unsafe)
      end

      # text must have been created using a TextEngine
      # from SDL3::create_text_engine,
      # and will draw using the renderer passed to that function
      def draw(x : Float32, y : Float32) : Bool
        LibSDL3TTF.draw_renderer_text(to_unsafe, x, y)
      end

      def draw_to_surface(x : Float32, y : Float32, surface : SDL3::Surface)
        LibSDL3TTF.draw_surface_text(to_unsafe, x, y, surface.to_unsafe)
      end
    end
  end
end
