describe "SDL3 BlendMode" do
  before_each do
    SDL3.init(0) # No specific subsystem needed for blendmode tests
  end

  after_each do
    SDL3.quit
  end

  it "defines standard blend modes" do
    LibSDL3::SDL_BLENDMODE_NONE.should eq(0x00000000_u32)
    LibSDL3::SDL_BLENDMODE_BLEND.should eq(0x00000001_u32)
    LibSDL3::SDL_BLENDMODE_ADD.should eq(0x00000002_u32)
    LibSDL3::SDL_BLENDMODE_MOD.should eq(0x00000004_u32)
  end

  it "defines blend operations" do
    LibSDL3::BlendOperation::Add.value.should eq(0x1_u32)
    LibSDL3::BlendOperation::Subtract.value.should eq(0x2_u32)
  end

  it "defines blend factors" do
    LibSDL3::BlendFactor::One.value.should eq(0x2_u32)
    LibSDL3::BlendFactor::SrcAlpha.value.should eq(0x5_u32)
  end

  it "composes a custom blend mode" do
    custom_blend_mode = SDL3::BlendMode.compose_custom(
      src_color_factor: LibSDL3::BlendFactor::SrcAlpha,
      dst_color_factor: LibSDL3::BlendFactor::OneMinusSrcAlpha,
      color_operation: LibSDL3::BlendOperation::Add,
      src_alpha_factor: LibSDL3::BlendFactor::One,
      dst_alpha_factor: LibSDL3::BlendFactor::Zero,
      alpha_operation: LibSDL3::BlendOperation::Add
    )
    custom_blend_mode.should be_a(LibSDL3::BlendMode)
    custom_blend_mode.should_not eq(0) # Should not be none
  end
end
