lib LibSDL3
  # SDL_blendmode.h

  alias BlendMode = UInt32

  # Predefined Blend Modes
  SDL_BLENDMODE_NONE = 0x00000000_u32
  SDL_BLENDMODE_BLEND = 0x00000001_u32
  SDL_BLENDMODE_BLEND_PREMULTIPLIED = 0x00000010_u32
  SDL_BLENDMODE_ADD = 0x00000002_u32
  SDL_BLENDMODE_ADD_PREMULTIPLIED = 0x00000020_u32
  SDL_BLENDMODE_MOD = 0x00000004_u32
  SDL_BLENDMODE_MUL = 0x00000008_u32
  SDL_BLENDMODE_INVALID = 0x7FFFFFFF_u32

  enum BlendOperation : UInt32
    Add = 0x1
    Subtract = 0x2
    RevSubtract = 0x3
    Minimum = 0x4
    Maximum = 0x5
  end

  enum BlendFactor : UInt32
    Zero = 0x1
    One = 0x2
    SrcColor = 0x3
    OneMinusSrcColor = 0x4
    SrcAlpha = 0x5
    OneMinusSrcAlpha = 0x6
    DstColor = 0x7
    OneMinusDstColor = 0x8
    DstAlpha = 0x9
    OneMinusDstAlpha = 0xA
  end

  fun compose_custom_blend_mode = SDL_ComposeCustomBlendMode(
    srcColorFactor : BlendFactor,
    dstColorFactor : BlendFactor,
    colorOperation : BlendOperation,
    srcAlphaFactor : BlendFactor,
    dstAlphaFactor : BlendFactor,
    alphaOperation : BlendOperation
  ) : BlendMode
end

module SDL3
  module BlendMode
    extend self

    def compose_custom(
      src_color_factor : LibSDL3::BlendFactor,
      dst_color_factor : LibSDL3::BlendFactor,
      color_operation : LibSDL3::BlendOperation,
      src_alpha_factor : LibSDL3::BlendFactor,
      dst_alpha_factor : LibSDL3::BlendFactor,
      alpha_operation : LibSDL3::BlendOperation
    ) : LibSDL3::BlendMode
      LibSDL3.compose_custom_blend_mode(
        src_color_factor,
        dst_color_factor,
        color_operation,
        src_alpha_factor,
        dst_alpha_factor,
        alpha_operation
      )
    end
  end
end
