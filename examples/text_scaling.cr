require "../src/sdl3"

class SDFShader
  @handle : LibSDL3::GPUShader*

  def initialize(renderer : SDL3::Renderer, file : String)
    device = LibSDL3.get_gpu_renderer_device(renderer.to_unsafe)
    if device.null?
      raise "GSDL Error: The current renderer does not support GPU shaders (device is null). Ensure you are using the 'gpu' backend."
    end

    # 1. Query the device for supported shader formats
    # This is more robust than checking the renderer name
    props = renderer.properties

    # On macOS with 'gpu' backend, this will likely be MSL
    format = LibSDL3::GPUShaderFormat::Invalid
    path = ""

    if props.get_boolean(LibSDL3::SDL_PROP_RENDERER_CREATE_GPU_SHADERS_MSL_BOOLEAN) || renderer.name == "gpu"
      # We assume MSL for Apple, but let's be safe and check if we can provide it
      # In a real app, you'd check LibSDL3.get_gpu_shader_formats(device)
      format = LibSDL3::SDL_GPU_SHADERFORMAT_MSL
      path = "#{file}.msl"
    elsif props.get_boolean(LibSDL3::SDL_PROP_RENDERER_CREATE_GPU_SHADERS_SPIRV_BOOLEAN)
      format = LibSDL3::SDL_GPU_SHADERFORMAT_SPIRV
      path = "#{file}.spv"
    end

    if format == LibSDL3::GPUShaderFormat::Invalid
      raise "GSDL Error: Could not determine a supported shader format for this device."
    end

    # 3. Read the file bytes
    shader_code = File.read(path).to_slice


    # 4. Create the CreateInfo struct
    create_info = LibSDL3::GPUShaderCreateInfo.new
    create_info.code = shader_code.to_unsafe
    create_info.code_size = shader_code.bytesize
    create_info.entrypoint = format == LibSDL3::SDL_GPU_SHADERFORMAT_MSL ? "main0".to_unsafe : "main".to_unsafe
    create_info.format = format
    create_info.stage = LibSDL3::SDL_GPU_SHADERSTAGE_FRAGMENT
    create_info.num_samplers = 1
    create_info.num_storage_textures = 0
    create_info.num_storage_buffers = 0
    create_info.num_uniform_buffers = 0
    create_info.props = 0_u32

    # 5. Create the handle
    # Note: Many SDL3 setups require the GPUDevice, which you can get from the renderer
    device = LibSDL3.get_gpu_renderer_device(renderer.to_unsafe)
    @handle = LibSDL3.create_gpu_shader(device, pointerof(create_info))

    if @handle.null?
      raise "GSDL Error: Failed to create shader from #{path}: #{String.new(LibSDL3.get_error)}"
    end
  end

  def to_unsafe
    @handle
  end
end

SDL3.init(LibSDL3::SDL_INIT_VIDEO)
SDL3::TTF.init

window = SDL3::Window.new("SDL3 SDF Text Example", 800, 600, 0)
window.raise_window
# Force the "gpu" renderer to enable SDL_gpu integration
# renderer = SDL3::Renderer.new(window, "gpu")
renderer = SDL3::Renderer.new(window)

font_path = "assets/fonts/Electrolize-Regular.ttf"

# Helper to create a texture from text with SDF enabled
def create_text_texture(renderer, font_path, text, size, color)
  font = SDL3::TTF::Font.open(font_path, size.to_f32)
  surface = font.render_text_blended(text, color)
  texture = SDL3::Texture.from_surface(renderer, surface)
  texture.blend_mode = LibSDL3::SDL_BLENDMODE_BLEND
  surface.destroy
  font.close
  texture
end

white = SDL3.color(255, 255, 255, 255)

font_size = 72

# Create 3 textures with different sizes
tex72 = create_text_texture(renderer, font_path, "Size 72 SDF", font_size, white)
tex64 = create_text_texture(renderer, font_path, "Size 64 SDF", font_size, white)
tex16 = create_text_texture(renderer, font_path, "Size 16 SDF", font_size, white)

running = true
angle = 0.0

while running
  event = uninitialized LibSDL3::Event
  while SDL3.poll_event(pointerof(event))
    if event.type == LibSDL3::SDL_EVENT_QUIT
      running = false
    end
  end

  renderer.draw_color = {0_u8, 0_u8, 0_u8, 255_u8}
  renderer.clear

  angle += 0.5

  # Render textures in the center
  [ {tex72, 0, 72}, {tex64, 100, 64}, {tex16, 180, 16} ].each do |tex_info|
    tex, y_offset, target_size = tex_info
    w, h = tex.size

    scale = target_size / font_size
    w *= scale
    h *= scale

    dest_rect = LibSDL3::FRect.new(
      x: 400.0_f32 - w / 2,
      y: 300.0_f32 - h / 2 + y_offset,
      w: w,
      h: h
    )

    renderer.draw_color = {255_u8, 255_u8, 255_u8, 255_u8}
    renderer.render_texture_rotated(tex, dest_rect, angle)
  end

  renderer.present
  SDL3.delay(16_u32)
end

tex72.destroy
tex64.destroy
tex16.destroy
renderer.destroy
window.destroy
SDL3::TTF.quit
SDL3.quit
