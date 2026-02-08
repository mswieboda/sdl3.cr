require "../../spec_helper"
require "../../../src/sdl3"

describe SDL3::Mixer do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_AUDIO)
    SDL3::Mixer.init.should be_true
  end

  after_each do
    SDL3::Mixer.quit
    SDL3.quit
  end

  it "should return the mixer version" do
    version = SDL3::Mixer.version
    version.should be_a(Int32)
  end

  it "gets the number of audio decoders" do
    num_decoders = LibSDL3Mixer.num_audio_decoders
    num_decoders.should be >= 0
  end

  it "gets audio decoder names" do
    num_decoders = LibSDL3Mixer.num_audio_decoders
    num_decoders.times do |i|
      decoder_name = LibSDL3Mixer.audio_decoder(i)
      decoder_name.should_not be_nil
      String.new(decoder_name).should_not be_empty
    end
  end

  it "creates and destroys a mixer device" do
    spec = LibSDL3::AudioSpec.new(freq: 44100, format: LibSDL3::AudioFormatEnum::S16, channels: 2)
    mixer = LibSDL3Mixer.create_mixer_device(LibSDL3::AUDIO_DEVICE_DEFAULT_PLAYBACK, pointerof(spec))
    mixer.should_not be_nil
    LibSDL3Mixer.destroy_mixer(mixer)
  end

  # This test requires a valid audio file at "assets/sfx/sample.wav"
  # it "loads and destroys audio" do
  #   spec = LibSDL3::AudioSpec.new(freq: 44100, format: LibSDL3::AudioFormatEnum::S16, channels: 2)
  #   mixer = LibSDL3Mixer.create_mixer(pointerof(spec))
  #   mixer.should_not be_nil
  #
  #   audio = LibSDL3Mixer.load_audio(mixer, "assets/sfx/sample.wav", false)
  #   audio.should_not be_nil
  #
  #   LibSDL3Mixer.destroy_audio(audio)
  #   LibSDL3Mixer.destroy_mixer(mixer)
  # end
end
