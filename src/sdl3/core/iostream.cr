lib LibSDL3
  alias IOStream = Void

  enum IOStatus : Int32
    Ready = 0
    Error = 1
    Eof = 2
    NotReady = 3
    Readonly = 4
    Writeonly = 5
  end

  enum IOWhence : Int32
    SeekSet = 0
    SeekCur = 1
    SeekEnd = 2
  end

  fun io_from_file = SDL_IOFromFile(file : LibC::Char*, mode : LibC::Char*) : IOStream*
  fun io_from_mem = SDL_IOFromMem(mem : Void*, size : LibC::SizeT) : IOStream*
  fun io_from_const_mem = SDL_IOFromConstMem(mem : Void*, size : LibC::SizeT) : IOStream*
  fun io_from_dynamic_mem = SDL_IOFromDynamicMem() : IOStream*
  fun close_io = SDL_CloseIO(context : IOStream*) : Bool
  fun get_io_properties = SDL_GetIOProperties(context : IOStream*) : PropertiesID
  fun get_io_status = SDL_GetIOStatus(context : IOStream*) : IOStatus
  fun get_io_size = SDL_GetIOSize(context : IOStream*) : Int64
  fun seek_io = SDL_SeekIO(context : IOStream*, offset : Int64, whence : IOWhence) : Int64
  fun tell_io = SDL_TellIO(context : IOStream*) : Int64
  fun read_io = SDL_ReadIO(context : IOStream*, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
  fun write_io = SDL_WriteIO(context : IOStream*, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
end

module SDL3
  class IOStream
    @ptr : LibSDL3::IOStream*

    def initialize(@ptr : LibSDL3::IOStream*)
      raise "Failed to create IOStream" if @ptr.null?
    end

    def self.from_file(file : String, mode : String)
      ptr = LibSDL3.io_from_file(file.to_unsafe, mode.to_unsafe)
      new(ptr)
    end

    def close
      LibSDL3.close_io(@ptr)
    end

    def to_unsafe
      @ptr
    end
  end
end
