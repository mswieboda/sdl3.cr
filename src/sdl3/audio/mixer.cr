# Copyright 2024 The Crystal-SDL3 authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

@[Link(lib: "SDL3_mixer", dll: "SDL3_mixer.dll")]
lib LibSDL3Mixer
  alias Mixer = Void
  alias Audio = Void
  alias Track = Void
  alias Group = Void
  alias AudioDecoder = Void

  @[Packed]
  struct StereoGains
    left : Float32
    right : Float32
  end

  @[Packed]
  struct Point3D
    x : Float32
    y : Float32
    z : Float32
  end

  SDL_MIXER_MAJOR_VERSION = 3
  SDL_MIXER_MINOR_VERSION = 1
  SDL_MIXER_MICRO_VERSION = 2

  fun version = MIX_Version : Int32
  fun init = MIX_Init : Bool
  fun quit = MIX_Quit : Void

  fun num_audio_decoders = MIX_GetNumAudioDecoders : Int32
  fun audio_decoder = MIX_GetAudioDecoder(index : Int32) : UInt8*

  fun create_mixer_device = MIX_CreateMixerDevice(devid : LibSDL3::AudioDeviceID, spec : LibSDL3::AudioSpec*) : Mixer*
  fun create_mixer = MIX_CreateMixer(spec : LibSDL3::AudioSpec*) : Mixer*
  fun destroy_mixer = MIX_DestroyMixer(mixer : Mixer*) : Void

  fun get_mixer_properties = MIX_GetMixerProperties(mixer : Mixer*) : LibSDL3::PropertiesID

  MIX_PROP_MIXER_DEVICE_NUMBER = "SDL_mixer.mixer.device"

  fun get_mixer_format = MIX_GetMixerFormat(mixer : Mixer*, spec : LibSDL3::AudioSpec*) : Bool

  fun load_audio_io = MIX_LoadAudio_IO(mixer : Mixer*, io : LibSDL3::IOStream*, predecode : Bool, closeio : Bool) : Audio*
  fun load_audio = MIX_LoadAudio(mixer : Mixer*, path : UInt8*, predecode : Bool) : Audio*
  fun load_audio_with_properties = MIX_LoadAudioWithProperties(props : LibSDL3::PropertiesID) : Audio*

  MIX_PROP_AUDIO_LOAD_IOSTREAM_POINTER       = "SDL_mixer.audio.load.iostream"
  MIX_PROP_AUDIO_LOAD_CLOSEIO_BOOLEAN        = "SDL_mixer.audio.load.closeio"
  MIX_PROP_AUDIO_LOAD_PREDECODE_BOOLEAN      = "SDL_mixer.audio.load.predecode"
  MIX_PROP_AUDIO_LOAD_PREFERRED_MIXER_POINTER = "SDL_mixer.audio.load.preferred_mixer"
  MIX_PROP_AUDIO_LOAD_SKIP_METADATA_TAGS_BOOLEAN = "SDL_mixer.audio.load.skip_metadata_tags"
  MIX_PROP_AUDIO_DECODER_STRING              = "SDL_mixer.audio.decoder"

  fun load_raw_audio_io = MIX_LoadRawAudio_IO(mixer : Mixer*, io : LibSDL3::IOStream*, spec : LibSDL3::AudioSpec*, closeio : Bool) : Audio*
  fun load_raw_audio = MIX_LoadRawAudio(mixer : Mixer*, data : Void*, datalen : LibC::SizeT, spec : LibSDL3::AudioSpec*) : Audio*
  fun load_raw_audio_no_copy = MIX_LoadRawAudioNoCopy(mixer : Mixer*, data : Void*, datalen : LibC::SizeT, spec : LibSDL3::AudioSpec*, free_when_done : Bool) : Audio*
  fun create_sine_wave_audio = MIX_CreateSineWaveAudio(mixer : Mixer*, hz : Int32, amplitude : Float32, ms : Int64) : Audio*

  fun get_audio_properties = MIX_GetAudioProperties(audio : Audio*) : LibSDL3::PropertiesID

  MIX_PROP_METADATA_TITLE_STRING             = "SDL_mixer.metadata.title"
  MIX_PROP_METADATA_ARTIST_STRING            = "SDL_mixer.metadata.artist"
  MIX_PROP_METADATA_ALBUM_STRING             = "SDL_mixer.metadata.album"
  MIX_PROP_METADATA_COPYRIGHT_STRING         = "SDL_mixer.metadata.copyright"
  MIX_PROP_METADATA_TRACK_NUMBER             = "SDL_mixer.metadata.track"
  MIX_PROP_METADATA_TOTAL_TRACKS_NUMBER      = "SDL_mixer.metadata.total_tracks"
  MIX_PROP_METADATA_YEAR_NUMBER              = "SDL_mixer.metadata.year"
  MIX_PROP_METADATA_DURATION_FRAMES_NUMBER   = "SDL_mixer.metadata.duration_frames"
  MIX_PROP_METADATA_DURATION_INFINITE_BOOLEAN = "SDL_mixer.metadata.duration_infinite"

  fun get_audio_duration = MIX_GetAudioDuration(audio : Audio*) : Int64

  MIX_DURATION_UNKNOWN = -1
  MIX_DURATION_INFINITE = -2

  fun get_audio_format = MIX_GetAudioFormat(audio : Audio*, spec : LibSDL3::AudioSpec*) : Bool
  fun destroy_audio = MIX_DestroyAudio(audio : Audio*) : Void

  fun create_track = MIX_CreateTrack(mixer : Mixer*) : Track*
  fun destroy_track = MIX_DestroyTrack(track : Track*) : Void
  fun get_track_properties = MIX_GetTrackProperties(track : Track*) : LibSDL3::PropertiesID
  fun get_track_mixer = MIX_GetTrackMixer(track : Track*) : Mixer*

  fun set_track_audio = MIX_SetTrackAudio(track : Track*, audio : Audio*) : Bool
  fun set_track_audio_stream = MIX_SetTrackAudioStream(track : Track*, stream : LibSDL3::AudioStream*) : Bool
  fun set_track_io_stream = MIX_SetTrackIOStream(track : Track*, io : LibSDL3::IOStream*, closeio : Bool) : Bool
  fun set_track_raw_io_stream = MIX_SetTrackRawIOStream(track : Track*, io : LibSDL3::IOStream*, spec : LibSDL3::AudioSpec*, closeio : Bool) : Bool

  fun tag_track = MIX_TagTrack(track : Track*, tag : UInt8*) : Bool
  fun untag_track = MIX_UntagTrack(track : Track*, tag : UInt8*) : Void
  fun get_track_tags = MIX_GetTrackTags(track : Track*, count : Int32*) : UInt8**
  fun get_tagged_tracks = MIX_GetTaggedTracks(mixer : Mixer*, tag : UInt8*, count : Int32*) : Track**

  fun set_track_playback_position = MIX_SetTrackPlaybackPosition(track : Track*, frames : Int64) : Bool
  fun get_track_playback_position = MIX_GetTrackPlaybackPosition(track : Track*) : Int64
  fun get_track_fade_frames = MIX_GetTrackFadeFrames(track : Track*) : Int64
  fun get_track_loops = MIX_GetTrackLoops(track : Track*) : Int32
  fun set_track_loops = MIX_SetTrackLoops(track : Track*, num_loops : Int32) : Bool
  fun get_track_audio = MIX_GetTrackAudio(track : Track*) : Audio*
  fun get_track_audio_stream = MIX_GetTrackAudioStream(track : Track*) : LibSDL3::AudioStream*
  fun get_track_remaining = MIX_GetTrackRemaining(track : Track*) : Int64

  fun track_ms_to_frames = MIX_TrackMSToFrames(track : Track*, ms : Int64) : Int64
  fun track_frames_to_ms = MIX_TrackFramesToMS(track : Track*, frames : Int64) : Int64
  fun audio_ms_to_frames = MIX_AudioMSToFrames(audio : Audio*, ms : Int64) : Int64
  fun audio_frames_to_ms = MIX_AudioFramesToMS(audio : Audio*, frames : Int64) : Int64
  fun ms_to_frames = MIX_MSToFrames(sample_rate : Int32, ms : Int64) : Int64
  fun frames_to_ms = MIX_FramesToMS(sample_rate : Int32, frames : Int64) : Int64

  fun play_track = MIX_PlayTrack(track : Track*, options : LibSDL3::PropertiesID) : Bool

  MIX_PROP_PLAY_LOOPS_NUMBER                      = "SDL_mixer.play.loops"
  MIX_PROP_PLAY_MAX_FRAME_NUMBER                  = "SDL_mixer.play.max_frame"
  MIX_PROP_PLAY_MAX_MILLISECONDS_NUMBER           = "SDL_mixer.play.max_milliseconds"
  MIX_PROP_PLAY_START_FRAME_NUMBER                = "SDL_mixer.play.start_frame"
  MIX_PROP_PLAY_START_MILLISECOND_NUMBER          = "SDL_mixer.play.start_millisecond"
  MIX_PROP_PLAY_LOOP_START_FRAME_NUMBER           = "SDL_mixer.play.loop_start_frame"
  MIX_PROP_PLAY_LOOP_START_MILLISECOND_NUMBER     = "SDL_mixer.play.loop_start_millisecond"
  MIX_PROP_PLAY_FADE_IN_FRAMES_NUMBER             = "SDL_mixer.play.fade_in_frames"
  MIX_PROP_PLAY_FADE_IN_MILLISECONDS_NUMBER       = "SDL_mixer.play.fade_in_milliseconds"
  MIX_PROP_PLAY_FADE_IN_START_GAIN_FLOAT          = "SDL_mixer.play.fade_in_start_gain"
  MIX_PROP_PLAY_APPEND_SILENCE_FRAMES_NUMBER      = "SDL_mixer.play.append_silence_frames"
  MIX_PROP_PLAY_APPEND_SILENCE_MILLISECONDS_NUMBER = "SDL_mixer.play.append_silence_milliseconds"

  fun play_tag = MIX_PlayTag(mixer : Mixer*, tag : UInt8*, options : LibSDL3::PropertiesID) : Bool
  fun play_audio = MIX_PlayAudio(mixer : Mixer*, audio : Audio*) : Bool

  fun stop_track = MIX_StopTrack(track : Track*, fade_out_frames : Int64) : Bool
  fun stop_all_tracks = MIX_StopAllTracks(mixer : Mixer*, fade_out_ms : Int64) : Bool
  fun stop_tag = MIX_StopTag(mixer : Mixer*, tag : UInt8*, fade_out_ms : Int64) : Bool

  fun pause_track = MIX_PauseTrack(track : Track*) : Bool
  fun pause_all_tracks = MIX_PauseAllTracks(mixer : Mixer*) : Bool
  fun pause_tag = MIX_PauseTag(mixer : Mixer*, tag : UInt8*) : Bool
  fun resume_track = MIX_ResumeTrack(track : Track*) : Bool
  fun resume_all_tracks = MIX_ResumeAllTracks(mixer : Mixer*) : Bool
  fun resume_tag = MIX_ResumeTag(mixer : Mixer*, tag : UInt8*) : Bool

  fun track_playing = MIX_TrackPlaying(track : Track*) : Bool
  fun track_paused = MIX_TrackPaused(track : Track*) : Bool

  fun set_mixer_gain = MIX_SetMixerGain(mixer : Mixer*, gain : Float32) : Bool
  fun get_mixer_gain = MIX_GetMixerGain(mixer : Mixer*) : Float32
  fun set_track_gain = MIX_SetTrackGain(track : Track*, gain : Float32) : Bool
  fun get_track_gain = MIX_GetTrackGain(track : Track*) : Float32
  fun set_tag_gain = MIX_SetTagGain(mixer : Mixer*, tag : UInt8*, gain : Float32) : Bool

  fun set_mixer_frequency_ratio = MIX_SetMixerFrequencyRatio(mixer : Mixer*, ratio : Float32) : Bool
  fun get_mixer_frequency_ratio = MIX_GetMixerFrequencyRatio(mixer : Mixer*) : Float32
  fun set_track_frequency_ratio = MIX_SetTrackFrequencyRatio(track : Track*, ratio : Float32) : Bool
  fun get_track_frequency_ratio = MIX_GetTrackFrequencyRatio(track : Track*) : Float32

  fun set_track_output_channel_map = MIX_SetTrackOutputChannelMap(track : Track*, chmap : Int32*, count : Int32) : Bool

  fun set_track_stereo = MIX_SetTrackStereo(track : Track*, gains : StereoGains*) : Bool
  fun set_track_3d_position = MIX_SetTrack3DPosition(track : Track*, position : Point3D*) : Bool
  fun get_track_3d_position = MIX_GetTrack3DPosition(track : Track*, position : Point3D*) : Bool

  fun create_group = MIX_CreateGroup(mixer : Mixer*) : Group*
  fun destroy_group = MIX_DestroyGroup(group : Group*) : Void
  fun get_group_properties = MIX_GetGroupProperties(group : Group*) : LibSDL3::PropertiesID
  fun get_group_mixer = MIX_GetGroupMixer(group : Group*) : Mixer*
  fun set_track_group = MIX_SetTrackGroup(track : Track*, group : Group*) : Bool

  alias TrackStoppedCallback = (Void*, Track* ->)
  fun set_track_stopped_callback = MIX_SetTrackStoppedCallback(track : Track*, cb : TrackStoppedCallback, userdata : Void*) : Bool

  alias TrackMixCallback = (Void*, Track*, LibSDL3::AudioSpec*, Float32*, Int32 ->)
  fun set_track_raw_callback = MIX_SetTrackRawCallback(track : Track*, cb : TrackMixCallback, userdata : Void*) : Bool
  fun set_track_cooked_callback = MIX_SetTrackCookedCallback(track : Track*, cb : TrackMixCallback, userdata : Void*) : Bool

  alias GroupMixCallback = (Void*, Group*, LibSDL3::AudioSpec*, Float32*, Int32 ->)
  fun set_group_post_mix_callback = MIX_SetGroupPostMixCallback(group : Group*, cb : GroupMixCallback, userdata : Void*) : Bool

  alias PostMixCallback = (Void*, Mixer*, LibSDL3::AudioSpec*, Float32*, Int32 ->)
  fun set_post_mix_callback = MIX_SetPostMixCallback(mixer : Mixer*, cb : PostMixCallback, userdata : Void*) : Bool

  fun generate = MIX_Generate(mixer : Mixer*, buffer : Void*, buflen : Int32) : Bool

  fun create_audio_decoder = MIX_CreateAudioDecoder(path : UInt8*, props : LibSDL3::PropertiesID) : AudioDecoder*
  fun create_audio_decoder_io = MIX_CreateAudioDecoder_IO(io : LibSDL3::IOStream*, closeio : Bool, props : LibSDL3::PropertiesID) : AudioDecoder*
  fun destroy_audio_decoder = MIX_DestroyAudioDecoder(audiodecoder : AudioDecoder*) : Void
  fun get_audio_decoder_properties = MIX_GetAudioDecoderProperties(audiodecoder : AudioDecoder*) : LibSDL3::PropertiesID
  fun get_audio_decoder_format = MIX_GetAudioDecoderFormat(audiodecoder : AudioDecoder*, spec : LibSDL3::AudioSpec*) : Bool
  fun decode_audio = MIX_DecodeAudio(audiodecoder : AudioDecoder*, buffer : Void*, buflen : Int32, spec : LibSDL3::AudioSpec*) : Int32
