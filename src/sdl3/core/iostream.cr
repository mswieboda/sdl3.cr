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
      raise "Failed to create IOStream: #{SDL3.get_error}" if @ptr.null?
    end

    def self.from_file(file : String, mode : String = "rb")
      ptr = LibSDL3.io_from_file(file.to_unsafe, mode.to_unsafe)
      new(ptr)
    end

    def self.from_memory(data : Bytes)
      ptr = LibSDL3.io_from_mem(data.to_unsafe, data.bytesize.to_u64)
      new(ptr)
    end

    def close
      LibSDL3.close_io(@ptr)
    end

    def size : Int64
      LibSDL3.get_io_size(@ptr)
    end

    def to_unsafe
      @ptr
    end

    # --- High-Level Engine Helpers ---

    # Reads a specific number of bytes and returns a new Slice
    def read_bytes(count : Int) : Bytes
      buffer = Bytes.new(count.to_i)
      bytes_read = LibSDL3.read_io(@ptr, buffer.to_unsafe, count.to_u64)
      if bytes_read != count.to_u64
        raise "SDL3::IOStream Error: Unexpected end of stream while reading raw bytes."
      end
      buffer
    end

    # Reads the entire remainder of the stream into a Bytes slice
    def read_all : Bytes
      current_pos = tell
      remaining = size - current_pos
      read_bytes(remaining)
    end

    # Reads a Little Endian 32-bit unsigned integer
    def read_u32 : UInt32
      buffer = read_bytes(4)
      (buffer[0].to_u32) | (buffer[1].to_u32 << 8) | (buffer[2].to_u32 << 16) | (buffer[3].to_u32 << 24)
    end

    def read_u64 : UInt64
      buffer = read_bytes(8)
      (buffer[0].to_u64) |
        (buffer[1].to_u64 << 8) |
        (buffer[2].to_u64 << 16) |
        (buffer[3].to_u64 << 24) |
        (buffer[4].to_u64 << 32) |
        (buffer[5].to_u64 << 40) |
        (buffer[6].to_u64 << 48) |
        (buffer[7].to_u64 << 56)
    end

    # Seeks to an absolute position from the beginning of the file
    def seek(offset : Int64) : Nil
      # Using LibSDL3::IOWhence::SeekSet (0)
      result = LibSDL3.seek_io(@ptr, offset, LibSDL3::IOWhence::SeekSet)
      if result < 0
        raise "SDL3::IOStream Error: Failed to seek to position #{offset}."
      end
    end

    # Returns the current read/write byte offset
    def tell : Int64
      result = LibSDL3.tell_io(@ptr)
      raise "SDL3::IOStream Error: Failed to determine stream position." if result < 0
      result
    end
  end
end
