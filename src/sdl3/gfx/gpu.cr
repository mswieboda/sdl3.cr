lib LibSDL3
  # SDL_gpu.h
  alias GPUDevice = Void
  alias GPUShader = Void
  alias GPUTexture = Void
  alias GPUBuffer = Void
  alias GPUSampler = Void

  @[Flags]
  enum GPUShaderFormat : UInt32
    Invalid = 0
    Private = (1 << 0)
    SPIRV   = (1 << 1)
    DXBC    = (1 << 2)
    DXIL    = (1 << 3)
    MSL     = (1 << 4)
    MetalLib = (1 << 5)
  end

  enum GPUShaderStage : Int32
    Vertex
    Fragment
  end

  SDL_GPU_SHADERSTAGE_VERTEX   = GPUShaderStage::Vertex
  SDL_GPU_SHADERSTAGE_FRAGMENT = GPUShaderStage::Fragment

  SDL_GPU_SHADERFORMAT_INVALID  = GPUShaderFormat::Invalid
  SDL_GPU_SHADERFORMAT_PRIVATE  = GPUShaderFormat::Private
  SDL_GPU_SHADERFORMAT_SPIRV    = GPUShaderFormat::SPIRV
  SDL_GPU_SHADERFORMAT_DXBC     = GPUShaderFormat::DXBC
  SDL_GPU_SHADERFORMAT_DXIL     = GPUShaderFormat::DXIL
  SDL_GPU_SHADERFORMAT_MSL      = GPUShaderFormat::MSL
  SDL_GPU_SHADERFORMAT_METALLIB = GPUShaderFormat::MetalLib

  struct GPUShaderCreateInfo
    code_size : LibC::SizeT
    code : UInt8*
    entrypoint : UInt8*
    format : GPUShaderFormat
    stage : GPUShaderStage
    num_samplers : UInt32
    num_storage_textures : UInt32
    num_storage_buffers : UInt32
    num_uniform_buffers : UInt32
    props : PropertiesID
  end

  struct GPUTextureSamplerBinding
    texture : GPUTexture*
    sampler : GPUSampler*
  end

  fun create_gpu_shader = SDL_CreateGPUShader(device : GPUDevice*, createinfo : GPUShaderCreateInfo*) : GPUShader*
  fun release_gpu_shader = SDL_ReleaseGPUShader(device : GPUDevice*, shader : GPUShader*)
end

module SDL3
  class GPUShader
    @ptr : LibSDL3::GPUShader*
    @device : LibSDL3::GPUDevice*

    def initialize(@device, @ptr)
    end

    def to_unsafe
      @ptr
    end

    def release
      LibSDL3.release_gpu_shader(@device, @ptr)
    end
  end
end
