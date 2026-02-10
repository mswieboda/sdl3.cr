# Crystal bindings for SDL3_audio
# Docs: https://wiki.libsdl.org/SDL3/CategoryAudio

lib LibSDL3
  alias AudioDeviceID = UInt32
  alias AudioFormat = UInt16

  # Constants
  AUDIO_MASK_BITSIZE       = 0xFF_u16
  AUDIO_MASK_FLOAT         = (1_u16 << 8)
  AUDIO_MASK_BIG_ENDIAN    = (1_u16 << 12)
  AUDIO_MASK_SIGNED        = (1_u16 << 15)

  AUDIO_DEVICE_DEFAULT_PLAYBACK = 0xFFFFFFFF_u32
  AUDIO_DEVICE_DEFAULT_RECORDING = 0xFFFFFFFE_u32

  # Enums
  enum AudioFormatEnum : AudioFormat
    Unknown = 0x0000_u16
    U8 = 0x0008_u16
    S8 = 0x8008_u16
    S16LE = 0x8010_u16
    S16BE = 0x9010_u16
    S32LE = 0x8020_u16
    S32BE = 0x9020_u16
    F32LE = 0x8120_u16
    F32BE = 0x9120_u16

    {% if flag?(:big_endian) %}
      S16 = S16BE
      S32 = S32BE
      F32 = F32BE
    {% else %}
      S16 = S16LE
      S32 = S32LE
      F32 = F32LE
    {% end %}
  end

  # Structs
  struct AudioSpec
    format : AudioFormat
    channels : LibC::Int
    freq : LibC::Int
  end

  # Opaque Structs
  alias AudioStream = Void

  # Functions
  fun get_num_audio_drivers = SDL_GetNumAudioDrivers : LibC::Int
  fun get_audio_driver = SDL_GetAudioDriver(index : LibC::Int) : LibC::Char*
  fun get_current_audio_driver = SDL_GetCurrentAudioDriver : LibC::Char*
  fun get_audio_playback_devices = SDL_GetAudioPlaybackDevices(count : LibC::Int*) : AudioDeviceID*
  fun get_audio_recording_devices = SDL_GetAudioRecordingDevices(count : LibC::Int*) : AudioDeviceID*
  fun get_audio_device_name = SDL_GetAudioDeviceName(devid : AudioDeviceID) : LibC::Char*
  fun get_audio_device_format = SDL_GetAudioDeviceFormat(devid : AudioDeviceID, spec : AudioSpec*, sample_frames : LibC::Int*) : Bool
  fun open_audio_device = SDL_OpenAudioDevice(devid : AudioDeviceID, spec : AudioSpec*) : AudioDeviceID
  fun close_audio_device = SDL_CloseAudioDevice(devid : AudioDeviceID)
  fun pause_audio_device = SDL_PauseAudioDevice(devid : AudioDeviceID) : Bool
  fun resume_audio_device = SDL_ResumeAudioDevice(devid : AudioDeviceID) : Bool
  fun audio_device_paused = SDL_AudioDevicePaused(devid : AudioDeviceID) : Bool
  fun load_wav_io = SDL_LoadWAV_IO(src : IOStream*, closeio : Bool, spec : AudioSpec*, audio_buf : UInt8**, audio_len : UInt32*) : Bool
  fun load_wav = SDL_LoadWAV(path : LibC::Char*, spec : AudioSpec*, audio_buf : UInt8**, audio_len : UInt32*) : Bool
  fun free = SDL_free(mem : Void*)
  fun mix_audio = SDL_MixAudio(dst : UInt8*, src : UInt8*, format : AudioFormat, len : UInt32, volume : Float32) : Bool
  fun create_audio_stream = SDL_CreateAudioStream(src_spec : AudioSpec*, dst_spec : AudioSpec*) : AudioStream*
  fun destroy_audio_stream = SDL_DestroyAudioStream(stream : AudioStream*)
  fun get_audio_stream_format = SDL_GetAudioStreamFormat(stream : AudioStream*, src_spec : AudioSpec*, dst_spec : AudioSpec*) : Bool
  fun set_audio_stream_format = SDL_SetAudioStreamFormat(stream : AudioStream*, src_spec : AudioSpec*, dst_spec : AudioSpec*) : Bool
  fun put_audio_stream_data = SDL_PutAudioStreamData(stream : AudioStream*, buf : Void*, len : LibC::Int) : Bool
  fun get_audio_stream_data = SDL_GetAudioStreamData(stream : AudioStream*, buf : Void*, len : LibC::Int) : LibC::Int
  fun get_audio_stream_available = SDL_GetAudioStreamAvailable(stream : AudioStream*) : LibC::Int
  fun flush_audio_stream = SDL_FlushAudioStream(stream : AudioStream*) : Bool
  fun clear_audio_stream = SDL_ClearAudioStream(stream : AudioStream*) : Bool
  fun open_audio_device_stream = SDL_OpenAudioDeviceStream(devid : AudioDeviceID, spec : AudioSpec*, callback : Void*, userdata : Void*) : AudioStream*
  fun resume_audio_stream_device = SDL_ResumeAudioStreamDevice(stream : AudioStream*) : Bool
  fun pause_audio_stream_device = SDL_PauseAudioStreamDevice(stream : AudioStream*) : Bool
  fun get_audio_stream_queued = SDL_GetAudioStreamQueued(stream : AudioStream*) : LibC::Int
  fun convert_audio_samples = SDL_ConvertAudioSamples(src_spec : AudioSpec*, src_data : UInt8*, src_len : LibC::Int, dst_spec : AudioSpec*, dst_data : UInt8**, dst_len : LibC::Int*) : Bool
end