end

module SDL3
  module Mixer
    def self.version
      {% if flag?(:wasm32) %}
        0
      {% else %}
        LibSDL3Mixer.version
      {% end %}
    end

    def self.init
      {% if flag?(:wasm32) %}
        true
      {% else %}
        LibSDL3Mixer.init
      {% end %}
    end

    def self.quit
      {% if !flag?(:wasm32) %}
        LibSDL3Mixer.quit
      {% end %}
    end

    class Device
      {% if flag?(:wasm32) %}
        def initialize(@id : LibSDL3::AudioDeviceID)
        end
        def to_unsafe
          Pointer(Void).new(1) # Return dummy pointer
        end
      {% else %}
        def initialize(@ptr : LibSDL3Mixer::Mixer*)
        end
        def to_unsafe
          @ptr
        end
      {% end %}

      def self.create(device_id : LibSDL3::AudioDeviceID, spec : LibSDL3::AudioSpec? = nil)
        {% if flag?(:wasm32) %}
          new(device_id)
        {% else %}
          ptr = LibSDL3Mixer.create_mixer_device(device_id, spec ? pointerof(spec) : nil)
          raise "Failed to create mixer device: #{SDL3.get_error}" if ptr.null?
          new(ptr)
        {% end %}
      end

      def destroy
        {% if !flag?(:wasm32) %}
          LibSDL3Mixer.destroy_mixer(@ptr)
        {% end %}
      end
    end

    class Audio
      {% if flag?(:wasm32) %}
        getter data : Bytes
        getter spec : LibSDL3::AudioSpec
        def initialize(@data, @spec)
        end
        def to_unsafe
          Pointer(Void).new(1) # Return dummy pointer
        end
      {% else %}
        def initialize(@ptr : LibSDL3Mixer::Audio*)
        end
        def to_unsafe
          @ptr
        end
      {% end %}

      def self.load(mixer : Device, path : String, predecode : Bool = false)
        {% if flag?(:wasm32) %}
          spec = uninitialized LibSDL3::AudioSpec
          audio_buf = Pointer(UInt8).null
          audio_len = 0_u32
          if !LibSDL3.load_wav(path, pointerof(spec), pointerof(audio_buf), pointerof(audio_len))
            raise "Failed to load WAV: #{SDL3.get_error}"
          end
          data = Bytes.new(audio_buf, audio_len)
          new(data, spec)
        {% else %}
          ptr = LibSDL3Mixer.load_audio(mixer.to_unsafe.as(LibSDL3Mixer::Mixer*), path.to_unsafe, predecode)
          raise "Failed to load audio: #{SDL3.get_error}" if ptr.null?
          new(ptr)
        {% end %}
      end

      def destroy
        {% if flag?(:wasm32) %}
          # Memory is managed by GC, but wav buffer from SDL should be freed if we were using LibSDL3.free
        {% else %}
          LibSDL3Mixer.destroy_audio(@ptr)
        {% end %}
      end
    end

    class Track
      {% if flag?(:wasm32) %}
        @stream : LibSDL3::AudioStream*?
        @audio : Audio?
        def initialize(@mixer : Device)
        end
        def to_unsafe
          Pointer(Void).new(1) # Return dummy pointer
        end
      {% else %}
        def initialize(@ptr : LibSDL3Mixer::Track*)
        end
        def to_unsafe
          @ptr
        end
      {% end %}

      def self.create(mixer : Device)
        {% if flag?(:wasm32) %}
          new(mixer)
        {% else %}
          ptr = LibSDL3Mixer.create_track(mixer.to_unsafe.as(LibSDL3Mixer::Mixer*))
          raise "Failed to create track: #{SDL3.get_error}" if ptr.null?
          new(ptr)
        {% end %}
      end

      def audio=(audio : Audio)
        {% if flag?(:wasm32) %}
          @audio = audio
          spec = audio.spec
          @stream = LibSDL3.open_audio_device_stream(LibSDL3::AUDIO_DEVICE_DEFAULT_PLAYBACK, pointerof(spec), nil, nil)
        {% else %}
          LibSDL3Mixer.set_track_audio(to_unsafe.as(LibSDL3Mixer::Track*), audio.to_unsafe.as(LibSDL3Mixer::Audio*))
        {% end %}
      end

      def play(loops : Int32 = 0)
        {% if flag?(:wasm32) %}
          if (s = @stream) && (a = @audio)
            LibSDL3.put_audio_stream_data(s, a.data.to_unsafe, a.data.size.to_u32)
            LibSDL3.resume_audio_stream_device(s)
          end
          true
        {% else %}
          # Simplified play for non-wasm too? Mixer has properties for play...
          # Mixer.cr example uses LibSDL3Mixer.play_track(track, 0)
          # but our LibSDL3Mixer.play_track takes PropertiesID.
          # Let's add a helper.
          false
        {% end %}
      end

      def destroy
        {% if flag?(:wasm32) %}
          if s = @stream
            LibSDL3.destroy_audio_stream(s)
          end
        {% else %}
          LibSDL3Mixer.destroy_track(to_unsafe.as(LibSDL3Mixer::Track*))
        {% end %}
      end
    end
  end
end
